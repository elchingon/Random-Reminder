//
//  MainViewController.m
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "Reminder.h"

@implementation MainViewController

@synthesize managedObjectContext, reminderPicker, remindfulAction, facebookButton, fromTime, toTime, verb;

// Your Facebook App Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
static NSString* kAppId = @"173331372680031";

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    // pickerView Data
    reminderTypes = [[NSArray alloc] initWithObjects:@"breathe", @"smile", @"be Grateful", @"laugh", @"dream", @"eat healthy", nil];
    
    reminderStart = [[NSArray alloc] initWithObjects:@"12am",@"1am", @"2am", @"3am", @"4am", @"5am", @"6am", @"7am", @"8am",@"9am", @"10am", @"11am", @"12pm", @"1pm", @"2pm", @"3pm", @"4pm", @"5pm", @"6pm", @"7pm", @"8pm",@"9pm", @"10pm", @"11pm",  nil];
    
    reminderFinish = [[NSArray alloc] initWithObjects:@"12am",@"1am", @"2am", @"3am", @"4am", @"5am", @"6am", @"7am", @"8am",@"9am", @"10am", @"11am", @"12pm", @"1pm", @"2pm", @"3pm", @"4pm", @"5pm", @"6pm", @"7pm", @"8pm",@"9pm", @"10pm", @"11pm",  nil];
    
    // action Label vars
    fromTime = @"time";
    toTime = @"time";
     
	[super viewDidLoad];
    
    // Facebook
    permissions =  [[NSArray arrayWithObjects: 
                      @"publish_stream",@"read_stream", @"offline_access",nil] retain];
    
    facebook = [[Facebook alloc] init];
    
    if ([facebook isSessionValid]) {
        NSLog(@"session was valid");
        [facebookButton setHighlighted:NO];
    }else {
        [facebookButton setHighlighted:YES];
        NSLog(@"session was NOT valid");
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
      
    //set up vars for notification from reminderPicker
    int startTime = [reminderPicker selectedRowInComponent:1];
    int endTime = [reminderPicker selectedRowInComponent:2];
    NSString *action = [reminderTypes objectAtIndex:[reminderPicker selectedRowInComponent:0]];
    Reminder *reminder = [[Reminder alloc] init];   
    NSDate *reminderDate = [reminder scheduleReminder:reminder action:action startTime:startTime endTime:endTime];
    NSLog(@"date of reminder: %@", reminderDate);
    [reminder release];
    
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
    [facebook release];
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
    
    if ([facebook isSessionValid]) {
        NSLog(@"session was valid");
        [facebook logout:self];
    }else {
        [facebook authorize:kAppId permissions:permissions delegate:self];
        NSLog(@"session was NOT valid");
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// Facebook Session Delegates

/**
 * Called when the dialog successful log in the user
 */
- (void)fbDidLogin {
    NSLog(@"user did login");
    [facebookButton setHighlighted:NO];
    [facebook requestWithGraphPath:@"me" andDelegate:self];
    [facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

/**
 * Called when the user dismiss the dialog without login
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"user CANCELLED login");
    [facebookButton setHighlighted:YES];
}

/**
 * Called when the user is logged out
 */
- (void)fbDidLogout {
    NSLog(@"user did LOGOUT");
    // does not fire? is session still valid on view did load?
    [facebookButton setHighlighted:YES];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// Facebook Request Delegates

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest*)request {
    NSLog(@"request loading %@", request);
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response {
    NSLog(@"did recieve response %@", response);
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
    NSLog(@"did fail with error %@", error);
}

/**
 * Called when a request returns and its response has been parsed into an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {
    NSLog(@"did load %@", result);
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest*)request didLoadRawResponse:(NSData*)data {
    NSLog(@"did load raw respose %@", data);
}

@end
