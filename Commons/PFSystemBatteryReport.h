//
//  PFSystemBatteryReport.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFSystemBatteryReport : NSObject
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

-(instancetype) initWithDCC:(NSNumber*)designedCycleCountLocal
					 serial:(NSString*)serialLocal
					  model:(NSString*)modelLocal
			   manufacturer:(NSString*)manufacturerLocal
			manufactureDate:(NSDate*)manufactureDateLocal;

-(void) updateWithIsPresent:(BOOL)isPresentLocal
					 isFull:(BOOL)isFullLocal
				 isCharging:(BOOL)isChargingLocal
			  isACConnected:(BOOL)isACConnectedLocal
				   amperage:(NSNumber*)amperageLocal
			currentCapacity:(NSNumber*)currentCapacityLocal
				maxCapacity:(NSNumber*)maxCapacityLocal
					voltage:(NSNumber*)voltageLocal
				 cycleCount:(NSNumber*)cycleCountLocal
					 health:(NSNumber*)healthLocal
				temperature:(NSNumber*)temperatureLocal
					  power:(NSNumber*)powerLocal
						age:(NSNumber*)ageLocal;
@end
