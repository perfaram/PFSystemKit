//
//  PFSK_Common.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSKProtocol.h"
#import "PFSystemKit/PFSKTypes.h"

@interface PFSK_Common : NSObject

NSString* errorToString(PFSystemKitError);

NSString* iokitErrorToString(kern_return_t);

NSString* platformToString(PFSystemKitPlatform);

PFSystemKitPlatform stringToPlatform(NSString*);

NSString* familyToString(PFSystemKitFamily);

PFSystemKitFamily stringToFamily(NSString* str);

@end
