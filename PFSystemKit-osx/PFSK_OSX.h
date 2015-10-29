//
//  PFSK_OSX.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_Common.h"
#import "PFSystemKitCPUReport.h"
#import "PFSystemKitRAMReport.h"
#import "PFSystemKitBatteryReport.h"

@class PFSystemKitPlatformReport;
@class PFSystemKitBatteryReport;

@interface PFSystemKit : PFSK_Common {
	@protected
	mach_port_t   			masterPort;
	@private
    PFSystemKitCPUReport*   cpuReport;
    PFSystemKitRAMReport*   ramReport;
    PFSystemKitPlatformReport* platformReport;
    PFSystemKitBatteryReport* batteryReport;
}

/*!
 NSArray of NSDictionaries holding a graphic device and its informations
 */
@property (strong, atomic, readonly) NSArray*							graphicReport;

/*!
 NSArray of NSDictionaries holding a screen and its informations
 */
@property (strong, atomic, readonly) NSArray*							displayReport;

/*!
 Various CPU informations
 */
-(PFSystemKitCPUReport*) cpuReport;
-(BOOL) cpuReport:(NSError Ind2_NUAR)err;

/*!
 RAM stats and size
 */
-(PFSystemKitRAMReport*) ramReport;
-(BOOL) ramReport:(NSError Ind2_NUAR)err;

/*!
 Various platform informations (serial, UUID, model, etc...)
 */
-(PFSystemKitPlatformReport*) platformReport;
-(BOOL) platformReport:(NSError Ind2_NUAR)err;

/*!
 Various battery informations
 */
-(PFSystemKitBatteryReport*) batteryReport;
-(BOOL) batteryReport:(NSError Ind2_NUAR)err;

+(PFSystemKit*) investigate;
-(PFSystemKit*) init __attribute__((unavailable("Use +investigate ; -init does not use the singleton pattern.")));
-(void) finalize;

#if defined(__OBJC__) && defined(__cplusplus) //we're working with Objective-C++

#endif
@end

#import "PFSK_OSX+GPU.h"
