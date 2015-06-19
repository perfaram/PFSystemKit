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
+(BOOL) cpuCreateReport:(PFSystemCPUReport**)ret error:(NSError**)error __attribute__((nonnull (1)));
+(BOOL) cpuCount:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1)));
+(BOOL) cpuBrand:(NSString**)ret error:(NSError**)error __attribute__((nonnull (1)));
+(BOOL) cpuCoreCount:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1)));
+(BOOL) cpuThreadCount:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1)));
+(BOOL) cpuFrequency:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1)));
+(BOOL) cpuL2Cache:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1)));
+(BOOL) cpuL3Cache:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1)));
+(BOOL) cpuArchitecture:(PFSystemKitCPUArches*)ret error:(NSError**)error __attribute__((nonnull (1)));
+(BOOL) cpuVendor:(NSString**)ret error:(NSError**)error __attribute__((nonnull (1)));
@end
