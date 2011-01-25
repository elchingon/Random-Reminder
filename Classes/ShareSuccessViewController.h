//
//  ShareSuccessViewController.h
//  remindful-base
//
//  Created by David Lowman on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareSuccessViewControllerDelegate;
@interface ShareSuccessViewController : UIViewController {
id <ShareSuccessViewControllerDelegate> delegate;
    IBOutlet UIImageView *success_message;
    
    
}
@property (nonatomic, assign) id <ShareSuccessViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIImageView *success_message;

- (IBAction)openWebsite;

@end

@protocol ShareSuccessViewControllerDelegate
- (void)shareSuccessViewControllerDidFinish:(ShareSuccessViewController *)controller;
@end
