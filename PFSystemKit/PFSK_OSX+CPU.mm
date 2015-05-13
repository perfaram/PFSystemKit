//
//  PFSK_OSX(CPU).m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_OSX+CPU.h"
#import "NSString+CPPAdditions.h"
#import <string>

@implementation PFSystemKit(CPU)
-(NSNumber*) cpuCount {
	NSNumber* ret = [NSNumber.alloc init];
	_error = [self.class cpuCount:&ret];
	return ret;
}

-(NSString*) cpuBrand {
	NSString* ret = [NSString.alloc init];
	_error = [self.class cpuBrand:&ret];
	return ret;
}

-(NSNumber*) cpuCoreCount {
	NSNumber* ret = [NSNumber.alloc init];
	_error = [self.class cpuCoreCount:&ret];
	return ret;
}

-(NSNumber*) cpuThreadCount {
	NSNumber* ret = [NSNumber.alloc init];
	_error = [self.class cpuThreadCount:&ret];
	return ret;
}

-(NSNumber*) cpuFrequency {
	NSNumber* ret = [NSNumber.alloc init];
	_error = [self.class cpuFrequency:&ret];
	return ret;
}

-(NSNumber*) cpuL2Cache {
	NSNumber* ret = [NSNumber.alloc init];
	_error = [self.class cpuL2Cache:&ret];
	return ret;
}

-(NSNumber*) cpuL3Cache {
	NSNumber* ret = [NSNumber.alloc init];
	_error = [self.class cpuL3Cache:&ret];
	return ret;
}

-(PFSystemKitCPUArches) cpuArchitecture {
	PFSystemKitCPUArches ret;
	_error = [self.class cpuArchitecture:&ret];
	return ret;
}
-(NSString*) cpuVendor {
	NSString* ret = [NSString.alloc init];
	_error = [self.class cpuVendor:&ret];
	return ret;
}

+(PFSystemKitError) cpuCount:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat count = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"hw.packages", count);
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(count);
finish:
	return result;
}

+(PFSystemKitError) cpuCoreCount:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat count = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"machdep.cpu.core_count", count);
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(count);
finish:
	return result;
}

+(PFSystemKitError) cpuThreadCount:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat count = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"machdep.cpu.thread_count", count);
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(count);
finish:
	return result;
}

+(PFSystemKitError) cpuBrand:(NSString**)ret __attribute__((nonnull (1)))
{
	std::string brand;
	PFSystemKitError locResult;
	locResult = _sysctlStringForKey((char*)"machdep.cpu.brand_string", brand);
	if (locResult != PFSKReturnSuccess)
		goto finish;
	else
		*ret = [NSString stringWithSTDString:brand];
finish:
	return locResult;
}

+(PFSystemKitError) cpuFrequency:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat size = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"hw.cpufrequency", size);
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(size/1000000000);//hertz in a gigahertz
finish:
	return result;
}

+(PFSystemKitError) cpuL2Cache:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat size = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"hw.l2cachesize", size);
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(size/1048576);
finish:
	return result;
}

+(PFSystemKitError) cpuL3Cache:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat size = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"hw.l3cachesize", size);
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(size/1048576);
finish:
	return result;
}

+(PFSystemKitError) cpuArchitecture:(PFSystemKitCPUArches*)ret __attribute__((nonnull (1))) {
	CGFloat arch = 0;
	PFSystemKitError locResult;
	locResult = _sysctlFloatForKey((char*)"hw.cputype", arch);
	if (locResult != PFSKReturnSuccess) {
		//memcpy(ret, (const int*)PFSKEndiannessUnknown, sizeof(PFSystemKitEndianness*));
		*ret = PFSKCPUArchesUnknown;
		goto finish;
	}
	else {
		// values for cputype and cpusubtype defined in mach/machine.h
		if (arch == CPU_TYPE_X86)
		{
			if (arch == CPU_TYPE_X86_64)
				*ret = PFSKCPUArchesX86_64;
			*ret = PFSKCPUArchesX86;
		} else if (arch == CPU_TYPE_POWERPC)
		{
			if (arch == CPU_TYPE_POWERPC64)
				*ret = PFSKCPUArchesPPC_64;
			*ret = PFSKCPUArchesPPC;
		} else if (arch == CPU_TYPE_I860)
		{
			*ret = PFSKCPUArchesI860;
		}
		goto finish;
	}
finish:
	return locResult;
}

+(PFSystemKitError) cpuVendor:(NSString**)ret __attribute__((nonnull (1)))
{
	std::string vendor;
	PFSystemKitError locResult;
	locResult = _sysctlStringForKey((char*)"machdep.cpu.vendor", vendor);
	if (locResult != PFSKReturnSuccess)
		goto finish;
	else
		*ret = [NSString stringWithSTDString:vendor];
finish:
	return locResult;
}

/*+(PFSystemKitError) cpuVendor:(PFSystemKitCPUVendors*)ret __attribute__((nonnull (1))) {
	std::string vendor;
	PFSystemKitError locResult;
	locResult = _sysctlStringForKey((char*)"machdep.cpu.vendor", vendor);
	if (locResult != PFSKReturnSuccess) {
		*ret = PFSKCPUVendorUnknown;
		goto finish;
	} else {
		if (locResult != PFSKReturnSuccess) {
			*ret = PFSKCPUVendorUnknown;
			goto finish;
		}
		else {
			if (vendor == "GenuineIntel") {
				*ret = PFSKCPUVendorGenuineIntel;
			} else if (vendor == "AuthenticAMD") {
				*ret = PFSKCPUVendorAuthenticAMD;
			} else {
				*ret = PFSKCPUVendorUnknown;
			}
			goto finish;
		}
	}
finish:
	return locResult;
}*/

@end
