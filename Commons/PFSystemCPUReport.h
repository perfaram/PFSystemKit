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
@property (readonly)  NSString* brand;
@property (readonly)  NSString* vendor;
@property (readonly)  NSNumber* count;
@property (readonly)  NSNumber* coreCount;
#if !TARGET_OS_IPHONE
@property (readonly)  NSNumber* threadCount;
@property (readonly)  NSNumber* frequency;
#endif
#if TARGET_OS_IPHONE
@property (readonly)  NSNumber* L1ICache;
@property (readonly)  NSNumber* L1DCache;
#endif
@property (readonly)  NSNumber* L2Cache;
#if !TARGET_OS_IPHONE
@property (readonly)  NSNumber* L3Cache;
#endif
@property (readonly)  PFSystemKitCPUArches architecture;
#if TARGET_OS_IPHONE
@property (readonly)  PFSystemKitCPUArchesARMTypes subType;
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
					   vendor:(NSString*)vendorLocal;
#endif
#if TARGET_OS_IPHONE
-(instancetype) initWithCount:(NSNumber*)countLocal
                    coreCount:(NSNumber*)coreCountLocal
                          l1D:(NSNumber*)l1DLocal
                          l1I:(NSNumber*)l1ILocal
                           l2:(NSNumber*)l2Local
                 architecture:(PFSystemKitCPUArches)architectureLocal
                      subType:(PFSystemKitCPUArchesARMTypes)subTypeLocal;
#endif
@end
