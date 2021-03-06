//
//  FlipsideViewController.m
//  remindful-base
//
//  Created by e7systems on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@implementation FlipsideViewController

@synthesize delegate, reminderAction, reminderQuote, reminderAuthor, share_twitter_button, share_facebook_button, done_sharing_button;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
      
}

// close reminder and reset notification for new random time.
- (IBAction)done:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *start = [defaults objectForKey:@"start_time"];
    NSNumber *end = [defaults objectForKey:@"end_time"];

    Reminder *reminder = [[Reminder alloc] init];
    
    [reminder cancelAllReminders];
    
    NSDate *reminderDate = [reminder scheduleReminder:reminder action:reminderAction.text quote:reminderQuote.text author:reminderAuthor.text startTime:[start intValue] endTime:[end intValue] repeat:YES];
    
    NSLog(@"date of reminder: %@", reminderDate);
    
    [reminder release];

	[self.delegate flipsideViewControllerDidFinish:self];	
}

// open share reminder view.
- (IBAction)share:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *start = [defaults objectForKey:@"start_time"];
    NSNumber *end = [defaults objectForKey:@"end_time"];
    
    Reminder *reminder = [[Reminder alloc] init];
    
    [reminder cancelAllReminders];
    
    NSDate *reminderDate = [reminder scheduleReminder:reminder action:reminderAction.text quote:reminderQuote.text author:reminderAuthor.text startTime:[start intValue] endTime:[end intValue] repeat:YES];
    
    NSLog(@"date of reminder: %@", reminderDate);
    
    [reminder release];

      
    ShareViewController *controller = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
    [controller release];

}

// close share reminder view
- (void)shareViewControllerDidFinish:(ShareViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}




@end
