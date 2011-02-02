//
//  remindful_baseAppDelegate.m
//  remindful-base
//
//  Created by David Lowman on 11/6/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "remindful_baseAppDelegate.h"

#import "MainViewController.h"
#import "FlipsideViewController.h"

@implementation remindful_baseAppDelegate


@synthesize window;

@synthesize mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Handle launching from a notification
    application.applicationIconBadgeNumber = 0;
    // this mav need to go after the window code to launch.
    UILocalNotification *notification =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    
    // Override point for customization after application launch.
    // Add the main view controller's view to the window and display.
    [window addSubview:mainViewController.view];
    [window makeKeyAndVisible];
    if (notification) {
        NSLog(@"Recieved Notification %@",notification);
        
        NSString *reminderText = [notification.userInfo 
                                  objectForKey:@"action"];
        NSString *quote = [notification.userInfo 
                                  objectForKey:@"quote"];
        NSString *author = [notification.userInfo 
                                  objectForKey:@"author"];
        [mainViewController showReminder:reminderText withQuote:quote andAuthor:author];
        
    }
    
           
    [mainViewController showIntro];
        
    
    return YES;
}

- (void)application:(UIApplication *)application 
didReceiveLocalNotification:(UILocalNotification *)notification {
    	
    UIApplicationState state = [application applicationState];
    application.applicationIconBadgeNumber = 0;
    NSString *reminderText = [notification.userInfo 
                              objectForKey:@"action"];
    NSString *quote = [notification.userInfo 
                       objectForKey:@"quote"];
    NSString *author = [notification.userInfo 
                        objectForKey:@"author"];
    
    if (state == UIApplicationStateInactive) {
        
        // Application was in the background when notification
        // was delivered.
        NSLog(@"Recieved Notification while in background... %@",notification);
        
        [mainViewController showReminder:reminderText withQuote:quote andAuthor:author];
               
    }else{
        NSLog(@"Recieved Notification while Active! %@",notification);
    
        [mainViewController showReminder:reminderText withQuote:quote andAuthor:author];
    }
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
    
}

-(void)applicationWillEnterForeground:(UIApplication *)application {
    
    //application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 7;
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

    // Saves changes in the application's managed object context before the application terminates.
    NSError *error = nil;
    if (managedObjectContext) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)dealloc {

    [window release];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [mainViewController release];
    [super dealloc];
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"remindful_base.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
