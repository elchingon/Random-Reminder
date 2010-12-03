//
//  xutils_exampleViewController.h
//  xutils-example
//
//  Created by Shaikh Sonny Aman on 4/2/10.
//  Copyright SHAIKH SONNY AMAN :)  2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"MyViewController.h"
/////////////////////////
// Import these two header
#import "TwitterAgent.h"
// for some helper macro
#import "xmacros.h"

#import "RemoteImageView.h"

//////////////////////////

@interface xutils_exampleViewController : MyViewController<FacebookAgentDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

	// Declare these two varialbes
	//FacebookAgent* fbAgent;
	TwitterAgent* twit;
	
	UIImagePickerController* imagePicker;
	//////////////////////////////
	
	// Outlets
	RemoteImageView* profileImage;
	UILabel* profileName;
	UIButton* btnFBConnect;
	UIButton* btnFBPublishFeed;
	UIButton* btnFBUploadImage;
	UISwitch* directPhotoApprove;
	
	
}

-(IBAction) OnTwitter:(id)sender;

-(IBAction) OnFacebookConnect:(id)sender;
-(IBAction) OnPhotoUploadPermissionChanged:(id)sender;
-(IBAction) OnFacebook:(id)sender;
-(IBAction) OnUploadImageToFacebook:(id)sender;



@property(nonatomic, retain) UIImagePickerController* imagePicker;

@property(nonatomic, retain) IBOutlet RemoteImageView* profileImage;
@property(nonatomic, retain) IBOutlet UILabel* profileName;
@property(nonatomic, retain) IBOutlet UIButton* btnFBConnect;
@property(nonatomic, retain) IBOutlet UIButton* btnFBPublishFeed;
@property(nonatomic, retain) IBOutlet UIButton* btnFBUploadImage;
@property(nonatomic, retain) IBOutlet UISwitch* directPhotoApprove;
@end

