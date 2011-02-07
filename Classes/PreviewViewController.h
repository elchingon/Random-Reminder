//
//  PreviewViewController.h
//  remindful-base
//
//  Created by e7systems on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PreviewViewControllerDelegate;

@interface PreviewViewController : UIViewController {
	id <PreviewViewControllerDelegate> delegate;
    IBOutlet UILabel *reminderAction;
    IBOutlet UILabel *quote;
    IBOutlet UILabel *author;
    
}
@property (nonatomic, assign) id <PreviewViewControllerDelegate> delegate;
@property (nonatomic, retain) UILabel *reminderAction;
@property (nonatomic, retain) UILabel *quote;
@property (nonatomic, retain) UILabel *author;

- (IBAction)done:(id)sender;

@end

@protocol PreviewViewControllerDelegate
- (void)previewViewControllerDidFinish:(PreviewViewController *)controller;
@end
