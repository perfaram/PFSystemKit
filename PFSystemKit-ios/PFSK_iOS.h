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
#import "PFSystemKitRAMReport.h"

@class PFSystemKitPlatformReport;

@interface PFSystemKit : PFSK_Common {
@private
    PFSystemKitCPUReport*           cpuReport;
    PFSystemKitRAMReport*           ramReport;
    PFSystemKitPlatformReport*      platformReport;
}
/*!
 Various platform informations
 */
@property (strong, atomic, readonly) PFSystemKitPlatformReport*			platformReport;

/*!
 Various CPU informations
 */
-(PFSystemKitCPUReport*) cpuReport;
-(BOOL) cpuReport:(NSError Ind2_NUAR)err;

/*!
 RAM stats and size
 */
-(PFSystemKitRAMReport*) ramReport;
-(BOOL) ramReport:(NSError Ind2_NUAR)err;

/*!
 Various platform informations (serial, UUID, model, etc...)
 */
-(PFSystemKitPlatformReport*) platformReport;
-(BOOL) platformReport:(NSError Ind2_NUAR)err;
@end
