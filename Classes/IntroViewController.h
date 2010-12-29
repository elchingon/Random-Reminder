//
//  IntroViewController.h
//  remindful-base
//
//  Created by David Lowman on 12/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroViewControllerDelegate;

@interface IntroViewController : UIViewController {
    id <IntroViewControllerDelegate> delegate;
}
@property (nonatomic, assign) id <IntroViewControllerDelegate> delegate;

- (IBAction)next:(id)sender;

@end

@protocol IntroViewControllerDelegate

- (void)introViewControllerDidFinish:(IntroViewController *)controller;

@end