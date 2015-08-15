//
//  PFSK_Common+Machine.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 17/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_Common.h"
@interface PFSK_Common(Machine)
+(BOOL) deviceFamily:(PFSystemKitDeviceFamily*__nonnull)ret error:(NSError Ind2_NUAR)error;
+(BOOL) deviceEndianness:(PFSystemKitEndianness*__nonnull)ret error:(NSError Ind2_NUAR)error;
+(BOOL) deviceModel:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
#if TARGET_OS_IPHONE
#if asrg_get_out_of_my_way
+(BOOL) deviceColor:(PFSystemKitDeviceColor*__nonnull)ret error:(NSError Ind2_NUAR)error;
#endif
+(BOOL) isJailbroken:(BOOL*__nonnull)ret error:(NSError Ind2_NUAR)error;
#endif
+(BOOL) deviceVersion:(PFSystemKitDeviceVersion*__nonnull)ret error:(NSError Ind2_NUAR)error;
@end
