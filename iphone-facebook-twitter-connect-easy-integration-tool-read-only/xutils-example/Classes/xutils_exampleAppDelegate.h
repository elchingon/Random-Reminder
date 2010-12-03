//
//  xutils_exampleAppDelegate.h
//  xutils-example
//
//  Created by Shaikh Sonny Aman on 4/2/10.
//  Copyright SHAIKH SONNY AMAN :)  2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class xutils_exampleViewController;

@interface xutils_exampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    xutils_exampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet xutils_exampleViewController *viewController;

@end

