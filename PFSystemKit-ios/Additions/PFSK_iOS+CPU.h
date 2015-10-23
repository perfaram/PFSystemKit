//
//  PFSK_iOS+CPU.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 31/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_iOS.h"
@class PFSystemKitCPUReport;

@interface PFSystemKit(CPU)
+(BOOL) cpuCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuCoreCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuHasFeature:(PFSystemKitCPUARMFeatures)feature toNumber:(BOOL*__nonnull)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuL1ICache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuL1DCache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuL1Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuL2Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuArchitecture:(PFSystemKitCPUArches*__nonnull)ret subtype:(PFSystemKitCPUArchesARMTypes*__nonnull)sub error:(NSError Ind2_NUAR)error;
+(BOOL) cpuCreateReport:(PFSystemKitCPUReport Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
@end
