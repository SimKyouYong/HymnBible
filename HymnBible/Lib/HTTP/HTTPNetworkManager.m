//
//  HTTPNetworkManager.m
//  JCFamily
//
//  Created by Joseph on 10. 11. 1..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTTPNetworkManager.h"


@implementation HTTPNetworkManager

/**
 * @brief 일반 HTTP 비동기 요청시 사용
 * @author 강요셉
 * @param newURL - 요청 URL
 * @param setDelegate - 응답받을 부모
 */
+ (id)requestWithURL:(NSString *)newURL setDelegate:(id)del
{	
	NSURL *url = [NSURL URLWithString:
				   [newURL  stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR)]];
	HTTPNetworkManager *request = [self requestWithURL:url];
	[request setTimeOutSeconds:NET_TIME_OUT];
	[request setDelegate:del];
	[request startAsynchronous];
	
	return request;
}

/**
 * @brief 델리게이트 선택 HTTP 비동기 요청시 사용
 * @author 강요셉
 * @param newURL - 요청 URL
 * @param setDelegate - 응답받을 부모
 */
+ (id)requestWithURL:(NSString *)newURL setDelegate:(id)del finishSel:(SEL)finishSelector failSel:(SEL)failSelector
{	
	NSURL *url = [NSURL URLWithString:
				  [newURL  stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR)]];
	HTTPNetworkManager *request = [self requestWithURL:url];
	[request setTimeOutSeconds:NET_TIME_OUT];
	[request setDelegate:del];
	[request setDidFinishSelector:finishSelector];
	[request setDidFailSelector:failSelector];
	
	[request startAsynchronous];
	
	return request;
}

/**
 * @brief 일반 POST 방식 HTTP 비동기 요청시 사용
 * @author 강요셉
 * @param newURL - 요청 URL
 * @param setDelegate - 응답받을 부모
 */
+ (id)requestPostWithURL:(NSString *)newURL setDelegate:(id)del
{	
	NSURL *url = [NSURL URLWithString:
				  [newURL  stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR)]];
	HTTPNetworkManager *request = [self requestWithURL:url];
	[request setTimeOutSeconds:NET_TIME_OUT];
	[request setDelegate:del];
		
	return request;
}

/**
 * @brief 델리게이트 선택 POST 방식 HTTP 비동기 요청시 사용
 * @author 강요셉
 * @param newURL - 요청 URL
 * @param setDelegate - 응답받을 부모
 */
+ (id)requestPostWithURL:(NSString *)newURL setDelegate:(id)del finishSel:(SEL)finishSelector failSel:(SEL)failSelector
{	
	NSURL *url = [NSURL URLWithString:
				  [newURL  stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR)]];
	HTTPNetworkManager *request = [self requestWithURL:url];
	[request setTimeOutSeconds:NET_TIME_OUT];
	[request setDelegate:del];
	[request setDidFinishSelector:finishSelector];
	[request setDidFailSelector:failSelector];
	
	return request;
}

/**
 * @brief 큐를 이용한 HTTP 비동기 요청시 사용
 * @author 강요셉
 * @param newURL - 요청 URL
 * @param setDelegate - 응답받을 부모
 * @param setTag - 태그설정
 * @param setQueue - 요청을 넣을 큐 포인터
 * @param finishSel - 요청성공 시 델리게이트
 * @param failSel - 요청실패 시 델리게이트
 */
+ (id)requestWithQueue:(NSString *)newURL 
						setDelegate:(id)del 
						setTag:(NSUInteger)tag 
						setQueue:(NSOperationQueue *)queue
						finishSel:(SEL)finishSelector
						failSel:(SEL)failSelector
{
	NSURL *url = [NSURL URLWithString:
				  [newURL  stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR)]];
	HTTPNetworkManager *request = [self requestWithURL:url];
	
	[request setTimeOutSeconds:NET_TIME_OUT];
	[request setDelegate:del];
	[request setTag:tag];			//태그를 현재 인덱스에 맞게 설정
	[request setDidFinishSelector:finishSelector];
	[request setDidFailSelector:failSelector];
	[queue addOperation:request];
	
	return request;
}

/**
 * @brief HTTP 비동기 요청 인스턴스 생성
 * @author 강요셉
 */
+ (id)requestWithURL:(NSURL *)newURL
{
	return [[[self alloc] initWithURL:newURL] autorelease];
}

/**
 * @brief HTTP POST연결시 데이터 설정
 * @author 강요셉
 */
- (void)setPostValue:(NSString *)value forKey:(NSString *)key {
	[self setPostValue:value forKey:key];
}

/**
 * @brief 응답취소
 * @author 강요셉
 */
- (void)destroy{
	if (self) {
		[self cancel];
	}
	self.delegate = nil;
}

@end
