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
	kSKReturnSuccess = 0,
	kSKReturnNoMasterPort = 1,
	kSKReturnComponentUnavailable = 2,
	kSKReturnIOKitError = 3, //see _extError
	kSKReturnIOKitCFFailure = 4, //error while making CFProperty
	kSKReturnSysCtlError = 5,
	kSKReturnLockedWrite = 6,
	kSKReturnCastError = 7,
	kSKReturnNotWritable = 8,
	kSKReturnGeneral = 65533, //too bad
	kSKReturnUnknown = 65534 //unknown error (shouldn't happen)
};

/*!
 @typedef PFSystemKitLockState
 Enumeration of integers matching the state of the PFSystemKit write lock
 */
typedef NS_ENUM(int, PFSystemKitLockState) {
	kSKLockStateLocked = 0,
	kSKLockStateUnlocked = 1
};

/*!
 @typedef PFSystemKitGroup
 Enumeration of integers matching a PFSystemKit group of informations (ROM, NVRAM, SMC, etc...)
 */
typedef NS_ENUM(int, PFSystemKitGroup) {
	kSKGroupPlatformExpertDevice = 1,
	kSKGroupROM = 2,
	kSKGroupNVRam = 3,
	kSKGroupSMC = 4,
	kSKGroupLMU = 5,
	kSKGroupGraphics = 6,
	kSKGroupTerminator
};

/*!
 @typedef PFSystemKitPlatform
 Enumeration of integers matching a Device Platform (iOS/OSX)
 */
typedef NS_ENUM(int, PFSystemKitPlatform) {
	kSKPlatformUnknown = 0,
	kSKPlatformIOS,
	kSKPlatformOSX,
};

/*!
 @typedef PFSystemKitFamily
 Enumeration of integers matching a Device Family (e.g. MacBookPro, MacBook, iMac, iPad, etc...)
 */
typedef NS_ENUM(int, PFSystemKitFamily) {
	kSKDeviceFamilyUnknown = 0,
	kSKDeviceFamilyiMac,
	kSKDeviceFamilyMacMini,
	kSKDeviceFamilyMacPro,
	kSKDeviceFamilyMacBook,
	kSKDeviceFamilyMacBookAir,
	kSKDeviceFamilyMacBookPro,
	kSKDeviceFamilyXserve,
	kSKDeviceFamilyiPhone,
	kSKDeviceFamilyiPad,
	kSKDeviceFamilyiPod,
	kSKDeviceFamilySimulator,
};
static NSString* const kSKDeviceFamilyUnknownStr    = @"Unknown";
static NSString* const kSKDeviceFamilyiMacStr       = @"iMac";
static NSString* const kSKDeviceFamilyMacminiStr    = @"Mac Mini";
static NSString* const kSKDeviceFamilyMacBookStr    = @"MacBook";
static NSString* const kSKDeviceFamilyMacBookAirStr = @"MacBook Air";
static NSString* const kSKDeviceFamilyMacBookProStr = @"MacBook Pro";
static NSString* const kSKDeviceFamilyMacProStr     = @"Mac Pro";
static NSString* const kSKDeviceFamilyXServeStr     = @"XServe";
static NSString* const kSKDeviceFamilyiPhoneStr     = @"iPhone";
static NSString* const kSKDeviceFamilyiPadStr       = @"iPad";
static NSString* const kSKDeviceFamilyiPodStr       = @"iPod";
static NSString* const kSKDeviceFamilySimulatorStr  = @"Simulator";

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
} PFSKDeviceVersion;

#endif
