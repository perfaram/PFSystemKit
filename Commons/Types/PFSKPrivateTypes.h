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
#include <functional>

struct CompareNSString: public std::binary_function<NSString*, NSString*, bool> {
    bool operator()(NSString* lhs, NSString* rhs) const {
        if (rhs != nil)
            return (lhs == nil) || ([lhs compare: rhs] == NSOrderedAscending);
        else
            return false;
    }
};

constexpr double operator "" _MB(unsigned long long bytes)
{
	return static_cast<double>(bytes * 1048576);
}

std::map<PFSystemKitError, char const*> PFSystemKitErrorStrings = {
	{ PFSKReturnSuccess, "Success" },
	{ PFSKReturnNoMasterPort, "No Master Port" },
	{ PFSKReturnComponentUnavailable, "Component not available" },
	{ PFSKReturnIOKitError, "IOKit error" }, //see _extError
	{ PFSKReturnIOKitCFFailure, "Property extraction failed" }, //error while making CFProperty
	{ PFSKReturnSysCtlUnknownKey, "SysCtl called with unknown key" },
    { PFSKReturnSysCtlError, "SysCtl call failed" },
	{ PFSKReturnLockedWrite, "Write locked" },
	{ PFSKReturnCastError, "Cast error" },
	{ PFSKReturnNotWritable, "Component not writable" },
	{ PFSKReturnGeneral, "General error" }, //too bad
	{ PFSKReturnUnknown, "Unknown state" } //unknown error (shouldn't happen)
};

std::map<PFSystemKitError, char const*> PFSystemKitErrorReasons = {
	{ PFSKReturnSuccess, "Nothing bad happened while performing the last operation" },
	{ PFSKReturnNoMasterPort, "IOKit encountered a problem while creating the MasterPort, see extended error informations for details"/*. See below for details.*/ },
	{ PFSKReturnComponentUnavailable, "Requested component isn't available on this machine" },
	{ PFSKReturnIOKitError, "IOKit call failed, see extended error informations for details" }, //see _extError
	{ PFSKReturnIOKitCFFailure, "Couldn't get device properties list from IOService, see extended error informations for details" }, //error while making CFProperty
	{ PFSKReturnSysCtlUnknownKey, "Requested SysCtl key isn't available on this system" },
    { PFSKReturnSysCtlError, "SysCtl call failed, system likely doesn't handle the requested key" },
	{ PFSKReturnLockedWrite, "Writing to device is currently forbidden" },
	{ PFSKReturnCastError, "Cast error, IOKit likely returned meaningless data" },
	{ PFSKReturnNotWritable, "IOKit forbids write access to this component" },
	{ PFSKReturnGeneral, "General error, something went wrong in the program itself!" }, //too bad
	{ PFSKReturnUnknown, "Unknown state, something went wrong in the program itself!" } //unknown error (shouldn't happen)
};

std::map<PFSystemKitError, char const*> PFSystemKitErrorRecovery = {
	{ PFSKReturnSuccess, "Nothing to recover from" },
	{ PFSKReturnNoMasterPort, "Recovery depends on the exact IOKit error"/*. See below for details.*/ },
	{ PFSKReturnComponentUnavailable, "Nothing to do" },
	{ PFSKReturnIOKitError, "Recovery depends on the exact IOKit error" }, //see _extError
	{ PFSKReturnIOKitCFFailure, "Recovery depends on the exact IOKit error; however, it is most likely due a lack of memory" }, //error while calling IORegistryEntryCreateCFProperties
	{ PFSKReturnSysCtlUnknownKey, "Nothing to do" },
    { PFSKReturnSysCtlError, "Nothing to do" },
	{ PFSKReturnLockedWrite, "Elevate yourself" },
	{ PFSKReturnCastError, "Nothing particular to do, apart from retrying" },
	{ PFSKReturnNotWritable, "Nothing to do, privilege escalation won't help" },
	{ PFSKReturnGeneral, "Reopen the program, then file a bug report" }, //too bad
	{ PFSKReturnUnknown, "Reopen the program, then file a bug report" } //unknown error (shouldn't happen)
};

std::map<NSString*, PFSystemKitDeviceColor, CompareNSString> PFSystemKitDeviceColorHexesReverse = {
    { @"Unknown", PFSKDeviceColorUnknown },
    { @"f5f4f7", PFSKDeviceColorWhite },
    { @"99989b", PFSKDeviceColorSpaceGrey },
    { @"d4c5b3", PFSKDeviceColorSilver },
    { @"d7d9d8", PFSKDeviceColorGold },
    { @"46abe0", PFSKDeviceColorBlue },
    { @"a1e877", PFSKDeviceColorGreen },
    { @"faf189", PFSKDeviceColorYellow },
    { @"fe767a", PFSKDeviceColorRed }
};

std::map<PFSystemKitDeviceFamily, char const*> PFSystemKitDeviceFamilyStrings = {
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

std::map<PFSystemKitPlatform, char const*> PFSystemKitPlatformStrings = {
	{ PFSKPlatformUnknown, "Unknown" },
	{ PFSKPlatformIOS, "iOS" },
	{ PFSKPlatformOSX, "OSX" },
    { PFSKPlatformWatchOS, "watchOS" }
};

std::map<PFSystemKitEndianness, char const*> PFSystemKitEndiannessStrings = {
	{ PFSKEndiannessUnknown, "Unknown" },
	{ PFSKEndiannessLittleEndian, "Little Endian" },
	{ PFSKEndiannessBigEndian, "Big Endian" }
};

std::map<PFSystemKitCPUVendor, char const*> PFSystemKitCPUVendorStrings = {
	{ PFSKCPUVendorUnknown, "Unknown" },
	{ PFSKCPUVendorGenuineIntel, "GenuineIntel" },
	{ PFSKCPUVendorAuthenticAMD, "AuthenticAMD" }
};

std::map<PFSystemKitCPUArches, char const*> PFSystemKitCPUArchesStrings = {
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
