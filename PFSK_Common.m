//
//  PFSK_Common.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <mach/mach_error.h>
#import "PFSK_Common.h"
#import "PFSKHelper.h"

@implementation PFSK_Common
NSString* errorToString(PFSystemKitError err) {
	NSString* ret;
	switch (err) {
		case kSKReturnSuccess:
			ret = @"Success";
		case kSKReturnNoMasterPort:
			ret = @"Couldn't create an IOKit Master Port";
		case kSKReturnComponentUnavailable:
			ret = @"Requested component isn't available on this machine";
		case kSKReturnIOKitError:
			ret = @"IOKit call failed"; //see _extError
		case kSKReturnIOKitCFFailure:
			ret = @"Couldn't create property list from IOService";
		case kSKReturnSysCtlError:
			ret = @"SYSCTL system call failed";
		case kSKReturnLockedWrite:
			ret = @"Writing is currently forbidden";
		case kSKReturnCastError:
			ret = @"Couldn't cast"; //any idea ?
		case kSKReturnNotWritable:
			ret = @"Requested component isn't writable";
		case kSKReturnGeneral:
			ret = @"General error";
		default:
			ret = @"Unknown error";
	}
	return ret;
}

NSString* iokitErrorToString(kern_return_t err) {
	return [NSString.alloc initWithCString:mach_error_string(err) encoding:NSUTF8StringEncoding];
}

//PFSystemKitError stringToError(NSString* str) {} such a function would be useless

NSString* platformToString(PFSystemKitPlatform pf) {
	NSString* ret;
	switch (pf) {
		case PFSKPlatformIOS:
			ret = @"iOS";
		case PFSKPlatformOSX:
			ret = @"OSX";
		default:
			ret = @"Unknown";
	}
	return ret;
}
PFSystemKitPlatform stringToPlatform(NSString* str) {
	if ([str caseInsensitiveCompare:@"iOS"] == NSOrderedSame)
		return PFSKPlatformIOS;
	else if ([str caseInsensitiveCompare:@"OSX"] == NSOrderedSame)
		return PFSKPlatformOSX;
	else
		return PFSKPlatformUnknown;
}

NSString* familyToString(PFSystemKitFamily fm) {
	NSString* ret;
	switch (fm) {
		case PFSKDeviceFamilyiMac:
			ret = @"iMac";
		case PFSKDeviceFamilyMacMini:
			ret = @"Mac Mini";
		case PFSKDeviceFamilyMacPro:
			ret = @"Mac Pro";
		case PFSKDeviceFamilyMacBook:
			ret = @"MacBook";
		case PFSKDeviceFamilyMacBookAir:
			ret = @"MacBook Air";
		case PFSKDeviceFamilyMacBookPro:
			ret = @"MacBook Pro";
		case PFSKDeviceFamilyXserve:
			ret = @"XServe";
		case PFSKDeviceFamilyiPhone:
			ret = @"iPhone";
		case PFSKDeviceFamilyiPad:
			ret = @"iPad";
		case PFSKDeviceFamilyiPod:
			ret = @"iPod";
		case PFSKDeviceFamilySimulator:
			ret = @"Simulator";
		default:
			ret = @"Unknown";
	}
	return ret;
}
PFSystemKitFamily stringToFamily(NSString* str) {
	if ([PFSKHelper NSString:str contains:@"mac"]) {
		if (([str caseInsensitiveCompare:@"iMac"] == NSOrderedSame))
			return PFSKDeviceFamilyiMac;
		else if ([PFSKHelper NSString:str contains:@"air"])
			return PFSKDeviceFamilyMacBookAir;
		else if ([PFSKHelper NSString:str contains:@"pro"] && [PFSKHelper NSString:str contains:@"book"])
			return PFSKDeviceFamilyMacBookPro;
		else if ([PFSKHelper NSString:str contains:@"mini"])
			return PFSKDeviceFamilyMacMini;
		else if ([PFSKHelper NSString:str contains:@"pro"])
			return PFSKDeviceFamilyMacPro;
		else if ([str caseInsensitiveCompare:@"macbook"] == NSOrderedSame)
			return PFSKDeviceFamilyMacBook;
	} else if ([str hasPrefix:@"i"]) { //don't care about imac, has been checked before
		if (([str caseInsensitiveCompare:@"iPhone"] == NSOrderedSame))
			return PFSKDeviceFamilyiPhone;
		else if (([str caseInsensitiveCompare:@"iPad"] == NSOrderedSame))
			return PFSKDeviceFamilyiPad;
		else if (([str caseInsensitiveCompare:@"iPod"] == NSOrderedSame))
			return PFSKDeviceFamilyiPod;
	} else if ([str caseInsensitiveCompare:@"xserve"] == NSOrderedSame) {
		return PFSKDeviceFamilyXserve;
	} else if ([str caseInsensitiveCompare:@"simulator"] == NSOrderedSame) {
		return PFSKDeviceFamilySimulator;
	}
	return PFSKDeviceFamilyUnknown;
}
@end