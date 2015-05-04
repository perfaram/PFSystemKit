//
//  PFSKProtocol.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#ifndef PFSystemKit_PFSKProtocol_h
#define PFSystemKit_PFSKProtocol_h
#import "PFSKTypes.h"

@class PFSystemKit;
@protocol PFSystemKitProtocol
/*!
 The device family. e.g. PFSKDeviceFamilyiPhone
 */
@property (assign, atomic, readonly) PFSystemKitDeviceFamily			family;
/*!
 The device family string. e.g. @"iPhone"
 */
@property (assign, atomic, readonly) NSString*							familyString;

/*!
 The device version. (a PFSystemKitDeviceVersion)
 */
@property (assign, atomic, readonly) PFSystemKitDeviceVersion			version;
/*!
 The device version string. e.g. @"5,1"
 */
@property (assign, atomic, readonly) NSString*							versionString;

/*!
 The system endianness. (a PFSystemKitEndianness)
 */
@property (assign, atomic, readonly) PFSystemKitEndianness				endianness;
/*!
 The system endianness string. e.g. @"Little Endian"
 */
@property (assign, atomic, readonly) NSString*							endiannessString;

/*!
 The device model. e.g. @"MacBookPro8,1"
 */
@property (assign, atomic, readonly) NSString*							model;

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
-(BOOL) refreshGroup:(PFSystemKitGroup)group; 					//overrides any non-commited modification
-(BOOL) refresh;
@end

#endif
