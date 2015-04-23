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
			ret = kSKDeviceFamilyiMacStr;
		case kSKDeviceFamilyMacMini:
			ret = kSKDeviceFamilyMacminiStr;
		case kSKDeviceFamilyMacPro:
			ret = kSKDeviceFamilyMacProStr;
		case kSKDeviceFamilyMacBook:
			ret = kSKDeviceFamilyMacBookStr;
		case kSKDeviceFamilyMacBookAir:
			ret = kSKDeviceFamilyMacBookAirStr;
		case kSKDeviceFamilyMacBookPro:
			ret = kSKDeviceFamilyMacBookProStr;
		case kSKDeviceFamilyXserve:
			ret = kSKDeviceFamilyXServeStr;
		case kSKDeviceFamilyiPhone:
			ret = kSKDeviceFamilyiPhoneStr;
		case kSKDeviceFamilyiPad:
			ret = kSKDeviceFamilyiPadStr;
		case kSKDeviceFamilyiPod:
			ret = kSKDeviceFamilyiPodStr;
		case kSKDeviceFamilySimulator:
			ret = kSKDeviceFamilySimulatorStr;
		default:
			ret = kSKDeviceFamilyUnknownStr;
	}
	return ret;
}
PFSystemKitFamily stringToFamily(NSString* str) {
	//[mydict objectForKey:[[str stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString]];
	str = [str lowercaseString]; //transform to lowercase, meaning less code afterwards
	if ([PFSKHelper NSString:str contains:@"mac"]) {
		if ([str isEqualToString:@"imac"])
			return kSKDeviceFamilyiMac;
		else if ([PFSKHelper NSString:str contains:@"air"])
			return kSKDeviceFamilyMacBookAir;
		else if ([PFSKHelper NSString:str contains:@"pro"] && [PFSKHelper NSString:str contains:@"book"])
			return kSKDeviceFamilyMacBookPro;
		else if ([PFSKHelper NSString:str contains:@"mini"])
			return kSKDeviceFamilyMacMini;
		else if ([PFSKHelper NSString:str contains:@"pro"])
			return kSKDeviceFamilyMacPro;
		else if ([PFSKHelper NSString:str contains:@"macbook"])
			return kSKDeviceFamilyMacBook;
	} else if ([str hasPrefix:@"i"]) { //don't care about imac, has been checked before
		if ([str isEqualToString:@"iphone"])
			return kSKDeviceFamilyiPhone;
		else if ([str isEqualToString:@"ipad"])
			return kSKDeviceFamilyiPad;
		else if ([str isEqualToString:@"ipod"])
			return kSKDeviceFamilyiPod;
	} else if ([str isEqualToString:@"xserve"]) {
		return kSKDeviceFamilyXserve;
	} else if ([str isEqualToString:@"simulator"]) {
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