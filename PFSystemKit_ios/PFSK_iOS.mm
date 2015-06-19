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
+(BOOL)isJailbroken{ //objc_copyImageNames() "can't" be fooled (checks for MobileSubstrate)
#if !(TARGET_IPHONE_SIMULATOR)
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]){
		return YES;
	}else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]){
		return YES;
	}else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"]){
		return YES;
	}else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"]){
		return YES;
	}else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"]){
		return YES;
	}
	
	FILE *f = fopen("/bin/bash", "r");
	if (f != NULL) {
		fclose(f);
		return YES;
	}
	fclose(f);
	f = fopen("/Applications/Cydia.app", "r");
	if (f != NULL) {
		fclose(f);
		return YES;
	}
	fclose(f);
	f = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r");
	if (f != NULL) {
		fclose(f);
		return YES;
	}
	fclose(f);
	f = fopen("/etc/apt", "r");
	if (f != NULL) {
		fclose(f);
		return YES;
	}
	fclose(f);
    
    int result = fork(); // Check if this process can fork, shouldn't happen if properly sandboxed
    if (result >= 0) {
        return YES;
    }
    
    const char **names;
    unsigned libNamesCount = 0;
    names = objc_copyImageNames(&libNamesCount); //best effort : check whether substrate is loaded
    for (unsigned libIdx = 0; libIdx < libNamesCount; ++libIdx) {
        NSString* name = @(names[libIdx]);
        if ([name isKindOfClass:NSClassFromString(@"NSString")]) {
            if ([name.lowercaseString containsString:@"substrate"]) return YES;
        }
    }
    free(names);
#endif
	//All checks have failed. Most probably, the device is not jailbroken
	return NO;
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
    if (IOresult!=kIOReturnSuccess) {
        _error = PFSKReturnNoMasterPort;
        _extError = IOresult;
        return nil;
    }
    return self;
}
@end
