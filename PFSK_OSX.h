//
//  PFSK_OSX.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSKProtocol.h"
#import "PFSystemKit/PFSKTypes.h"
#import "PFSK_Common.h"
#import "PFSKHelper.h"



@interface PFSystemKit : PFSK_Common <PFSystemKitProtocol>
+(PFSystemKit*) investigate;
-(PFSystemKit*) init;
-(void) dealloc;
-(void) finalize;
-(BOOL) refreshGroup:(PFSystemKitGroup)group; 					//overrides any non-commited modification
-(BOOL) refresh;												//overrides any non-commited modification
#if WRITE_ABILITY
-(BOOL) commitGroup:(PFSystemKitGroup)group;					//commits any change made in the specified group
-(BOOL) commit;
#endif
@end
