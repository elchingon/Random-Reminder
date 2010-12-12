//
//  Tweet.h
//  remindful-base
//
//  Created by David Lowman on 12/11/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"


@interface Tweet : NSObject <SA_OAuthTwitterEngineDelegate>{
    SA_OAuthTwitterEngine *_engine;
}

- (void)tweet:(NSString *)message;

@end
