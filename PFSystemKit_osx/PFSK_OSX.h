//
//  PFSK_OSX.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_Common.h"

@interface PFSystemKit : PFSK_Common <PFSystemKitProtocol> {
	@protected
	io_connect_t 			conn;
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

/*!
 The mainboard identifier
 */
@property (strong, atomic, readonly) NSString*							boardID;

/*!
 The platform identifier
 */
@property (strong, atomic, readonly) NSString*							platformID;

/*!
 The ROM firmware version
 */
@property (strong, atomic, readonly) NSString*							romVersion;

/*!
 The ROM firmware release date
 */
@property (strong, atomic, readonly) NSString*							romReleaseDate;

/*!
 The total RAM size
 */
@property (strong, atomic, readonly) NSNumber*							ramSize;

/*!
 The RAM usage statistics
 */
@property (strong, atomic, readonly) NSDictionary*						ramStats;

/*!
 Various CPU informations
 */
@property (strong, atomic, readonly) NSDictionary*						cpuReport;

/*!
 Various battery informations
 */
@property (strong, atomic, readonly) NSDictionary*						batteryReport;

/*!
 NSArray of NSDictionaries holding a graphic device and its informations
 */
@property (strong, atomic, readonly) NSArray*							graphicReport;

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


+(PFSystemKit*) investigate;
-(PFSystemKit*) init NS_DESIGNATED_INITIALIZER;
-(void) dealloc;
-(void) finalize;
-(BOOL) refreshGroup:(PFSystemKitGroup)group; 					//overrides any non-commited modification
-(BOOL) refresh;												//overrides any non-commited modification
#if WRITE_ABILITY
-(BOOL) commitGroup:(PFSystemKitGroup)group;					//commits any change made in the specified group
-(BOOL) commit;
#endif

#if defined(__OBJC__) && defined(__cplusplus) //we're working with Objective-C++

#endif
@end
