//
//  IntroViewController.m
//  remindful-base
//
//  Created by David Lowman on 12/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IntroViewController.h"


@implementation IntroViewController

@synthesize delegate, skip_button;

- (IBAction)next:(id)sender {
    [self.delegate introViewControllerDidFinish:self];
}

- (IBAction)skip:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"skip_intro"] == @"yes") {
        [defaults setObject:@"no" forKey:@"skip_intro"];
        [skip_button setImage:[UIImage imageNamed:@"skip_button.png"] forState:UIControlStateNormal];
        NSLog(@"key = %@ ", [defaults objectForKey:@"skip_intro"]);
    }else{
        [defaults setObject:@"yes" forKey:@"skip_intro"];
        [skip_button setImage:[UIImage imageNamed:@"skip_button_alt.png"] forState:UIControlStateNormal];
        NSLog(@"key = %@", [defaults objectForKey:@"skip_intro"]);
    }
    
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"no" forKey:@"skip_intro"];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
