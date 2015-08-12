//
//  PFSK_iOS+RAM.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 12.08.15.
//
//

#import <Foundation/Foundation.h>
#import "PFSK_iOS.h"

@interface PFSystemKit(RAM)
+(BOOL) ramSize:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) ramStatistics:(PFSystemRAMStatistics Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
@end
