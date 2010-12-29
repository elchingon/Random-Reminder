//
//  ShareViewController.h
//  remindful-base
//
//  Created by David Lowman on 12/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "SA_OAuthTwitterEngine.h"

@protocol ShareViewControllerDelegate;

@interface ShareViewController : UIViewController <FBRequestDelegate, SA_OAuthTwitterEngineDelegate> {
    id <ShareViewControllerDelegate> delegate;
    // Facebook
    IBOutlet UIButton *facebookButton;
    Facebook *facebook;
    // twitter
    IBOutlet UIButton *twitterButton;
    SA_OAuthTwitterEngine *_engine;
    
    IBOutlet UILabel *facebookMessage;
    IBOutlet UILabel *twitterMessage;
    
    BOOL sendFacebook;
    BOOL sendTwitter;

}
@property (nonatomic, assign) id <ShareViewControllerDelegate> delegate;
@property (nonatomic, retain) UIButton *facebookButton;
@property (nonatomic, retain) UIButton *twitterButton;

@property (nonatomic, retain) UILabel *facebookMessage;
@property (nonatomic, retain) UILabel *twitterMessage;



- (IBAction)shareReminder:(id)sender;
- (void)refreshButtons;
- (IBAction)toggleTwitter:(id)sender;
- (IBAction)toggleFacebook:(id)sender;
@end

@protocol ShareViewControllerDelegate
- (void)shareViewControllerDidFinish:(ShareViewController *)controller;
@end
