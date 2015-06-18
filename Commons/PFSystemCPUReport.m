//
//  PFSystemCPUReport.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 10/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSystemCPUReport.h"

@implementation PFSystemCPUReport
@synthesize count;
@synthesize brand;
@synthesize coreCount;
@synthesize threadCount;
@synthesize frequency;
@synthesize L2Cache;
@synthesize L3Cache;
@synthesize architecture;
@synthesize vendor;

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
@end
