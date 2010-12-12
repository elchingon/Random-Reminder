//
//  MainViewController.m
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize managedObjectContext, reminderPicker, remindfulAction, facebookButton, fromTime, toTime, verb;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // pickerView Data
    reminderTypes = [[NSArray alloc] initWithObjects:@"breathe", @"smile", @"be Grateful", @"laugh", @"dream", @"eat healthy", nil];
    
    reminderStart = [[NSArray alloc] initWithObjects:@"12am",@"1am", @"2am", @"3am", @"4am", @"5am", @"6am", @"7am", @"8am",@"9am", @"10am", @"11am", @"12pm", @"1pm", @"2pm", @"3pm", @"4pm", @"5pm", @"6pm", @"7pm", @"8pm",@"9pm", @"10pm", @"11pm",  nil];
    
    reminderFinish = [[NSArray alloc] initWithObjects:@"12am",@"1am", @"2am", @"3am", @"4am", @"5am", @"6am", @"7am", @"8am",@"9am", @"10am", @"11am", @"12pm", @"1pm", @"2pm", @"3pm", @"4pm", @"5pm", @"6pm", @"7pm", @"8pm",@"9pm", @"10pm", @"11pm",  nil];
    
    // get user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults removeObjectForKey:@"remindful_action"];
    //[defaults removeObjectForKey:@"start_time"];
    //[defaults removeObjectForKey:@"end_time"];
    //[defaults synchronize];

    
    // facebook status
    if ([defaults objectForKey:@"FBAccessToken"] == nil) {
        [facebookButton setHighlighted:YES];
    } else {
        [facebookButton setHighlighted:NO];
    }
    
    // action Label vars
    if ([defaults integerForKey:@"start_time"]) {
        fromTime = [reminderStart objectAtIndex:[defaults integerForKey:@"start_time"]];
    } else {
        fromTime = @"9am";
    }
    
    if ([defaults integerForKey:@"end_time"]) {
        toTime = [reminderFinish objectAtIndex:[defaults integerForKey:@"end_time"]];
    } else {
        toTime = @"5pm";
    }
    
    NSString *action;
    
    if ([defaults objectForKey:@"remindful_action"]) {
        action = [defaults objectForKey:@"remindful_action"];
    } else {
        action = @"smile";
    }
    
    
    NSString *sentence = [NSString stringWithFormat:@"%@ from %@ to %@", action, fromTime, toTime];
    [remindfulAction setText:sentence];
}

- (void)presentIntroduction {
    
    PopOverView *introView = [[PopOverView alloc] initWithURL:@"http://randomappsofkindness.com" params:nil delegate:self]; 
    [introView show];

}

//
// pickerView datasource methods
//

// set number of components
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (void)setUpPicker {
    // get user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"remindful_action"]) {
        [reminderPicker selectRow:[reminderTypes indexOfObject:[defaults objectForKey:@"remindful_action"]] inComponent:0 animated:YES];
    } else {
        [reminderPicker selectRow:1 inComponent:0 animated:YES];
    }

    if ([defaults integerForKey:@"start_time"]) {
        [reminderPicker selectRow:[defaults integerForKey:@"start_time"] inComponent:1 animated:YES];
    } else {
        [reminderPicker selectRow:9 inComponent:1 animated:YES];
    }
    
    if ([defaults integerForKey:@"end_time"]) {
        [reminderPicker selectRow:[defaults integerForKey:@"end_time"] inComponent:2 animated:YES];
    } else {
        [reminderPicker selectRow:17 inComponent:2 animated:YES];
    }

    
       [self performSelector:@selector(presentIntroduction) withObject:nil afterDelay:0.8];
    
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
      
    //set up vars for notification from reminderPicker
    int startTime = [reminderPicker selectedRowInComponent:1];
    int endTime = [reminderPicker selectedRowInComponent:2];
    NSString *action = [reminderTypes objectAtIndex:[reminderPicker selectedRowInComponent:0]];
    Reminder *reminder = [[Reminder alloc] init];   
    NSDate *reminderDate = [reminder scheduleReminder:reminder action:action startTime:startTime endTime:endTime];
    NSLog(@"date of reminder: %@", reminderDate);
    [reminder release];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:startTime forKey:@"start_time"];
    [defaults setInteger:endTime forKey:@"end_time"];
    [defaults setObject:action forKey:@"remindful_action"];
    [defaults synchronize];

    // show Reminder
    [self showReminder:action];
}

- (IBAction)showReminder:(NSString *)reminderText {
    BOOL visible = [self.modalViewController isViewLoaded];
    NSLog(@"visible: %d", visible );
    NSLog(@"current modal view: %@", self.modalViewController);
        
    
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
    [reminderStart release];
    [reminderFinish release];
    [reminderTypes release];
    [managedObjectContext release];
    [super dealloc];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
// Facebook login

/**
 * FBAuth
 */ 
- (IBAction)login:(id)sender {
    Session *facebookSession = [[Session alloc] init];
    [facebookSession login];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Twitter login

// login action
- (IBAction)loginTwitter:(id)sender {
    
     

   _engine = [SA_OAuthTwitterEngine OAuthTwitterEngineWithDelegate:self];
    [_engine clearAccessToken];
	_engine.consumerKey = @"hHkdIPMUKDO594ZndN7feg";
	_engine.consumerSecret = @"zp0QQv2F4aPeAmam0L1xFuOw6YTKlyo4ZGs3NO5YQ";
    
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
    
    [self presentModalViewController: controller animated: YES];
    
}


// store auth data
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    NSLog(@"called");
    
    NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

//implement these methods to store off the creds returned by Twitter
- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//if you don't do this, the user will have to re-authenticate every time they run
- (void) twitterOAuthConnectionFailedWithData: (NSData *) data {
    
}

// controller delegates
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    NSLog(@"Authenticated with user %@", username);
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    NSLog(@"Authentication Failure");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    NSLog(@"Authentication Canceled");
}




@end
