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
+(BOOL) memorySize:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1,2)));
+(BOOL) memoryStats:(NSDictionary**)ret error:(NSError**)error __attribute__((nonnull (1,2)));
@end
