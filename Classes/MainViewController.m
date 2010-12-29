//
//  MainViewController.m
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

// Your Facebook App Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
static NSString* kAppId = @"173331372680031";


@synthesize managedObjectContext, reminderPicker, remindfulAction, facebookButton, twitterButton, fromTime, toTime, verb;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //////////////////////////////////////////////////////////////////////////////////////
    // pickerView Data
    reminderTypes = [[NSArray alloc] initWithObjects:@"Stretch", @"Relax", @"Notice the present moment", @"Breathe", @"Smile", @"Feel the force", @"Let the tension go", @"Be kind to yourself", @"Notice the absurd", @"Rest your eyes", nil];
    
    reminderStart = [[NSArray alloc] initWithObjects:@"12am",@"1am", @"2am", @"3am", @"4am", @"5am", @"6am", @"7am", @"8am",@"9am", @"10am", @"11am", @"12pm", @"1pm", @"2pm", @"3pm", @"4pm", @"5pm", @"6pm", @"7pm", @"8pm",@"9pm", @"10pm", @"11pm",  nil];
    
    reminderFinish = [[NSArray alloc] initWithObjects:@"12am",@"1am", @"2am", @"3am", @"4am", @"5am", @"6am", @"7am", @"8am",@"9am", @"10am", @"11am", @"12pm", @"1pm", @"2pm", @"3pm", @"4pm", @"5pm", @"6pm", @"7pm", @"8pm",@"9pm", @"10pm", @"11pm",  nil];
    ////////////////////////////////////////////////////////////////////////////////////////
    // get user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults removeObjectForKey:@"remindful_action"];
    //[defaults removeObjectForKey:@"start_time"];
    //[defaults removeObjectForKey:@"end_time"];
    //[defaults synchronize];

    [self refreshButtons];
    
    // action Label vars
    NSNumber *start = [defaults objectForKey:@"start_time"];
    NSNumber *end = [defaults objectForKey:@"end_time"];
    
    if ([defaults objectForKey:@"start_time"]) {
        fromTime = [reminderStart objectAtIndex:[start intValue]];
    } else {
        fromTime = @"9am";
    }
    
    if ([defaults objectForKey:@"end_time"]) {
        toTime = [reminderFinish objectAtIndex:[end intValue]];
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

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)refreshButtons {
    ////////////////////////////////////////////////////////////////////////////////////////
    // get user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults removeObjectForKey:@"remindful_action"];
    //[defaults removeObjectForKey:@"start_time"];
    //[defaults removeObjectForKey:@"end_time"];
    //[defaults synchronize];

    ////////////////////////////////////////////////////////////////////////////////////////
    // facebook status
    if ([defaults objectForKey:@"FBAccessToken"]) {
        NSLog(@"facebook is authorized");
        [facebookButton setImage:[UIImage imageNamed:@"facebook_alt.png"] forState:UIControlStateNormal];
        //[facebookButton setEnabled:NO];
    } else {
        NSLog(@"facebook is NOT authorized");
        [facebookButton setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
        //[facebookButton setEnabled:YES];
    }
    /////////////////////////////////////////////////////////////////////////////////////////
    // twitter status
    if([defaults objectForKey:@"authData"]) {
        NSLog(@"twitter is authorized");
        [twitterButton setImage:[UIImage imageNamed:@"twitter_alt.png"] forState:UIControlStateNormal];
        //[twitterButton setEnabled:NO];
    }else{
        NSLog(@"twitter is NOT authorized");
        [twitterButton setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
        //[twitterButton setEnabled:YES];
    }

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
    NSNumber *start = [defaults objectForKey:@"start_time"];
    NSNumber *end = [defaults objectForKey:@"end_time"];
    
    if ([defaults objectForKey:@"remindful_action"]) {
        [reminderPicker selectRow:[reminderTypes indexOfObject:[defaults objectForKey:@"remindful_action"]] inComponent:0 animated:YES];
    } else {
        [reminderPicker selectRow:1 inComponent:0 animated:YES];
    }

    if ([defaults objectForKey:@"start_time"]) {
        [reminderPicker selectRow:[start intValue] inComponent:1 animated:YES];
    } else {
        [reminderPicker selectRow:9 inComponent:1 animated:YES];
    }
    
    if ([defaults objectForKey:@"end_time"]) {
        [reminderPicker selectRow:[end intValue] inComponent:2 animated:YES];
    } else {
        [reminderPicker selectRow:17 inComponent:2 animated:YES];
    }

    
       //[self performSelector:@selector(presentIntroduction) withObject:nil afterDelay:0.8];
    
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
    NSDate *now = [NSDate date];
    //set up vars for notification from reminderPicker
    int startTime = [reminderPicker selectedRowInComponent:1];
    int endTime = [reminderPicker selectedRowInComponent:2];
    NSString *action = [reminderTypes objectAtIndex:[reminderPicker selectedRowInComponent:0]];
    Reminder *reminder = [[Reminder alloc] init];
    [reminder cancelAllReminders];
    NSDate *reminderDate = [reminder scheduleReminder:reminder action:action startTime:startTime endTime:endTime repeat:YES];
    NSLog(@"date of reminder: %@", reminderDate);
    
    if ([reminderDate isEqual:[now earlierDate:reminderDate]]) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:now];

        Reminder *soloReminder = [[Reminder alloc] init];
        [soloReminder scheduleReminder:soloReminder action:action startTime:comps.hour endTime:endTime repeat:NO];
    }
    
    NSNumber *start = [NSNumber numberWithInt:startTime];
    NSNumber *end = [NSNumber numberWithInt:endTime];
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:start forKey:@"start_time"];
    [defaults setObject:end forKey:@"end_time"];
    [defaults setObject:action forKey:@"remindful_action"];
    [defaults synchronize];

    // show Reminder
    [self showReminder:action];
    
    [reminder release];

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

- (IBAction)showIntro {
    BOOL visible = [self.modalViewController isViewLoaded];
    NSLog(@"visible: %d", visible );
    NSLog(@"current modal view: %@", self.modalViewController);
    
    
    IntroViewController *controller = [[IntroViewController alloc] initWithNibName:@"IntroViewController" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:NO];
    [controller release];
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
    
}


- (void)introViewControllerDidFinish:(IntroViewController *)controller {
    
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
    [facebook release];
    [permissions release];
    [managedObjectContext release];
    [super dealloc];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
// Facebook login

/**
 * FBAuth
 */ 
- (IBAction)login:(id)sender {
    permissions =  [[NSArray arrayWithObjects: 
                     @"publish_stream",@"read_stream", @"offline_access", @"publish_checkins",nil] retain];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    facebook = [[Facebook alloc] init];
    facebook.accessToken = [defaults objectForKey:@"FBAccessToken"];
    facebook.expirationDate = [defaults objectForKey:@"FBSessionExpires"];
    
    if ([facebook isSessionValid]) {
        NSLog(@"session was valid");
        [facebook logout:self];
    }else {
        NSLog(@"session was NOT valid");
        [facebook authorize:kAppId permissions:permissions delegate:self];
    }

}

//////////////////////////////////////////////////////////////////////////////////////////////////
// Facebook Session Delegates

/**
 * Called when the dialog successful log in the user
 */
- (void)fbDidLogin {
    NSLog(@"user did login");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *access_token = facebook.accessToken;
    if ((access_token != (NSString *) [NSNull null]) && (access_token.length > 0)) {
        [defaults setObject:access_token forKey:@"FBAccessToken"];
    } else {
        [defaults removeObjectForKey:@"FBAccessToken"];
    }
    
    NSDate *expirationDate = facebook.expirationDate;  
    if (expirationDate) {
        [defaults setObject:expirationDate forKey:@"FBSessionExpires"];
    } else {
        [defaults removeObjectForKey:@"FBSessionExpires"];
    }
    
    [defaults synchronize];
    
    [self refreshButtons];
    
    NSLog(@"userDefaults: %@", [defaults objectForKey:@"FBAccessToken"]);
    NSLog(@"userDefaults: %@", [defaults objectForKey:@"FBSessionExpires"]);
    
    //[facebook requestWithGraphPath:@"me" andDelegate:self];
    
}

/**
 * Called when the user dismiss the dialog without login
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"user CANCELLED login");
   
}

/**
 * Called when the user is logged out
 */
- (void)fbDidLogout {
    NSLog(@"user did LOGOUT");
    // does not fire? is session still valid on view did load?
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"FBAccessToken"];
    [defaults removeObjectForKey:@"FBSessionExpires"];
    
    [defaults synchronize]; 
    [self refreshButtons];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// Twitter login

// login action
- (IBAction)loginTwitter:(id)sender {
    
    // get user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"authData"]) {
        NSLog(@"twitter is authorized");
        [defaults removeObjectForKey:@"authData"];
        [defaults synchronize];
        [self refreshButtons];
        
    }else{
        NSLog(@"twitter is NOT authorized");
        
        // login
        _engine = [SA_OAuthTwitterEngine OAuthTwitterEngineWithDelegate:self];
        _engine.consumerKey = @"hHkdIPMUKDO594ZndN7feg";
        _engine.consumerSecret = @"zp0QQv2F4aPeAmam0L1xFuOw6YTKlyo4ZGs3NO5YQ";
        
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
        
        [self presentModalViewController: controller animated: YES];
                
    }

       
}


// store auth data
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    NSLog(@"called");
    
    NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
    NSLog(@"auth Data: %@", [defaults objectForKey:@"authData"]);
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
    [self refreshButtons];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    NSLog(@"Authentication Failure");
    [self refreshButtons];
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    NSLog(@"Authentication Canceled");
    
}

#pragma mark MGTwitterEngineDelegate Methods

- (void)requestSucceeded:(NSString *)connectionIdentifier {
    
	NSLog(@"Request Suceeded: %@", connectionIdentifier);
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
    
}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Recieved Object: %@", dictionary);
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Direct Messages Received: %@", messages);
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"User Info Received: %@", userInfo);
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Misc Info Received: %@", miscInfo);
}



@end
