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
+(BOOL) deviceFamily:(PFSystemKitDeviceFamily*)ret error:(NSError**)error __attribute__((nonnull (1,2)));
+(BOOL) deviceEndianness:(PFSystemKitEndianness*)ret error:(NSError**)error __attribute__((nonnull (1,2)));
+(BOOL) deviceModel:(NSString**)ret error:(NSError**)error __attribute__((nonnull (1,2)));
+(BOOL) deviceVersion:(PFSystemKitDeviceVersion*)ret error:(NSError**)error __attribute__((nonnull (1,2)));
@end
