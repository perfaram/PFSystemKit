//
//  PFSK_Common+Machine.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 17/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_Common+Machine.h"
#import <string>
#import "NSString+PFSKAdditions.h"
#if TARGET_OS_IPHONE
#import "PFSKPrivateTypes.h"
#import <UIKit/UIKit.h>
#import <objc/objc.h>
#import <objc/runtime.h>
#endif

@implementation PFSK_Common(Machine)
+(BOOL) deviceFamily:(PFSystemKitDeviceFamily*__nonnull)ret error:(NSError Ind2_NUAR)error
{
    NSString* str;
    BOOL result = [self deviceModel:&str error:error];
    if (result != true) {
        return false;
    }
    str = [str lowercaseString]; //transform to lowercase, meaning less code afterwards
#if !TARGET_OS_IPHONE
    if ([str containsString:@"mac"]) {
        if ([str isEqualToString:@"imac"])
            *ret = PFSKDeviceFamilyiMac;
        else if ([str containsString:@"air"])
            *ret = PFSKDeviceFamilyMacBookAir;
        else if ([str containsString:@"pro"] && [str containsString:@"book"])
            *ret = PFSKDeviceFamilyMacBookPro;
        else if ([str containsString:@"mini"])
            *ret = PFSKDeviceFamilyMacMini;
        else if ([str containsString:@"pro"])
            *ret = PFSKDeviceFamilyMacPro;
        else if ([str containsString:@"macbook"])
            *ret = PFSKDeviceFamilyMacBook;
    } else if ([str isEqualToString:@"xserve"])
        *ret = PFSKDeviceFamilyXserve;
#endif
#if TARGET_OS_IPHONE
    if ([str hasPrefix:@"i"]) { //don't care about imac, has been checked before
        if ([str isEqualToString:@"iphone"])
            *ret = PFSKDeviceFamilyiPhone;
        else if ([str isEqualToString:@"ipad"])
            *ret = PFSKDeviceFamilyiPad;
        else if ([str isEqualToString:@"ipod"])
            *ret = PFSKDeviceFamilyiPod;
    } else if ([str isEqualToString:@"simulator"]) {
        *ret = PFSKDeviceFamilySimulator;
    }
#endif
    *ret = PFSKDeviceFamilyUnknown;
    return true;
}

+(BOOL) deviceEndianness:(PFSystemKitEndianness*__nonnull)ret error:(NSError Ind2_NUAR)error
{
    double order = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.byteorder", order, error);
    if (!result) {
        *ret = PFSKEndiannessUnknown;
        return false;
    }
    // values for cputype and cpusubtype defined in mach/machine.h
    if (order == 1234) {
        *ret = PFSKEndiannessLittleEndian;
    } else if (order == 4321) {
        *ret = PFSKEndiannessBigEndian;
    } else {
        *ret = PFSKEndiannessUnknown;
    }
    return true;
}
#if !TARGET_OS_IPHONE
+(BOOL) deviceModel:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    BOOL result = sysctlNSStringForKeySynthesizing((char*)"hw.model", ret, error);
    if (!result) {
        *ret = @"-";
        return false;
    }
    return true;
}
#endif
#if TARGET_OS_IPHONE
+(BOOL) deviceModel:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    BOOL result = sysctlNSStringForKeySynthesizing((char*)"hw.machine", ret, error);
    if (!result) {
        *ret = @"-";
        return false;
    }
    return true;
}

+(BOOL) devicePlatform:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    BOOL result = sysctlNSStringForKeySynthesizing((char*)"hw.model", ret, error);
    if (!result) {
        *ret = @"-";
        return false;
    }
    return true;
}

+(BOOL) isJailbroken
{
#if !(TARGET_IPHONE_SIMULATOR)
    
    // Check whether some typical files exist
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
    
    // Check whether I can fopen these files
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
    f = fopen("/usr/sbin/sshd", "r");
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
    
    // Check for Cydia URLs
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]){
        return YES;
    }
    
    // Check if this process can fork, shouldn't happen if properly sandboxed
    int result = fork();
    if (result >= 0) {
        return YES;
    }
    
    // Check if I can write in /private, shouldn't if properly sandboxed
    NSError *locError;
    [[NSString stringWithFormat:@"pfskJailbroken"] writeToFile:@"/private/isjb.txt" atomically:YES encoding:NSUTF8StringEncoding error:&locError];
    if(!locError) {
        // Clean up
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/isjb.txt" error:nil];
        return YES;
    }
    
    // Best effort : check whether substrate is loaded
    const char **names;
    unsigned libNamesCount = 0;
    names = objc_copyImageNames(&libNamesCount);
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

#if asrg_get_out_of_my_way
+(BOOL) deviceColor:(PFSystemKitDeviceColor*__nonnull)ret error:(NSError Ind2_NUAR)error
{
    UIDevice *device = [UIDevice currentDevice];
    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector]) {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
    if ([device respondsToSelector:selector]) {
        NSString* enclosure = [[[device performSelector:selector withObject:@"DeviceEnclosureColor"] lowercaseString] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        const char* test = [enclosure getString].c_str();
        if (PFSystemKitDeviceColorHexesReverse.find(test) == PFSystemKitDeviceColorHexesReverse.end()) {
            NSString* global = [[device performSelector:selector withObject:@"DeviceColor"] lowercaseString];
            if ([global isEqualToString:@"black"]) {
                *ret = PFSKDeviceColorBlack;
                return true;
            } else if ([global isEqualToString:@"white"]) {
                *ret = PFSKDeviceColorWhite;
                return true;
            }
            *ret = PFSKDeviceColorUnknown;
            if (error)
                *error = synthesizeError(PFSKReturnUnsupportedDevice);
            return false;
        } else {
            *ret = PFSystemKitDeviceColorHexesReverse[test];
            return false;
        }
    } else {
        if (error)
            *error = synthesizeError(PFSKReturnInvalidSelector);
        return false;
    }
    return true;
}
#endif
#endif
+(BOOL) deviceVersion:(PFSystemKitDeviceVersion*__nonnull)ret error:(NSError Ind2_NUAR)error
{
	NSString* systemInfoString;
	BOOL result = [self deviceModel:&systemInfoString error:error];
	if (result != true) {
		return false;
	}
    if (error)
        *error = synthesizeError(PFSKReturnSuccess);
    NSUInteger positionOfFirstInteger = [systemInfoString rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location;
    NSUInteger positionOfComma = [systemInfoString rangeOfString:@","].location;
    
    NSUInteger major = 0;
    NSUInteger minor = 0;
    
    if (positionOfComma != NSNotFound) {
        major = [[systemInfoString substringWithRange:NSMakeRange(positionOfFirstInteger, positionOfComma - positionOfFirstInteger)] integerValue];
        minor = [[systemInfoString substringFromIndex:positionOfComma + 1] integerValue];
    }
    *ret = (PFSystemKitDeviceVersion){major, minor};
	return true;
}
@end
