//
//  PFSK_iOS.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_Common.h"
#import "PFSystemKitCPUReport.h"

@class PFSystemKitPlatformReport;

@interface PFSystemKit : PFSK_Common
/*!
 Various platform informations
 */
@property (strong, atomic, readonly) PFSystemKitPlatformReport*			platformReport;

/*!
 Various CPU informations
 */
-(PFSystemKitCPUReport*) cpuReport;
+(Class) cpu;
@end
