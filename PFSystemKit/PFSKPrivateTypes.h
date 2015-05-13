//
//  PFSKPrivateTypes.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 03/05/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//
#ifndef PFSystemKit_PFSKPrivateTypes_h
#define PFSystemKit_PFSKPrivateTypes_h
#import "PFSKTypes.h"
#include <set>
#include <map>
#include <string>

constexpr CGFloat operator "" _MB(unsigned long long bytes)
{
	return static_cast<CGFloat>(bytes * 1048576);
}

std::map<int, char const*> PFSystemKitErrorStrings = {
	{ PFSKReturnSuccess, "Success" },
	{ PFSKReturnNoMasterPort, "No Master Port" },
	{ PFSKReturnComponentUnavailable, "Component not available" },
	{ PFSKReturnIOKitError, "IOKit error" }, //see _extError
	{ PFSKReturnIOKitCFFailure, "Property extraction failed" }, //error while making CFProperty
	{ PFSKReturnSysCtlError, "SysCtl call failed" },
	{ PFSKReturnLockedWrite, "Write locked" },
	{ PFSKReturnCastError, "Cast error" },
	{ PFSKReturnNotWritable, "Component not writable" },
	{ PFSKReturnGeneral, "General error" }, //too bad
	{ PFSKReturnUnknown, "Unknown state" } //unknown error (shouldn't happen)
};

std::map<int, char const*> PFSystemKitErrorExplanations = {
	{ PFSKReturnSuccess, "Success" },
	{ PFSKReturnNoMasterPort, "Couldn't create an IOKit Master Port" },
	{ PFSKReturnComponentUnavailable, "Requested component isn't available on this machine" },
	{ PFSKReturnIOKitError, "IOKit call failed" }, //see _extError
	{ PFSKReturnIOKitCFFailure, "Couldn't create property list from IOService" }, //error while making CFProperty
	{ PFSKReturnSysCtlError, "SysCtl system call failed" },
	{ PFSKReturnLockedWrite, "Writing is currently forbidden" },
	{ PFSKReturnCastError, "Cast error" },
	{ PFSKReturnNotWritable, "Requested component isn't writable" },
	{ PFSKReturnGeneral, "General error" }, //too bad
	{ PFSKReturnUnknown, "Unknown state" } //unknown error (shouldn't happen)
};

std::map<int, char const*> PFSystemKitDeviceFamilyStrings = {
	{ PFSKDeviceFamilyUnknown, "Unknown" },
	{ PFSKDeviceFamilyiMac, "iMac" },
	{ PFSKDeviceFamilyMacMini, "Mac Mini" },
	{ PFSKDeviceFamilyMacPro, "Mac Pro" },
	{ PFSKDeviceFamilyMacBook, "MacBook" },
	{ PFSKDeviceFamilyMacBookAir, "MacBook Air" },
	{ PFSKDeviceFamilyMacBookPro, "MacBook Pro" },
	{ PFSKDeviceFamilyXserve, "XServe" },
	{ PFSKDeviceFamilyiPhone, "iPhone" },
	{ PFSKDeviceFamilyiPad, "iPad" },
	{ PFSKDeviceFamilyiPod, "iPod" },
	{ PFSKDeviceFamilySimulator, "Simulator" }
};

std::map<int, char const*> PFSystemKitPlatformStrings = {
	{ PFSKEndiannessUnknown, "Unknown" },
	{ PFSKPlatformIOS, "iOS" },
	{ PFSKPlatformOSX, "OSX" }
};

std::map<int, char const*> PFSystemKitEndiannessStrings = {
	{ PFSKPlatformUnknown, "Unknown" },
	{ PFSKEndiannessLittleEndian, "Little Endian" },
	{ PFSKEndiannessBigEndian, "Big Endian" }
};

std::map<int, char const*> PFSystemKitCPUVendorsStrings = {
	{ PFSKCPUVendorUnknown, "Unknown" },
	{ PFSKCPUVendorGenuineIntel, "GenuineIntel" },
	{ PFSKCPUVendorAuthenticAMD, "AuthenticAMD" }
};

std::map<int, char const*> PFSystemKitCPUArchesStrings = {
	{ PFSKCPUArchesUnknown, "Unknown" },
	{ PFSKCPUArchesX86, "x86" },
	{ PFSKCPUArchesX86_64, "x86_64" },
	{ PFSKCPUArchesPPC, "PPC" },
	{ PFSKCPUArchesPPC_64, "PPC_64" },
	{ PFSKCPUArchesI860, "i860" },
	{ PFSKCPUArchesARM, "ARM" },
	{ PFSKCPUArchesARM_64, "ARM_64" },
};

#endif
