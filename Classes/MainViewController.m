//
//  MainViewController.m
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize managedObjectContext, reminderPicker, remindfulAction, fromTime, toTime, verb;

// Your Facebook App Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
static NSString* kAppId = @"173331372680031";



- (IBAction)configTwitter:(id)sender {
    
    
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
	_engine.consumerKey = @"hHkdIPMUKDO594ZndN7feg";
	_engine.consumerSecret = @"zp0QQv2F4aPeAmam0L1xFuOw6YTKlyo4ZGs3NO5YQ";
    
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
  
    [self presentModalViewController: controller animated: YES];

}

- (IBAction)configTwitter {
    
    
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
	_engine.consumerKey = @"hHkdIPMUKDO594ZndN7feg";
	_engine.consumerSecret = @"zp0QQv2F4aPeAmam0L1xFuOw6YTKlyo4ZGs3NO5YQ";
    
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
    
    [self presentModalViewController: controller animated: YES];
    
}

-(IBAction)updateStream:(id)sender {
    
}

-(IBAction)tweet:(id)sender {
    
}

#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark SA_OAuthTwitterController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    
	NSLog(@"Authenticated with user %@", username);
    
	tweets = [[NSMutableArray alloc] init];
	[self updateStream:nil];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    
	NSLog(@"Authentication Failure");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    
	NSLog(@"Authentication Canceled");
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    reminderTypes = [[NSArray alloc] initWithObjects:@"breathe", @"smile", @"be Grateful", @"laugh", @"dream", @"eat healthy", nil];
    
    reminderStart = [[NSArray alloc] initWithObjects:@"12am",@"1am", @"2am", @"3am", @"4am", @"5am", @"6am", @"7am", @"8am",@"9am", @"10am", @"11am", @"12pm", @"1pm", @"2pm", @"3pm", @"4pm", @"5pm", @"6pm", @"7pm", @"8pm",@"9pm", @"10pm", @"11pm",  nil];
    
    reminderFinish = [[NSArray alloc] initWithObjects:@"12am",@"1am", @"2am", @"3am", @"4am", @"5am", @"6am", @"7am", @"8am",@"9am", @"10am", @"11am", @"12pm", @"1pm", @"2pm", @"3pm", @"4pm", @"5pm", @"6pm", @"7pm", @"8pm",@"9pm", @"10pm", @"11pm",  nil];
    
    fromTime = @"time";
    toTime = @"time";
    //facebook
    facebook = [[Facebook alloc] init];

	[super viewDidLoad];
}


//
// pickerView datasource methods
//

// set number of components
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (void)setUpPicker {
    [reminderPicker selectRow:3 inComponent:0 animated:YES];
    [reminderPicker selectRow:8 inComponent:1 animated:YES];
    [reminderPicker selectRow:16 inComponent:2 animated:YES];
}

// set nimber of rows per component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    int rows;
    if (component == 0) {
        rows = reminderTypes.count;
    }else if (component == 1) {
        rows = reminderStart.count;
    }else if (component == 2) {
        rows = reminderFinish.count;
        [self performSelector:@selector(setUpPicker) withObject:nil afterDelay:.2];
    }
    
    return rows;
}

//
// pickerView delegate methods
//

// react to row selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    fromTime = [reminderStart objectAtIndex:[pickerView selectedRowInComponent:1]];
    toTime = [reminderFinish objectAtIndex:[pickerView selectedRowInComponent:2]];
    verb = [reminderTypes objectAtIndex:[pickerView selectedRowInComponent:0]];
    if (component == 0) {
        
        NSString *sentence = [[NSString alloc] initWithFormat:@"%@ from %@ to %@",[reminderTypes objectAtIndex:row], fromTime, toTime];
        [remindfulAction setText:sentence];
        
    }else if (component == 1) {
        
        NSString *sentence = [[NSString alloc] initWithFormat:@"%@ from %@ to %@", verb, [reminderStart objectAtIndex:row], toTime];
        [remindfulAction setText:sentence];
        
    }else if (component == 2) {
        
        NSString *sentence = [[NSString alloc] initWithFormat:@"%@ from %@ to %@", verb, fromTime, [reminderFinish objectAtIndex:row]];
        [remindfulAction setText:sentence];
        
    }
}

// get row data from array
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    if (component == 0) {
        title = [reminderTypes objectAtIndex:row];
    }else if (component == 1) {
        title = [reminderStart objectAtIndex:row];
    }else if (component == 2) {
        title = [reminderFinish objectAtIndex:row];
    }
    return title;
}

// set row size
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int width;
    if (component == 0) {
        width = 140;
    }else if (component == 1) {
        width = 80;
    }else if (component == 2) {
        width = 80;
    }
    return width;
}

// pickerView control

- (IBAction)togglePicker:(id)sender {
    if (reminderPicker.hidden == YES) {
        [reminderPicker setHidden:NO];
    }else {
        [reminderPicker setHidden:YES];    }
}



// set reminders
- (IBAction)setReminder:(id)sender {
      
    //set up date components for notification
    int startTime = [reminderPicker selectedRowInComponent:1];
    int endTime = [reminderPicker selectedRowInComponent:2];
    int myHour;
    int myMinute = (arc4random() % 60);
    int mySecond = (arc4random() % 60);
    int range = endTime - startTime;
    
    NSLog(@"start time = integer: %d", startTime);
    NSLog(@"end time = integer: %d", endTime);
    
    if (startTime == endTime) {
        
        myHour = (arc4random() % 24);
        
    }else if (startTime < endTime) {
        
        myHour = (arc4random() % range) + startTime;
        
    }else if (startTime > endTime) {
        
        int theDecider = (arc4random()% 2);
        NSLog(@"the Decider is = integer: %d", theDecider);
        
        if (theDecider == 1) {
            int partRange = 24 - startTime;
            myHour = (arc4random() % partRange) + startTime;            
        } else {
            int partRange = 0 + endTime;
            myHour = (arc4random() % partRange); 
            
        }
        
        
    }
    
    NSLog(@"my hour = integer: %d", myHour);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];
    NSLog(@"creation date equals %@", date);
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    //[comps setHour:myHour];
    //[comps setMinute:myMinute];
    [comps setMinute:comps.minute + 1];
    //[comps setSecond:mySecond];
    [comps setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"comps time zone equals %@", comps.timeZone);
    NSLog(@"comps hour equals %d", comps.hour);
    date = [calendar dateFromComponents:comps];
    
    
    NSLog(@"fire date equals %@", date);
    
    // create the notification
    UILocalNotification *newNotification = [[UILocalNotification alloc] init];
    if (newNotification)
        
    // set the fireDate and the timezone,    
    newNotification.fireDate = date;
    newNotification.timeZone = [NSTimeZone defaultTimeZone];
    NSLog(@"time zone equals %@", newNotification.timeZone);
    
    // Notification details
    newNotification.alertBody = [reminderTypes objectAtIndex:[reminderPicker selectedRowInComponent:0]];
    NSLog(@"alertBody equals %@", newNotification.alertBody);
    
    // Set the action button
    newNotification.alertAction = @"View";
    
    // set the sound
    newNotification.soundName = UILocalNotificationDefaultSoundName;
    
    // set the badgeNumber
    newNotification.applicationIconBadgeNumber = 1;
    
    // Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:newNotification.alertBody forKey:@"name"];
    newNotification.userInfo = infoDict;
    NSLog(@"userInfo equals %@", newNotification.userInfo);
    
    // Schedule the notification
    //[[UIApplication sharedApplication] cancelLocalNotification:newNotification];
    [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
    
    // log
    NSLog(@"Sent Notification %@",newNotification);
    [self showReminder:newNotification.alertBody];
    
    [newNotification release];

       
}

- (IBAction)showReminder:(NSString *)reminderText {
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	[controller.reminderAction setText:reminderText];
	[controller release];
}



- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender {    
    UIActionSheet *shareOptions = [[UIActionSheet alloc]initWithTitle:@"Sharing Options" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Set Up Facebook", @"Set Up Twitter", nil];
    
    [shareOptions showInView:self.view];
	
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Change the navigation bar style, also make the status bar match with it
    switch (buttonIndex)
    {
        case 0:
        {
            [self configFaceBook];
            break;
        }
        case 1:
        {
            [self configTwitter];
            break;
        }
        case 2:
        {
            
            break;
        }
    }
}


- (IBAction)configFaceBook:(id)sender {
    permissions =  [[NSArray arrayWithObjects: 
                      @"publish_stream",@"read_stream", @"offline_access",nil] retain];
    
    
    [facebook authorize:kAppId permissions:permissions delegate:self];
}

- (IBAction)configFaceBook {
    permissions =  [[NSArray arrayWithObjects: 
                     @"publish_stream",@"read_stream", @"offline_access",nil] retain];
    
    
    [facebook authorize:kAppId permissions:permissions delegate:self];
}


- (IBAction)logoutFaceBook:(id)sender {
    [facebook logout:self];
}

/**
 * Callback for facebook login
 */ 
-(void) fbDidLogin {
    NSLog(@"did login");
}

/**
 * Callback for facebook did not login
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"did not login");
}

/**
 * Callback for facebook logout
 */ 
-(void) fbDidLogout {
  NSLog(@"did logout");
}






- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)dealloc {

    [managedObjectContext release];
    [super dealloc];
}

@end
