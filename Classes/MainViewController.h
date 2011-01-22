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
#import "PopOverView.h"
#import "Facebook.h"
#import "Reminder.h"
#import <CoreData/CoreData.h>
@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, SocialViewControllerDelegate, IntroViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, FBDialogDelegate> {
    
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
    
}


- (IBAction)showSocialViewController;


// reminders
- (IBAction)showReminder:(NSString *)reminderText;
- (IBAction)setReminder:(id)sender;
- (IBAction)showIntro;

// picker actions
- (IBAction)togglePicker:(id)sender;
- (void)setUpPicker;


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIPickerView *reminderPicker;
@property (nonatomic, retain) UILabel *remindfulAction;
@property (nonatomic, retain) NSString *fromTime;
@property (nonatomic, retain) NSString *toTime;
@property (nonatomic, retain) NSString *verb;

@end
