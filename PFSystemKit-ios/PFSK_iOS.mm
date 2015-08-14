//
//  PFSK_iOS.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import "PFSK_iOS.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import <sys/sysctl.h>
#import <CoreFoundation/CoreFoundation.h>
#import <string>
#import <vector>
#import "PFSKHelper.h"

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
        [sharedInstance updatePlatformReport];
        [sharedInstance updateCPUReport];
        [sharedInstance updateBatteryReport];
    });
    return sharedInstance;
}

#pragma mark - Getters
@synthesize cpuReport;
@synthesize batteryReport;
@synthesize platformReport;

#pragma mark - NSObject std methods
-(void) finalize { //cleanup everything
    IOObjectRelease(nvrEntry);
    IOObjectRelease(pexEntry);
    IOObjectRelease(smcEntry);
    IOObjectRelease(romEntry);
    [super finalize];
    return;
}

-(instancetype) init {
    if (!(self = [super init])) {
        return nil;
    }
    _writeLockState = PFSKLockStateLocked;
    _error = PFSKReturnUnknown;
    _extError = 0;
    kern_return_t IOresult;
    IOresult = IOMasterPort(bootstrap_port, &masterPort);
    if (IOresult!=PFSKReturnSuccess) {
        _error = PFSKReturnNoMasterPort;
        _extError = IOresult;
        return nil;
    }
    return self;
}
@end
