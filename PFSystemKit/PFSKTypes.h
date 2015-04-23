//
//  PFSKTypes.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#ifndef PFSystemKit_PFSystemKitTypes_h
#define PFSystemKit_PFSystemKitTypes_h
#define _error self->error
#define _extError self->extError
#define _writeLockState self->writeLockState

/*!
 @typedef PFSystemKitLockState
 Enumeration of integers matching a PFSystemKit error
 */
typedef NS_ENUM(int, PFSystemKitError) {
	PFSKReturnSuccess = 0,
	PFSKReturnNoMasterPort = 1,
	PFSKReturnComponentUnavailable = 2,
	PFSKReturnIOKitError = 3, //see _extError
	PFSKReturnIOKitCFFailure = 4, //error while making CFProperty
	PFSKReturnSysCtlError = 5,
	PFSKReturnLockedWrite = 6,
	PFSKReturnCastError = 7,
	PFSKReturnNotWritable = 8,
	PFSKReturnGeneral = 65533, //too bad
	PFSKReturnUnknown = 65534 //unknown error (shouldn't happen)
};

/*!
 @typedef PFSystemKitLockState
 Enumeration of integers matching the state of the PFSystemKit write lock
 */
typedef NS_ENUM(int, PFSystemKitLockState) {
	PFSKLockStateLocked = 0,
	PFSKLockStateUnlocked = 1
};

/*!
 @typedef PFSystemKitGroup
 Enumeration of integers matching a PFSystemKit group of informations (ROM, NVRAM, SMC, etc...)
 */
typedef NS_ENUM(int, PFSystemKitGroup) {
	PFSKGroupPlatformExpertDevice = 1,
	PFSKGroupROM = 2,
	PFSKGroupNVRam = 3,
	PFSKGroupSMC = 4,
	PFSKGroupLMU = 5,
	PFSKGroupGraphics = 6,
	PFSKGroupTerminator
};

/*!
 @typedef PFSystemKitPlatform
 Enumeration of integers matching a Device Platform (iOS/OSX)
 */
typedef NS_ENUM(int, PFSystemKitPlatform) {
	PFSKPlatformUnknown = 0,
	PFSKPlatformIOS,
	PFSKPlatformOSX,
};

/*!
 @typedef PFSystemKitFamily
 Enumeration of integers matching a Device Family (e.g. MacBookPro, MacBook, iMac, iPad, etc...)
 */
typedef NS_ENUM(int, PFSystemKitDeviceFamily) {
	PFSKDeviceFamilyUnknown = 0,
	PFSKDeviceFamilyiMac,
	PFSKDeviceFamilyMacMini,
	PFSKDeviceFamilyMacPro,
	PFSKDeviceFamilyMacBook,
	PFSKDeviceFamilyMacBookAir,
	PFSKDeviceFamilyMacBookPro,
	PFSKDeviceFamilyXserve,
	PFSKDeviceFamilyiPhone,
	PFSKDeviceFamilyiPad,
	PFSKDeviceFamilyiPod,
	PFSKDeviceFamilySimulator,
};
static NSString* const PFSKDeviceFamilyUnknownStr    = @"Unknown";
static NSString* const PFSKDeviceFamilyiMacStr       = @"iMac";
static NSString* const PFSKDeviceFamilyMacminiStr    = @"Mac Mini";
static NSString* const PFSKDeviceFamilyMacBookStr    = @"MacBook";
static NSString* const PFSKDeviceFamilyMacBookAirStr = @"MacBook Air";
static NSString* const PFSKDeviceFamilyMacBookProStr = @"MacBook Pro";
static NSString* const PFSKDeviceFamilyMacProStr     = @"Mac Pro";
static NSString* const PFSKDeviceFamilyXServeStr     = @"XServe";
static NSString* const PFSKDeviceFamilyiPhoneStr     = @"iPhone";
static NSString* const PFSKDeviceFamilyiPadStr       = @"iPad";
static NSString* const PFSKDeviceFamilyiPodStr       = @"iPod";
static NSString* const PFSKDeviceFamilySimulatorStr  = @"Simulator";

/*!
 @typedef @struct PFSKDeviceVersion
 Structure holding a device's Major and Minor version 
 
 For a Macbookpro8,1 : 8 as Major and 1 as minor
 */
typedef struct {
	/*!
	 Major device version
	 */
	NSUInteger                                          major;
	
	/*!
	 Minor device version
	 */
	NSUInteger                                          minor;
} PFSystemKitDeviceVersion;

#endif
