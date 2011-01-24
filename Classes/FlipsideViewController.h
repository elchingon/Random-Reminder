//
//  FlipsideViewController.h
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Reminder.h"
#import "ShareViewController.h"
#import "ShareSuccessViewController.h"
#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController <ShareViewControllerDelegate, ShareSuccessViewControllerDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
    IBOutlet UILabel *reminderAction;
    IBOutlet UIImage *share_overlay_image;
    IBOutlet UIButton *done_sharing_button;
    IBOutlet UIButton *share_facebook_button;
    IBOutlet UIButton *share_twitter_button;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) UILabel *reminderAction;
@property (nonatomic, retain) UIImage *share_overlay_image;
@property (nonatomic, retain) UIButton *done_sharing_button;
@property (nonatomic, retain) UIButton *share_facebook_button;
@property (nonatomic, retain) UIButton *share_twitter_button;


- (IBAction)done:(id)sender;
- (IBAction)share:(id)sender;


@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
