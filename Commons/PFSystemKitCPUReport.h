//
//  PFSK_OSX(CPU).h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_Common.h"


@interface PFSystemKitCPUReport : NSObject
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

-(instancetype) initWithError:(NSError Ind2_NUAR)error;

+(BOOL) count:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) coreCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) L2Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;

#if !TARGET_OS_IPHONE
+(BOOL) vendor:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) brand:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) threadCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) frequency:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) L3Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) architecture:(PFSystemKitCPUArches*__nonnull)ret error:(NSError Ind2_NUAR)error;
#else
+(BOOL) hasFeature:(PFSystemKitCPUARMFeatures)feature toNumber:(BOOL*__nonnull)ret error:(NSError Ind2_NUAR)error;
+(BOOL) L1ICache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) L1DCache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) L1Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) architecture:(PFSystemKitCPUArches*__nonnull)ret subtype:(PFSystemKitCPUArchesARMTypes*__nonnull)sub error:(NSError Ind2_NUAR)error;
#endif
@end
