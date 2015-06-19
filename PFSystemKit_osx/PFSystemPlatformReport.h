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

/*!
 Whether LocalIAPStore tweak is present (to fake IAP receipts)
 */
@property (atomic, readonly)         BOOL                               hasIAPFaker;
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

#if !TARGET_OS_IPHONE
-(instancetype) initWithBoardID:(NSString*)boardIDLocal
                   hardwareUUID:(NSString*)UUIDLocal
                     romVersion:(NSString*)romVersionLocal
                 romReleaseDate:(NSDate*)romReleaseDateLocal
                     smcVersion:(NSString*)smcVersionLocal
                  shutdownCause:(NSNumber*)shutdownCauseLocal
                         family:(PFSystemKitDeviceFamily)familyLocal
                        version:(PFSystemKitDeviceVersion)versionLocal
                     endianness:(PFSystemKitEndianness)endiannessLocal
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
                  isJailbroken:(BOOL)isJB
                         isIAP:(BOOL)isIAP;
#endif
@end
