//
//  PFSK_Common.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSKProtocol.h"
#if defined(__cplusplus)
#import <string>
#endif

@interface PFSK_Common : NSObject {
	@protected
	PFSystemKitError error;
	kern_return_t extError;
	PFSystemKitLockState writeLockState;
}

/*!
 @discussion Translates the last PFSystemKitError (stored in the `_error` ivar) to a human-readable string
 @returns A NSString holding the _error ivar string value
 */
-(NSString*) stringifyError;

/*!
 @discussion Translates the last IOKit error (stored in the `_extError` ivar) to a human-readable string
 @returns A NSString holding the _extError ivar string value
 */
-(NSString*) stringifyExtError;

/*!
 @discussion Returns the current platform as a member of the PFSystemKitPlatform enum
 @returns An int matching the current platform (iOS/OSX)
 */
-(PFSystemKitPlatform)platform;

/*!
 @discussion Returns the current platform
 @returns A NSString holding the current platform (iOS/OSX)
 */
-(NSString*)platformString;



/*!
 @discussion Translates a PFSystemKitError to a human-readable string
 @param err Any member of the PFSystemKitError enum
 @returns A NSString holding the PFSystemKitError string value
 */
+(NSString*) errorToString:(PFSystemKitError)err;

/*!
 @discussion Explains a PFSystemKitError
 @param err Any member of the PFSystemKitError enum
 @returns A NSString holding the explanation
 */
+(NSString*) errorToExplanation:(PFSystemKitError)err;

/*!
 @discussion Translates a kern_return_t to a human-readable string
 @abstract Wraps mach_error_string()
 @param err Any int, that is a valid error code
 @returns A NSString holding the error string
 */
+(NSString*) iokitErrorToString:(kern_return_t)err;

/*!
 @discussion Matches a PFSystemKitPlatform to a displayable NSString
 @param platform Any member of the PFSystemKitPlatform enum
 @returns A NSString holding the platform string
 */
+(NSString*) platformToString:(PFSystemKitPlatform)platform;

/*!
 @discussion Matches a NSString to its PFSystemKitPlatform value
 @param string Any NSString, that could be a valid platform from Apple
 @returns A member of the PFSystemKitPlatform enum if found, PFSystemKitPlatformUnknown else
 */
+(PFSystemKitPlatform) stringToPlatform:(NSString*)str;

/*!
 @discussion Matches a PFSystemKitFamily to a displayable NSString
 @param family Any member of the PFSystemKitFamily enum
 @returns A NSString holding the Device Family string
 */
+(NSString*) familyToString:(PFSystemKitDeviceFamily)family;

/*!
 @discussion Matches a PFSystemKitEndianness to a displayable NSString
 @param endianness Any member of the PFSystemKitEndianness enum
 @returns A NSString holding either "Big Endian", "Little Endian", or "Unknown" if unknown
 */
+(NSString*) endiannessToString:(PFSystemKitEndianness) endianness;

/*!
 @discussion Matches a NSString to its PFSystemKitFamily value
 @param string Any NSString, that could be a valid Apple device family
 @returns A member of the PFSystemKitFamily enum if found, PFSystemKitFamilyUnknown else
 */
+(PFSystemKitDeviceFamily) stringToFamily:(NSString*)str;

/*!
 @discussion Translates a member of PFSystemKitCPUVendors to a displayable NSString
 @param vendor Any member of the PFSystemKitCPUVendors enum
 @returns A NSString holding either "GenuineIntel", "AuthenticAMD" (for hackintoshes, most likely), or "Unknown" if unknown
 */
+(NSString*) cpuVendorToString:(PFSystemKitCPUVendors) vendor;

#if defined(__cplusplus) //we're working with Objective-C++, so we can use std::strings and pass by reference
PFSystemKitError _sysctlStringForKey(char* key, std::string& answerString);
PFSystemKitError _sysctlFloatForKey(char* key, CGFloat& answerFloat);
/*!
 @discussion Makes a SysCtl call with the given key, and assign the received string value to the passed std::string
 @param key A char array holding the requested key
 @param answerStr A std::string that will be holding the SysCtl-retrieved string
 @returns A member of the PFSystemKitError enum (PFSKReturnSuccess in case of successful request)
 */
+(PFSystemKitError) sysctlStringForKey:(char*)key intoSTDString:(std::string&)answerStr;

/*!
 @discussion Makes a SysCtl call with the given key, and assign the received value to the passed CGFloat
 @param key A char array holding the requested key
 @param answerStr A CGFloat instance that will be holding the SysCtl-retrieved value
 @returns A member of the PFSystemKitError enum (PFSKReturnSuccess in case of successful request)
 */
+(PFSystemKitError) sysctlFloatForKey:(char*)key intoFloat:(CGFloat&)answerFloat;
#endif

/*!
 @discussion Makes a SysCtl call with the given key, and assign the received string value to the passed NSString
 @param key A char array holding the requested key
 @param answerStr A NSString that will be holding the SysCtl-retrieved string
 @returns A member of the PFSystemKitError enum (PFSKReturnSuccess in case of successful request)
 */
+(PFSystemKitError) sysctlStringForKey:(char*)key intoNSString:(NSString**)answerStr;

/*!
 @discussion Makes a SysCtl call with the given key, and assign the received value to the passed NSNumber
 @param key A char array holding the requested key
 @param answerStr A NSNumber instance that will be holding the SysCtl-retrieved value
 @returns A member of the PFSystemKitError enum (PFSKReturnSuccess in case of successful request)
 */
+(PFSystemKitError) sysctlFloatForKey:(char*)key intoNSNumber:(NSNumber**)answerNumber;
@end
