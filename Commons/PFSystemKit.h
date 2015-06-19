//
//  PFSystemKit.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Foundation/Foundation.h>

/* iOS imports */
#if TARGET_OS_IPHONE
//! Project version number for PFSystemKit_ios.
FOUNDATION_EXPORT double PFSystemKit_iosVersionNumber;
//! Project version string for PFSystemKit_ios.
FOUNDATION_EXPORT const unsigned char PFSystemKit_iosVersionString[];
#import "PFSK_iOS.h"
#endif


/* OS X imports */
#if !TARGET_OS_IPHONE
//! Project version number for PFSystemKit_osx
FOUNDATION_EXPORT double PFSystemKitVersionNumber;
//! Project version string for PFSystemKit_osx
FOUNDATION_EXPORT const unsigned char PFSystemKitVersionString[];
#import "PFSK_OSX.h"
#endif

/*
 simulator policy (#if (TARGET_IPHONE_SIMULATOR && SIMULATOR_SHORTCUTS))
 target #
 too fucking fragile : for a simple sysctl call failing (not supported key, anything) the whole Kit may lock (because of main instance methods being callable only once)
 */