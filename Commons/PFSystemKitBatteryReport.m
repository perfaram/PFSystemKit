//
//  PFSystemKitBatteryReport.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSystemKitBatteryReport.h"

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

-(instancetype) initWithDCC:(NSNumber*)designedCycleCountLocal
					 serial:(NSString*)serialLocal
					  model:(NSString*)modelLocal
			   manufacturer:(NSString*)manufacturerLocal
			manufactureDate:(NSDate*)manufactureDateLocal

{
	if (!(self = [super init])) {
		return nil;
	}
	designedCycleCount = designedCycleCountLocal;
	serial = serialLocal;
	model = modelLocal;
	manufacturer = manufacturerLocal;
	manufactureDate = manufactureDateLocal;
	return self;
}

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
						age:(NSNumber*)ageLocal

{
	isPresent = isPresentLocal;
	isFull = isFullLocal;
	isCharging = isChargingLocal;
	isACConnected = isACConnectedLocal;
	amperage = amperageLocal;
	currentCapacity = currentCapacityLocal;
	maxCapacity = maxCapacityLocal;
	voltage = voltageLocal;
	cycleCount = cycleCountLocal;
	health = healthLocal;
	temperature = temperatureLocal;
	power = powerLocal;
	age = ageLocal;
	return;
}
@end
