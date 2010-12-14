//
//  MainViewController.h
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "Reminder.h"
#import "FBConnect.h"
#import "PopOverView.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import <CoreData/CoreData.h>
@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, FBDialogDelegate, FBSessionDelegate, SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate> {
    
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
    // Facebook
    IBOutlet UIButton *facebookButton;
    Facebook *facebook;
    NSArray *permissions;
    // twitter
    IBOutlet UIButton *twitterButton;
    SA_OAuthTwitterEngine *_engine;
	NSMutableArray *tweets;

}

- (void)refreshButtons;

//login to Facebook
- (IBAction)login:(id)sender;

// login to twitter
- (IBAction)loginTwitter:(id)sender;

// reminders
- (IBAction)showReminder:(NSString *)reminderText;
- (IBAction)setReminder:(id)sender;

// picker actions
- (IBAction)togglePicker:(id)sender;
- (void)setUpPicker;


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIPickerView *reminderPicker;
@property (nonatomic, retain) UILabel *remindfulAction;
@property (nonatomic, retain) UIButton *facebookButton;
@property (nonatomic, retain) UIButton *twitterButton;
@property (nonatomic, retain) NSString *fromTime;
@property (nonatomic, retain) NSString *toTime;
@property (nonatomic, retain) NSString *verb;

@end
