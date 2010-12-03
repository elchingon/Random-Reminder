//
//  RemoteImageView.m
//  HoodPhoto
//
//  Created by Shaikh Sonny Aman on 9/3/09.
//  Copyright 2009 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import "RemoteImageView.h"


@implementation RemoteImageView

@synthesize noCache,notifyId,shouldNotifyTouched, doAnimate, imageURL,isLoaded;

-(void)setUrl:(NSString*)url{
	isLoaded =NO;
	if(!flagConnectionEnded){
		[conn cancel];
		[wait stopAnimating];
		conn = nil;
	}
//	ViewTransitionsAppDelegate *appDelegate = (ViewTransitionsAppDelegate *) [[UIApplication sharedApplication] delegate];
	//id data = [(SnapLogsAppDelegate*)[[UIApplication sharedApplication] delegate] GetRemoteImageCache:url];
	//if(data){
	//	UIImage* tmp  =[UIImage imageWithData:data];
	//	if(tmp)	self.image = tmp;
	//	return;
	//}
	self.imageURL = url;
	if(!wait){
		int tw = self.frame.size.width;
		int th = self.frame.size.height;
		if(th>32)th = 32;
		if(tw>32)tw = 32;
		int tx = (self.frame.size.width - tw)/2;
		int ty = (self.frame.size.height - th)/2;
		wait = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(tx, ty, tw,th)];
		wait.hidesWhenStopped = YES;
		
		[self addSubview:wait];
	}
	[wait startAnimating];
	
	flagConnectionEnded = NO;
	
	NSLog(@"RemoteImageView: loading image at: %@",url);
	NSURL *imageURL1 = [NSURL URLWithString:url];
	NSURLRequest *req;
	if(self.noCache){
		req = [NSURLRequest requestWithURL:imageURL1 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
	}else {
		req = [NSURLRequest requestWithURL:imageURL1 cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];

	}

	conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	if(!conn){
		flagConnectionEnded = YES;
		return;
	}
	
	if(self.doAnimate){
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
		[self setImage:nil];
		[UIView commitAnimations];
	}else {
		[self setImage:nil];
	}

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response  
{ 
	imageData = [[NSMutableData alloc] init];
	//[imageData setLength:0]; 
    //imageSize = [response expectedContentLength]; 
    //////NSLog(@"size %i",imageSize); 
} 

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  
{ 
    [imageData appendData:data]; 
	self.image = [UIImage imageWithData:imageData];
	
	/*
	//[connection ];
    NSNumber *resourceLength = [NSNumber numberWithUnsignedInteger:[imageData length]]; 
	long len = imageSize;
    NSNumber *progress = [NSNumber numberWithFloat:([resourceLength floatValue] /len  )]; 
    dlProgress.progress = [progress floatValue]; 
	
    const unsigned int bytes = 1024 * 1024; 
	
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init]; 
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; 
    [formatter setPositiveFormat:@"##0.00"]; 
    NSNumber *partial = [NSNumber numberWithFloat:([resourceLength floatValue] / bytes)]; 
    NSNumber *total = [NSNumber numberWithFloat:([[NSNumber numberWithInt:imageSize] floatValue]  / bytes)]; 
    alert.message = [NSString stringWithFormat:@"\n%@ MB of %@ MB", [formatter stringFromNumber:partial], [formatter stringFromNumber:total]]; 
    [formatter release]; 
	 */
	
} 


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[wait stopAnimating];
	[imageData release];
	
	flagConnectionEnded = YES;
} 


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[wait stopAnimating];
	if(self.doAnimate){
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
		self.image = [UIImage imageWithData:imageData];
		[UIView commitAnimations];
	}else {
		self.image = [UIImage imageWithData:imageData];
		
	}
	NSLog(@"iamge size.width:%f,height:%f",self.image.size.width,self.image.size.height);
	//if(!self.noCache){
		//[(SnapLogsAppDelegate*)[[UIApplication sharedApplication] delegate]  SetRemoteImageCache:self.imageURL image:imageData];
	//}
	[imageData release];
	flagConnectionEnded = YES;
	isLoaded = YES;
}

-(void)dealloc{
	if(!flagConnectionEnded){
		[conn cancel];
	}
	[wait release];
	[imageURL release];
	[notifyId release];
	[super dealloc];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if(!isLoaded){
		return;
	}
	if(shouldNotifyTouched){
		if(!self.notifyId){
			self.notifyId = @"RemoteImageView";
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:@"notifyRemoteImageViewTouched" 
															object:self 
														  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.notifyId,@"notifyId",self.image,@"image", nil]];

	}
}


@end
