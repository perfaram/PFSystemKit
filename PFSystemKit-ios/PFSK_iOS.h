//
//  PFSK_iOS.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_Common.h"
@class PFSystemKitPlatformReport;
@class PFSystemKitCPUReport;

@interface PFSystemKit : PFSK_Common
/*!
 Various platform informations
 */
@property (strong, atomic, readonly) PFSystemKitPlatformReport*			platformReport;

/*!
 Various CPU informations
 */
@property (strong, atomic, readonly) PFSystemKitCPUReport*              cpuReport;
@end

#import "PFSK_iOS+CPU.h"
#import "PFSK_iOS+RAM.h"