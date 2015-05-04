//
//  PFSK_Common.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSKProtocol.h"
#import <string>

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
NSString* errorToString(PFSystemKitError);

/*!
 @discussion Translates a kern_return_t to a human-readable string
 @abstract Wraps mach_error_string()
 @param err Any int, that is a valid error code
 @returns A NSString holding the error string
 */
NSString* iokitErrorToString(kern_return_t);

/*!
 @discussion Matches a PFSystemKitPlatform to a displayable NSString
 @param platform Any member of the PFSystemKitPlatform enum
 @returns A NSString holding the platform string
 */
NSString* platformToString(PFSystemKitPlatform);

/*!
 @discussion Matches a NSString to its PFSystemKitPlatform value
 @param string Any NSString, that could be a valid platform from Apple
 @returns A member of the PFSystemKitPlatform enum if found, PFSystemKitPlatformUnknown else
 */
PFSystemKitPlatform stringToPlatform(NSString*);

/*!
 @discussion Matches a PFSystemKitFamily to a displayable NSString
 @param family Any member of the PFSystemKitFamily enum
 @returns A NSString holding the Device Family string
 */
NSString* familyToString(PFSystemKitDeviceFamily);

/*!
 @discussion Matches a NSString to its PFSystemKitFamily value
 @param string Any NSString, that could be a valid Apple device family
 @returns A member of the PFSystemKitFamily enum if found, PFSystemKitFamilyUnknown else
 */
PFSystemKitDeviceFamily stringToFamily(NSString*);

+(PFSystemKitError) sysctlStringForKey:(char*)key intoChar:(std::string&)answerChar;
+(PFSystemKitError) sysctlFloatForKey:(char*)key intoFloat:(CGFloat&)answerFloat;
@end
