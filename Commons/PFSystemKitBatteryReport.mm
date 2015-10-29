//
//  PFSystemKitBatteryReport.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSystemKitBatteryReport.h"
#import "PFSKHelper.h"

@implementation PFSystemKitBatteryReport
@synthesize designedCycleCount;
@synthesize serial;
@synthesize model;
@synthesize manufacturer;
@synthesize manufactureDate;
@synthesize isPresent;
@synthesize isFull;
@synthesize isCharging;
@synthesize isACConnected;
@synthesize amperage;
@synthesize currentCapacity;
@synthesize maxCapacity;
@synthesize voltage;
@synthesize cycleCount;
@synthesize health; //percentage
@synthesize temperature;
@synthesize power;
@synthesize age;

-(BOOL) batteryDetailsWithError:(NSError Ind2_NUAR)err {
    kern_return_t result;
    if (!firstRunDoneForBattery) {
        batEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("IOPMPowerSource"));
        if (batEntry == 0) {
            *err = synthesizeErrorWithObjectAndKey(PFSKReturnComponentUnavailable, @"Battery", @"Component");
            return false;
        }
    }
    CFMutableDictionaryRef batProps = NULL;
    result = IORegistryEntryCreateCFProperties(batEntry, &batProps, NULL, 0);
    if (result!=kIOReturnSuccess) {
        *err = synthesizeErrorExtIO(PFSKReturnIOKitCFFailure, result);
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
            
            designedCycleCount = [batteryRawDict objectForKey:@"DesignCycleCount9C"];
            serial = [batteryRawDict objectForKey:@"BatterySerialNumber"];
            model = [batteryRawDict objectForKey:@"DeviceName"];
            manufacturer = [batteryRawDict objectForKey:@"Manufacturer"];
            manufactureDate = [[NSCalendar currentCalendar] dateFromComponents:manufactureDateComponents];
            firstRunDoneForBattery = true;
        }
        
        NSDateComponents* differenceDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                                           fromDate:[temp objectForKey:@"manufactureDate"]
                                                                             toDate:[NSDate date]
                                                                            options:0];
        
        isPresent = [[batteryRawDict objectForKey:@"BatteryInstalled"] boolValue];
        isFull = [[batteryRawDict objectForKey:@"FullyCharged"] boolValue];
        isCharging = [[batteryRawDict objectForKey:@"IsCharging"] boolValue];
        isACConnected = [[batteryRawDict objectForKey:@"ExternalConnected"] boolValue];
        amperage = [batteryRawDict objectForKey:@"Amperage"];
        currentCapacity = [batteryRawDict objectForKey:@"CurrentCapacity"];
        maxCapacity = [batteryRawDict objectForKey:@"MaxCapacity"];
        voltage = [batteryRawDict objectForKey:@"Voltage"];
        cycleCount = [batteryRawDict objectForKey:@"CycleCount"];
        health = @(([[batteryRawDict objectForKey:@"MaxCapacity"] intValue] / [[batteryRawDict objectForKey:@"DesignCapacity"] intValue])*100);
        temperature = @([[batteryRawDict objectForKey:@"Temperature"] doubleValue] / 100);
        power = @([[batteryRawDict objectForKey:@"Amperage"] doubleValue] / 1000 * [[batteryRawDict objectForKey:@"Voltage"] doubleValue] / 1000);
        age = @([differenceDate day]);
        return true;
    }
}

-(instancetype) initWithMasterPort:(mach_port_t)port error:(NSError Ind2_NUAR)err
{
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
    
    BOOL res = [self batteryDetailsWithError:err];
    if (!res)
        return nil;
	return self;
}

-(void) update
{
    [self batteryDetailsWithError:nil]; //already ran once, so there should be no errors
	return;
}

-(void) finalize {
    IOObjectRelease(batEntry);
    [super finalize];
    return;
}
@end
