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
		case PFSKReturnSuccess:
			ret = @"Success";
		case PFSKReturnNoMasterPort:
			ret = @"Couldn't create an IOKit Master Port";
		case PFSKReturnComponentUnavailable:
			ret = @"Requested component isn't available on this machine";
		case PFSKReturnIOKitError:
			ret = @"IOKit call failed"; //see _extError
		case PFSKReturnIOKitCFFailure:
			ret = @"Couldn't create property list from IOService";
		case PFSKReturnSysCtlError:
			ret = @"SYSCTL system call failed";
		case PFSKReturnLockedWrite:
			ret = @"Writing is currently forbidden";
		case PFSKReturnCastError:
			ret = @"Couldn't cast"; //any idea ?
		case PFSKReturnNotWritable:
			ret = @"Requested component isn't writable";
		case PFSKReturnGeneral:
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

NSString* familyToString(PFSystemKitDeviceFamily fm) {
	NSString* ret;
	switch (fm) {
		case PFSKDeviceFamilyiMac:
			ret = PFSKDeviceFamilyiMacStr;
		case PFSKDeviceFamilyMacMini:
			ret = PFSKDeviceFamilyMacminiStr;
		case PFSKDeviceFamilyMacPro:
			ret = PFSKDeviceFamilyMacProStr;
		case PFSKDeviceFamilyMacBook:
			ret = PFSKDeviceFamilyMacBookStr;
		case PFSKDeviceFamilyMacBookAir:
			ret = PFSKDeviceFamilyMacBookAirStr;
		case PFSKDeviceFamilyMacBookPro:
			ret = PFSKDeviceFamilyMacBookProStr;
		case PFSKDeviceFamilyXserve:
			ret = PFSKDeviceFamilyXServeStr;
		case PFSKDeviceFamilyiPhone:
			ret = PFSKDeviceFamilyiPhoneStr;
		case PFSKDeviceFamilyiPad:
			ret = PFSKDeviceFamilyiPadStr;
		case PFSKDeviceFamilyiPod:
			ret = PFSKDeviceFamilyiPodStr;
		case PFSKDeviceFamilySimulator:
			ret = PFSKDeviceFamilySimulatorStr;
		default:
			ret = PFSKDeviceFamilyUnknownStr;
	}
	return ret;
}
PFSystemKitDeviceFamily stringToFamily(NSString* str) {
	//[mydict objectForKey:[[str stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString]];
	str = [str lowercaseString]; //transform to lowercase, meaning less code afterwards
	if ([PFSKHelper NSString:str contains:@"mac"]) {
		if ([str isEqualToString:@"imac"])
			return PFSKDeviceFamilyiMac;
		else if ([PFSKHelper NSString:str contains:@"air"])
			return PFSKDeviceFamilyMacBookAir;
		else if ([PFSKHelper NSString:str contains:@"pro"] && [PFSKHelper NSString:str contains:@"book"])
			return PFSKDeviceFamilyMacBookPro;
		else if ([PFSKHelper NSString:str contains:@"mini"])
			return PFSKDeviceFamilyMacMini;
		else if ([PFSKHelper NSString:str contains:@"pro"])
			return PFSKDeviceFamilyMacPro;
		else if ([PFSKHelper NSString:str contains:@"macbook"])
			return PFSKDeviceFamilyMacBook;
	} else if ([str hasPrefix:@"i"]) { //don't care about imac, has been checked before
		if ([str isEqualToString:@"iphone"])
			return PFSKDeviceFamilyiPhone;
		else if ([str isEqualToString:@"ipad"])
			return PFSKDeviceFamilyiPad;
		else if ([str isEqualToString:@"ipod"])
			return PFSKDeviceFamilyiPod;
	} else if ([str isEqualToString:@"xserve"]) {
		return PFSKDeviceFamilyXserve;
	} else if ([str isEqualToString:@"simulator"]) {
		return PFSKDeviceFamilySimulator;
	}
	return PFSKDeviceFamilyUnknown;
}

-(NSString*) stringifyError {
	return errorToString(_error);
}

-(NSString*) stringifyExtError {
	return iokitErrorToString(_extError);
}

-(NSString*)platformString {
#if TARGET_OS_IPHONE
	return @"iOS";
#endif
#if !TARGET_OS_IPHONE
	return @"OSX";
#endif
}

-(PFSystemKitPlatform)platform {
#if TARGET_OS_IPHONE
	return PFSKPlatformIOS;
#endif
#if !TARGET_OS_IPHONE
	return PFSKPlatformOSX;
#endif
}

@end