//
//  PFSK_Common.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <mach/mach_error.h>
#import <sys/sysctl.h>
#import <string>
#import <errno.h>
#import "PFSKPrivateTypes.h"
#import "PFSK_Common.h"
#import "PFSKHelper.h"
#import "NSString+PFSKAdditions.h"

NSString* PFSKErrorDomain = @"com.faramaz.PFSystemKit";
NSString* PFSKErrorExtendedDomain = @"com.faramaz.PFSystemKit.extended";

@implementation PFSK_Common
+(NSString*) userPreferredLanguages {
    // User preferred language
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    return (NSString*)[languages objectAtIndex:0];
}

+(NSString*__nullable) errorToString:(PFSystemKitError)err {
    return errorToString(err);
}

+(NSString*__nullable) errorToExplanation:(PFSystemKitError)err {
    return errorToExplanation(err);
}

+(NSString*__nullable) errorToRecovery:(PFSystemKitError)err {
    return errorToRecovery(err);
}

inline NSString*__nullable errorToRecovery(PFSystemKitError err) {
    if (err < PFSKReturnUnknown)
        return @(PFSystemKitErrorRecovery[err]);
    return nil;
}

inline NSString*__nullable errorToExplanation(PFSystemKitError err) {
    if (err < PFSKReturnUnknown)
        return @(PFSystemKitErrorReasons[err]);
    return nil;
}

inline NSString*__nullable errorToString(PFSystemKitError err) {
    if (err < PFSKReturnUnknown)
        return @(PFSystemKitErrorStrings[err]);
    return nil;
}

+(NSString*__nullable) iokitErrorToString:(kern_return_t)err {
    return [NSString.alloc initWithCString:mach_error_string(err) encoding:NSUTF8StringEncoding];
}

+(NSString*__nullable) platformToString:(PFSystemKitPlatform)platform {
    if (platform < PFSKPlatformUnknown)
        return @(PFSystemKitPlatformStrings[platform]);
    return nil;
}

+(PFSystemKitPlatform) stringToPlatform:(NSString*__nullable)str {
    if (!str)
        return PFSKPlatformUnknown;
    str = [str lowercaseString];
    if ([str containsString:@"i"])
        return PFSKPlatformIOS;
    else if ([str containsString:@"x"])
        return PFSKPlatformOSX;
    else
        return PFSKPlatformUnknown;
}

+(NSString*__nullable) familyToString:(PFSystemKitDeviceFamily)family {
    if (family < PFSKDeviceFamilyUnknown)
        return @(PFSystemKitDeviceFamilyStrings[family]);
    return nil;
}
+(PFSystemKitDeviceFamily) stringToFamily:(NSString*)str {
    //[mydict objectForKey:[[str stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString]];
    str = [str lowercaseString]; //transform to lowercase, meaning less code afterwards
    if ([str containsString:@"mac"]) {
        if ([str isEqualToString:@"imac"])
            return PFSKDeviceFamilyiMac;
        else if ([str containsString:@"air"])
            return PFSKDeviceFamilyMacBookAir;
        else if ([str containsString:@"pro"] && [str containsString:@"book"])
            return PFSKDeviceFamilyMacBookPro;
        else if ([str containsString:@"mini"])
            return PFSKDeviceFamilyMacMini;
        else if ([str containsString:@"pro"])
            return PFSKDeviceFamilyMacPro;
        else if ([str containsString:@"macbook"])
            return PFSKDeviceFamilyMacBook;
    } else if ([str hasPrefix:@"i"]) { //don't care about imac, has been checked before
        if ([str isEqualToString:@"iphone"])
            return PFSKDeviceFamilyiPhone;
        else if ([str isEqualToString:@"ipad"])
            return PFSKDeviceFamilyiPad;
        else if ([str isEqualToString:@"ipod"])
            return PFSKDeviceFamilyiPod;
    } else if ([str isEqualToString:@"xserve"]) {
        return PFSKDeviceFamilyXserve;
    } else if ([str isEqualToString:@"simulator"]) {
        return PFSKDeviceFamilySimulator;
    }
    return PFSKDeviceFamilyUnknown;
}

+(NSString*__nullable) endiannessToString:(PFSystemKitEndianness) endianness {
    if (endianness < PFSKEndiannessUnknown)
        return @(PFSystemKitEndiannessStrings[endianness]);
    return nil;
}

+(NSString*__nullable) cpuVendorToString:(PFSystemKitCPUVendor) vendor {
    if (vendor < PFSKCPUVendorUnknown)
        return @(PFSystemKitCPUVendorStrings[vendor]);
    return nil;
}

+(NSString*__nullable) cpuArchToString:(PFSystemKitCPUArches) arch {
    if (arch < PFSKCPUArchesUnknown)
        return @(PFSystemKitCPUArchesStrings[arch]);
    return nil;
}

+(NSOperatingSystemVersion) osVersionFromString:(NSString*__nonnull) string {
    return NSOperatingSystemVersionWithNSString(string);
}

inline int _sysctlStringForKey(char* key, std::string& answerChar) {
    size_t length;
    int i = sysctlbyname(key, NULL, &length, NULL, 0);
    if (length) {
        std::string platform;
        memset(&answerChar, 0, sizeof(answerChar));
        i = sysctlbyname(key, WriteInto(&answerChar, length), &length, NULL, 0);
        answerChar += std::to_string(i);
        return i;
    }
    return i;
}

inline int _sysctlDoubleForKey(char* key, double& answerDouble) {
    size_t length;
    int i = sysctlbyname(key, NULL, &length, NULL, 0);
    if (length) {
        answerDouble = 0;
        //char *answerRaw = malloc(length * sizeof(char));
        char *answerRaw = new char[length];
        i = sysctlbyname(key, answerRaw, &length, NULL, 0);
        switch (length) {
            case 8: {
                answerDouble = (double)*(int64_t *)answerRaw;
                return i;
            } break;
                
            case 4: {
                answerDouble = (double)*(int32_t *)answerRaw;
                return i;
            } break;
                
            default: {
                answerDouble = (double)0.;
                return i;
            } break;
        }
        delete [] answerRaw;
    }
    return i;
}

PFSystemKitError _sysctlErrorParser(int i) {
    if (i==-1)
        return PFSKReturnSysCtlUnknownKey;
    else if (i!=0)
        return PFSKReturnSysCtlError;
    else
        return PFSKReturnSuccess;
}

/*PFSystemKitError sysctlSTDStringForKey(char* key, std::string& answerString) { //function used only in the framework, to avoid ObjC method resolving (=faster)
    int i = _sysctlStringForKey(key, answerString);
    return _sysctlErrorParser(i);
}

PFSystemKitError sysctlNSStringForKey(char* key, NSString Ind2_NNAR answerString) { //function used only in the framework, to avoid ObjC method resolving (=faster)
    std::string answerSTDString;
    PFSystemKitError res = _sysctlErrorParser(_sysctlStringForKey(key, answerSTDString));
    *answerString = [NSString stringWithSTDString:answerSTDString];
    return res;
}

PFSystemKitError sysctlCStringForKey(char* key, char* answerString) { //function used only in the framework, to avoid ObjC method resolving (=faster)
    std::string answerSTDString;
    PFSystemKitError res = _sysctlErrorParser(_sysctlStringForKey(key, answerSTDString));
    strcpy(answerString, answerSTDString.c_str());
    return res;
}*/

BOOL sysctlSTDStringForKey(char*__nonnull key, std::string& answerString, NSError Ind2_NUAR error) { //function used only in the framework, to avoid ObjC method resolving (=faster)
    int i = _sysctlStringForKey(key, answerString);
    PFSystemKitError res = _sysctlErrorParser(i);
    if (error)
        *error = synthesizeErrorExtSCWithObjectAndKey(res, i, [NSString.alloc initWithCString:key encoding:NSASCIIStringEncoding], @"Key");
    if (res != PFSKReturnSuccess)
        return false;
    return true;
}

BOOL sysctlNSStringForKey(char*__nonnull key, NSString Ind2_NNAR answerString, NSError Ind2_NUAR error) { //function used only in the framework, to avoid ObjC method resolving (=faster)
    std::string answerSTDString;
    int i = _sysctlStringForKey(key, answerSTDString);
    PFSystemKitError res = _sysctlErrorParser(i);
    if (error)
        *error = synthesizeErrorExtSCWithObjectAndKey(res, i, [NSString.alloc initWithCString:key encoding:NSASCIIStringEncoding], @"Key");
    *answerString = [NSString stringWithSTDString:answerSTDString];
    if (res != PFSKReturnSuccess)
        return false;
    return true;
}

BOOL sysctlCStringForKey(char*__nonnull key, char*__nonnull answerString, NSError Ind2_NUAR error) { //function used only in the framework, to avoid ObjC method resolving (=faster)
    std::string answerSTDString;
    int i = _sysctlStringForKey(key, answerSTDString);
    PFSystemKitError res = _sysctlErrorParser(i);
    if (error)
        *error = synthesizeErrorExtSCWithObjectAndKey(res, i, [NSString.alloc initWithCString:key encoding:NSASCIIStringEncoding], @"Key");
    
    strcpy(answerString, answerSTDString.c_str());
    
    if (res != PFSKReturnSuccess)
        return false;
    return true;
}
/*
PFSystemKitError sysctlDoubleForKey(char*__nonnull key, double& answerDouble) { //function used only in the framework, to avoid ObjC method resolving (=faster)
    return _sysctlErrorParser(_sysctlDoubleForKey(key, answerDouble));
}

PFSystemKitError sysctlNumberForKey(char* key, NSNumber Ind2_NNAR answerNumber) { //function used only in the framework, to avoid ObjC method resolving (=faster)
    double answerDouble = 0;
    PFSystemKitError res = _sysctlErrorParser(_sysctlDoubleForKey(key, answerDouble));
    *answerNumber = @(answerDouble);
    return res;
}*/

BOOL sysctlDoubleForKey(char* key, double& answerDouble, NSError Ind2_NUAR error) { //function used only in the framework, to avoid ObjC method resolving (=faster)
    int i = _sysctlDoubleForKey(key, answerDouble);
    PFSystemKitError res = _sysctlErrorParser(i);
    if (error)
        *error = synthesizeErrorExtSCWithObjectAndKey(res, i, [NSString.alloc initWithCString:key encoding:NSASCIIStringEncoding], @"Key");
    if (res != PFSKReturnSuccess)
        return false;
    return true;
}

BOOL sysctlNumberForKey(char*__nonnull key, NSNumber Ind2_NNAR answerNumber, NSError Ind2_NUAR error) { //function used only in the framework, to avoid ObjC method resolving (=faster)
    double answerDouble = 0;
    int i = _sysctlDoubleForKey(key, answerDouble);
    PFSystemKitError res = _sysctlErrorParser(i);
    if (error)
        *error = synthesizeErrorExtSCWithObjectAndKey(res, i, [NSString.alloc initWithCString:key encoding:NSASCIIStringEncoding], @"Key");
    *answerNumber = @(answerDouble);
    if (res != PFSKReturnSuccess)
        return false;
    return true;
}

__attribute__((always_inline)) PFSystemKitDeviceColor colorFromString(NSString* string) {
    return PFSystemKitDeviceColorHexesReverse[string];
}

__attribute__((always_inline)) BOOL colorDoesNotExists(NSString* string) {
    return (PFSystemKitDeviceColorHexesReverse.find(string) == PFSystemKitDeviceColorHexesReverse.end());
}

__attribute__((always_inline)) NSError* synthesizeError(PFSystemKitError error) {
    return [NSError errorWithDomain:PFSKErrorDomain
                               code:error
                           userInfo:@{
                                      NSLocalizedDescriptionKey: errorToExplanation(error),
                                      NSLocalizedFailureReasonErrorKey: errorToRecovery(error)
                                      }];
}

__attribute__((always_inline)) NSError* synthesizeErrorExtSCWithObjectAndKey(PFSystemKitError error, int errNo, id object, id key) {
    return [NSError errorWithDomain:PFSKErrorDomain
                               code:error
                           userInfo:@{
                                      NSLocalizedDescriptionKey: errorToExplanation(error),
                                      NSLocalizedFailureReasonErrorKey: errorToRecovery(error),
                                      key: object,
                                      NSUnderlyingErrorKey: [NSError errorWithDomain:PFSKErrorExtendedDomain
                                                                                code:errNo
                                                                            userInfo:@{
                                                                                       NSLocalizedDescriptionKey: [NSString.alloc initWithCString:strerror(errNo)
                                                                                                                                         encoding:NSUTF8StringEncoding]
                                                                                       }]
                                      }];
}

__attribute__((always_inline)) NSError* synthesizeErrorExtIO(PFSystemKitError error, kern_return_t extendedError) {
    return [NSError errorWithDomain:PFSKErrorDomain
                               code:error
                           userInfo:@{
                                      NSLocalizedDescriptionKey: errorToExplanation(error),
                                      NSLocalizedFailureReasonErrorKey: errorToRecovery(error),
                                      NSUnderlyingErrorKey: [NSError errorWithDomain:PFSKErrorExtendedDomain
                                                                                code:extendedError
                                                                            userInfo:@{
                                                                                       NSLocalizedDescriptionKey: [NSString.alloc initWithCString:mach_error_string(extendedError)
                                                                                                                                         encoding:NSUTF8StringEncoding]
                                                                                       }]
                                      }];
}
@end