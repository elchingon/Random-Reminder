//
//  FlipsideViewController.h
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Reminder.h"
#import "FBConnect.h"
#import "SA_OAuthTwitterEngine.h"
#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController <FBRequestDelegate, SA_OAuthTwitterEngineDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
    IBOutlet UILabel *reminderAction;
    // Facebook
    IBOutlet UIButton *facebookButton;
    Facebook *facebook;
    // twitter
    IBOutlet UIButton *twitterButton;
    SA_OAuthTwitterEngine *_engine;
    
    BOOL sendFacebook;
    BOOL sendTwitter;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) UILabel *reminderAction;


- (IBAction)done:(id)sender;
- (IBAction)shareReminder:(id)sender;
- (void)refreshButtons;
- (IBAction)toggleTwitter:(id)sender;
- (IBAction)toggleFacebook:(id)sender;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
