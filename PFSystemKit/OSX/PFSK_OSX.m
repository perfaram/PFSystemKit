//
//  PFSK_OSX.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_OSX.h"
#import <sys/sysctl.h>

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
 * PFSystemKit singleton instance retrieval method
 */
+(PFSystemKit *) investigate{
	if (sharedInstance == nil ){
		sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}

-(PFSystemKitDeviceFamily)family {
	return self.family;
}

-(NSString*)familyString {
	return self.familyString;
}

-(PFSystemKitDeviceVersion)version {
	return self.version;
}

-(NSString*)versionString {
	return self.versionString;
}

-(NSString*)model {
	return self.model;
}

+(NSString *) machineModel
{
	size_t len = 0;
	sysctlbyname("hw.model", NULL, &len, NULL, 0);
	
	if (len)
	{
		char *model = malloc(len*sizeof(char));
		sysctlbyname("hw.model", model, &len, NULL, 0);
		NSString *model_ns = [NSString stringWithUTF8String:model];
		free(model);
		return model_ns;
	}
	
	return @"-"; //in case model name can't be read
}


/*
-(PFSystemKitDeviceVersion)version;
-(NSString*)versionString;
-(NSString*)model;*/

-(void) finalize { //cleanup everything
	IOObjectRelease(nvrEntry);
	IOObjectRelease(pexEntry);
	IOObjectRelease(smcEntry);
	IOObjectRelease(romEntry);
	[super finalize];
	return;
}

-(void) dealloc {
	//[super dealloc];
}

-(id) init {
	self = [super init];
	if (self) {
		_writeLockState = PFSKLockStateLocked;
		_error = PFSKReturnUnknown;
		_extError = 0;
		
		kern_return_t IOresult;
		IOresult = IOMasterPort(bootstrap_port, &masterPort);
		if (IOresult!=kIOReturnSuccess) {
			_error = PFSKReturnNoMasterPort;
			_extError = IOresult;
			return nil;
		}
		
		BOOL REFresult = [self refresh];
		if (REFresult!=true) {
			//error/extError already setted
			return nil;
		}
	}
	return self;
}
@end
