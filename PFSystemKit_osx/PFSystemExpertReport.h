//
//  PFSystemExpertReport.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFSystemExpertReport : NSObject
/*!
 The mainboard identifier
 */
@property (strong, atomic, readonly) NSString*							boardID;

/*!
 The platform identifier
 */
@property (strong, atomic, readonly) NSString*							hardwareUUID;

/*!
 The ROM firmware version
 */
@property (strong, atomic, readonly) NSString*							romVersion;

/*!
 The ROM firmware release date
 */
@property (strong, atomic, readonly) NSString*							romReleaseDate;
@end
