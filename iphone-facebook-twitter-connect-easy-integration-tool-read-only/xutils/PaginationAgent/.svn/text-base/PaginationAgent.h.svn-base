//
//  PaginationAgent.h
//  Pagination
//
//  Created by Shaikh Sonny Aman on 1/4/10.
//  Copyright 2010 SHAIKH SONNY AMAN :). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum {
	PaginationAgentRequestTypeTotalDataCount = 0,
	PaginationAgentRequestTypePageData,
}PaginationAgentRequestType;

@class PaginationAgent;

@protocol PaginationAgentDelegate

/**
 * This method is called when the busystate is changed.
 * You can do something like disable/enable the buttons, grayout etc 
 * based on the isBusy value.
 */
-(void)paginationAgent:(PaginationAgent*)agent updateBusyMode:(BOOL)isBusy;

/**
 * Called when total data count is received if shouldReloadAtFirstPage is set NO.
 */
-(void)paginationAgent:(PaginationAgent*)agent totalDataCountReceived:(int)dataCount;

/**
 * Called when page data is loaded. You may set your table dataSource here and realod
 * reload the table.
 */
-(void)paginationAgent:(PaginationAgent*)agent pageDataReceived:(NSArray*)data;

/**
 * Called if server sends malformed data
 */
-(void)paginationAgent:(PaginationAgent*)agent onPaginationServerError:(NSString*)message;

/**
 * Called if connection failed. It may occur due to poor or no internet connectivity
 */
-(void)paginationAgent:(PaginationAgent*)agent onPaginationConnectionError:(NSString*)message;
@end


/**
 * PaginationAgent class can be used for paginating information.
 * For exanple, you are showing comments in a table.
 * This class may help you in such case.
 *
 * PaginationAgent works on calling 2 remote api written in php, they are:
 *		get_total_number_of_records.php
 *		get_records.php
 *
 * These are called like:
 *
 * To Get the total number of data: http://some.remote.host/path/to/get_total_number_of_records.php
 * To Get some data at an offset and limit: http://some.remote.host/path/to/get_records.php?offset=0&limit=20
 *
 * You need to set the property remoteApiBasePath to http://some.remote.host/path/to/ without trailing '/'.
 *
 * If some extra parameter are to be passed, add them as key-value pair to its params property.
 *
 * @example
 * See the demo project comes along with this code.
 *
 */

@interface PaginationAgent : NSObject {
	/**
	 * Current page number
	 */
	int currentPage;
	
	/**
	 * Total number of pages
	 */
	int numberOfPages;
	
	/**
	 * Total number of records
	 */
	int totalNumberOfRecords;
	
	/**
	 * How many record to show in one page
	 */
	int numberOfRecordsPerPage;
	
	/**
	 * Delegate. release it in the dealloc method of the delegate object.
	 */
	id <PaginationAgentDelegate> delegate;
	
	/**
	 * Flag to indicated if its middle of any operation
	 */
	BOOL isBusy;
	
	/**
	 * Set it yes if the agent should reload data on first page.
	 * Default is YES
	 */
	BOOL shouldReloadAtFirstPage;
	
	/**
	 *  Base path to the api.
	 */
	NSString* remoteApiBasePath;
	
	/**
	 * Store the extra parameters
	 */
	NSMutableDictionary* params;
	
	/**
	 * Used to asynchronously fetch data
	 */
	NSURLConnection* conn;
	
	/**
	 * Used to hold connection data
	 */
	NSMutableData* returnData;
	
	PaginationAgentRequestType currentRequestType;
}

/**
 * Initialization
 */
-(id)init;

/**
 * Realods the pagination. This method must be called at least once.
 */
-(void)reload;

/**
 * Checks any more pagination is there after the current page
 */
-(BOOL)hasNext;

/**
 * Checks any previous pageination is there before the current page
 */

-(BOOL)hasPrevious;

/**
 * Get the next page data
 */

-(void)goNext;

/**
 * Get the previous page data
 */
-(void)goPrevious;

/**
 *	Get the first page data
 */
-(void)goFirst;

/**
 * Get the last page data
 */
-(void)goLast;

/**
 * Get the page data at page
 */
-(void)goToPage:(int)page;

/**
 * You don't need to add "limit" and "offset" params here.
 * They are added inside;
 */
-(void)addParam:(NSString*)key withValue:(NSString*)val;

@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) int numberOfPages;
@property (nonatomic,assign) int totalNumberOfRecords;
@property (nonatomic,assign) int numberOfRecordsPerPage;
@property (nonatomic,assign) BOOL shouldReloadAtFirstPage;
@property (nonatomic,retain) NSString* remoteApiBasePath;
@property (nonatomic,assign) id<PaginationAgentDelegate> delegate;

@end


