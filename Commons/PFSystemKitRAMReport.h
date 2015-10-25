//
//  PFSystemKitRAMStatistics.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 18.06.15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_Common.h"

@interface PFSystemKitRAMReport : NSObject
/*!
 The amount of wired RAM
 */
@property (strong, atomic, readonly) NSNumber*							wired;

/*!
 The amount of active RAM
 */
@property (strong, atomic, readonly) NSNumber*							active;

/*!
 The amount of inactive RAM
 */
@property (strong, atomic, readonly) NSNumber*							inactive;

/*!
 The amount of free RAM
 */
@property (strong, atomic, readonly) NSNumber*							free;

/*!
 All of the previous RAM stats
 */
@property (assign, atomic, readonly) PFSystemKitRAMStatistics           stats;

/*!
 The total amount of RAM
 */
@property (strong, atomic, readonly) NSNumber*							total;

+(BOOL) size:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error;
+(BOOL) statistics:(PFSystemKitRAMStatistics *__nonnull)ret error:(NSError Ind2_NUAR)error;

-(instancetype) initWithError:(NSError Ind2_NUAR)error;

@end
