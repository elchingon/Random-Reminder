//
//  Session.m
//  remindful-base
//
//  Created by David Lowman on 12/5/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Session.h"


@implementation Session

// Your Facebook App Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
static NSString* kAppId = @"173331372680031";


- (void)login {
    permissions =  [[NSArray arrayWithObjects: 
                     @"publish_stream",@"read_stream", @"offline_access", @"publish_checkins",nil] retain];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    facebook = [[Facebook alloc] init];
    facebook.accessToken = [defaults objectForKey:@"FBAccessToken"];
    facebook.expirationDate = [defaults objectForKey:@"FBSessionExpires"];
    
    if ([facebook isSessionValid]) {
        NSLog(@"session was valid");
        [facebook logout:self];
    }else {
        NSLog(@"session was NOT valid");
        [facebook authorize:kAppId permissions:permissions delegate:self];
    }
    
}

- (void)shareReminder {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    facebook = [[Facebook alloc] init];
    facebook.accessToken = [defaults objectForKey:@"FBAccessToken"];
    facebook.expirationDate = [defaults objectForKey:@"FBSessionExpires"];
    
    NSString *message = [NSString stringWithFormat:@"The message is: %@", [defaults objectForKey:@"remindful_action"]];
    
    if ([facebook isSessionValid]) {
        NSLog(@"session was valid");
        //[facebook logout:self];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       message,@"message",
                                       @"Remindful",@"name",
                                       @"http://www.randomappsofkindness/", @"link",
                                       @"this is the link caption", @"caption",
                                       @"this is the description, which is also related to the link", @"description",
                                       @"[{\"name\":\"Get Remindful!\",\"link\":\"http://www.randomappsofkindness/\"}]",@"actions",
                                       nil];
        
        [facebook requestWithGraphPath:@"me/feed"   // or use page ID instead of 'me'
                              andParams:params
                          andHttpMethod:@"POST"
                            andDelegate:self];
    }else {
        NSLog(@"session was NOT valid");
        [facebook authorize:kAppId permissions:permissions delegate:self];
        /*
         What do we do if user is not logged in?
         ?set flag and reprocess call if not logged in?
         */
    }
    
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// Facebook Session Delegates

/**
 * Called when the dialog successful log in the user
 */
- (void)fbDidLogin {
    NSLog(@"user did login");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *access_token = facebook.accessToken;
    if ((access_token != (NSString *) [NSNull null]) && (access_token.length > 0)) {
        [defaults setObject:access_token forKey:@"FBAccessToken"];
    } else {
        [defaults removeObjectForKey:@"FBAccessToken"];
    }
    
    NSDate *expirationDate = facebook.expirationDate;  
    if (expirationDate) {
        [defaults setObject:expirationDate forKey:@"FBSessionExpires"];
    } else {
        [defaults removeObjectForKey:@"FBSessionExpires"];
    }
    
    [defaults synchronize];
    
    NSLog(@"userDefaults: %@", [defaults objectForKey:@"FBAccessToken"]);
    NSLog(@"userDefaults: %@", [defaults objectForKey:@"FBSessionExpires"]);
    
    [facebook requestWithGraphPath:@"me" andDelegate:self];

}

/**
 * Called when the user dismiss the dialog without login
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"user CANCELLED login");
}

/**
 * Called when the user is logged out
 */
- (void)fbDidLogout {
    NSLog(@"user did LOGOUT");
    // does not fire? is session still valid on view did load?
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    [defaults removeObjectForKey:@"FBAccessToken"];
    [defaults removeObjectForKey:@"FBSessionExpires"];
    
    [defaults synchronize]; 
  
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// Facebook Request Delegates

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest*)request {
    NSLog(@"request loading %@", request);
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response {
    NSLog(@"did recieve response %@", response);
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
    NSLog(@"did fail with error %@", error);
}

/**
 * Called when a request returns and its response has been parsed into an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {
    if ([result objectForKey:@"name"] == nil) {
        NSLog(@"posted to wall");
        NSLog(@"did load %@", result);
        
        
    } else {
        NSLog(@"did load %@", result);
        NSLog(@"name: %@", [result objectForKey:@"name"]);
        NSLog(@"first name: %@", [result objectForKey:@"first_name"]);
        NSLog(@"last name: %@", [result objectForKey:@"last_name"]);
        NSLog(@"id: %@", [result objectForKey:@"id"]);
        NSLog(@"link: %@", [result objectForKey:@"link"]);
        NSLog(@"locale: %@", [result objectForKey:@"locale"]);
        NSLog(@"timezone: %@", [result objectForKey:@"timezone"]);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[result objectForKey:@"name"] forKey:@"FBname"];
        [defaults setObject:[result objectForKey:@"first_name"] forKey:@"FBfirst_name"];
        [defaults setObject:[result objectForKey:@"last_name"] forKey:@"FBlast_name"];
        [defaults setObject:[result objectForKey:@"id"] forKey:@"FBid"];
        [defaults setObject:[result objectForKey:@"link"] forKey:@"FBlink"];
        [defaults setObject:[result objectForKey:@"locale"] forKey:@"FBlocale"];
        [defaults setObject:[result objectForKey:@"timezone"] forKey:@"FBtimezone"];
    }
    
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest*)request didLoadRawResponse:(NSData*)data {
    NSLog(@"did load raw respose %@", data);
}


@end
