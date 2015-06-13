//
//  PFSystemCPUReport.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 10/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSystemCPUReport.h"

@implementation PFSystemCPUReport
@synthesize cpuCount;
@synthesize cpuBrand;
@synthesize cpuCoreCount;
@synthesize cpuThreadCount;
@synthesize cpuFrequency;
@synthesize cpuL2Cache;
@synthesize cpuL3Cache;
@synthesize cpuArchitecture;
@synthesize cpuVendor;

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
	cpuCount = countLocal;
	cpuBrand = brandLocal;
	cpuCoreCount = coreCountLocal;
	cpuThreadCount = threadNumberLocal;
	cpuFrequency = frequencyLocal;
	cpuL2Cache = l2Local;
	cpuL3Cache = l3Local;
	cpuArchitecture = architectureLocal;
	cpuVendor = vendorLocal;
	return self;
}
@end
