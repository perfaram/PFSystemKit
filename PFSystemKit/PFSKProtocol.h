//
//  PFSKProtocol.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#ifndef PFSystemKit_PFSKProtocol_h
#define PFSystemKit_PFSKProtocol_h
#import "PFSKTypes.h"

@class PFSystemKit;
@protocol PFSystemKitProtocol
@required

-(PFSystemKit*)investigate;
-(PFSystemKitPlatform)platform;
-(NSString*)platformString;
-(PFSystemKitFamily)family;
-(NSString*)familyString;
-(PFSKDeviceVersion)version;
-(NSString*)versionString;
-(NSString*)model;
@end

#endif
