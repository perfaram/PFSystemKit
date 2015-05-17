//
//  PFSK_iOS.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFSKProtocol.h"
#import "PFSKTypes.h"

@interface PFSystemKit : NSObject <PFSystemKitProtocol>
+(PFSystemKitError) memSize:(NSNumber**)ret;
@end
