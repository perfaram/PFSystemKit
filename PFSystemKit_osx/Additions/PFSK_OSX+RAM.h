//
//  PFSK_OSX+RAM.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 11/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_OSX.h"

@interface PFSystemKit(RAM)
/*!
 @discussion Getter for the memorySize property : first run will get the actual size and save it in the property, then any subsequent runs will simply return the property
 @returns an NSNumber (the one stored in memorySize), holding the RAM total size in gibibytes
*/
-(NSNumber*) memorySize;

/*!
 @discussion Dynamic getter for the memoryStats property
 @returns an NSNumber (the one stored in memorySize), holding the RAM total size in gibibytes
 */
-(NSDictionary*) memoryStats;
+(PFSystemKitError) memorySize:(NSNumber**)ret;
+(PFSystemKitError) memoryStats:(NSDictionary**)ret __attribute__((nonnull (1)));
@end
