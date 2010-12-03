//
//  RemoteImageView.h
//  HoodPhoto
//
//  Created by Shaikh Sonny Aman on 9/3/09.
//  Copyright 2009 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RemoteImageView : UIImageView {
	NSMutableData* imageData;
	NSURLConnection* conn;
	
	BOOL flagConnectionEnded;
	BOOL noCache;
	BOOL shouldNotifyTouched;
	
	NSString* notifyId;
	NSString* imageURL;
	UIActivityIndicatorView* wait;
	
	BOOL doAnimate;
	
	BOOL isLoaded;

}
-(void)setUrl:(NSString*)url;

@property (nonatomic,assign) BOOL noCache;
@property (nonatomic,assign) BOOL shouldNotifyTouched;
@property (nonatomic,retain) NSString* notifyId;
@property (nonatomic,retain) NSString* imageURL;
@property (nonatomic, assign) BOOL doAnimate;
@property (nonatomic,assign) BOOL isLoaded;
@end
