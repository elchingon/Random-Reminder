//
//  xutils_exampleViewController.m
//  xutils-example
//
//  Created by Shaikh Sonny Aman on 4/2/10.
//  Copyright SHAIKH SONNY AMAN :)  2010. All rights reserved.
//

#import "xutils_exampleViewController.h"
#import "BusyAgent.h"
#import "xmacros.h"



@implementation xutils_exampleViewController

@synthesize imagePicker, profileImage, profileName, btnFBConnect, directPhotoApprove, btnFBPublishFeed, btnFBUploadImage;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
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


//*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate =self;
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	directPhotoApprove.enabled = NO;
	btnFBPublishFeed.enabled = NO;
	btnFBUploadImage.enabled = NO;
	
	
	// intialize twitter agent
	twit = [[TwitterAgent alloc] init];
	
	// update delegate
	[[FacebookAgent sharedAgent] setDelegate:self];
}
//*/


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
	[twit release];
	self.imagePicker = nil;
	self.profileName = nil;
	self.profileImage = nil;
	self.btnFBConnect =nil;
	self.btnFBPublishFeed  =nil;
	self.btnFBUploadImage = nil;
	self.directPhotoApprove = nil;
	
	
    [super dealloc];
}

-(IBAction) OnTwitter:(id)sender{
	[[TwitterAgent defaultAgent] twit:@"Search with google!" withLink:@"http://www.google.com" makeTiny:NO];
}
-(IBAction) OnFacebookConnect:(id)sender{
	[[BusyAgent defaultAgent] queueBusy];
	
	if(btnFBConnect.selected){
		[[FacebookAgent sharedAgent] logout];
	}else {
		[[FacebookAgent sharedAgent] login];
	}
}

-(IBAction) OnPhotoUploadPermissionChanged:(id)sender{
	if(directPhotoApprove.on){
		[[FacebookAgent sharedAgent] grantPermission:FacebookAgentPermissionPhotoUpload];
	}else {
		ALERT(@"You can disable it from your profile",@"");
	}

}

-(IBAction) OnFacebook:(id)sender{
	// you have to create a facebook app first! 
	// if done, delete the following two lines :)
	//ALERT(@"Have you created a facebook app?",@"You need to supply valid facebook app api key and ape secret");
	//return;
	[[FacebookAgent sharedAgent] publishFeedWithName:@"Hellow world" 
					 captionText:@"how are you?" 
						imageurl:@"http://amanpages.com/wordpress/wp-content/uploads/2009/12/logo2.png" 
						 linkurl:@"http://amanpages.com/" 
			   userMessagePrompt:@"What do i think:"];
}

-(IBAction) OnUploadImageToFacebook:(id)sender{
	
	[self presentModalViewController:imagePicker animated:YES];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
	[picker dismissModalViewControllerAnimated:NO];
	[[BusyAgent defaultAgent] queueBusy];
	[[FacebookAgent sharedAgent] uploadPhotoAsData:UIImagePNGRepresentation(image) 
									   withCaption:@"A caption" 
										   toAlbum:nil];
	
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[picker dismissModalViewControllerAnimated:YES];
}


// override delegate methods of FacebookAgentDelegate
- (void) facebookAgent:(FacebookAgent*)agent loginStatus:(BOOL) loggedIn{
	btnFBConnect.selected = loggedIn;
	if(!loggedIn){
		profileName.text = @"";
		profileImage.image =nil;
		btnFBPublishFeed.enabled = NO;
		btnFBUploadImage.enabled = NO;
		
		[[BusyAgent defaultAgent] dequeueBusy];
		
	}else {
		btnFBPublishFeed.enabled = YES;
		btnFBUploadImage.enabled = YES;
	}

	
}
- (void) facebookAgent:(FacebookAgent*)agent didLoadInfo:(NSDictionary*) info{
	profileName.text = [NSString stringWithFormat:@"Welcome, %@",[[FacebookAgent sharedAgent] getUserName]];
	[profileImage setUrl:[[FacebookAgent sharedAgent] getUserProfileSquareImage]];
	[[FacebookAgent sharedAgent] getPermissions];
}

- (void) facebookAgent:(FacebookAgent*)agent didLoadPermissions:(NSArray*) data{
	[directPhotoApprove setOn: [[FacebookAgent sharedAgent] hasPermission:FacebookAgentPermissionPhotoUpload] animated:YES];
	
	if(directPhotoApprove.on){
		directPhotoApprove.enabled = NO;
	}else {
		directPhotoApprove.enabled = YES;
	}
	
	[[BusyAgent defaultAgent] dequeueBusy];
}


- (void) facebookAgent:(FacebookAgent*)agent requestFaild:(NSString*) message{
	[[BusyAgent defaultAgent] dequeueBusy];
}
- (void) facebookAgent:(FacebookAgent*)agent statusChanged:(BOOL) success{
}
- (void) facebookAgent:(FacebookAgent*)agent photoUploaded:(NSString*) pid{
	ALERT(@"Photo uploaded!",@"");
	[[BusyAgent defaultAgent] dequeueBusy];
}

- (void) facebookAgent:(FacebookAgent*)agent dialog:(FBDialog*)dialog didFailWithError:(NSError*)error{
}

- (void) facebookAgent:(FacebookAgent*)agent permissionGranted:(FacebookAgentPermission)permission{
	[[FacebookAgent sharedAgent] getPermissions];
}


@end
