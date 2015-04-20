//
//  PFSKProtocol.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#ifndef PFSystemKit_PFSKProtocol_h
#define PFSystemKit_PFSKProtocol_h
#import "PFSystemKit/PFSKTypes.h"

@class PFSystemKit;
@protocol PFSystemKitProtocol
@required
@property (assign, readonly, atomic) 		PFSystemKitError 		error;		//stringify using stringifyError:
@property (assign, readonly, atomic) 		kern_return_t 			extError; 	//stringify using stringifyError:
@property (assign, readonly, atomic)		BOOL					writeLockState;

-(PFSystemKit*)investigate;
-(PFSystemKitPlatform)platform;
-(NSString*)platformString;
-(PFSystemKitFamily)family;
-(NSString*)familyString;
-(NSString*)model;
@end

#endif
