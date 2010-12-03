//
//  xutils_exampleAppDelegate.m
//  xutils-example
//
//  Created by Shaikh Sonny Aman on 4/2/10.
//  Copyright SHAIKH SONNY AMAN :)  2010. All rights reserved.
//

#import "xutils_exampleAppDelegate.h"
#import "xutils_exampleViewController.h"
#import "FacebookAgent.h"

@implementation xutils_exampleAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
 
	
	[[FacebookAgent sharedAgent] initializeWithApiKey:@"YOUR API KEY" 
											ApiSecret:@"YOUR_API SECRET" 
											 ApiProxy:nil];
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
