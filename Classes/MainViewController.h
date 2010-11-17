//
//  MainViewController.h
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "FBConnect.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import <CoreData/CoreData.h>
@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, FBSessionDelegate, SA_OAuthTwitterControllerDelegate, UIActionSheetDelegate> {
    
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
    
    // facebook
    Facebook *facebook;
    NSArray *permissions;
    
    //twitter
    SA_OAuthTwitterEngine *_engine;
	NSMutableArray *tweets;
}


- (IBAction)showInfo:(id)sender;
- (IBAction)showReminder:(NSString *)reminderText;
- (IBAction)setReminder:(id)sender;
// twitter actions
- (IBAction)configTwitter:(id)sender;
- (IBAction)configTwitter;
- (IBAction)updateStream:(id)sender;
- (IBAction)tweet:(id)sender;
// facebook actions
- (IBAction)configFaceBook:(id)sender;
- (IBAction)configFaceBook;
- (IBAction)logoutFaceBook:(id)sender;
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
