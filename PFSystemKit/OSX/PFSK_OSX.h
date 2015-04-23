//
//  PFSK_OSX.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PFSKProtocol.h>
#import "PFSKTypes.h"
#import "PFSK_Common.h"
#import "PFSKHelper.h"

@interface PFSystemKit : PFSK_Common <PFSystemKitProtocol>
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
 The device model. e.g. @"MacBookPro8,1"
 */
@property (assign, atomic, readonly) NSString*							model;

+(PFSystemKit*) investigate;
-(PFSystemKit*) init;
-(void) dealloc;
-(void) finalize;
-(BOOL) refreshGroup:(PFSystemKitGroup)group; 					//overrides any non-commited modification
-(BOOL) refresh;												//overrides any non-commited modification
#if WRITE_ABILITY
-(BOOL) commitGroup:(PFSystemKitGroup)group;					//commits any change made in the specified group
-(BOOL) commit;
#endif

+(NSString *) machineModel;
@end
