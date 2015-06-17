//
//  PFSK_Common.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <mach/mach_error.h>
#import <sys/sysctl.h>
#import <string>
#import "PFSK_Common.h"
#import "PFSKHelper.h"
#import "PFSKPrivateTypes.h"

NSString* PFSKErrorDomain = @"com.faramaz.PFSystemKit";
NSString* PFSKErrorExtendedDomain = @"com.faramaz.PFSystemKit.extended";

@implementation PFSK_Common
+(BOOL)isVersion:(NSOperatingSystemVersion)version
		 between:(NSOperatingSystemVersion)lowVersion
			 and:(NSOperatingSystemVersion)highVersion {
	
	// major in range
	if (lowVersion.majorVersion >= version.majorVersion <= highVersion.majorVersion) {
		return YES;
	} else {
		if (lowVersion.minorVersion >= version.minorVersion <= highVersion.minorVersion) {
			return YES;
		} else {
			if (lowVersion.patchVersion >= version.patchVersion <= highVersion.patchVersion) {
				return YES;
			} else {
				return NO;
			}
		}
	}
}

+(BOOL)isVersion:(NSOperatingSystemVersion)version
  atLeastVersion:(NSOperatingSystemVersion)leastVersion {
	
	if (version.majorVersion == leastVersion.majorVersion) {
		if (version.minorVersion == leastVersion.minorVersion) {
			return version.patchVersion >= leastVersion.patchVersion;
		}
		return version.minorVersion >= leastVersion.minorVersion;
	}
	return version.majorVersion >= leastVersion.majorVersion;
}

+(BOOL)isVersion:(NSOperatingSystemVersion)version
   atBestVersion:(NSOperatingSystemVersion)bestVersion {

	if (version.majorVersion == bestVersion.majorVersion) {
		if (version.minorVersion == bestVersion.minorVersion) {
			return version.patchVersion <= bestVersion.patchVersion;
		}
		return version.minorVersion <= bestVersion.minorVersion;
	}
	return version.majorVersion <= bestVersion.majorVersion;
}

+(NSString*) errorToString:(PFSystemKitError)err {
	return @(PFSystemKitErrorStrings[err]);
}

+(NSString*) errorToExplanation:(PFSystemKitError)err {
	return @(PFSystemKitErrorReasons[err]);
}

+(NSString*) errorToRecovery:(PFSystemKitError)err {
	return @(PFSystemKitErrorRecovery[err]);
}

inline NSString* errorToRecovery(PFSystemKitError err) {
	return @(PFSystemKitErrorRecovery[err]);
}

inline NSString* errorToExplanation(PFSystemKitError err) {
	return @(PFSystemKitErrorReasons[err]);
}

inline NSString* errorToString(PFSystemKitError err) {
	return @(PFSystemKitErrorStrings[err]);
}

+(NSString*) iokitErrorToString:(kern_return_t)err {
	return [NSString.alloc initWithCString:mach_error_string(err) encoding:NSUTF8StringEncoding];
}

+(NSString*) platformToString:(PFSystemKitPlatform)platform {
	return @(PFSystemKitPlatformStrings[platform]);
}

+(PFSystemKitPlatform) stringToPlatform:(NSString*)str {
	str = [str lowercaseString];
	if ([PFSKHelper NSString:str contains:@"i"])
		return PFSKPlatformIOS;
	else if ([PFSKHelper NSString:str contains:@"x"])
		return PFSKPlatformOSX;
	else
		return PFSKPlatformUnknown;
}

+(NSString*) familyToString:(PFSystemKitDeviceFamily)family {
	return @(PFSystemKitDeviceFamilyStrings[family]);
}
+(PFSystemKitDeviceFamily) stringToFamily:(NSString*)str {
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

+(NSString*) endiannessToString:(PFSystemKitEndianness) endianness {
	return @(PFSystemKitEndiannessStrings[endianness]);
}

+(NSString*) cpuVendorToString:(PFSystemKitCPUVendors) vendor {
	return @(PFSystemKitCPUVendorsStrings[vendor]);
}

+(NSString*) cpuArchToString:(PFSystemKitCPUArches) arch {
	return @(PFSystemKitCPUArchesStrings[arch]);
}

NSString* _cpuArchToString(PFSystemKitCPUArches arch) {
	return @(PFSystemKitCPUArchesStrings[arch]);
}

+(NSOperatingSystemVersion) osVersionFromString:(NSString*) string {
	return NSOperatingSystemVersionWithNSString(string);
}

-(NSString*) stringifyError {
	return [self.class errorToString:_error];
}

-(NSString*) stringifyExtError {
	return [self.class iokitErrorToString:_extError];
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

inline PFSystemKitError __sysctlStringForKey(char* key, std::string& answerChar) {
	size_t length;
	sysctlbyname(key, NULL, &length, NULL, 0);
	if (length) {
		std::string platform;
		memset(&answerChar, 0, sizeof(answerChar));
		sysctlbyname(key, WriteInto(&answerChar, length), &length, NULL, 0);
		return PFSKReturnSuccess;
	}
	
	return PFSKReturnSysCtlError;
}

inline PFSystemKitError __sysctlFloatForKey(char* key, CGFloat& answerFloat) {
	size_t length;
	sysctlbyname(key, NULL, &length, NULL, 0);
	if (length) {
		answerFloat = 0;
		//char *answerRaw = malloc(length * sizeof(char));
		char *answerRaw = new char[length];
		sysctlbyname(key, answerRaw, &length, NULL, 0);
		switch (length) {
			case 8: {
				answerFloat = (CGFloat)*(int64_t *)answerRaw;
				return PFSKReturnSuccess;
			} break;
				
			case 4: {
				answerFloat = (CGFloat)*(int32_t *)answerRaw;
				return PFSKReturnSuccess;
			} break;
				
			default: {
				answerFloat = (CGFloat)0.;
				return PFSKReturnSuccess;
			} break;
		}
		delete [] answerRaw;
	}
	return PFSKReturnSysCtlError;
}

PFSystemKitError _sysctlStringForKey(char* key, std::string& answerString) { //function used only in the framework, to avoid ObjC method resolving (=faster)
	return __sysctlStringForKey(key, answerString);
}

PFSystemKitError _sysctlFloatForKey(char* key, CGFloat& answerFloat) { //function used only in the framework, to avoid ObjC method resolving (=faster)
	return __sysctlFloatForKey(key, answerFloat);
}

+(PFSystemKitError) sysctlStringForKey:(char*)key intoSTDString:(std::string&)answerStr {
	return __sysctlStringForKey(key, answerStr);
}

+(PFSystemKitError) sysctlFloatForKey:(char*)key intoFloat:(CGFloat&)answerFloat {
	return __sysctlFloatForKey(key, answerFloat);
}

+(PFSystemKitError) sysctlStringForKey:(char*)key intoNSString:(NSString**)answerStr {
	unsigned char *text = (unsigned char*)CFStringGetCStringPtr((CFStringRef)((void *)answerStr), CFStringGetSystemEncoding());
	size_t length;
	sysctlbyname(key, NULL, &length, NULL, 0);
	if (length) {
		std::string platform;
		sysctlbyname(key, &text, &length, NULL, 0);
		return PFSKReturnSuccess;
	}
	
	return PFSKReturnSysCtlError;
}

+(PFSystemKitError) sysctlFloatForKey:(char*)key intoNSNumber:(NSNumber**)answerNumber {
	CGFloat answerFloat = 0;
	PFSystemKitError result = __sysctlFloatForKey(key, answerFloat);
	*answerNumber = @(answerFloat);
	return result;
}

__attribute__((always_inline)) NSError* synthesizeError(PFSystemKitError error) {
	return [NSError errorWithDomain:PFSKErrorDomain
							   code:error
						   userInfo:@{
									  NSLocalizedDescriptionKey: errorToExplanation(error),
									  NSLocalizedFailureReasonErrorKey: errorToRecovery(error)
									  }];
}

__attribute__((always_inline)) NSError* synthesizeErrorExt(PFSystemKitError error, kern_return_t extendedError) {
	return [NSError errorWithDomain:PFSKErrorDomain
							   code:error
						   userInfo:@{
									  NSLocalizedDescriptionKey: errorToExplanation(error),
									  NSLocalizedFailureReasonErrorKey: errorToRecovery(error),
									  NSUnderlyingErrorKey: [NSError errorWithDomain:PFSKErrorExtendedDomain
																				code:extendedError
																			userInfo:@{
																					   NSLocalizedDescriptionKey: [NSString.alloc initWithCString:mach_error_string(extendedError)
																																		 encoding:NSUTF8StringEncoding]
																					   }]
									  }];
}
@end