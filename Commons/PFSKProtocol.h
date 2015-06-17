//
//  PFSKProtocol.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#ifndef PFSystemKit_PFSKProtocol_h
#define PFSystemKit_PFSKProtocol_h
#import "PFSKTypes.h"
#import "PFSystemCPUReport.h"
#import "PFSystemBatteryReport.h"
#import "PFSystemPlatformReport.h"

@class PFSystemKit;
@protocol PFSystemKitProtocol

/*!
 Various CPU informations
 */
@property (strong, atomic, readonly) PFSystemCPUReport*					cpuReport;

/*!
 Various battery informations
 */
@property (strong, atomic, readonly) PFSystemBatteryReport*				batteryReport;

+(PFSystemKit*)investigate;
/*!
 @discussion Returns the current platform as a member of the PFSystemKitPlatform enum
 @returns An int matching the current platform (iOS/OSX)
 */
-(PFSystemKitPlatform)platform;
/*!
 @discussion Returns the current platform as string
 @returns A NSString holding the current platform (iOS/OSX)
 */
-(NSString*)platformString;

-(PFSystemKit*) init;
-(void) dealloc;
-(void) finalize;
@end

#endif
