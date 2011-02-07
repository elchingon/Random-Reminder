//
//  SocialViewController.h
//  remindful-base
//
//  Created by e7systems on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"


@protocol SocialViewControllerDelegate;

@interface SocialViewController : UIViewController <FBDialogDelegate, FBSessionDelegate, FBRequestDelegate, SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate> {
    id <SocialViewControllerDelegate> delegate;
    
    // Facebook
    IBOutlet UIButton *facebookButton;
    Facebook *facebook;
    NSArray *permissions;
    // twitter
    IBOutlet UIButton *twitterButton;
    SA_OAuthTwitterEngine *_engine;
	NSMutableArray *tweets;

}

@property (nonatomic, retain) id <SocialViewControllerDelegate> delegate;
@property (nonatomic, retain) UIButton *facebookButton;
@property (nonatomic, retain) UIButton *twitterButton;


- (IBAction)done:(id)sender;

//login to Facebook
- (IBAction)login:(id)sender;

// login to twitter
- (IBAction)loginTwitter:(id)sender;

- (void)refreshButtons;



@end

@protocol SocialViewControllerDelegate <NSObject>

- (void)socialViewControllerDidFinish:(SocialViewController *)controller;

@end