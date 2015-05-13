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
+(PFSystemKitError) cpuCount:(NSNumber**)ret __attribute__((nonnull (1)));
+(PFSystemKitError) cpuBrand:(NSString**)ret __attribute__((nonnull (1)));
+(PFSystemKitError) cpuCoreCount:(NSNumber**)ret __attribute__((nonnull (1)));
+(PFSystemKitError) cpuThreadCount:(NSNumber**)ret __attribute__((nonnull (1)));
+(PFSystemKitError) cpuFrequency:(NSNumber**)ret __attribute__((nonnull (1)));
+(PFSystemKitError) cpuL2Cache:(NSNumber**)ret __attribute__((nonnull (1)));
+(PFSystemKitError) cpuL3Cache:(NSNumber**)ret __attribute__((nonnull (1)));
+(PFSystemKitError) cpuArchitecture:(PFSystemKitCPUArches*)ret __attribute__((nonnull (1)));
//+(PFSystemKitError) cpuVendor:(PFSystemKitCPUVendors*)ret __attribute__((nonnull (1)));
+(PFSystemKitError) cpuVendor:(NSString**)ret __attribute__((nonnull (1)));

-(NSNumber*) cpuCount;
-(NSString*) cpuBrand;
-(NSNumber*) cpuCoreCount;
-(NSNumber*) cpuThreadCount;
-(NSNumber*) cpuFrequency;
-(NSNumber*) cpuL2Cache;
-(NSNumber*) cpuL3Cache;
-(PFSystemKitCPUArches) cpuArchitecture;
-(NSString*) cpuVendor;
@end
