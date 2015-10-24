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
//#import "PFSKPrivateTypes.h"
#import <UIKit/UIKit.h>
#import <objc/objc.h>
#undef _error
#import <objc/runtime.h>
#define _error self->errorCode
#endif

@implementation PFSK_Common(Machine)
+(BOOL) deviceFamily:(PFSystemKitDeviceFamily*__nonnull)ret error:(NSError Ind2_NUAR)error
{
    NSString* str;
    BOOL result = [self deviceModel:&str error:error];
    if (result != true) {
        *ret = PFSKDeviceFamilyUnknown;
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
    BOOL result = sysctlDoubleForKey((char*)"hw.byteorder", order, error);
    if (!result) {
#if ERRORS_USE_COMMON_SENSE
        *ret = PFSKEndiannessLittleEndian;  //sooo likely
#else
        *ret = PFSKEndiannessUnknown;
#endif
        return false;
    }
    // values for cputype and cpusubtype defined in mach/machine.h
    if (order == 1234) {
        *ret = PFSKEndiannessLittleEndian;
    } else if (order == 4321) {
        *ret = PFSKEndiannessBigEndian;
    } else {
#if ERRORS_USE_COMMON_SENSE
        *ret = PFSKEndiannessLittleEndian;  //sooo likely
#else
        *ret = PFSKEndiannessUnknown;
#endif
    }
    return true;
}
#if !TARGET_OS_IPHONE
+(BOOL) deviceModel:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    BOOL result = sysctlNSStringForKey((char*)"hw.model", ret, error);
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
    BOOL result = sysctlNSStringForKey((char*)"hw.machine", ret, error);
    if (!result) {
        *ret = @"-";
        return false;
    }
    return true;
}

+(BOOL) devicePlatform:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    BOOL result = sysctlNSStringForKey((char*)"hw.model", ret, error);
    if (!result) {
        *ret = @"-";
        return false;
    }
    return true;
}

+(BOOL) isJailbroken:(BOOL*__nonnull)ret error:(NSError Ind2_NUAR)error
{
#if !(TARGET_IPHONE_SIMULATOR)
    
    // Check whether some typical files exist
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]){
        *ret = YES;
        return true;
    }else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]){
        *ret = YES;
        return true;
    }else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"]){
        *ret = YES;
        return true;
    }else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"]){
        *ret = YES;
        return true;
    }else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"]){
        *ret = YES;
        return true;
    }
    
    // Check whether I can fopen these files
    FILE *f = fopen("/bin/bash", "r");
    if (f != NULL) {
        fclose(f);
        *ret = YES;
        return true;
    }
    fclose(f);
    f = fopen("/Applications/Cydia.app", "r");
    if (f != NULL) {
        fclose(f);
        *ret = YES;
        return true;
    }
    fclose(f);
    f = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r");
    if (f != NULL) {
        fclose(f);
        *ret = YES;
        return true;
    }
    fclose(f);
    f = fopen("/usr/sbin/sshd", "r");
    if (f != NULL) {
        fclose(f);
        *ret = YES;
        return true;
    }
    fclose(f);
    f = fopen("/etc/apt", "r");
    if (f != NULL) {
        fclose(f);
        *ret = YES;
        return true;
    }
    fclose(f);
    
    // Check for Cydia URLs
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]){
        *ret = YES;
        return true;
    }
    
    // Check if this process can fork, shouldn't happen if properly sandboxed
    int result = fork();
    if (result >= 0) {
        *ret = YES;
        return true;
    }
    
    // Check if I can write in /private, shouldn't if properly sandboxed
    NSError *locError;
    [[NSString stringWithFormat:@"pfskJailbroken"] writeToFile:@"/private/isjb.txt" atomically:YES encoding:NSUTF8StringEncoding error:&locError];
    if(!locError) {
        // Clean up
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/isjb.txt" error:error];
        if (error)
            return false;
        *ret = YES;
        return true;
    }
    
    // Best effort : check whether substrate is loaded
    const char **names;
    unsigned libNamesCount = 0;
    names = objc_copyImageNames(&libNamesCount);
    for (unsigned libIdx = 0; libIdx < libNamesCount; ++libIdx) {
        NSString* name = @(names[libIdx]);
        if ([name isKindOfClass:NSClassFromString(@"NSString")]) {
            if ([name.lowercaseString containsString:@"substrate"]) {
                *ret = YES;
                return true;
            }
        }
    }
    free(names);
#endif
    //All checks have failed. Most probably, the device is not jailbroken
    *ret = NO;
    return true;
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
        
        if (colorDoesNotExists(enclosure)) { //not found
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
        } else { //found
            *ret = colorFromString(enclosure);
            return true;
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
