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
#import "PopOverView.h"
#import "Facebook.h"
#import "Reminder.h"
#import <CoreData/CoreData.h>
@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, SocialViewControllerDelegate, IntroViewControllerDelegate, PreviewViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, FBDialogDelegate> {
    
    NSArray *reminderTypes;
    NSArray *reminderStart;
    NSArray *reminderFinish;
    NSArray *reminders;
    NSString *fromTime;
    NSString *toTime;
    NSString *verb;
    NSManagedObjectContext *managedObjectContext;
    IBOutlet UIPickerView *reminderPicker;
    IBOutlet UILabel *remindfulAction;
    IBOutlet UIButton *enable_sharing_button;
    
}


- (IBAction)showSocialViewController;


// reminders
- (void)showReminder:(NSString *)reminderText;
- (void)showPreview:(NSString *)reminderText withQuote:(NSString *)quote andAuthor:(NSString *)author;
- (IBAction)setReminder:(id)sender;
- (IBAction)showPreview:(id)sender;
- (void)showIntro;

// picker actions
- (IBAction)togglePicker:(id)sender;
- (void)setUpPicker;

- (void)refreshButtons;


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIPickerView *reminderPicker;
@property (nonatomic, retain) UILabel *remindfulAction;
@property (nonatomic, retain) UIButton *enable_sharing_button;
@property (nonatomic, retain) NSString *fromTime;
@property (nonatomic, retain) NSString *toTime;
@property (nonatomic, retain) NSString *verb;

@end
