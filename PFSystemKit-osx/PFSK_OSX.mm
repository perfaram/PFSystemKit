//
//  PFSK_OSX.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <sys/sysctl.h>
#import <CoreFoundation/CoreFoundation.h>
#import <string>
#import <vector>
#import "PFSKHelper.h"
#import "PFSK_OSX.h"
#import "PFSystemKitPlatformReport.h"
#import "PFSystemKitBatteryReport.h"
#import "PFSystemKitCPUReport.h"

@implementation PFSystemKit
#pragma mark - Singleton pattern
/**
 * PFSystemKit singleton instance retrieval method
 */
+(instancetype) investigate {
	static PFSystemKit* sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

-(BOOL) ramReport:(NSError Ind2_NUAR)err {
    if (ramReport == nil) {
        ramReport = [PFSystemKitRAMReport.alloc initWithError:err];
        if (ramReport)
            return true;
        else
            return false;
    } else
        return true;
}

-(PFSystemKitRAMReport*) ramReport {
    if (ramReport == nil) {
        ramReport = [PFSystemKitRAMReport.alloc initWithError:nil];
        return ramReport;
    } else
        return ramReport;
}

-(BOOL) cpuReport:(NSError Ind2_NUAR)err {
    if (cpuReport == nil) {
        cpuReport = [PFSystemKitCPUReport.alloc initWithError:err];
        if (cpuReport)
            return true;
        else
            return false;
    } else
        return true;
}

-(PFSystemKitCPUReport*) cpuReport {
    if (cpuReport == nil) {
        cpuReport = [PFSystemKitCPUReport.alloc initWithError:nil];
        return cpuReport;
    } else
        return cpuReport;
}

-(BOOL) platformReport:(NSError Ind2_NUAR)err {
    if (platformReport == nil) {
        platformReport = [PFSystemKitPlatformReport.alloc initWithMasterPort:masterPort error:err];
        if (platformReport)
            return true;
        else
            return false;
    } else
        return true;
}

-(PFSystemKitPlatformReport*) platformReport {
    if (platformReport == nil) {
        platformReport = [PFSystemKitPlatformReport.alloc initWithMasterPort:masterPort error:nil];
        return platformReport;
    } else
        return platformReport;
}

-(BOOL) batteryReport:(NSError Ind2_NUAR)err {
    if (batteryReport == nil) {
        batteryReport = [PFSystemKitBatteryReport.alloc initWithMasterPort:masterPort error:err];
        if (batteryReport)
            return true;
        else
            return false;
    } else
        return true;
}

-(PFSystemKitBatteryReport*) batteryReport {
    if (batteryReport == nil) {
        batteryReport = [PFSystemKitBatteryReport.alloc initWithMasterPort:masterPort error:nil];
        return batteryReport;
    } else
        return batteryReport;
}

#pragma mark - NSObject std methods
-(instancetype) init {
	if (!(self = [super init])) {
		return nil;
	}
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
	return self;
}
@end
