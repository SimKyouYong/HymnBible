//
//  HTTPNetworkManager.h
//  JCFamily
//
//  Created by Joseph on 10. 11. 1..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

#define NET_TIME_OUT 30.0

@interface HTTPNetworkManager : ASIHTTPRequest {
	
}

+ (id)requestWithURL:(NSString *)newURL setDelegate:(id)del finishSel:(SEL)finishSelector failSel:(SEL)failSelector;
+ (id)requestWithURL:(NSString *)newURL setDelegate:(id)del;

+ (id)requestPostWithURL:(NSString *)newURL setDelegate:(id)del;
+ (id)requestPostWithURL:(NSString *)newURL setDelegate:(id)del finishSel:(SEL)finishSelector failSel:(SEL)failSelector;

+ (id)requestWithQueue:(NSString *)newURL 
		   setDelegate:(id)del 
				setTag:(NSUInteger)tag 
			  setQueue:(NSOperationQueue *)queue
			 finishSel:(SEL)finishSelector
			   failSel:(SEL)failSelector;

+ (id)requestWithURL:(NSURL *)newURL;

- (void)setPostValue:(NSString *)value forKey:(NSString *)key;
- (void)destroy;

@end
