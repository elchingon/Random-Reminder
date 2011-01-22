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
    IBOutlet UIButton *skip_button;
}
@property (nonatomic, assign) id <IntroViewControllerDelegate> delegate;
@property (nonatomic, retain) UIButton *skip_button;

- (IBAction)next:(id)sender;
- (IBAction)skip:(id)sender;

@end

@protocol IntroViewControllerDelegate

- (void)introViewControllerDidFinish:(IntroViewController *)controller;

@end