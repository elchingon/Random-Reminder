//
//  Session.h
//  remindful-base
//
//  Created by David Lowman on 12/5/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "FBConnect.h"
#import <Foundation/Foundation.h>


@interface Session : NSObject <FBSessionDelegate, FBRequestDelegate>{
    // Facebook
    Facebook *facebook;
    Session *session;
    NSArray *permissions;

}

- (void)login;

@end
