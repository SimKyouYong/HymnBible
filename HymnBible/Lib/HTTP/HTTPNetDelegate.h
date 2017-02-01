//
//  HTTPNetDelegate.h
//  GirlBoardApp
//
//  Created by Joseph on 10. 02. 22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HOST_NAME @"http://m.test.hyundai.com/hmb/action.do"

@protocol HTTPDelegate;

#import <UIKit/UIKit.h>

@interface HTTPNetDelegate : NSObject <UIApplicationDelegate> {
	id<HTTPDelegate> delegate;
	NSMutableData *receivedData;
	NSURLResponse *response;
	NSData *result;
}

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, assign) NSData *result;
@property (nonatomic, assign) id<HTTPDelegate> delegate;

- (BOOL)requestHost:(NSDictionary *)bodyObject;
- (BOOL)requestAddress:(NSString *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;


@end

@protocol HTTPDelegate<NSObject>
@required
- (void)DataResponse:(NSData *)readData;
@optional
- (void)NetError:(NSError *)error;
@end
