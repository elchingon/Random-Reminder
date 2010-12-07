//
//  Reminder.m
//  remindful-base
//
//  Created by David Lowman on 11/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Reminder.h"


@implementation Reminder

- (NSDate *)scheduleReminder:(Reminder *)reminder action:(NSString *)action startTime:(int)startTime endTime:(int)endTime {
   
    int myHour;
    int myMinute = (arc4random() % 60);
    int mySecond = (arc4random() % 60);
    int range = endTime - startTime;
    
    NSLog(@"start time = integer: %d", startTime);
    NSLog(@"end time = integer: %d", endTime);
    
    if (startTime == endTime) {
        
        myHour = (arc4random() % 24);
        
    }else if (startTime < endTime) {
        
        myHour = (arc4random() % range) + startTime;
        
    }else if (startTime > endTime) {
        
        int theDecider = (arc4random()% 2);
        NSLog(@"the Decider is = integer: %d", theDecider);
        
        if (theDecider == 1) {
            int partRange = 24 - startTime;
            myHour = (arc4random() % partRange) + startTime;            
        } else {
            int partRange = 0 + endTime;
            myHour = (arc4random() % partRange); 
            
        }
        
        
    }
    
    NSLog(@"my hour = integer: %d", myHour);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];
    NSLog(@"creation date equals %@", date);
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    //[comps setHour:myHour];
    //[comps setMinute:myMinute];
    [comps setMinute:comps.minute + 1];
    //[comps setSecond:mySecond];
    [comps setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"comps time zone equals %@", comps.timeZone);
    NSLog(@"comps hour equals %d", comps.hour);
    date = [calendar dateFromComponents:comps];
    
    
    NSLog(@"fire date equals %@", date);
    
    // create the notification
    UILocalNotification *newNotification = [[UILocalNotification alloc] init];
    if (newNotification)
        
    // set the fireDate   
    newNotification.fireDate = date;
    
    // set the timeZone
    newNotification.timeZone = [NSTimeZone defaultTimeZone];
    NSLog(@"time zone equals %@", newNotification.timeZone);
    
    // Notification details
    newNotification.alertBody = action;
    NSLog(@"alertBody equals %@", newNotification.alertBody);
    
    // Set the action button
    newNotification.alertAction = @"View";
    
    // set the sound
    newNotification.soundName = UILocalNotificationDefaultSoundName;
    
    // set the badgeNumber
    newNotification.applicationIconBadgeNumber = 1;
    
    // Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:newNotification.alertBody forKey:@"name"];
    newNotification.userInfo = infoDict;
    NSLog(@"userInfo equals %@", newNotification.userInfo);
    
    // Schedule the notification
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
    
    // log
    NSLog(@"Sent Notification %@",newNotification);
    
    
    [newNotification release];
    
    return date;

}

@end
