//
//  PFSystemCPUReport.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 10/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSKTypes.h"

@interface PFSystemCPUReport : NSObject
@property (readonly)  NSNumber* cpuCount;
@property (readonly)  NSString* cpuBrand;
@property (readonly)  NSNumber* cpuCoreCount;
@property (readonly)  NSNumber* cpuThreadCount;
@property (readonly)  NSNumber* cpuFrequency;
@property (readonly)  NSNumber* cpuL2Cache;
@property (readonly)  NSNumber* cpuL3Cache;
@property (readonly)  PFSystemKitCPUArches cpuArchitecture;
@property (readonly)  NSString* cpuVendor;

-(instancetype) initWithCount:(NSNumber*)countLocal
						brand:(NSString*)brandLocal
					coreCount:(NSNumber*)coreCountLocal
				  threadCount:(NSNumber*)threadNumberLocal
					frequency:(NSNumber*)frequencyLocal
						   l2:(NSNumber*)l2Local
						   l3:(NSNumber*)l3Local
				 architecture:(PFSystemKitCPUArches)architectureLocal
					   vendor:(NSString*)vendorLocal;
@end
