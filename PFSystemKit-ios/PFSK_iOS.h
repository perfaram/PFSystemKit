//
//  PFSK_iOS.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_Common.h"

@interface PFSystemKit : NSObject
/*!
 Various platform informations
 */
@property (strong, atomic, readonly) PFSystemPlatformReport*			platformReport;

/*!
 Various CPU informations
 */
@property (strong, atomic, readonly) PFSystemCPUReport*					cpuReport;

/*!
 Various battery informations
 */
@property (strong, atomic, readonly) PFSystemBatteryReport*				batteryReport;
@end

#import "PFSK_iOS+CPU.h"