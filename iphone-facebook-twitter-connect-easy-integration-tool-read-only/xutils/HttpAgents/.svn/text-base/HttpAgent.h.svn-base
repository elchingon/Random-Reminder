//
//  HttpAgent.h
//  eatlate
//
//  Created by Shaikh Sonny Aman on 1/24/10.
//  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum {
	HttpAgentReturnDataTypeString=0,
	HttpAgentReturnDataTypeArray,
	HttpAgentReturnDataTypeDictionary,
	HttpAgentReturnDataTypeImage,
}HttpAgentReturnDataType;

typedef  enum {
	HttpAgentHTTPRequestTypeGet=0,
	HttpAgentHTTPRequestTypePost,
}HttpAgentHTTPRequestType;

typedef  enum {
	HttpAgentErrorSuccess=0,
	HttpAgentErrorNetwork,
	HttpAgentErrorReturnTypeMismatch,
	HttpAgentErrorServer,
}HttpAgentError;


@class HttpAgent;

@protocol HttpAgentDelegate
-(void)httpAgent:(HttpAgent*)agent OnSuccess:(id)data type:(HttpAgentReturnDataType)type;
-(void)httpAgent:(HttpAgent*)agent OnError:(HttpAgentError)errorType errorData:(id)error;
@end



@interface HttpAgent : NSObject {
	NSMutableDictionary* httpParams;
	NSString* strURL;
	id <HttpAgentDelegate> delegate;
	
	NSURLConnection* conn;
	NSMutableData* returnData;
	NSMutableData* postData;
	
	double timeout;
	BOOL shouldRequestBusyMode; // TBD
	HttpAgentReturnDataType returnType;
	
	HttpAgentHTTPRequestType requestType; 
}

-(id) initWithGetURL:(NSString*)url;
-(id) initWithPostURL:(NSString*)url;

-(void) setURL:(NSString*)url;
-(void) setURL:(NSString*)url clearParams:(BOOL)yesOrno;
-(void) setURL:(NSString*)url withParams:(NSDictionary*)params;

-(void) addKey:(NSString*)key withStringValue:(NSString*)val;
-(void) addKey:(NSString*)key withIntValue:(int)val;
-(void) addKey:(NSString*)key withDoubleValue:(double)val;

// methods related to get
-(void) getImage;
-(void) getArray;
-(void) getString;
-(void) getDictionary;

// methods related to post
-(void) post:(HttpAgentReturnDataType)type;
-(void) addKey:(NSString*)key withImage:(UIImage*)val;

// Utility function
- (UIImage *)scaleAndRotateImage:(UIImage *)timage maxResolution:(int)maxr;


@property(nonatomic, retain) NSString* strURL;
@property(nonatomic, retain) NSMutableDictionary* httpParams;
@property(nonatomic, retain) NSMutableData* returnData;
@property(nonatomic, retain) NSMutableData* postData;
@property(nonatomic, retain) NSURLConnection* conn;
@property(nonatomic, assign) double timeout; 
@property(nonatomic, assign) BOOL shouldRequestBusyMode; 
@property(nonatomic, assign) id<HttpAgentDelegate> delegate;

@end
