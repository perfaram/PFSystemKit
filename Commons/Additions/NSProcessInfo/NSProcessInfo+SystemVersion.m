/*
 * Copyright (c) 2014 Petroules Corporation. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
/*
 * Portions Copyright (C) Perceval <@perfaram> FARAMAZ
 */

#import "NSProcessInfo+SystemVersion.h"

#if defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif defined(TARGET_OS_MAC) && TARGET_OS_MAC
#import <CoreServices/CoreServices.h>
#endif

@interface NSProcessInfo (SystemVersionPrivate)

#if LOAD_OPERATING_SYSTEM_VERSION
- (NSOperatingSystemVersion)SystemVersion_operatingSystemVersion;
- (BOOL)SystemVersion_isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion)version;
- (BOOL)SystemVersion_isOperatingSystemAtBestVersion:(NSOperatingSystemVersion)version;
#endif

@end

@implementation NSProcessInfo (SystemVersionPrivate)

+(void)load
{
#if LOAD_OPERATING_SYSTEM_VERSION
	// Public API since OS X 10.10 (present since 10.9) and iOS 8.0
	class_addInstanceMethodIfNecessary([self class],
									   NSSelectorFromString(@"operatingSystemVersion"),
									   @selector(SystemVersion_operatingSystemVersion));
	
	// Public API since OS X 10.10 (present since 10.9) and iOS 8.0
	class_addInstanceMethodIfNecessary([self class],
									   NSSelectorFromString(@"isOperatingSystemAtLeastVersion:"),
									   @selector(SystemVersion_isOperatingSystemAtLeastVersion:));
	// No API for this one, added by @perfaram
	class_addInstanceMethodIfNecessary([self class],
									   NSSelectorFromString(@"isOperatingSystemAtBestVersion:"),
									   @selector(SystemVersion_isOperatingSystemAtBestVersion:));
#endif
}

#if LOAD_OPERATING_SYSTEM_VERSION
- (NSOperatingSystemVersion)SystemVersion_operatingSystemVersion
{
	NSOperatingSystemVersion v = {0, 0, 0};
	SInt32 major = 0, minor = 0, patch = 0;
#if defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE
#if !defined(__has_feature) || !__has_feature(objc_arc)
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif
	NSArray *parts = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
	major = parts.count > 0 ? [[parts objectAtIndex:0] intValue] : 0;
	minor = parts.count > 1 ? [[parts objectAtIndex:1] intValue] : 0;
	patch = parts.count > 2 ? [[parts objectAtIndex:2] intValue] : 0;
#if !defined(__has_feature) || !__has_feature(objc_arc)
	[pool release];
#endif
#elif defined(TARGET_OS_MAC) && TARGET_OS_MAC
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	if (Gestalt(gestaltSystemVersionMajor, &major) != noErr) return v;
	if (Gestalt(gestaltSystemVersionMinor, &minor) != noErr) return v;
	if (Gestalt(gestaltSystemVersionBugFix, &patch) != noErr) return v;
#pragma clang diagnostic pop
#endif
	v.majorVersion = major;
	v.minorVersion = minor;
	v.patchVersion = patch;
	return v;
}

- (BOOL)SystemVersion_isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion)version
{
	const NSOperatingSystemVersion systemVersion = [self operatingSystemVersion];
	if (systemVersion.majorVersion == version.majorVersion) {
		if (systemVersion.minorVersion == version.minorVersion) {
			return systemVersion.patchVersion >= version.patchVersion;
		}
		return systemVersion.minorVersion >= version.minorVersion;
	}
	return systemVersion.majorVersion >= version.majorVersion;
}

- (BOOL)SystemVersion_isOperatingSystemAtBestVersion:(NSOperatingSystemVersion)version {
	
	const NSOperatingSystemVersion systemVersion = [self operatingSystemVersion];
	if (systemVersion.majorVersion == version.majorVersion) {
		if (systemVersion.minorVersion == version.minorVersion) {
			return systemVersion.patchVersion <= version.patchVersion;
		}
		return systemVersion.minorVersion <= version.minorVersion;
	}
	return systemVersion.majorVersion <= version.majorVersion;
}

- (BOOL)SystemVersion_isMacAppStoreAvailable {
	const NSOperatingSystemVersion osVersion = [self operatingSystemVersion];
	
	return ((osVersion.minorVersion >= 7) ||
			(osVersion.minorVersion == 6 && osVersion.patchVersion >=  6));
}

#endif

@end
