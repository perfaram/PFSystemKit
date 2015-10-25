//
//  PFSystemExpertReport.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_Common.h"

@interface PFSystemKitPlatformReport : NSObject {
@protected
    mach_port_t   			masterPort;
    io_registry_entry_t 	nvrEntry;
    io_registry_entry_t 	pexEntry;
    io_registry_entry_t 	smcEntry;
    io_registry_entry_t 	romEntry;
    io_registry_entry_t 	batEntry;
    BOOL					firstRunDoneForExpertDevice;
    BOOL					firstRunDoneForROM;
    BOOL					firstRunDoneForSMC;
    BOOL					firstRunDoneForBattery;
@private
    NSDictionary*			platformExpertRawDict;
    NSDictionary*			romRawDict;
    NSDictionary*			smcRawDict;
    NSDictionary*			batteryRawDict;
}
#if !TARGET_OS_IPHONE
/*!
 The mainboard identifier
 */
@property (strong, atomic, readonly) NSString*							boardID;

/*!
 The platform identifier
 */
@property (strong, atomic, readonly) NSString*							uuid;

/*!
 The ROM firmware version
 */
@property (strong, atomic, readonly) NSString*							romVersion;

/*!
 The ROM firmware release date
 */
@property (strong, atomic, readonly) NSDate*							romReleaseDate;

/*!
 The SMC firmware version
 */
@property (strong, atomic, readonly) NSString*							smcVersion;

/*!
 The last sleep cause
 */
@property (strong, atomic, readonly) NSNumber*							sleepCause;

/*!
 The last shutdown cause
 */
@property (strong, atomic, readonly) NSNumber*							shutdownCause;
#endif

#if TARGET_OS_IPHONE
/*!
 Whether the device is jailbroken (iOS devices only)
 */
@property (atomic, readonly)         BOOL                               isJailbroken;
#endif

/*!
 The device family. e.g. PFSKDeviceFamilyiPhone
 */
@property (assign, atomic, readonly) PFSystemKitDeviceFamily			family;

/*!
 The device platform. e.g. PFSKPlatformIOS
 */
@property (assign, atomic, readonly) PFSystemKitPlatform                platform;

/*!
 The device version. (a PFSystemKitDeviceVersion)
 */
@property (assign, atomic, readonly) PFSystemKitDeviceVersion			version;

/*!
 The device endianness. (a PFSystemKitEndianness)
 */
@property (assign, atomic, readonly) PFSystemKitEndianness				endianness;

/*!
 The device model. e.g. @"MacBookPro8,1"
 */
@property (strong, atomic, readonly) NSString*							model;

/*!
 The device serial
 */
@property (strong, atomic, readonly) NSString*							serial;

/*!
 The total RAM size
 */
@property (strong, atomic, readonly) NSNumber*							memorySize;

-(instancetype) initWithError:(NSError Ind2_NUAR)err;
#if !TARGET_OS_IPHONE
-(BOOL) smcDetailsWithError:(NSError Ind2_NUAR)err;
-(BOOL) expertDetailsWithError:(NSError Ind2_NUAR)err;
-(BOOL) romDetailsWithError:(NSError Ind2_NUAR)err;
#endif
@end
