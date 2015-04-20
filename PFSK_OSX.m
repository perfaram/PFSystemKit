//
//  PFSK_OSX.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_OSX.h"

io_connect_t conn;
static mach_port_t   		masterPort;
static io_registry_entry_t 	nvrEntry;
static io_registry_entry_t 	pexEntry;
static io_registry_entry_t 	smcEntry;
static io_registry_entry_t 	romEntry;
// Shared Instance (Singleton)
static PFSystemKit *sharedInstance = nil;

@implementation PFSystemKit
/**
 * sharedWrapper - Singleton instance retrieval method.
 */
+(PFSystemKit *) investigate{
	if (sharedInstance == nil ){
		sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}
@end
