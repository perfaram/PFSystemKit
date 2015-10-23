//
//  PFSK_OSX+RAM.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 11/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_OSX.h"
@class PFSystemKitRAMStatistics;

@interface PFSystemKit(RAM)
+(BOOL) ramSize:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) ramStatistics:(PFSystemKitRAMStatistics Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
@end