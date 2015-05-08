//
//  PFSystemKitTests.m
//  PFSystemKitTests
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "PFSK_OSX.h"
#import "PFSK_Common.h"

@interface PFSystemKitTests : XCTestCase {
	PFSystemKit* pfsys;
}
@end

@implementation PFSystemKitTests

- (void)setUp {
    [super setUp];
	//pfsys = [PFSystemKit.alloc init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
	NSNumber* res;
	[PFSystemKit memorySize:&res];
	NSLog(@"%@", res);
	[PFSystemKit cpuL3Cache:&res];
	NSLog(@"%@", res);
	NSString* machineModel;
	[PFSystemKit machineModel:&machineModel];
	NSLog(@"%@", machineModel);
	machineModel = familyToString(PFSKDeviceFamilyiMac);
	NSLog(@"%@", machineModel);
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
