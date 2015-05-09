//
//  PFSK_OSX.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSK_Common.h"
#import "PFSKHelper.h"

@interface PFSystemKit : PFSK_Common <PFSystemKitProtocol>
+(PFSystemKit*) investigate;
-(PFSystemKit*) init NS_DESIGNATED_INITIALIZER;
-(void) dealloc;
-(void) finalize;
-(BOOL) refreshGroup:(PFSystemKitGroup)group; 					//overrides any non-commited modification
-(BOOL) refresh;												//overrides any non-commited modification
#if WRITE_ABILITY
-(BOOL) commitGroup:(PFSystemKitGroup)group;					//commits any change made in the specified group
-(BOOL) commit;
#endif

#if defined(__OBJC__) && defined(__cplusplus) //we're working with Objective-C++

#endif
+(PFSystemKitError) systemEndianness:(PFSystemKitEndianness*)ret __attribute__((nonnull (1)));
+(PFSystemKitError) cpuL3Cache:(NSNumber**)ret __attribute__((nonnull (1)));
+(PFSystemKitError) machineModel:(NSString**)ret __attribute__((nonnull (1)));
+(PFSystemKitError) memorySize:(NSNumber**)ret;
@end
