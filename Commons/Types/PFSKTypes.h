//
//  PFSKTypes.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//
#ifndef PFSKTypes_Header
#import <Foundation/Foundation.h>
#define _error self->errorCode
#define _extError self->extErrorCode
#define _writeLockState self->writeLockState
#define val4Key(key, val) setValueForKey(key, val, self)
#define val4KeyPh(key, val) setValueForKeyPath(key, val, self)
#define Ind2_NNAR *__nonnull __autoreleasing*__nonnull //Ind2 = Double Indirection, NNAR = NonNull AutoReleasing
#define Ind2_NUAR *__nullable __autoreleasing*__nullable //Ind2 = Double Indirection, NUAR = Nullable AutoReleasing
#define PFSystemKit_cpu PFSystemKitCPUReport
#define PFSystemKit_ram PFSystemKitRAMReport

/*!
 @typedef GPUArray
 NSArray of NSDictionaries, using generics
 */
typedef NSArray<NSDictionary*> GPUArray;

/*!
 @typedef PFSystemKitLockState
 Enumeration of integers matching a PFSystemKit error
 */
typedef NS_ENUM(int, PFSystemKitError) {
    PFSKReturnSuccess = 0,
    PFSKReturnNoMasterPort,
    PFSKReturnComponentUnavailable,
    PFSKReturnIOKitError, //see _extError
    PFSKReturnIOKitCFFailure, //error while making CFProperty
    PFSKReturnSysCtlUnknownKey,
    PFSKReturnSysCtlError,
    PFSKReturnLockedWrite,
    PFSKReturnCastError,
    PFSKReturnNotWritable,
    PFSKReturnNoGraphicDevicesFound,
    PFSKReturnInvalidSelector,
    PFSKReturnUnsupportedDevice,
    PFSKReturnGeneral = 65533, //too bad
    PFSKReturnUnknown = 65534 //unknown error (shouldn't happen), could serve as a terminator
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
 @typedef PFSystemKitPlatform
 Enumeration of integers matching a Device Platform (iOS/OSX)
 */
typedef NS_ENUM(int, PFSystemKitPlatform) {
	PFSKPlatformIOS = 0,
	PFSKPlatformOSX,
    PFSKPlatformWatchOS,
    PFSKPlatformUnknown
};

/*!
 @typedef PFSystemKitFamily
 Enumeration of integers matching a Device Family (e.g. MacBookPro, MacBook, iMac, iPad, etc...)
 */
typedef NS_ENUM(int, PFSystemKitDeviceFamily) {
	PFSKDeviceFamilyiMac = 0,
	PFSKDeviceFamilyMacMini,
	PFSKDeviceFamilyMacPro,
	PFSKDeviceFamilyMacBook,
	PFSKDeviceFamilyMacBookAir,
	PFSKDeviceFamilyMacBookPro,
	PFSKDeviceFamilyXserve,
	PFSKDeviceFamilyiPhone,
	PFSKDeviceFamilyiPad,
	PFSKDeviceFamilyiPod,
    PFSKDeviceFamilyWatch, //seems to be a good idea, as watchOS now has native apps
	PFSKDeviceFamilySimulator,
    PFSKDeviceFamilyUnknown
};

/*!
 @typedef PFSystemKitEndianness
 Enumeration of integers matching a type of endianness (little or big)
 */
typedef NS_ENUM(int, PFSystemKitEndianness) {
	PFSKEndiannessLittleEndian = 0,
	PFSKEndiannessBigEndian,
    PFSKEndiannessUnknown
};

/*!
 @typedef PFSystemKitDeviceColor
 Enumeration of integers matching an iOS Device's color, such as Golden, White, Black/Space grey
 */
typedef NS_ENUM(int, PFSystemKitDeviceColor) {
    PFSKDeviceColorBlack = 0,
    PFSKDeviceColorWhite,                   //#F5F4F7
    PFSKDeviceColorSpaceGrey,               //#99989B
    PFSKDeviceColorSilver,                  //#D4C5B3
    PFSKDeviceColorGold,                    //#D7D9D8
    PFSKDeviceColorBlue,                    //#46ABE0
    PFSKDeviceColorGreen,                   //#A1E877
    PFSKDeviceColorYellow,                  //#FAF189
    PFSKDeviceColorRed,                     //#FE767A
    PFSKDeviceColorUnknown
};

/*!
 @typedef PFSystemKitCPUArches
 Enumeration of integers matching a type of CPU (x86, ARM, etc...)
 */
typedef NS_ENUM(int, PFSystemKitCPUArches) {
	PFSKCPUArchesX86 = 0,
	PFSKCPUArchesX86_64,
	PFSKCPUArchesPPC,
	PFSKCPUArchesPPC_64,
	PFSKCPUArchesI860,
	PFSKCPUArchesARM,
	PFSKCPUArchesARM_64,
    PFSKCPUArchesUnknown
};

/*!
 @typedef PFSystemKitCPUArchesARMTypes
 Enumeration of integers matching an ARM subtype (ARM v7, v7s, v8, etc...)
 */
typedef NS_ENUM(int, PFSystemKitCPUArchesARMTypes) {
    PFSKCPUArchesARM_XSCALE = 0,
    PFSKCPUArchesARM_V4T,
    PFSKCPUArchesARM_V5TEJ,
    PFSKCPUArchesARM_V6,
    PFSKCPUArchesARM_V6M,
    PFSKCPUArchesARM_V7,
    PFSKCPUArchesARM_V7S,
    PFSKCPUArchesARM_V7F,
    PFSKCPUArchesARM_V7K,
    PFSKCPUArchesARM_V7M,
    PFSKCPUArchesARM_V7EM,
    PFSKCPUArchesARM_V8,
    PFSKCPUArchesARM_Unknown
};

/*!
 @typedef PFSystemKitCPUARMFeatures
 Enumeration of integers matching an ARM SoC feature
 */
typedef NS_ENUM(int, PFSystemKitCPUARMFeatures) {
    PFSKCPUARMFeaturesUnknown = 0,
    PFSKCPUARMFeaturesFloatingPoint,
    PFSKCPUARMFeaturesVector,
    PFSKCPUARMFeaturesShortVector,
    PFSKCPUARMFeaturesNeon,
    PFSKCPUARMFeaturesNeonHPFP,
};

/*!
 @typedef PFSystemKitCPUVendor
 Enumeration of integers matching a CPU vendor (AuthenticAMD, GenuineIntel, or IBM for ppc)
 */
typedef NS_ENUM(int, PFSystemKitCPUVendor) {
	PFSKCPUVendorGenuineIntel = 0,
	PFSKCPUVendorAuthenticAMD,
	//PFSKCPUVendorIBM,
    PFSKCPUVendorUnknown
};

/*!
 @typedef ll
 Alias for "long long"
 */
typedef long long llong;

/*!
 @typedef @struct PFSystemKitRAMStatistics
 Structure holding current memory shares
 */
typedef struct {
    llong wired;
    llong active;
    llong inactive;
    llong free;
} PFSystemKitRAMStatistics;

/*!
 Creates a PFSystemKitRAMStatistics struct from Wired, Active, Inactive, and Free amounts
 */
inline static PFSystemKitRAMStatistics PFSystemKitRAMStatisticsWithComponents(llong wired, llong active, llong inactive, llong free) {
    return (PFSystemKitRAMStatistics){wired, active, inactive, free};
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
	NSUInteger                                          major;
	
	/*!
	 Minor device version
	 */
	NSUInteger                                          minor;
} PFSystemKitDeviceVersion;

/*!
 Creates a PFSystemKitDeviceVersion struct from major and minor components
 */
inline static PFSystemKitDeviceVersion PFSKDeviceVersionWithComponents(NSUInteger major, NSUInteger minor) {
	return (PFSystemKitDeviceVersion){major, minor};
};

/*!
 Creates a NSOperatingSystemVersion struct from major, minor, patch components
 */
inline static NSOperatingSystemVersion NSOperatingSystemVersionWithComponents(NSInteger major, NSInteger minor, NSInteger patch) {
	return (NSOperatingSystemVersion){major, minor, patch};
};

/*!
 Creates a NSOperatingSystemVersion struct from a NSString, being parsed
 */
inline static NSOperatingSystemVersion NSOperatingSystemVersionWithNSString(NSString*versionString) {
	NSArray *components = [versionString componentsSeparatedByString:@"."];
	NSUInteger major = components.count >= 1 ? [components[0] unsignedIntegerValue] : 0;
	NSUInteger minor = components.count >= 2 ? [components[1] unsignedIntegerValue] : 0;
	NSUInteger patch = components.count >= 3 ? [components[2] unsignedIntegerValue] : 0;
	return NSOperatingSystemVersionWithComponents(major, minor, patch);
};


inline __attribute__((__visibility__("hidden")))
void setValueForKey(const char* key, id value, id cSelf) {
	[cSelf setValue:value forKey:@(key)];
};
inline __attribute__((__visibility__("hidden")))
void setValueForKeyPath(const char* key, id value, id cSelf) {
	[cSelf setValue:value forKeyPath:@(key)];
};
#define PFSKTypes_Header
#endif
