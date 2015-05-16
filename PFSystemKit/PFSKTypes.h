//
//  PFSKTypes.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//
#ifndef PFSystemKit_PFSystemKitTypes_h
#import <Foundation/Foundation.h>
#define PFSystemKit_PFSystemKitTypes_h
#define _error self->error
#define _extError self->extError
#define _writeLockState self->writeLockState
#define val4Key(key, val) setValueForKey(key, val, self)
#define val4KeyPh(key, val) setValueForKeyPath(key, val, self)

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
	PFSKGroupBattery = 7,
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

/*!
 @typedef PFSystemKitEndianness
 Enumeration of integers matching a type of endianness (little or big)
 */
typedef NS_ENUM(int, PFSystemKitEndianness) {
	PFSKEndiannessUnknown= 0,
	PFSKEndiannessLittleEndian,
	PFSKEndiannessBigEndian,
};

/*!
 @typedef PFSystemKitCPUArches
 Enumeration of integers matching a type of CPU (x86, ARM, etc...)
 */
typedef NS_ENUM(int, PFSystemKitCPUArches) {
	PFSKCPUArchesUnknown = 0,
	PFSKCPUArchesX86,
	PFSKCPUArchesX86_64,
	PFSKCPUArchesPPC,
	PFSKCPUArchesPPC_64,
	PFSKCPUArchesI860,
	PFSKCPUArchesARM,
	PFSKCPUArchesARM_64,
};

/*!
 @typedef PFSystemKitCPUVendors
 Enumeration of integers matching a CPU vendor (AuthenticAMD, GenuineIntel, or IBM for ppc)
 */
typedef NS_ENUM(int, PFSystemKitCPUVendors) {
	PFSKCPUVendorUnknown = 0,
	PFSKCPUVendorGenuineIntel,
	PFSKCPUVendorAuthenticAMD,
	//PFSKCPUVendorIBM,
};

/*!
 @typedef @struct PFSystemKitDeviceVersion
 Structure holding a device's Major and Minor version 
 
 For a Macbookpro8,1 : 8 as Major and 1 as minor
 */
typedef struct {
	/*!
	 Major device version
	 */
	NSInteger                                          major;
	
	/*!
	 Minor device version
	 */
	NSInteger                                          minor;
} PFSystemKitDeviceVersion;

/*!
 @typedef @struct PFSystemKitOSVersion
 Structure holding a OS version's Major, Minor and Patch components
 
 For iOS 8.1.3 : 8 as major, 1 as minor, 3 as patch
 */
typedef struct {
	/*!
	 Major component of OS version
	 */
	NSInteger                                          major;
	
	/*!
	 Minor component of OS version
	 */
	NSInteger                                          minor;
	
	/*!
	 Patch component of OS version
	 */
	NSInteger                                          patch;
} PFSystemKitOSVersion;

inline __attribute__((__visibility__("hidden")))
void setValueForKey(const char* key, id value, id cSelf) {
	[cSelf setValue:value forKey:@(key)];
};
inline __attribute__((__visibility__("hidden")))
void setValueForKeyPath(const char* key, id value, id cSelf) {
	[cSelf setValue:value forKeyPath:@(key)];
};

#endif
