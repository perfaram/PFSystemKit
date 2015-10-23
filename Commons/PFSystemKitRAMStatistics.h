//
//  PFSystemKitRAMStatistics.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 18.06.15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFSystemKitRAMStatistics : NSObject
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

-(instancetype) initWithWired:(NSNumber*)wiredLocal
                       active:(NSNumber*)activeLocal
                     inactive:(NSNumber*)inactiveLocal
                         free:(NSNumber*)freeLocal;
@end
