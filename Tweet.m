//
//  Tweet.m
//  remindful-base
//
//  Created by David Lowman on 12/11/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Tweet.h"


@implementation Tweet

- (void)tweet:(NSString *)message {
    _engine = [SA_OAuthTwitterEngine OAuthTwitterEngineWithDelegate:self];
	_engine.consumerKey = @"hHkdIPMUKDO594ZndN7feg";
	_engine.consumerSecret = @"zp0QQv2F4aPeAmam0L1xFuOw6YTKlyo4ZGs3NO5YQ";
    //[_engine ];    
    if([_engine isAuthorized]) {
        NSLog(@"authorized");
        [_engine sendUpdate:message];
    }else{
        NSLog(@"not authed");
    }

}

// controller delegates
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    NSLog(@"Authenticated with user %@", username);
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    NSLog(@"Authentication Failure");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    NSLog(@"Authentication Canceled");
}


// store auth data
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    NSLog(@"called");
    
    NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

//implement these methods to store off the creds returned by Twitter
- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//if you don't do this, the user will have to re-authenticate every time they run
- (void) twitterOAuthConnectionFailedWithData: (NSData *) data {
    
}


#pragma mark MGTwitterEngineDelegate Methods

- (void)requestSucceeded:(NSString *)connectionIdentifier {
    
	NSLog(@"Request Suceeded: %@", connectionIdentifier);
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
        
}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Recieved Object: %@", dictionary);
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Direct Messages Received: %@", messages);
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"User Info Received: %@", userInfo);
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Misc Info Received: %@", miscInfo);
}


@end
