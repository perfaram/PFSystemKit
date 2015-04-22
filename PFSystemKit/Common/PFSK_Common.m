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
		case kSKPlatformIOS:
			ret = @"iOS";
		case kSKPlatformOSX:
			ret = @"OSX";
		default:
			ret = @"Unknown";
	}
	return ret;
}
PFSystemKitPlatform stringToPlatform(NSString* str) {
	if ([str caseInsensitiveCompare:@"iOS"] == NSOrderedSame)
		return kSKPlatformIOS;
	else if ([str caseInsensitiveCompare:@"OSX"] == NSOrderedSame)
		return kSKPlatformOSX;
	else
		return kSKPlatformUnknown;
}

NSString* familyToString(PFSystemKitFamily fm) {
	NSString* ret;
	switch (fm) {
		case kSKDeviceFamilyiMac:
			ret = @"iMac";
		case kSKDeviceFamilyMacMini:
			ret = @"Mac Mini";
		case kSKDeviceFamilyMacPro:
			ret = @"Mac Pro";
		case kSKDeviceFamilyMacBook:
			ret = @"MacBook";
		case kSKDeviceFamilyMacBookAir:
			ret = @"MacBook Air";
		case kSKDeviceFamilyMacBookPro:
			ret = @"MacBook Pro";
		case kSKDeviceFamilyXserve:
			ret = @"XServe";
		case kSKDeviceFamilyiPhone:
			ret = @"iPhone";
		case kSKDeviceFamilyiPad:
			ret = @"iPad";
		case kSKDeviceFamilyiPod:
			ret = @"iPod";
		case kSKDeviceFamilySimulator:
			ret = @"Simulator";
		default:
			ret = @"Unknown";
	}
	return ret;
}
PFSystemKitFamily stringToFamily(NSString* str) {
	if ([PFSKHelper NSString:str contains:@"mac"]) {
		if (([str caseInsensitiveCompare:@"iMac"] == NSOrderedSame))
			return kSKDeviceFamilyiMac;
		else if ([PFSKHelper NSString:str contains:@"air"])
			return kSKDeviceFamilyMacBookAir;
		else if ([PFSKHelper NSString:str contains:@"pro"] && [PFSKHelper NSString:str contains:@"book"])
			return kSKDeviceFamilyMacBookPro;
		else if ([PFSKHelper NSString:str contains:@"mini"])
			return kSKDeviceFamilyMacMini;
		else if ([PFSKHelper NSString:str contains:@"pro"])
			return kSKDeviceFamilyMacPro;
		else if ([str caseInsensitiveCompare:@"macbook"] == NSOrderedSame)
			return kSKDeviceFamilyMacBook;
	} else if ([str hasPrefix:@"i"]) { //don't care about imac, has been checked before
		if (([str caseInsensitiveCompare:@"iPhone"] == NSOrderedSame))
			return kSKDeviceFamilyiPhone;
		else if (([str caseInsensitiveCompare:@"iPad"] == NSOrderedSame))
			return kSKDeviceFamilyiPad;
		else if (([str caseInsensitiveCompare:@"iPod"] == NSOrderedSame))
			return kSKDeviceFamilyiPod;
	} else if ([str caseInsensitiveCompare:@"xserve"] == NSOrderedSame) {
		return kSKDeviceFamilyXserve;
	} else if ([str caseInsensitiveCompare:@"simulator"] == NSOrderedSame) {
		return kSKDeviceFamilySimulator;
	}
	return kSKDeviceFamilyUnknown;
}

-(NSString*) stringifyError {
	return errorToString(_error);
}

-(NSString*) stringifyExtError {
	return iokitErrorToString(_extError);
}

@end