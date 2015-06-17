//
//  PFSystemExpertReport.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSKTypes.h"

@interface PFSystemPlatformReport : NSObject
#if !TARGET_OS_IPHONE
/*!
 The mainboard identifier
 */
@property (strong, atomic, readonly) NSString*							boardID;

/*!
 The platform identifier
 */
@property (strong, atomic, readonly) NSString*							hardwareUUID;

/*!
 The ROM firmware version
 */
@property (strong, atomic, readonly) NSString*							romVersion;

/*!
 The ROM firmware release date
 */
@property (strong, atomic, readonly) NSString*							romReleaseDate;

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

/*!
 The device family. e.g. PFSKDeviceFamilyiPhone
 */
@property (assign, atomic, readonly) PFSystemKitDeviceFamily			family;

/*!
 The device family string. e.g. @"iPhone"
 */
@property (strong, atomic, readonly) NSString*							familyString;

/*!
 The device version. (a PFSystemKitDeviceVersion)
 */
@property (assign, atomic, readonly) PFSystemKitDeviceVersion			version;

/*!
 The device version string. e.g. @"5,1"
 */
@property (strong, atomic, readonly) NSString*							versionString;

/*!
 The system endianness. (a PFSystemKitEndianness)
 */
@property (assign, atomic, readonly) PFSystemKitEndianness				endianness;

/*!
 The system endianness string. e.g. @"Little Endian"
 */
@property (strong, atomic, readonly) NSString*							endiannessString;

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

#if !TARGET_OS_IPHONE
-(instancetype) initWithBoardID:(NSString*)boardIDLocal
                   hardwareUUID:(NSString*)UUIDLocal
                     romVersion:(NSString*)romVersionLocal
                 romReleaseDate:(NSString*)romReleaseDateLocal
                     smcVersion:(NSString*)smcVersionLocal
                  shutdownCause:(NSNumber*)shutdownCauseLocal
                         family:(PFSystemKitDeviceFamily)familyLocal
                   familyString:(NSString*)familyStringLocal
                        version:(PFSystemKitDeviceVersion)versionLocal
                  versionString:(NSString*)versionStringLocal
                     endianness:(PFSystemKitEndianness)endiannessLocal
               endiannessString:(NSString*)endiannessStringLocal
                          model:(NSString*)modelStringLocal
                         serial:(NSString*)serialLocal
                     memorySize:(NSNumber*)memorySizeLocal;
-(void) updateWithSleepCause:(NSNumber*)sleepCauseLocal;
#endif
#if TARGET_OS_IPHONE
-(instancetype) initWithFamily:(PFSystemKitDeviceFamily)familyLocal
                  familyString:(NSString*)familyStringLocal
                       version:(PFSystemKitDeviceVersion)versionLocal
                 versionString:(NSString*)versionStringLocal
                    endianness:(PFSystemKitEndianness)endiannessLocal
              endiannessString:(NSString*)endiannessStringLocal
                         model:(NSString*)modelStringLocal
                        serial:(NSString*)serialLocal
                    memorySize:(NSNumber*)memorySizeLocal
#endif
@end
