//
//  HttpAgent.m
//
//
//  Created by Shaikh Sonny Aman on 1/24/10.
//  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import "HttpAgent.h"
#import "SBJSON.h"

#define HTTP_AGENT_STRING_BOUNDARY @"0xKhTmLbOuNdArY"

@interface HttpAgent()
-(void)initWithURL:(NSString*)url;
-(void) get;
-(void) post;

@end

@implementation HttpAgent
@synthesize strURL, httpParams, conn, returnData, timeout, delegate, shouldRequestBusyMode, postData;


-(id) initWithGetURL:(NSString*)url{
	if(!(self = [super init]))return nil;
	
	requestType = HttpAgentHTTPRequestTypeGet;
	[self initWithURL:url];
	return self;
}
-(id) initWithPostURL:(NSString*)url{
	if(!(self = [super init]))return nil;
	
	requestType = HttpAgentHTTPRequestTypePost;
	self.postData = [NSMutableData new];
	
	[self initWithURL:url];
	return self;
}

-(void)initWithURL:(NSString*)url{
	shouldRequestBusyMode = YES;// default is yes
	self.strURL = url;
	self.httpParams = [NSMutableDictionary new];
	self.returnData  = [[NSMutableData alloc] init];
	timeout = 10;
	returnType = HttpAgentReturnDataTypeString;
}

-(void) addKey:(NSString*)key withStringValue:(NSString*)val{
	[httpParams setValue:val forKey:key];
}
-(void) addKey:(NSString*)key withIntValue:(int)val{
	[self addKey:key withStringValue:[NSString stringWithFormat:@"%d",val]];
}
-(void) addKey:(NSString*)key withDoubleValue:(double)val{
	[self addKey:key withStringValue:[NSString stringWithFormat:@"%f",val]];
}

-(void) setURL:(NSString*)url{
	self.strURL = url;
}
-(void) setURL:(NSString*)url clearParams:(BOOL)yesOrno{
	self.strURL = url;
	if(yesOrno){
		self.httpParams = nil;
		self.httpParams = [NSMutableDictionary new];
	}
}
-(void) setURL:(NSString*)url withParams:(NSDictionary*)params{
	self.strURL = url;
	if(params){
		self.httpParams = [NSMutableDictionary dictionaryWithDictionary:params];
	}else {
		self.httpParams = nil;
		self.httpParams = [NSMutableDictionary new];
	}

}
-(void)dealloc{
	[strURL release];
	[httpParams release];
	[conn release];
	[returnData release];
	[postData release];
	[super dealloc];
}


-(void) get{
	NSString* strParams = @"";
	for(NSString* key in [httpParams allKeys]){
		strParams = [strParams stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[httpParams valueForKey:key]]];
	}
	
	
	
	NSString* fullurl = [NSString stringWithFormat:@"%@?%@",self.strURL,strParams];
	NSURLRequest* request= [NSURLRequest requestWithURL:[NSURL URLWithString:fullurl] 
											cachePolicy:NSURLRequestUseProtocolCachePolicy 
										timeoutInterval:timeout];
	
	self.conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if(!conn){
		[delegate httpAgent:self OnError:HttpAgentErrorNetwork errorData:@"Failed to create connection"];
	}
}
-(void)getString{
	returnType = HttpAgentReturnDataTypeString;
	[self get];
}
-(void)getArray{
	returnType = HttpAgentReturnDataTypeArray;
	[self get];
}
-(void)getDictionary{
	returnType = HttpAgentReturnDataTypeDictionary;
	[self get];
}
-(void)getImage{
	returnType = HttpAgentReturnDataTypeImage;
	[self get];
}

#pragma mark Post methods
-(void) post:(HttpAgentReturnDataType)type{
	returnType = type;
	[self post];
}

-(void) post{
	
	
	NSString* val;
	for (NSString *key in httpParams) {
		val = [httpParams valueForKey:key];
		[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", HTTP_AGENT_STRING_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[[NSString stringWithString:val] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	
	//[self addDataWithKey:@"client_time_zone" withVal:[[NSTimeZone defaultTimeZone] abbreviation]];
	
	//self.notificationName = notification;
	
	
	//urlString		= [NSString stringWithFormat:@"%@", baseURLString];  
	NSURL* url				= [NSURL URLWithString:self.strURL];
	NSMutableURLRequest* urlRequest		= [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
	[urlRequest setHTTPMethod:@"POST"];	
	
	
	NSString* contentType    = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", HTTP_AGENT_STRING_BOUNDARY];
	[urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"]; 
	
	[postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", HTTP_AGENT_STRING_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
	[urlRequest setHTTPBody:postData];
	
	//nslog(@"POST:%@",self.strUrl);
	//theConnection=[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	self.conn = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
	[urlRequest release];
	if(!conn){
		[delegate httpAgent:self OnError:HttpAgentErrorNetwork errorData:@"Failed to create connection"];
	}
	
}
-(void) addKey:(NSString*)key withImage:(UIImage*)val{
	if(requestType != HttpAgentHTTPRequestTypePost)return;
	
	NSData* imageData	  = UIImagePNGRepresentation([self scaleAndRotateImage:val maxResolution:480]);
	[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", HTTP_AGENT_STRING_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",key, @"photo_upload" ] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithString:@"Content-Type: image/png\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];  // jpeg as data
	[postData appendData:[[NSString stringWithString:@"Content-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:imageData];  // Tack on the imageData to the end
	
}



#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	
    // this method is called when the server has determined that it
	
    // has enough information to create the NSURLResponse
	
	
	
    // it can be called multiple times, for example in the case of a
	
    // redirect, so each time we reset the data.
	
    // receivedData is declared as a method instance elsewhere
	
    [returnData setLength:0];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	
    // append the new data to the receivedData
	
    // receivedData is declared as a method instance elsewhere
	
    [returnData appendData:data];
	
}
- (void)connection:(NSURLConnection *)connection

  didFailWithError:(NSError *)error{
	//[(PuzzleShotAppDelegate*)[[UIApplication sharedApplication] delegate] HideWaitView:nil];
	
    // release the connection, and the data object
	
    [connection release];
	
    // receivedData is declared as a method instance elsewhere
	
    //[returnData release];
	[delegate httpAgent:self OnError:HttpAgentErrorNetwork errorData:error];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [connection release];
	
	switch (returnType) {
		case 0:{ // string
			NSString* strData = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
			[delegate httpAgent:self OnSuccess:strData type:returnType];
			[strData release];
			break;
		}
		case 1:{
			NSString* strData = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
			SBJSON *jsonParser = [SBJSON new];
			NSArray* arr = [jsonParser objectWithString:strData];
			[jsonParser release];
			
			if(arr){
				[delegate httpAgent:self OnSuccess:arr type:returnType];
			}else {
				[delegate httpAgent:self OnError:HttpAgentErrorReturnTypeMismatch errorData:strData];
			}
			[strData release];
			//nslog(@"GOT array:%@",arr);
			break;
		}
		case 2:{
			NSString* strData = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
			//nslog(@"GOT string:%@",strData);
			SBJSON *jsonParser = [SBJSON new];
			NSDictionary* dic = [jsonParser objectWithString:strData];
			if(dic){
				[delegate httpAgent:self OnSuccess:dic type:returnType];
			}else {
				[delegate httpAgent:self OnError:HttpAgentErrorReturnTypeMismatch errorData:strData];
			}
						
			[jsonParser release];
			[strData release];
			//nslog(@"GOT dic:%@",dic);
			break;
		}
		case 3:{
			NSString* strData = @"OK";
			UIImage* img = [UIImage imageWithData:returnData];
			if(!img)strData = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
			if(img){
				[delegate httpAgent:self OnSuccess:img type:returnType];
			}else {
				[delegate httpAgent:self OnError:HttpAgentErrorReturnTypeMismatch errorData:strData];
			}
			
			break;
		}
		default:
			break;
	}
	
    //[returnData release];
}

// utility
- (UIImage *)scaleAndRotateImage:(UIImage *)timage maxResolution:(int)maxr{
	int kMaxResolution = maxr; // Or whatever
	
	
	CGImageRef imgRef = timage.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize1 = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = timage.imageOrientation;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize1.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize1.width, imageSize1.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize1.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize1.height, imageSize1.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize1.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize1.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	
	
	
	return imageCopy;
}
@end
