//
//  SocialViewController.m
//  remindful-base
//
//  Created by David Lowman on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialViewController.h"


@implementation SocialViewController

// Your Facebook App Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
static NSString* kAppId = @"173331372680031";

@synthesize delegate, facebookButton, twitterButton;

- (IBAction)done:(id)sender {
       
	[self.delegate socialViewControllerDidFinish:self];	
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [facebook release];
    [permissions release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self refreshButtons];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        [facebookButton setImage:[UIImage imageNamed:@"share_facebook_button_alt.png"] forState:UIControlStateNormal];
        //[facebookButton setEnabled:NO];
    } else {
        NSLog(@"facebook is NOT authorized");
        [facebookButton setImage:[UIImage imageNamed:@"share_facebook_button.png"] forState:UIControlStateNormal];
        //[facebookButton setEnabled:YES];
    }
    /////////////////////////////////////////////////////////////////////////////////////////
    // twitter status
    if([defaults objectForKey:@"authData"]) {
        NSLog(@"twitter is authorized");
        [twitterButton setImage:[UIImage imageNamed:@"share_twitter_button_alt.png"] forState:UIControlStateNormal];
        //[twitterButton setEnabled:NO];
    }else{
        NSLog(@"twitter is NOT authorized");
        [twitterButton setImage:[UIImage imageNamed:@"share_twitter_button.png"] forState:UIControlStateNormal];
        //[twitterButton setEnabled:YES];
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// Facebook login

/**
 * FBAuth
 */ 
- (IBAction)login:(id)sender {
    permissions =  [[NSArray arrayWithObjects: 
                     @"publish_stream",@"read_stream", @"offline_access", @"publish_checkins", @"email",nil] retain];
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
    
    [facebook requestWithGraphPath:@"me" andDelegate:self];
    
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[result objectForKey:@"name"] forKey:@"FBname"];
    [defaults setObject:[result objectForKey:@"first_name"] forKey:@"FBfirst_name"];
    [defaults setObject:[result objectForKey:@"last_name"] forKey:@"FBlast_name"];
    [defaults setObject:[result objectForKey:@"id"] forKey:@"FBid"];
    [defaults setObject:[result objectForKey:@"link"] forKey:@"FBlink"];
    [defaults setObject:[result objectForKey:@"locale"] forKey:@"FBlocale"];
    [defaults setObject:[result objectForKey:@"timezone"] forKey:@"FBtimezone"];
    [defaults synchronize];
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest*)request didLoadRawResponse:(NSData*)data {
    NSLog(@"did load raw respose %@", data);
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
    
	[defaults setObject:data forKey: @"authData"];
    [defaults setObject:username forKey: @"TWusername"];
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
