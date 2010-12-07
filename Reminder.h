//
//  Reminder.h
//  remindful-base
//
//  Created by David Lowman on 11/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Reminder : NSObject {

}
// public methods
- (NSDate *)scheduleReminder:(Reminder *)reminder action:(NSString *)action startTime:(int)startTime endTime:(int)endTime; 
- (void)cancelAllReminders;
- (void)getAllReminders;
@end
