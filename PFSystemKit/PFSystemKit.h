//
//  PFSystemKit.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PFSystemKit/PFSKTypes.h>
#import <PFSystemKit/PFSKProtocol.h>

/* iOS imports */
#if TARGET_OS_IPHONE

//! Project version number for PFSystemInfoKit_ios.
FOUNDATION_EXPORT double PFSystemInfoKit_iosVersionNumber;
//! Project version string for PFSystemInfoKit_ios.
FOUNDATION_EXPORT const unsigned char PFSystemInfoKit_iosVersionString[];
#import "PFSK_iOS.h"

#endif


/* OS X imports */
#if !TARGET_OS_IPHONE

//! Project version number for PFSystemKit.
FOUNDATION_EXPORT double PFSystemKitVersionNumber;
//! Project version string for PFSystemKit.
FOUNDATION_EXPORT const unsigned char PFSystemKitVersionString[];
#import "PFSK_OSX.h"

#endif

// In this header, you should import all the public headers of your framework using statements like #import <PFSystemKit/PublicHeader.h>


/*
 simulator policy (#if (TARGET_IPHONE_SIMULATOR && SIMULATOR_SHORTCUTS))
 target #
 */