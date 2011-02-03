//
//  MainViewController.h
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "SocialViewController.h"
#import "IntroViewController.h"
#import "PreviewViewController.h"
#import "Reminder.h"
@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, SocialViewControllerDelegate, IntroViewControllerDelegate, PreviewViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    
    NSArray *reminderTypes;
    NSArray *reminderQuotes;
    NSArray *reminderAuthors;
    NSArray *reminderStart;
    NSArray *reminderFinish;
    NSString *fromTime;
    NSString *toTime;
    NSString *verb;
    IBOutlet UIPickerView *reminderPicker;
    IBOutlet UILabel *remindfulAction;
    IBOutlet UIButton *enable_sharing_button;
    
}
@property (nonatomic, retain) IBOutlet UIPickerView *reminderPicker;
@property (nonatomic, retain) IBOutlet UILabel *remindfulAction;
@property (nonatomic, retain) IBOutlet UIButton *enable_sharing_button;
@property (nonatomic, retain) NSString *fromTime;
@property (nonatomic, retain) NSString *toTime;
@property (nonatomic, retain) NSString *verb;

// login to facebook and twitter
- (IBAction)showSocialViewController;

// set reminders
- (void)showReminder:(NSString *)reminderText withQuote:(NSString *)quote andAuthor:(NSString *)author;
- (void)showPreview:(NSString *)reminderText withQuote:(NSString *)quote andAuthor:(NSString *)author;
- (void)setReminder;
- (void)setReminder:(id)sender;
- (IBAction)showPreview:(id)sender;
- (void)showIntro;

// set up interface.
- (void)setUpPicker;
- (void)refreshButtons;
- (IBAction)openWebsite;

@end
