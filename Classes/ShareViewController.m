//
//  ShareViewController.m
//  remindful-base
//
//  Created by David Lowman on 12/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"


@implementation ShareViewController

// Your Facebook App Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
static NSString* kAppId = @"173331372680031";

@synthesize facebookButton, twitterButton, facebookMessage, twitterMessage, delegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    permissions =  [[NSArray arrayWithObjects: 
                              @"publish_stream",@"read_stream", @"offline_access", @"publish_checkins", @"email",nil] retain];

    // init facebook
    facebook = [[Facebook alloc] init];
    facebook.accessToken = [defaults objectForKey:@"FBAccessToken"];
    facebook.expirationDate = [defaults objectForKey:@"FBSessionExpires"];
    // intit twitter
    _engine = [[SA_OAuthTwitterEngine OAuthTwitterEngineWithDelegate:self] retain];
    _engine.consumerKey = @"hHkdIPMUKDO594ZndN7feg";
    _engine.consumerSecret = @"zp0QQv2F4aPeAmam0L1xFuOw6YTKlyo4ZGs3NO5YQ";
    [self refreshButtons];
}


- (IBAction)shareReminder:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *message = [NSString stringWithFormat:@"The message is: %@", [defaults objectForKey:@"remindful_action"]];

    
    if(sendTwitter == YES) {
        
                [_engine sendUpdate:message];
        
    }
    
    //share facebook
    
    
        
    if (sendFacebook == YES) {
        NSLog(@"session was valid");
        //[facebook logout:self];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       message,@"message",
                                       @"Remindful",@"name",
                                       @"http://www.randomappsofkindness/", @"link",
                                       @"this is the link caption", @"caption",
                                       @"this is the description, which is also related to the link", @"description",
                                       @"[{\"name\":\"Get Remindful!\",\"link\":\"http://www.randomappsofkindness/\"}]",@"actions",
                                       nil];
        // post to users wall
        [facebook requestWithGraphPath:@"me/feed"   // or use page ID instead of 'me'
                             andParams:params
                         andHttpMethod:@"POST"
                           andDelegate:self];
        // post to app wall
        [facebook requestWithGraphPath:@"173331372680031/feed"   // or use page ID instead of 'me'
                             andParams:params
                         andHttpMethod:@"POST"
                           andDelegate:self];
        }
        
    // present success card   
    ShareSuccessViewController *controller = [[ShareSuccessViewController alloc] initWithNibName:@"ShareSuccessViewController" bundle:nil];
    
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentModalViewController:controller animated:YES];
    
    // check which message we are sending and setImage of UIImageView on success card
    if (sendTwitter == YES && sendFacebook == YES) {
        [controller.success_message setImage:[UIImage imageNamed:@"success_all.png"]];
    }else if (sendTwitter == YES){
        [controller.success_message setImage:[UIImage imageNamed:@"success_twitter.png"]];
    }else if (sendFacebook == YES){
        [controller.success_message setImage:[UIImage imageNamed:@"success_facebook.png"]];
    }else {
        NSLog(@"nothing shared");
    }

    
    [controller release];
        
}

- (void)shareSuccessViewControllerDidFinish:(ShareSuccessViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)toggleTwitter:(id)sender {
    
    /////////////////////////////////////////////////////////////////////////////////////////
    // twitter status
    if([_engine isAuthorized]) {
        if (sendTwitter == YES) {
            sendTwitter = NO;
            [twitterButton setImage:[UIImage imageNamed:@"share_twitter_button.png"] forState:UIControlStateNormal];
        } else {
            sendTwitter = YES;
            [twitterButton setImage:[UIImage imageNamed:@"share_twitter_button_alt.png"] forState:UIControlStateNormal];

        }
      
    } else {
        
        // login
               
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
        
        [self presentModalViewController:controller animated: YES];
    }

    
}

- (IBAction)toggleFacebook:(id)sender{
    ////////////////////////////////////////////////////////////////////////////////////////
    // facebook status
    if ([facebook isSessionValid]) {
        
        if (sendFacebook == YES) {
            sendFacebook = NO;
            [facebookButton setImage:[UIImage imageNamed:@"share_facebook_button.png"] forState:UIControlStateNormal];
        } else {
            
            sendFacebook = YES;
            [facebookButton setImage:[UIImage imageNamed:@"share_facebook_button_alt.png"] forState:UIControlStateNormal];
        }
       
    } else {
        
        [facebook authorize:kAppId permissions:permissions delegate:self];
    }

            
}


//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)refreshButtons {
    ////////////////////////////////////////////////////////////////////////////////////////
    // facebook status
    if ([facebook isSessionValid]) {
        NSLog(@"facebook is authorized");
        sendFacebook = YES;
        [facebookButton setImage:[UIImage imageNamed:@"share_facebook_button_alt.png"] forState:UIControlStateNormal];
    } else {
        NSLog(@"facebook is NOT authorized");
        sendFacebook = NO;
        [facebookButton setImage:[UIImage imageNamed:@"share_facebook_button.png"] forState:UIControlStateNormal];
    }
    /////////////////////////////////////////////////////////////////////////////////////////
    // twitter status
    if([_engine isAuthorized]) {
        NSLog(@"twitter is authorized");
        sendTwitter = YES;
        [twitterButton setImage:[UIImage imageNamed:@"share_twitter_button_alt.png"] forState:UIControlStateNormal];
    }else{
        NSLog(@"twitter is NOT authorized");
        sendTwitter = NO;
        [twitterButton setImage:[UIImage imageNamed:@"share_twitter_button.png"] forState:UIControlStateNormal];
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
    [facebook release];
    [permissions release];
    [_engine release];
    [super dealloc];
}



//////////////////////////////////////////////////////////////////////////////////////////////////
// Facebook login


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
    NSLog(@"posted to wall");
    NSLog(@"did load %@", result);
    [facebookMessage setText:@"You have shared to facebook!"];
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest*)request didLoadRawResponse:(NSData*)data {
    NSLog(@"did load raw respose %@", data);
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//Twitter

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
    [twitterMessage setText:@"You have tweeted!"];
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
