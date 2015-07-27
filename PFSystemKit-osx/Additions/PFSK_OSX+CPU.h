//
//  PFSK_OSX(CPU).h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_OSX.h"

@interface PFSystemKit(CPU)
+(BOOL) cpuCreateReport:(PFSystemCPUReport Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuBrand:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuCoreCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuThreadCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuFrequency:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuL2Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuL3Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuArchitecture:(PFSystemKitCPUArches*__nonnull)ret error:(NSError Ind2_NUAR)error;
+(BOOL) cpuVendor:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
@end
