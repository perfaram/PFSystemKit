//
//  PFSystemKitTests.m
//  PFSystemKitTests
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import <PFSystemKit/PFSystemKit.h>

@interface PFSystemKitTests : XCTestCase {
	PFSystemKit* pfsys;
}
@end

@implementation PFSystemKitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
	{
		PFSystemKit* systemKit = [PFSystemKit investigate];
        NSError* myErr = nil;
        if (![systemKit platformReport:&myErr]) {
            //handle error
            NSLog(@"%@", myErr);
        }
        NSLog(@"Serial : %@", [systemKit.platformReport serial]);//no need for NSError, because it has been handled earlier
        NSLog(@"Model : %@", [systemKit.platformReport model]);
        
		NSString* UUID = [systemKit.platformReport uuid];
        NSLog(@"UUID : %@", UUID);
        NSNumber* memSize = [systemKit.platformReport memorySize];
        NSLog(@"MemSize : %@ Gb", memSize);
        NSLog(@"CPU Vendor : %@", [systemKit.cpuReport vendor]);
        NSNumber* count;
        NSError* myError;
        [PFSystemKit_cpu coreCount:&count error:&myError];
        NSLog(@"CPU Core Count : %@", count);
        NSArray* graph = [NSArray.alloc init];
        [PFSystemKit graphicsCreateReport:&graph error:nil];
        NSLog(@"%@", graph);
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
    }];
}

@end
