//
//  PFSK_Common+Machine.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 17/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_Common+Machine.h"
#import <string>
#import "NSString+CPPAdditions.h"

@implementation PFSystemKit(Machine)
-(PFSystemKitEndianness) systemEndianness {
	static dispatch_once_t onceToken;
	static PFSystemKitEndianness ret;
	dispatch_once(&onceToken, ^{
		_error = [self.class systemEndianness:&ret];
	});
	return ret;
}

+(PFSystemKitError)systemEndianness:(PFSystemKitEndianness*)ret __attribute__((nonnull (1)))
{
	CGFloat order = 0;
	PFSystemKitError locResult;
	locResult = _sysctlFloatForKey((char*)"hw.byteorder", order);
	if (locResult != PFSKReturnSuccess) {
		//memcpy(ret, (const int*)PFSKEndiannessUnknown, sizeof(PFSystemKitEndianness*));
		*ret = PFSKEndiannessUnknown;
		goto finish;
	}
	else {
		if (order == 1234) {
			//memcpy(ret, (const int*)PFSKEndiannessLittleEndian, sizeof(PFSystemKitEndianness*));
			*ret = PFSKEndiannessLittleEndian;
		} else if (order == 4321) {
			//memcpy(ret, (const int*)PFSKEndiannessBigEndian, sizeof(PFSystemKitEndianness*));
			*ret = PFSKEndiannessBigEndian;
		} else {
			//memcpy(ret, (const int*)PFSKEndiannessUnknown, sizeof(PFSystemKitEndianness*));
			*ret = PFSKEndiannessUnknown;
		}
		goto finish;
	}
finish:
	return locResult;
}

+(PFSystemKitError) machineModel:(NSString**)ret __attribute__((nonnull (1)))
{
	std::string machineModel;
	PFSystemKitError result;
	result = _sysctlStringForKey((char*)"hw.model", machineModel);
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = [NSString stringWithSTDString:machineModel];
finish:
	return result;
}

-(NSString*) model {
	static dispatch_once_t onceToken;
	static NSString* ret;
	dispatch_once(&onceToken, ^{
		std::string machineModel;
		PFSystemKitError result;
		result = _sysctlStringForKey((char*)"hw.model", machineModel);
		if (result != PFSKReturnSuccess)
			ret = @"-";
		else
			ret = [NSString stringWithSTDString:machineModel];
	});
	return ret;
}

-(PFSystemKitDeviceVersion) deviceVersion
{
	PFSystemKitDeviceVersion ret;
	_error = [self.class deviceVersion:&ret];
	return ret;
}

+(PFSystemKitError) deviceVersion:(PFSystemKitDeviceVersion*)ret __attribute__((nonnull (1)))
{
	NSString* systemInfoString;
	PFSystemKitError result = [self machineModel:&systemInfoString];
	if (result != PFSKReturnSuccess) {
		return result;
	} else {
		NSUInteger positionOfFirstInteger = [systemInfoString rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location;
		NSUInteger positionOfComma = [systemInfoString rangeOfString:@","].location;
		
		NSUInteger major = 0;
		NSUInteger minor = 0;
		
		if (positionOfComma != NSNotFound) {
			major = [[systemInfoString substringWithRange:NSMakeRange(positionOfFirstInteger, positionOfComma - positionOfFirstInteger)] integerValue];
			minor = [[systemInfoString substringFromIndex:positionOfComma + 1] integerValue];
		}
		*ret = (PFSystemKitDeviceVersion){major, minor};
	}
	return PFSKReturnSuccess;
}
@end
