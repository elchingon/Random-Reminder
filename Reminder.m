//
//  Reminder.m
//  remindful-base
//
//  Created by e7systems on 11/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Reminder.h"


@implementation Reminder

- (void)cancelAllReminders {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)getAllReminders {
    NSArray *reminders = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    NSLog(@"current reminders: %@", reminders);
}

- (NSDate *)scheduleReminder:(Reminder *)reminder action:(NSString *)action quote:(NSString *)quote author:(NSString *)author startTime:(int)startTime endTime:(int)endTime repeat:(BOOL)repeat {
    
    
        
       
    /////////////////////////////////////////////////////////////////
    // Calculate random time
    int myHour = (arc4random() % 24);
    int myMinute = (arc4random() % 60);
    int mySecond = (arc4random() % 60);
    int range = endTime - startTime;

    if (startTime == endTime) {        
        myHour = startTime;
        //myHour = (arc4random() % 24);
        
    }else if (startTime < endTime) {
        myHour = (arc4random() % range) + startTime;
        if (myHour == endTime) {
            myHour = myHour - 1;
        }
    
    // choose between ranges for 24-1 case
    }else if (startTime > endTime) {
        int theDecider = (arc4random()% 20);
        NSLog(@"the Decider is = integer: %d", theDecider);
        if (theDecider < 10) {            
            int partRange = 24 - startTime;
            myHour = (arc4random() % partRange) + startTime;
            
        } else {
            if(endTime == 0) {
                myHour = 23;
            }else{
                int partRange = 0 + endTime;
                myHour = (arc4random() % partRange); 
                if (myHour == endTime) {
                    myHour = myHour - 1;
                }
            }
            
        }
        
    }
    
    NSLog(@"my hour = integer: %d", myHour);
    NSLog(@"start time = integer: %d", startTime);
    NSLog(@"end time = integer: %d", endTime);

    ///////////////////////////////////////////////////////////////////////
    // Set up Date components fore notification
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    [comps setHour:myHour];
    [comps setMinute:myMinute];
    [comps setSecond:mySecond];
    [comps setTimeZone:[NSTimeZone systemTimeZone]];
    
    date = [calendar dateFromComponents:comps];
    
    NSLog(@"creation date equals %@", date);
    NSLog(@"comps time zone equals %@", comps.timeZone);
    NSLog(@"comps hour equals %d", comps.hour);
    NSLog(@"fire date equals %@", date);
    
    // create the notification
    UILocalNotification *newNotification = [[UILocalNotification alloc] init];
    if (newNotification)
        
    // set the fireDate   
    newNotification.fireDate = date;
    
    // set the repeat interval
    if(repeat) {
        newNotification.repeatInterval = NSDayCalendarUnit;
    }
    
    // set the timeZone
    newNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    // Notification details
    newNotification.alertBody = @"You have a reminder.";
    
    // Set the action button
    newNotification.alertAction = @"View";
    
    // set the sound
    newNotification.soundName = UILocalNotificationDefaultSoundName;
    
    // set the badgeNumber
    newNotification.applicationIconBadgeNumber = 1;
    
    // Specify custom data for the notification
    NSArray *objects = [NSArray arrayWithObjects:action, quote, author, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"action", @"quote", @"author", nil];
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    newNotification.userInfo = infoDict;
    NSLog(@"userInfo equals %@", newNotification.userInfo);
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
    
    // log
    NSLog(@"Sent Notification %@",newNotification);
    NSLog(@"alertBody equals %@", newNotification.alertBody);
    NSLog(@"time zone equals %@", newNotification.timeZone);

    
    
    [newNotification release];
    [calendar release];
    
    return date;

}

@end
