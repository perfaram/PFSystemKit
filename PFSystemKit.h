//
//  PFSystemKit-osx.h
//  PFSystemKit-osx
//
//  Created by Perceval FARAMAZ on 19.06.15.
//
//

#import <Foundation/Foundation.h>
#import "PFSK_Common.h"
#import "PFSystemKitCPUReport.h"
#import "PFSystemKitBatteryReport.h"
#import "PFSystemKitPlatformReport.h"
#import "PFSystemKitRAMReport.h"

/* iOS imports */
#if TARGET_OS_IPHONE
//! Project version number for PFSystemKit-ios.
FOUNDATION_EXPORT double PFSystemKit_iosVersionNumber;
//! Project version string for PFSystemKit-ios.
FOUNDATION_EXPORT const unsigned char PFSystemKit_iosVersionString[];
#import "PFSK_iOS.h"
#endif


/* OS X imports */
#if !TARGET_OS_IPHONE
//! Project version number for PFSystemKit-osx.
FOUNDATION_EXPORT double PFSystemKit_osxVersionNumber;
//! Project version string for PFSystemKit-osx.
FOUNDATION_EXPORT const unsigned char PFSystemKit_osxVersionString[];
#import "PFSK_OSX.h"
#endif