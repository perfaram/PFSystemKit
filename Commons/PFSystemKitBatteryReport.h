//
//  PFSystemKitBatteryReport.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFSystemKitBatteryReport : NSObject {
@protected
    mach_port_t   			masterPort;
    io_registry_entry_t 	batEntry;
    BOOL                    firstRunDoneForBattery;
@private
    NSDictionary*			batteryRawDict;
}
@property (readonly)  NSNumber* designedCycleCount;
@property (readonly)  NSString* serial;
@property (readonly)  NSString* model;
@property (readonly)  NSString* manufacturer;
@property (readonly)  NSDate* manufactureDate;
@property (readonly)  BOOL isPresent;
@property (readonly)  BOOL isFull;
@property (readonly)  BOOL isCharging;
@property (readonly)  BOOL isACConnected;
@property (readonly)  NSNumber* amperage;
@property (readonly)  NSNumber* currentCapacity;
@property (readonly)  NSNumber* maxCapacity;
@property (readonly)  NSNumber* voltage;
@property (readonly)  NSNumber* cycleCount;
@property (readonly)  NSNumber* health; //percentage
@property (readonly)  NSNumber* temperature;
@property (readonly)  NSNumber* power;
@property (readonly)  NSNumber* age;

-(instancetype) initWithMasterPort:(mach_port_t)port error:(NSError Ind2_NUAR)err;
@end
