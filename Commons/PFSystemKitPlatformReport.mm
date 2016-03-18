//
//  PFSystemExpertReport.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSystemKitPlatformReport.h"
#import <sys/sysctl.h>
#import <CoreFoundation/CoreFoundation.h>
#import <string>
#import <vector>
#import "PFSKHelper.h"
#import "PFSystemKitRAMReport.h"

@implementation PFSystemKitPlatformReport
@synthesize family;
@synthesize platform;
@synthesize version;
@synthesize endianness;
@synthesize model;
@synthesize serial;
@synthesize memorySize;

#if !TARGET_OS_IPHONE
@synthesize boardID;
@synthesize uuid;
@synthesize romVersion;
@synthesize romReleaseDate;
@synthesize smcVersion;
@synthesize sleepCause;
@synthesize shutdownCause;
#endif
#if TARGET_OS_IPHONE
@synthesize isJailbroken;
#endif

#if !TARGET_OS_IPHONE
-(BOOL) smcDetailsWithError:(NSError Ind2_NUAR)err {
    kern_return_t result;
    smcEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("AppleSMC"));
    if (smcEntry == 0) {
        *err = synthesizeErrorWithObjectAndKey(PFSKReturnComponentUnavailable, @"SMC", @"Component");
        return false;
    } else {
        CFMutableDictionaryRef smcProps = NULL;
        result = IORegistryEntryCreateCFProperties(smcEntry, &smcProps, NULL, 0);
        if (result!=kIOReturnSuccess) {
            *err = synthesizeErrorExtIO(PFSKReturnIOKitCFFailure, result);
            return false;
        } else {
            smcRawDict = (__bridge_transfer NSDictionary*)smcProps;
            if (!firstRunDoneForSMC) {
                smcVersion = [smcRawDict objectForKey:@"smc-version"];
                shutdownCause = [smcRawDict objectForKey:@"ShutdownCause"];
                firstRunDoneForSMC = true;
            }
            sleepCause = [smcRawDict objectForKey:@"SleepCause"];
            return true;
        }
    }
}

-(BOOL) expertDetailsWithError:(NSError Ind2_NUAR)err {
    kern_return_t result;
    if (!firstRunDoneForExpertDevice) {
        pexEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("IOPlatformExpertDevice"));
        if (pexEntry == 0) {
            *err = synthesizeErrorWithObjectAndKey(PFSKReturnComponentUnavailable, @"Platform Expert", @"Component");
            return false;
        } else {
            CFMutableDictionaryRef pexProps = NULL;
            result = IORegistryEntryCreateCFProperties(pexEntry, &pexProps, NULL, 0);
            if (result!=kIOReturnSuccess) {
                *err = synthesizeErrorExtIO(PFSKReturnIOKitCFFailure, result);
                return false;
            } else {
                platformExpertRawDict = (__bridge_transfer NSDictionary*)pexProps;
                //handle results
                NSString* systemInfoString = [[NSString alloc] initWithData:[platformExpertRawDict objectForKey:@"model"]
                                                                   encoding:NSUTF8StringEncoding];
                family = [PFSK_Common stringToFamily:systemInfoString];
                model = systemInfoString;
                NSUInteger positionOfFirstInteger = [systemInfoString rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location;
                NSUInteger positionOfComma = [systemInfoString rangeOfString:@","].location;
                NSUInteger major = 0;
                NSUInteger minor = 0;
                if (positionOfComma != NSNotFound) {
                    major = [[systemInfoString substringWithRange:NSMakeRange(positionOfFirstInteger, positionOfComma - positionOfFirstInteger)] integerValue];
                    minor = [[systemInfoString substringFromIndex:positionOfComma + 1] integerValue];
                }
                version = (PFSystemKitDeviceVersion){major, minor};
                serial = [platformExpertRawDict objectForKey:@kIOPlatformSerialNumberKey];
                uuid = [platformExpertRawDict objectForKey:@kIOPlatformUUIDKey];
                boardID = [[NSString alloc] initWithData:[platformExpertRawDict objectForKey:@"board-id"]
                                                encoding:NSUTF8StringEncoding];
                firstRunDoneForExpertDevice = true;
                return true;
            }
        }
    } else {
        return true;
    }
}

-(BOOL) romDetailsWithError:(NSError Ind2_NUAR)err {
    kern_return_t result;
    if (!firstRunDoneForROM) {
        romEntry = IORegistryEntryFromPath(masterPort, "IODeviceTree:/rom@0");
        if (romEntry == 0) {
            *err = synthesizeErrorWithObjectAndKey(PFSKReturnComponentUnavailable, @"NVRAM", @"Component");
            return false;
        } else {
            CFMutableDictionaryRef romProps = NULL;
            result = IORegistryEntryCreateCFProperties(romEntry, &romProps, NULL, 0);
            if (result!=kIOReturnSuccess) {
                *err = synthesizeErrorExtIO(PFSKReturnIOKitCFFailure, result);
                return false;
            } else {
                romRawDict = (__bridge_transfer NSDictionary*)romProps;
                //handle results
                NSString* dateStr = [NSString.alloc initWithData:[romRawDict objectForKey:@"release-date"] encoding:NSUTF8StringEncoding];
                NSDateComponents* romDateComps = [NSDateComponents.alloc init];
                NSArray* romDateStrSplitted = [dateStr componentsSeparatedByString:@"/"];
                [romDateComps setMonth:[[romDateStrSplitted objectAtIndex:0] integerValue]];
                [romDateComps setDay:[[romDateStrSplitted objectAtIndex:1] integerValue]];
                [romDateComps setYear:(2000+[[romDateStrSplitted objectAtIndex:2] integerValue])];
                romReleaseDate = [[NSCalendar currentCalendar] dateFromComponents:romDateComps];
                romVersion = [[NSString alloc] initWithData:[romRawDict objectForKey:@"version"]
                                                   encoding:NSUTF8StringEncoding];
                firstRunDoneForROM = true;
                return true;
            }
        }
    } else {
        return true;
    }
}
#endif

-(void) updateData {
#if !TARGET_OS_IPHONE
    [self smcDetailsWithError:nil];//it will be OK, no essential info in there + already ran once, so it *should* be OK
#endif
}

#if TARGET_OS_IPHONE
-(instancetype) initWithError:(NSError Ind2_NUAR)err {
    if (!(self = [super init])) {
        return nil;
    }
    PFSystemKitDeviceFamily fam;
    PFSystemKitDeviceVersion ver;
    PFSystemKitEndianness end;
    NSString* mod;
    NSNumber* memSize;
    BOOL isjb;
    //BOOL state = true;
    BOOL res = [PFSK_Common deviceFamily:&fam error:err];
    res = [PFSK_Common deviceVersion:&ver error:err];
    res = [PFSK_Common deviceEndianness:&end error:err];
    res = [PFSK_Common deviceModel:&mod error:err];
    res = [PFSystemKitRAMReport size:&memSize error:err];
    res = [PFSK_Common isJailbroken:&isjb error:err];
    
    version = ver;
    endianness = end;
    model = mod;
    memorySize = memSize;
    isJailbroken = isjb;
    
    return self;
}
#else
-(instancetype) initWithMasterPort:(mach_port_t)port error:(NSError Ind2_NUAR)err {
    if (!(self = [super init])) {
        return nil;
    }
    if (!port) {
        kern_return_t IOresult;
        IOresult = IOMasterPort(bootstrap_port, &masterPort);
        if (IOresult!=kIOReturnSuccess) {
            *err = synthesizeErrorExtIO(PFSKReturnNoMasterPort, IOresult);
            return nil;
        }
    } else {
        port = masterPort;
    }
    
    BOOL depResult = true;
    PFSystemKitEndianness deviceEndian;
    depResult = [PFSK_Common deviceEndianness:&deviceEndian error:err];
    endianness = deviceEndian;
    
    NSNumber* memSize;
    depResult = [PFSystemKitRAMReport size:&memSize error:err];
    memorySize = memSize;
    
#if TARGET_OS_IPHONE
    platform = PFSKPlatformIOS;
#else
    platform = PFSKPlatformOSX;
#endif
    
    if (![self expertDetailsWithError:err])
        return nil; //because without expert device I'm a bit disappointed (no serial ?!)
    
    [self smcDetailsWithError:err];//it will be OK, no essential info in there
    
    [self romDetailsWithError:err];//don't return because I can deal with having no ROM details
    
    return self;
}

-(void) finalize {
    IOObjectRelease(pexEntry);
    IOObjectRelease(smcEntry);
    IOObjectRelease(romEntry);
    [super finalize];
    return;
}
#endif
@end
