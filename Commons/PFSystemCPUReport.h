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
@property (readonly)  NSNumber* count;
@property (readonly)  NSString* brand;
@property (readonly)  NSNumber* coreCount;
@property (readonly)  NSNumber* threadCount;
@property (readonly)  NSNumber* frequency;
@property (readonly)  NSNumber* L2Cache;
@property (readonly)  NSNumber* L3Cache;
@property (readonly)  PFSystemKitCPUArches architecture;
@property (readonly)  NSString* vendor;

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
