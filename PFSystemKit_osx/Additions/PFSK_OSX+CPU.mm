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
__attribute__((always_inline)) PFSystemKitError _cpuBrand(NSString** ret) {
	std::string brand;
	PFSystemKitError locResult;
	locResult = _sysctlStringForKey((char*)"machdep.cpu.brand_string", brand);
	if (locResult != PFSKReturnSuccess)
		*ret = @"-";
		goto finish;
	else
		*ret = [NSString stringWithSTDString:brand];
finish:
	return locResult;
}

__attribute__((always_inline)) PFSystemKitError _cpuCount(NSNumber** ret) {
	CGFloat count = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"hw.packages", count);
	if (result != PFSKReturnSuccess)
		*ret = @(-1);
		goto finish;
	else
		*ret = @(count);
finish:
	return result;
}

__attribute__((always_inline)) PFSystemKitError _cpuCoreCount(NSNumber** ret) {
	CGFloat count = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"machdep.cpu.core_count", count);
	if (result != PFSKReturnSuccess)
		*ret = @(-1);
		goto finish;
	else
		*ret = @(count);
finish:
	return result;
}

__attribute__((always_inline)) PFSystemKitError _cpuThreadCount(NSNumber** ret) {
	CGFloat count = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"machdep.cpu.thread_count", count);
	if (result != PFSKReturnSuccess)
		*ret = @(-1);
		goto finish;
	else
		*ret = @(count);
finish:
	return result;
}

__attribute__((always_inline)) PFSystemKitError _cpuFrequency(NSNumber** ret) {
	CGFloat size = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"hw.cpufrequency", size);
	if (result != PFSKReturnSuccess)
		*ret = @(-1);
		goto finish;
	else
		*ret = @(size/1000000000);//hertz in a gigahertz
finish:
	return result;
}

__attribute__((always_inline)) PFSystemKitError _cpuL2Cache(NSNumber** ret) {
	CGFloat size = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"hw.l2cachesize", size);
	if (result != PFSKReturnSuccess)
		*ret = @(-1);
		goto finish;
	else
		*ret = @(size/1048576);
finish:
	return result;
}

__attribute__((always_inline)) PFSystemKitError _cpuL3Cache(NSNumber** ret) {
	CGFloat size = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"hw.l3cachesize", size);
	if (result != PFSKReturnSuccess)
		*ret = @(-1);
		goto finish;
	else
		*ret = @(size/1048576);
finish:
	return result;
}

__attribute__((always_inline)) PFSystemKitError _cpuVendor(NSString** ret) {
	std::string vendor;
	PFSystemKitError locResult;
	locResult = _sysctlStringForKey((char*)"machdep.cpu.vendor", vendor);
	if (locResult != PFSKReturnSuccess)
		*ret = @"-";
		goto finish;
	else
		*ret = [NSString stringWithSTDString:vendor];
finish:
	return locResult;
}

__attribute__((always_inline)) PFSystemKitError _cpuArchitecture(PFSystemKitCPUArches* ret) {
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

+(BOOL) cpuCount:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1))) {
	return _cpuCount(ret);
}

+(BOOL) cpuCoreCount:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1))) {
	return _cpuCoreCount(ret);
}

+(BOOL) cpuThreadCount:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1))) {
	return _cpuThreadCount(ret);
}

+(BOOL) cpuBrand:(NSString**)ret error:(NSError**)error __attribute__((nonnull (1))) {
	return _cpuBrand(ret);
}

+(BOOL) cpuFrequency:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1))) {
	return _cpuFrequency(ret);
}

+(BOOL) cpuL2Cache:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1))) {
	return _cpuL2Cache(ret);
}

+(BOOL) cpuL3Cache:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1))) {
	return _cpuL3Cache(ret);
}

+(BOOL) cpuArchitecture:(PFSystemKitCPUArches*)ret error:(NSError**)error __attribute__((nonnull (1))) {
	return _cpuArchitecture(ret);
}

+(BOOL) cpuVendor:(NSString**)ret __attribute__((nonnull (1))) {
	return _cpuVendor(ret);
}

+(BOOL) cpuCreateReport:(PFSystemCPUReport**)ret error:(NSError**)error __attribute__((nonnull (1))) {
	PFSystemKitError locResult;
	BOOL errorOccured;
	NSString* cpuVendor;
	NSString* cpuBrand;
	
	NSNumber* cpuThreads, cpuCores, cpuS, cpuFreq, cpuL2, cpul3;
	
	PFSystemKitCPUArches arch;
	
	locResult = _cpuVendor(&cpuVendor);
	if (locResult != PFSKReturnSuccess) {
		cpuVendor = @"-";
		errorOccured = 1;
	}
	
	locResult = _cpuBrand(&cpuBrand);
	if (locResult != PFSKReturnSuccess) {
		cpuBrand = @"-";
		errorOccured = 1;
	}
	
	locResult = _cpuArchitecture(&arch);
	if (locResult != PFSKReturnSuccess) {
		arch = PFSKCPUArchesUnknown;
		errorOccured = 1;
	}
	
	locResult = _cpuThreadCount(&cpuThreads);
	if (locResult != PFSKReturnSuccess) {
		cpuThreads = @(-1);
		errorOccured = 1;
	}
	
	locResult = _cpuCoreCount(&cpuCores);
	if (locResult != PFSKReturnSuccess) {
		cpuCores = @(-1);
		errorOccured = 1;
	}
	
	locResult = _cpuCount(&cpuS);
	if (locResult != PFSKReturnSuccess) {
		cpuS = @(-1);
		errorOccured = 1;
	}
	
	locResult = _cpuFrequency(&cpuFreq);
	if (locResult != PFSKReturnSuccess) {
		cpuFreq = @(-1);
		errorOccured = 1;
	}
	
	locResult = _cpuL2Cache(&cpuL2);
	if (locResult != PFSKReturnSuccess) {
		cpuL2 = @(-1);
		errorOccured = 1;
	}
	
	locResult = _cpuL3Cache(&cpuL3);
	if (locResult != PFSKReturnSuccess) {
		cpuL3 = @(-1);
		errorOccured = 1;
	}
	
	ret = [PFSystemCPUReport.alloc initWithCount:cpuS
										   brand:cpuBrand
									   coreCount:cpuCores
									 threadCount:cpuThreads
									   frequency:cpuFreq
											  l2:cpuL2
											  l3:cpuL3
									architecture:arch
										  vendor:cpuVendor];
	
	error = synthesizeError(locResult);
	if (result != PFSKReturnSuccess) {
		return false;
	}
	return true;
}

@end
