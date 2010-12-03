//
//  MyViewController.m
//  xutils-example
//
//  Created by Shaikh Sonny Aman on 4/21/10.
//  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import "MyViewController.h"

@implementation MyViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

/**
 * Must define this method if setStatus is called
 *
 * This method is called when user status is changed either successfully or not
 */
- (void) facebookAgent:(FacebookAgent*)agent statusChanged:(BOOL) success{
}

/**
 * Must define this method if shouldFetchUsernameAfterLogin is set YES
 *
 * This method is called after the agent fetched facebook profile name
 */
- (void) facebookAgent:(FacebookAgent*)agent didLoadInfo:(NSDictionary*) info{
	
}

/**
 * This method is called after the agent fetched facebook friends
 */
- (void) facebookAgent:(FacebookAgent*)agent didLoadFriendList:(NSArray*) data onlyAppUsers:(BOOL)yesOrNo{
}

/**
 * This method is called after the agent fetched permissions of the app
 */
- (void) facebookAgent:(FacebookAgent*)agent didLoadPermissions:(NSArray*) data{
	
}

/**
 * This method is called after the agent fetched permissions of the app
 */
- (void) facebookAgent:(FacebookAgent*)agent didLoadFQL:(NSArray*) data{
}

/**
 * This method is called after the agent fetched permissions of the app
 */
- (void) facebookAgent:(FacebookAgent*)agent permissionGranted:(FacebookAgentPermission)permission{
}



/**
 * Must define this method if uploadPhoto is called
 *
 * This method is called after photo is uploaded
 */
- (void) facebookAgent:(FacebookAgent*)agent photoUploaded:(NSString*) pid{
}

/**
 * Must impement this method if any of the above method is defined
 *
 * This method is called if the agent fails to perform any of the above three actions
 */
- (void) facebookAgent:(FacebookAgent*)agent requestFaild:(NSString*) message{
}



/**
 * This method is called if after login or logout
 */
- (void) facebookAgent:(FacebookAgent*)agent loginStatus:(BOOL) loggedIn{
}

/**
 * This method is called on dialog errors
 */
- (void) facebookAgent:(FacebookAgent*)agent dialog:(FBDialog*)dialog didFailWithError:(NSError*)error{
}



@end
