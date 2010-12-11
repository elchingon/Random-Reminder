//
//  Tweet.h
//  remindful-base
//
//  Created by David Lowman on 12/11/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Tweet : NSObject {
    NSDictionary *contents;
}
-(id)initWithTweetDictionary:(NSDictionary*)_contents;
-(NSString*)tweet;
-(NSString*)author;
@end
