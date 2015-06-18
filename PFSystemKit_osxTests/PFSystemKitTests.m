//
//  PFSystemKitTests.m
//  PFSystemKitTests
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
//#import "PFSK_Common.h"
//#import "PFSK_OSX.h"
#import "PFSK_OSX+CPU.h"
#import "PFSK_OSX+RAM.h"
#import "PFSK_OSX+GPU.h"
#import "PFSK_Common+Machine.h"
#import "PFSK_Common+Language.h"

@interface PFSystemKitTests : XCTestCase {
	PFSystemKit* pfsys;
}
@end

@implementation PFSystemKitTests

- (void)setUp {
    [super setUp];
	pfsys = [PFSystemKit.alloc init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
	{
		PFSystemKit* pfkit = [PFSystemKit investigate];
		NSString* batterySerial = [pfkit.platformReport serial];
        NSLog(@"Serial : %@", batterySerial);
		NSString* UUID = [pfkit.platformReport hardwareUUID];
        NSLog(@"UUID : %@ Gb", UUID);
        NSNumber* memSize = [pfkit.platformReport memorySize];
        NSLog(@"MemSize : %@", memSize);
        NSString* model = [pfkit.platformReport model];
        NSLog(@"Model : %@", model);
        NSString* cpuVendor = [pfkit.cpuReport vendor];
        NSLog(@"CPU Vendor : %@", cpuVendor);
	}
	/*
    // This is an example of a functional test case.
	PFSystemKit* pfkit = [PFSystemKit.alloc init];
	NSNumber* res;
	[PFSystemKit memorySize:&res];
	NSLog(@"%@", res);
	[PFSystemKit cpuL3Cache:&res error:nil];
	NSLog(@"%@", res);
	NSString* machineModel;
	[PFSystemKit machineModel:&machineModel];
	NSLog(@"%@", machineModel);
	machineModel = [PFSK_Common familyToString:PFSKDeviceFamilyiMac];
	NSLog(@"%@", machineModel);
	PFSystemKitEndianness endianness = PFSKEndiannessLittleEndian;
	[PFSystemKit systemEndianness:&endianness];
	printf("%i", endianness);
	//[PFSK_Common sysctlStringForKey:"brah" intoNSString:&machineModel];
     */
/*
	NSDictionary* memStats;
	[PFSystemKit memoryStats:&memStats];*/
	//BOOL brah = [pfkit refreshGroup:PFSKGroupGraphics];
    /*
	BOOL refReturn = [pfkit updateExpertReport];
	NSArray* serial = [pfkit valueForKeyPath:@"serial"];
	NSLog(@"%@", serial);
	refReturn = [pfkit updateRomReport];
	NSDate* romRD = [pfkit valueForKey:@"romReleaseDate"];
	NSLog(@"%@", romRD);
	refReturn = [pfkit refreshGroup:PFSKGroupSMC];
	NSDate* slC = [pfkit valueForKey:@"sleepCause"];
	NSLog(@"%@", slC);
	NSArray* graphs = [pfkit graphicsCreateReport];
	NSLog(@"%@", graphs);
	refReturn = [pfkit refreshGroup:PFSKGroupBattery];
	NSDictionary* batt = [pfkit valueForKey:@"batteryReport"];
	NSLog(@"%@", batt);
	NSMutableDictionary* cBrand = [NSMutableDictionary.alloc init];
	[PFSystemKit cpuCreateReport:&cBrand];
	NSLog(@"%@", cBrand);
	
	NSLog(@"%@", [PFSystemKit userPreferredLanguages]);
	*/
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        NSError* error;
        PFSystemRAMStatistics* stats;
        [PFSystemKit ramStatistics:&stats error:&error];
    }];
}

@end
