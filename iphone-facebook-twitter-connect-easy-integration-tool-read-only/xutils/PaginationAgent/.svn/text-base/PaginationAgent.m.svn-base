//
//  PaginationAgent.m
//  Pagination
//
//  Created by Shaikh Sonny Aman on 1/4/10.
//  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import "PaginationAgent.h"
#import "SBJSON.h"



/**
 * Private methods
 */
@interface PaginationAgent()
-(void)loadData:(PaginationAgentRequestType)requestType;
@end


@implementation PaginationAgent

@synthesize currentPage;
@synthesize numberOfPages;
@synthesize totalNumberOfRecords;
@synthesize remoteApiBasePath;
@synthesize shouldReloadAtFirstPage;
@synthesize delegate;
@synthesize numberOfRecordsPerPage;

-(id)init{
	if((self = [super init])){
		
		// initialization
		currentPage = 0;
		numberOfPages = 0;
		totalNumberOfRecords = 0;
		numberOfRecordsPerPage = 10;
		shouldReloadAtFirstPage = YES;
		isBusy = NO;
		
		remoteApiBasePath = nil;
		delegate = nil;
		
		params = [[NSMutableDictionary alloc] init];
		currentRequestType = PaginationAgentRequestTypeTotalDataCount;
		
		return self;
	}
	
	return nil;
}

-(void)dealloc{
	// First remove it from notification loop.
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[params release];
	[remoteApiBasePath release];
	
	[super dealloc];
}



-(BOOL)hasNext{
	return currentPage < numberOfPages;
}
-(BOOL)hasPrevious{
	return currentPage > 0;
}
-(int)numberOfPages{
	return 0;
}
-(void)goNext{
	if(isBusy)return;
	if([self hasNext]){
		currentPage++;
		[self loadData:PaginationAgentRequestTypePageData];
	}
}
-(void)goPrevious{
	if(isBusy)return;
	
	if([self hasPrevious] ){
		currentPage--;
		[self loadData:PaginationAgentRequestTypePageData];
	}
}
-(void)goFirst{
	if(isBusy)return;
	
	if(shouldReloadAtFirstPage){
		[self reload];
		return;
	}
	
	currentPage = 0;
	[self loadData:PaginationAgentRequestTypePageData];
}


-(void)goLast{
	if(isBusy)return;
	//TBD
}
-(void)goToPage:(int)page{
	if(isBusy)return;
	//TBD
}

-(void)addParam:(NSString*)key withValue:(NSString*)val{
	NSArray* restrictedKeys = [NSArray arrayWithObjects:@"offset",@"limit",nil];
	if(! [restrictedKeys containsObject:key]){
		key = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[params setValue:val forKey:key];
	}
}
-(void)loadData:(PaginationAgentRequestType)requestType{
	if(isBusy)return;
	isBusy = YES;
	
	[self.delegate paginationAgent:self updateBusyMode:YES];
	
	currentRequestType = requestType;
	returnData  = [[NSMutableData alloc] init];
	
	NSString* strParams = @"";
	for(NSString* key in [params allKeys]){
		strParams = [strParams stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]]];
	}
	
	NSString* dataCountURL;
	switch (currentRequestType) {
		case PaginationAgentRequestTypeTotalDataCount:
			dataCountURL = [NSString stringWithFormat:@"%@/get_total_number_of_records.php?%@",self.remoteApiBasePath,strParams];
			break;
		case PaginationAgentRequestTypePageData:{
			int offset = currentPage*numberOfRecordsPerPage;
			int limit = numberOfRecordsPerPage;
			dataCountURL = [NSString stringWithFormat:@"%@/get_records.php?limit=%d&offset=%d&%@",self.remoteApiBasePath,limit,offset,strParams];
			break;
		}
		default:
			break;
	}
	
	
	NSLog(@"calling url = %@",dataCountURL);
	NSURLRequest* request= [NSURLRequest requestWithURL:[NSURL URLWithString:dataCountURL] 
											cachePolicy:NSURLRequestUseProtocolCachePolicy 
										timeoutInterval:20.0];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
-(void)reload{
	if(isBusy)return;
	[self loadData:PaginationAgentRequestTypeTotalDataCount];
}
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [returnData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [returnData appendData:data];	
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	isBusy = NO;
	// release the connection, and the data object
    [connection release];
    [returnData release];
	
	// call delegate method
	[self.delegate paginationAgent:self updateBusyMode:NO];
	[self.delegate paginationAgent:self onPaginationConnectionError:@"Failed to connect to remote server"];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[self.delegate paginationAgent:self updateBusyMode:NO];
	isBusy = NO;
	// release the connection
    [connection release];
	
	// Make string from received data
	NSString* strData = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	// try to retrieve the dictionary
	SBJSON *jsonParser = [SBJSON new];
	NSDictionary* dic = [jsonParser objectWithString:strData];
	
	// release the objects
	[jsonParser release];
	[strData release];
    [returnData release];
	
	NSLog(@"dic = %@",dic);
	// Check dictionary 
	if(!dic){
		[self.delegate paginationAgent:self onPaginationServerError:@"Unknown server error"];
		return;
	}
	
	if(![[dic allKeys] containsObject:@"success"]){
		[self.delegate paginationAgent:self onPaginationServerError:@"Malformed data received from server. No success key."];
		return;
	}
	if(![[dic allKeys] containsObject:@"message"]){
		[self.delegate paginationAgent:self onPaginationServerError:@"Malformed data received from server. No message key."];
		return;
	}
	if(![[dic allKeys] containsObject:@"data"]){
		[self.delegate paginationAgent:self onPaginationServerError:@"Malformed data received from server. No data key."];
		return;
	}
	
	if([[dic valueForKey:@"success"] intValue] == 0){
		[self.delegate paginationAgent:self onPaginationServerError:[dic valueForKey:@"message"]];
		return;
	}
	
	switch (currentRequestType) {
		case PaginationAgentRequestTypeTotalDataCount:
			self.totalNumberOfRecords = [[dic valueForKey:@"data"] intValue];
			self.numberOfPages = ceil(self.totalNumberOfRecords/self.numberOfRecordsPerPage);
			self.currentPage = 0;
			
			if(self.shouldReloadAtFirstPage){
				[self loadData:PaginationAgentRequestTypePageData];
			}else {
				[self.delegate paginationAgent:self totalDataCountReceived:self.totalNumberOfRecords];
			}
			break;
		case PaginationAgentRequestTypePageData:
			[self.delegate paginationAgent:self pageDataReceived:[dic objectForKey:@"data"]];
			break;

		default:
			break;
	}
	
}

@end
