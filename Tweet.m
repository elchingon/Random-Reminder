//
//  Tweet.m
//  remindful-base
//
//  Created by David Lowman on 12/11/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Tweet.h"


@implementation Tweet
-(id)initWithTweetDictionary:(NSDictionary*)_contents {
    
	if(self = [super init]) {
        
		contents = _contents;
		[contents retain];
	}
    
	return self;
}

-(NSString*)tweet {
    
	return [contents objectForKey:@"text"];
}

-(NSString*)author {
    
	return [[contents objectForKey:@"user"] objectForKey:@"screen_name"];
}
@end
