//
//  PFSystemKitCPUReport.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 10/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSystemKitCPUReport.h"

@implementation PFSystemKitCPUReport
@synthesize brand;
@synthesize vendor;
@synthesize count;
@synthesize coreCount;
#if !TARGET_OS_IPHONE
@synthesize threadCount;
@synthesize frequency;
#endif
#if TARGET_OS_IPHONE
@synthesize L1ICache;
@synthesize L1DCache;
#endif
@synthesize L2Cache;
#if !TARGET_OS_IPHONE
@synthesize L3Cache;
#endif
@synthesize architecture;
#if TARGET_OS_IPHONE
@synthesize subType;
#endif
#if !TARGET_OS_IPHONE
-(instancetype) initWithCount:(NSNumber*)countLocal
						brand:(NSString*)brandLocal
					coreCount:(NSNumber*)coreCountLocal
				  threadCount:(NSNumber*)threadNumberLocal
					frequency:(NSNumber*)frequencyLocal
						   l2:(NSNumber*)l2Local
						   l3:(NSNumber*)l3Local
				 architecture:(PFSystemKitCPUArches)architectureLocal
					   vendor:(NSString*)vendorLocal

{
	if (!(self = [super init])) {
		return nil;
	}
	count = countLocal;
	brand = brandLocal;
	coreCount = coreCountLocal;
	threadCount = threadNumberLocal;
	frequency = frequencyLocal;
	L2Cache = l2Local;
	L3Cache = l3Local;
	architecture = architectureLocal;
	vendor = vendorLocal;
	return self;
}
#endif
#if TARGET_OS_IPHONE
-(instancetype) initWithCount:(NSNumber*)countLocal
                    coreCount:(NSNumber*)coreCountLocal
                          l1D:(NSNumber*)l1DLocal
                          l1I:(NSNumber*)l1ILocal
                           l2:(NSNumber*)l2Local
                 architecture:(PFSystemKitCPUArches)architectureLocal
                      subType:(PFSystemKitCPUArchesARMTypes)subTypeLocal
{
    if (!(self = [super init])) {
        return nil;
    }
    count = countLocal;
    coreCount = coreCountLocal;
    L2Cache = l2Local;
    L1DCache = l1DLocal;
    L1ICache = l1ILocal;
    architecture = architectureLocal;
    subType = subTypeLocal;
    return self;
}
#endif
@end
