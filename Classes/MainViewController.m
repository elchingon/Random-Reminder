//
//  MainViewController.m
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize reminderPicker, remindfulAction, enable_sharing_button, fromTime, toTime, verb;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //////////////////////////////////////////////////////////////////////////////////////
    // pickerView Data
    reminderTypes = [[NSArray alloc] initWithObjects:@"smile", @"breathe", @"stretch", @"listen", @"love", @"let go", @"open up", @"have fun", @"feel the force", @"observe",  nil];
    
    reminderQuotes = [[NSArray alloc] initWithObjects:@"Allowing yourself to smile takes 99% of the effort.", @"Whenever I feel blue, I start breathing again.", @"As any jazz musician knows, it takes flexibility and adaptability for improvisation to create beauty.", @"Much silence makes a powerful noise.", @"Kindness is a language which the deaf can hear and the blind can see.", @"If the person you are talking to doesn't appear to be listening, be patient. It may simply be that he has a small piece of fluff in his ear.", @"There are two ways to live your life - one is as though nothing is a miracle, the other is as though everything is a miracle.", @"You can discover more about a person in an hour of play than in a year of conversation.", @"What the world needs is people who have come alive.", @"With an eye made quiet by the power of harmony, and the deep power of joy, we see into the life of things.", nil];
    
    reminderAuthors = [[NSArray alloc] initWithObjects:@"Simon Travaglia", @"L. Frank Baum", @"Doc Childre and Bruce Cryer", @"African proverb", @"Mark Twain", @"A. A. Milne", @"Albert Einstein", @"Plato", @"Robert Thurman", @"William Wordsworth", nil];
    
    reminderStart = [[NSArray alloc] initWithObjects:@"12am",@"1am", @"2am", @"3am", @"4am", @"5am", @"6am", @"7am", @"8am",@"9am", @"10am", @"11am", @"12pm", @"1pm", @"2pm", @"3pm", @"4pm", @"5pm", @"6pm", @"7pm", @"8pm",@"9pm", @"10pm", @"11pm",  nil];
    
    reminderFinish = [[NSArray alloc] initWithObjects:@"12am",@"1am", @"2am", @"3am", @"4am", @"5am", @"6am", @"7am", @"8am",@"9am", @"10am", @"11am", @"12pm", @"1pm", @"2pm", @"3pm", @"4pm", @"5pm", @"6pm", @"7pm", @"8pm",@"9pm", @"10pm", @"11pm",  nil];
    
    ////////////////////////////////////////////////////////////////////////////////////////
    // get user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults removeObjectForKey:@"remindful_action"];
    //[defaults removeObjectForKey:@"start_time"];
    //[defaults removeObjectForKey:@"end_time"];
    //[defaults synchronize];

    
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
    
    [self refreshButtons];
}


////////////////////////////////////////////////////////////////////////////////////////////
// pickerView datasource methods
//

// set number of components.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// set up picker view with default or saved settings.
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

}

// set nimber of rows per component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    int rows = 10;
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

//////////////////////////////////////////////////////////////////////////////////////////////////////
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
        [sentence release];
        
    }else if (component == 1) {
        
        NSString *sentence = [[NSString alloc] initWithFormat:@"%@ from %@ to %@", verb, [reminderStart objectAtIndex:row], toTime];
        [remindfulAction setText:sentence];
        [sentence release];
        
    }else if (component == 2) {
        
        NSString *sentence = [[NSString alloc] initWithFormat:@"%@ from %@ to %@", verb, fromTime, [reminderFinish objectAtIndex:row]];
        [remindfulAction setText:sentence];
        [sentence release];
        
    }
}

// get row data from array
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = @"title";
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
    int width = 80;
    if (component == 0) {
        width = 140;
    }else if (component == 1) {
        width = 80;
    }else if (component == 2) {
        width = 80;
    }
    return width;
}

////////////////////////////////////////////////////////////////////////////////////////////////
// set reminders

// set reminder notification
- (void)setReminder:(id)sender {
    NSDate *now = [NSDate date];
    //set up vars for notification from reminderPicker
    int startTime = [reminderPicker selectedRowInComponent:1];
    int endTime = [reminderPicker selectedRowInComponent:2];
    NSString *action = [reminderTypes objectAtIndex:[reminderPicker selectedRowInComponent:0]];
    NSString *quote = [reminderQuotes objectAtIndex:[reminderPicker selectedRowInComponent:0]];
    NSString *author = [reminderAuthors objectAtIndex:[reminderPicker selectedRowInComponent:0]];
    // create reminder
    Reminder *reminder = [[Reminder alloc] init];
    [reminder cancelAllReminders];
    NSDate *reminderDate = [reminder scheduleReminder:reminder action:action quote:quote author:author startTime:startTime endTime:endTime repeat:YES];
    NSLog(@"date of reminder: %@", reminderDate);
    
    if ([reminderDate isEqual:[now earlierDate:reminderDate]]) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:now];
        
        Reminder *soloReminder = [[Reminder alloc] init];
        [soloReminder scheduleReminder:soloReminder action:action quote:quote author:author startTime:comps.hour endTime:endTime repeat:NO];
        
        [soloReminder release];
        [calendar release];
    }
    
    NSNumber *start = [NSNumber numberWithInt:startTime];
    NSNumber *end = [NSNumber numberWithInt:endTime];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:start forKey:@"start_time"];
    [defaults setObject:end forKey:@"end_time"];
    [defaults setObject:action forKey:@"remindful_action"];
    [defaults synchronize];
    
    // show Reminder
    [self showReminder:action withQuote:quote andAuthor:author];
    
    [reminder release];
    
}

// set reminder notification
- (void)setReminder {
    NSDate *now = [NSDate date];
    //set up vars for notification from reminderPicker
    int startTime = [reminderPicker selectedRowInComponent:1];
    int endTime = [reminderPicker selectedRowInComponent:2];
    NSString *action = [reminderTypes objectAtIndex:[reminderPicker selectedRowInComponent:0]];
    NSString *quote = [reminderQuotes objectAtIndex:[reminderPicker selectedRowInComponent:0]];
    NSString *author = [reminderAuthors objectAtIndex:[reminderPicker selectedRowInComponent:0]];
    // create reminder
    Reminder *reminder = [[Reminder alloc] init];
    [reminder cancelAllReminders];
    NSDate *reminderDate = [reminder scheduleReminder:reminder action:action quote:quote author:author startTime:startTime endTime:endTime repeat:YES];
    NSLog(@"date of reminder: %@", reminderDate);
    
    if ([reminderDate isEqual:[now earlierDate:reminderDate]]) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:now];

        Reminder *soloReminder = [[Reminder alloc] init];
        [soloReminder scheduleReminder:soloReminder action:action quote:quote author:author startTime:comps.hour endTime:endTime repeat:NO];
        [soloReminder release];
        [calendar release];
    }
    
    NSNumber *start = [NSNumber numberWithInt:startTime];
    NSNumber *end = [NSNumber numberWithInt:endTime];
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:start forKey:@"start_time"];
    [defaults setObject:end forKey:@"end_time"];
    [defaults setObject:action forKey:@"remindful_action"];
    [defaults synchronize];

      
    [reminder release];

}
/////////////REMOVE
// show reminder preview
- (void)showReminder:(NSString *)reminderText withQuote:(NSString *)quote andAuthor:(NSString *)author {
    BOOL visible = [self.modalViewController isViewLoaded];
    NSLog(@"visible: %d", visible );
    NSLog(@"current modal view: %@", self.modalViewController);
    
    if (visible) {
        [self.modalViewController dismissModalViewControllerAnimated:YES];

    }
        
    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller.reminderAction setText:reminderText];
    [controller.reminderQuote setText:quote];
    [controller.reminderAuthor setText:author];
	[controller release];
}
// close reminder view.
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
    
}


////////////////////////////////////////
// show reninder preview action.
- (IBAction)showPreview:(id)sender {
    NSString *action = [reminderTypes objectAtIndex:[reminderPicker selectedRowInComponent:0]];
    NSString *quote = [reminderQuotes objectAtIndex:[reminderPicker selectedRowInComponent:0]];;
    NSString *author = [reminderAuthors objectAtIndex:[reminderPicker selectedRowInComponent:0]];;
    [self setReminder];
    [self showPreview:action withQuote:quote andAuthor:author];
}

// show peminder preview view.
- (void)showPreview:(NSString *)reminderText withQuote:(NSString *)quote andAuthor:(NSString *)author {
    PreviewViewController *controller = [[PreviewViewController alloc] initWithNibName:@"PreviewViewController" bundle:nil];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller.reminderAction setText:reminderText];
    [controller.quote setText:quote];
    [controller.author setText:author];
	[controller release];
}

// close preview view
- (void)previewViewControllerDidFinish:(PreviewViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
    
}

// show facebook and twitter login page.
- (IBAction)showSocialViewController {
    SocialViewController *controller = [[SocialViewController alloc] initWithNibName:@"SocialViewController" bundle:nil];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
    [controller release];
}

- (void)socialViewControllerDidFinish:(SocialViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
    [self refreshButtons];
    
}


//////////////////////////////////////////////////////////////////////////
// intro page
- (void)showIntro {
    
    IntroViewController *controller = [[IntroViewController alloc] initWithNibName:@"IntroViewController" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:NO];
    [controller release];
}

- (void)introViewControllerDidFinish:(IntroViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
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
    if ([defaults objectForKey:@"FBAccessToken"] && [defaults objectForKey:@"authData"]) {
        NSLog(@"facebook and twitter are authorized");
        [enable_sharing_button setImage:[UIImage imageNamed:@"enable_sharing_button_all.png"] forState:UIControlStateNormal];
        //[facebookButton setEnabled:NO];
    } else if ([defaults objectForKey:@"authData"]){
       
        NSLog(@"twitter is authorized");
        [enable_sharing_button setImage:[UIImage imageNamed:@"enable_sharing_button_twitter.png"] forState:UIControlStateNormal];
    } else if ([defaults objectForKey:@"FBAccessToken"]) {
        [enable_sharing_button setImage:[UIImage imageNamed:@"enable_sharing_button_facebook.png"] forState:UIControlStateNormal];
    } else {
        [enable_sharing_button setImage:[UIImage imageNamed:@"enable_sharing_button.png"] forState:UIControlStateNormal];
    }
          
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
    [fromTime release];
    [toTime release];
    [verb release];
    [super dealloc];
}



@end
