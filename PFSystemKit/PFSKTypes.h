//
//  PFSKTypes.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#ifndef PFSystemKit_PFSystemKitTypes_h
#define PFSystemKit_PFSystemKitTypes_h

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

typedef NS_ENUM(int, PFSystemKitGroup) {
	kSKGroupPlatformExpertDevice = 1,
	kSKGroupROM = 2,
	kSKGroupNVRam = 3,
	kSKGroupSMC = 4,
	kSKGroupLMU = 5,
	kSKGroupGraphics = 6,
	kSKGroupTerminator
};

typedef NS_ENUM(int, PFSystemKitPlatform) {
	PFSKPlatformUnknown = 0,
	PFSKPlatformIOS,
	PFSKPlatformOSX,
};

typedef NS_ENUM(int, PFSystemKitFamily) {
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

#endif
