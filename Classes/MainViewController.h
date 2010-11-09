//
//  MainViewController.h
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "FBConnect.h"
#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterEngineDelegate, FBSessionDelegate> {
    
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
    SA_OAuthTwitterEngine *_engine;
    Facebook *facebook;
    NSArray *permissions;
}


- (IBAction)showInfo:(id)sender;
- (IBAction)showReminder:(NSString *)reminderText;
- (IBAction)setReminder:(id)sender;
- (IBAction)configTwitter:(id)sender;
- (IBAction)configFaceBook:(id)sender;
- (IBAction)logoutFaceBook:(id)sender;
- (IBAction)togglePicker:(id)sender;
- (void)setUpPicker;


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIPickerView *reminderPicker;
@property (nonatomic, retain) UILabel *remindfulAction;
@property (nonatomic, retain) NSString *fromTime;
@property (nonatomic, retain) NSString *toTime;
@property (nonatomic, retain) NSString *verb;

@end
