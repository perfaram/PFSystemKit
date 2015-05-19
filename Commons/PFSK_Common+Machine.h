//
//  PFSK_Common+Machine.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 17/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
/* iOS imports */
#if TARGET_OS_IPHONE
#import "PFSK_iOS.h"
#endif
/* OS X imports */
#if !TARGET_OS_IPHONE
#import "PFSK_OSX.h"
#endif

@interface PFSystemKit(Machine)
+(PFSystemKitError) systemEndianness:(PFSystemKitEndianness*)ret __attribute__((nonnull (1)));
+(PFSystemKitError) machineModel:(NSString**)ret __attribute__((nonnull (1)));
@end
