//
//  HTTPNetDelegate.m
//  GirlBoardApp
//
//  Created by Joseph on 10. 02. 22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTTPNetDelegate.h"
#import "Util.h"

@implementation HTTPNetDelegate

@synthesize delegate;

@synthesize receivedData;
@synthesize response;
@synthesize result;

- (BOOL)requestAddress:(NSString *)data
{
	// URL Request 객체 생성
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:data]
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:5.0f];
	
	NSError *err;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
	if(returnData == nil)
	{
		NSLog(@"%@-timeout or error",data);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"경고" message:@"네트워크에 연결할 수 없습니다."
													   delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
		return NO;
	}
	
	// 통신방식 정의 (POST, GET)
	//[request setHTTPMethod:@"POST"];
	[request setHTTPMethod:@"GET"];
	// timeout 	
	[request setTimeoutInterval:5];
	
	// Request를 사용하여 실제 연결을 시도하는 NSURLConnection 인스턴스 생성
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	// 정상적으로 연결이 되었다면
	if(connection)
	{
		// 데이터를 전송받을 멤버 변수 초기화
		receivedData = [[NSMutableData alloc] init];
		return YES;
	}
	
	return NO;
}

/**
 * @brief 서버로 정보 요청
 * @author 강요셉
 * @param bodyObject 키 - 밸류
 * @return void
 */

- (BOOL)requestHost:(NSDictionary *)bodyObject
{
	// URL Request 객체 생성
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:HOST_NAME]
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:5.0f];
	
	// timeout 	
	[request setTimeoutInterval:5];
	
	NSError *err;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
	if(returnData == nil)
    {
		NSLog(@"%@-timeout or error",HOST_NAME);	
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"서버 접속에 실패하였습니다."
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
        
		return -1;
    }
	
	// 통신방식 정의 (POST, GET)
	//[request setHTTPMethod:@"POST"];
	[request setHTTPMethod:@"GET"];
	
	// bodyObject의 객체가 존재할 경우 QueryString형태로 변환
	if(bodyObject)
	{
		// 임시 변수 선언
		NSMutableArray *parts = [NSMutableArray array];
		NSString *part;
		id key;
		id value;
		
		// 값을 하나하나 변환
		for(key in bodyObject)
		{
			value = [bodyObject objectForKey:key];
			part = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
					[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			[parts addObject:part];
		}
		
		// 값들을 &로 연결하여 Body에 사용
		[request setHTTPBody:[[parts componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	// Request를 사용하여 실제 연결을 시도하는 NSURLConnection 인스턴스 생성
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	// 정상적으로 연결이 되었다면
	if(connection)
	{
		// 데이터를 전송받을 멤버 변수 초기화
		receivedData = [[NSMutableData alloc] init];
		return YES;
	}
    
	return NO;
}

/**
 * @brief 데이터를 전송받기 전에 호출되는 메서드
 * @author 강요셉
 * @param connection 
 * @param aResponse 
 * @return void
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
	// 우선 Response의 헤더만을 먼저 받아 온다.
	//[receivedData setLength:0];
	self.response = aResponse;
}

/**
 * @brief 데이터를 전송받는 도중에 호출되는 메서드
 * @author 강요셉
 * @param connection 
 * @param data 
 * @return void
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// 여러번에 나누어 호출될 수 있으므로 appendData를 사용한다.
	[receivedData appendData:data];
}

/**
 * @brief 에러가 발생되었을 경우 호출되는 메서드
 * @author 강요셉
 * @param connection 
 * @param error 
 * @return void
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if ([self.delegate respondsToSelector:@selector(NetError:)] ) {
		[self.delegate NetError:error];
	}
	
	[receivedData release];
	[response release];
	[result release];
}

/**
 * @brief 데이터 전송이 끝났을 때 호출되는 메서드, 전송받은 데이터를 NSString형태로 변환하여 콜백
 * @author 강요셉
 * @param connection 
 * @return void
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//result = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	
	[self.delegate DataResponse:receivedData];
	[receivedData release];
	[response release];
	[result release];
}


@end
