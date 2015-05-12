//
//  PFSK_OSX+RAM.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 11/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_OSX.h"

@interface PFSystemKit(RAM)
+(PFSystemKitError) memorySize:(NSNumber**)ret;
+(PFSystemKitError) memoryStats:(NSDictionary**)ret __attribute__((nonnull (1)));
@end
