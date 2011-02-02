//
//  FlipsideViewController.h
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Reminder.h"
#import "ShareViewController.h"
#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController <ShareViewControllerDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
    IBOutlet UILabel *reminderAction;
    IBOutlet UILabel *reminderQuote;
    IBOutlet UILabel *reminderAuthor;
    IBOutlet UIButton *done_sharing_button;
    IBOutlet UIButton *share_facebook_button;
    IBOutlet UIButton *share_twitter_button;
}
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *reminderAction;
@property (nonatomic, retain) IBOutlet UILabel *reminderQuote;
@property (nonatomic, retain) IBOutlet UILabel *reminderAuthor;
@property (nonatomic, retain) IBOutlet UIButton *done_sharing_button;
@property (nonatomic, retain) IBOutlet UIButton *share_facebook_button;
@property (nonatomic, retain) IBOutlet UIButton *share_twitter_button;

- (IBAction)done:(id)sender;
- (IBAction)share:(id)sender;

@end

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
