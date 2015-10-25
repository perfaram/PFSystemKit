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
#import "PFSK_OSX.h"
#import "PFSKHelper.h"
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
		[sharedInstance updatePlatformReport];
		[sharedInstance updateBatteryReport];
	});
	return sharedInstance;
}

-(BOOL) cpuReport:(NSError Ind2_NUAR)err {
    if (cpuReport == nil) {
        cpuReport = [PFSystemKitCPUReport.alloc initWithError:err];
        if (err)
            return false;
        else
            return true;
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

+(Class) cpu {
    return PFSystemKitCPUReport.class;
}

-(BOOL) updatePlatformReport {
    kern_return_t result;
    smcEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("AppleSMC"));
    if (smcEntry == 0) {
        _error = PFSKReturnComponentUnavailable;
        return false;
    }
    CFMutableDictionaryRef smcProps = NULL;
    result = IORegistryEntryCreateCFProperties(smcEntry, &smcProps, NULL, 0);
    if (result!=kIOReturnSuccess) {
        _error = PFSKReturnIOKitCFFailure;
        _extError = result;
        return false;
    }
    smcRawDict = (__bridge_transfer NSDictionary*)smcProps;
    if (!firstRunDoneForExpertDevice) {
        pexEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("IOPlatformExpertDevice"));
        if (pexEntry == 0) {
            _error = PFSKReturnComponentUnavailable;
            return false;
        }
        CFMutableDictionaryRef pexProps = NULL;
        result = IORegistryEntryCreateCFProperties(pexEntry, &pexProps, NULL, 0);
        if (result!=kIOReturnSuccess) {
            _error = PFSKReturnIOKitCFFailure;
            _extError = result;
            return false;
        }
        platformExpertRawDict = (__bridge_transfer NSDictionary*)pexProps;
        romEntry = IORegistryEntryFromPath(masterPort, "IODeviceTree:/rom@0");
        if (romEntry == 0) {
            _error = PFSKReturnComponentUnavailable;
            return false;
        }
        CFMutableDictionaryRef romProps = NULL;
        result = IORegistryEntryCreateCFProperties(romEntry, &romProps, NULL, 0);
        if (result!=kIOReturnSuccess) {
            _error = PFSKReturnIOKitCFFailure;
            _extError = result;
            return false;
        }
        romRawDict = (__bridge_transfer NSDictionary*)romProps;
        
        NSString* dateStr = [NSString.alloc initWithData:[romRawDict objectForKey:@"release-date"] encoding:NSUTF8StringEncoding];
        NSDateComponents* romDateComps = [NSDateComponents.alloc init];
        NSArray* romDateStrSplitted = [dateStr componentsSeparatedByString:@"/"];
        [romDateComps setMonth:[[romDateStrSplitted objectAtIndex:0] integerValue]];
        [romDateComps setDay:[[romDateStrSplitted objectAtIndex:1] integerValue]];
        [romDateComps setYear:(2000+[[romDateStrSplitted objectAtIndex:2] integerValue])];
        BOOL depResult = true;
        NSError* depError;
        
        PFSystemKitDeviceFamily deviceFamily = PFSKDeviceFamilyUnknown;
        //NSString* systemInfoString = [platformExpertRawDict objectForKey:@"model"];
        NSString* systemInfoString = [[NSString alloc] initWithData:[platformExpertRawDict objectForKey:@"model"]
                              encoding:NSUTF8StringEncoding];
        if ([systemInfoString length] != 0) { //is systemInfoString initialized, i.e non-nil nor empty
            systemInfoString = [systemInfoString lowercaseString]; //transform to lowercase, meaning less code afterwards
            if ([systemInfoString containsString:@"mac"]) {
                if ([systemInfoString isEqualToString:@"imac"])
                    deviceFamily = PFSKDeviceFamilyiMac;
                else if ([systemInfoString containsString:@"air"])
                    deviceFamily = PFSKDeviceFamilyMacBookAir;
                else if ([systemInfoString containsString:@"pro"] && [systemInfoString containsString:@"book"])
                    deviceFamily = PFSKDeviceFamilyMacBookPro;
                else if ([systemInfoString containsString:@"mini"])
                    deviceFamily = PFSKDeviceFamilyMacMini;
                else if ([systemInfoString containsString:@"pro"])
                    deviceFamily = PFSKDeviceFamilyMacPro;
                else if ([systemInfoString containsString:@"macbook"])
                    deviceFamily = PFSKDeviceFamilyMacBook;
                else if ([systemInfoString isEqualToString:@"xserve"])
                deviceFamily = PFSKDeviceFamilyXserve;
            }
        }

        NSUInteger positionOfFirstInteger = [systemInfoString rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location;
        NSUInteger positionOfComma = [systemInfoString rangeOfString:@","].location;
        NSUInteger major = 0;
        NSUInteger minor = 0;
        if (positionOfComma != NSNotFound) {
            major = [[systemInfoString substringWithRange:NSMakeRange(positionOfFirstInteger, positionOfComma - positionOfFirstInteger)] integerValue];
            minor = [[systemInfoString substringFromIndex:positionOfComma + 1] integerValue];
        }
        PFSystemKitDeviceVersion deviceVer = (PFSystemKitDeviceVersion){major, minor};
        
        PFSystemKitEndianness deviceEndian;
        depResult = [self.class deviceEndianness:&deviceEndian error:&depError];
        if (!depResult) {
            error = depError;
            return false;
        }
        
        NSNumber* memSize;
        depResult = [PFSystemKitRAMReport size:&memSize error:&depError];
        if (!depResult) {
            error = depError;
            return false;
        }
        
        platformReport = [PFSystemKitPlatformReport.alloc initWithBoardID:[[NSString alloc] initWithData:[platformExpertRawDict objectForKey:@"board-id"]
                                                                                             encoding:NSUTF8StringEncoding]
                                                          hardwareUUID:[platformExpertRawDict objectForKey:@kIOPlatformUUIDKey]
                                                            romVersion:[[NSString alloc] initWithData:[romRawDict objectForKey:@"version"]
                                                                                             encoding:NSUTF8StringEncoding]
                                                        romReleaseDate:[[NSCalendar currentCalendar] dateFromComponents:romDateComps]
                                                            smcVersion:[smcRawDict objectForKey:@"smc-version"]
                                                         shutdownCause:[smcRawDict objectForKey:@"ShutdownCause"]
                                                                family:deviceFamily
                                                               version:deviceVer
                                                            endianness:deviceEndian
                                                                 model:[[NSString alloc] initWithData:[platformExpertRawDict objectForKey:@"model"]
                                                                                             encoding:NSUTF8StringEncoding]
                                                                serial:[platformExpertRawDict objectForKey:@kIOPlatformSerialNumberKey]
                                                            memorySize:memSize];
		firstRunDoneForExpertDevice = 1;
	}
    [platformReport updateWithSleepCause:[smcRawDict objectForKey:@"SleepCause"]];
	return true;
}

-(BOOL) updateBatteryReport {
	kern_return_t result;
	if (!firstRunDoneForBattery) {
		batEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("IOPMPowerSource"));
		if (batEntry == 0) {
			_error = PFSKReturnComponentUnavailable;
			return false;
		}
	}
	CFMutableDictionaryRef batProps = NULL;
	result = IORegistryEntryCreateCFProperties(batEntry, &batProps, NULL, 0);
	if (result!=kIOReturnSuccess) {
		_error = PFSKReturnIOKitCFFailure;
		_extError = result;
		return false;
	} else {
		batteryRawDict = (__bridge_transfer NSDictionary*)batProps;
		NSMutableDictionary* temp = [NSMutableDictionary.alloc init];
		
		if (!firstRunDoneForBattery) { //static keys
			//[temp setObject:[batteryRawDict objectForKey:@"DesignCapacity"] forKey:@"DesignedCapacity"];
			unsigned int manufactureDateAsInt = [[batteryRawDict objectForKey:@"ManufactureDate"] intValue];
			NSDateComponents* manufactureDateComponents = [[NSDateComponents alloc]init];
			manufactureDateComponents.year = (manufactureDateAsInt >> 9) + 1980;
			manufactureDateComponents.month = (manufactureDateAsInt >> 5) & 0xF;
			manufactureDateComponents.day = manufactureDateAsInt & 0x1F;
			[temp setObject:[[NSCalendar currentCalendar] dateFromComponents:manufactureDateComponents] forKey:@"manufactureDate"];
			batteryReport = [PFSystemKitBatteryReport.alloc initWithDCC:[batteryRawDict objectForKey:@"DesignCycleCount9C"]
						 serial:[batteryRawDict objectForKey:@"BatterySerialNumber"]
						  model:[batteryRawDict objectForKey:@"DeviceName"]
				   manufacturer:[batteryRawDict objectForKey:@"Manufacturer"]
				manufactureDate:[[NSCalendar currentCalendar] dateFromComponents:manufactureDateComponents]];
			firstRunDoneForBattery = 1;
		}
		
		NSDateComponents* differenceDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
																		   fromDate:[temp objectForKey:@"manufactureDate"]
																			 toDate:[NSDate date]
																			options:0];
		[batteryReport updateWithIsPresent:[[batteryRawDict objectForKey:@"BatteryInstalled"] intValue]
									isFull:[[batteryRawDict objectForKey:@"FullyCharged"] intValue]
								isCharging:[[batteryRawDict objectForKey:@"IsCharging"] intValue]
							 isACConnected:[[batteryRawDict objectForKey:@"ExternalConnected"] intValue]
								  amperage:[batteryRawDict objectForKey:@"Amperage"]
						   currentCapacity:[batteryRawDict objectForKey:@"CurrentCapacity"]
							   maxCapacity:[batteryRawDict objectForKey:@"MaxCapacity"]
								   voltage:[batteryRawDict objectForKey:@"Voltage"]
								cycleCount:[batteryRawDict objectForKey:@"CycleCount"]
									health:@(([[batteryRawDict objectForKey:@"MaxCapacity"] intValue] / [[batteryRawDict objectForKey:@"DesignCapacity"] intValue])*100)
							   temperature:@([[batteryRawDict objectForKey:@"Temperature"] doubleValue] / 100)
									 power:@([[batteryRawDict objectForKey:@"Amperage"] doubleValue] / 1000 * [[batteryRawDict objectForKey:@"Voltage"] doubleValue] / 1000)
									   age:@([differenceDate day])];
		return true;
	}
}

#pragma mark - Getters
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
