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

__attribute__((always_inline)) PFSystemKitError _cpuCreateReport(NSMutableDictionary** ret) {
	PFSystemKitError locResult;
	BOOL errorOccured;
	NSString* tempStr;
	NSNumber* tempNum;
	PFSystemKitCPUArches arch;
	
	locResult = _cpuVendor(&tempStr);
	if (locResult != PFSKReturnSuccess) {
		[*ret setObject:@"-" forKey:@"vendor"];
		errorOccured = 1;
	}
	else
		[*ret setObject:tempStr forKey:@"vendor"];
	
	locResult = _cpuBrand(&tempStr);
	if (locResult != PFSKReturnSuccess) {
		[*ret setObject:@"-" forKey:@"brand"];
		errorOccured = 1;
	}
	else
		[*ret setObject:tempStr forKey:@"brand"];
	
	locResult = _cpuArchitecture(&arch);
	if (locResult != PFSKReturnSuccess) {
		[*ret setObject:@"-" forKey:@"architecture"];
		errorOccured = 1;
	}
	else
		[*ret setObject:_cpuArchToString(arch) forKey:@"architecture"];
	
	locResult = _cpuThreadCount(&tempNum);
	if (locResult != PFSKReturnSuccess) {
		[*ret setObject:@"-" forKey:@"threads"];
		errorOccured = 1;
	}
	else
		[*ret setObject:tempNum forKey:@"threads"];
	
	locResult = _cpuCoreCount(&tempNum);
	if (locResult != PFSKReturnSuccess) {
		[*ret setObject:@"-" forKey:@"cores"];
		errorOccured = 1;
	}
	else
		[*ret setObject:tempNum forKey:@"cores"];
	
	locResult = _cpuCount(&tempNum);
	if (locResult != PFSKReturnSuccess) {
		[*ret setObject:@"-" forKey:@"cpus"];
		errorOccured = 1;
	}
	else
		[*ret setObject:tempNum forKey:@"cpus"];
	
	locResult = _cpuFrequency(&tempNum);
	if (locResult != PFSKReturnSuccess) {
		[*ret setObject:@"-" forKey:@"frequency"];
		errorOccured = 1;
	}
	else
		[*ret setObject:tempNum forKey:@"frequency"];
	
	locResult = _cpuL2Cache(&tempNum);
	if (locResult != PFSKReturnSuccess) {
		[*ret setObject:@"-" forKey:@"l2cache"];
		errorOccured = 1;
	}
	else
		[*ret setObject:tempNum forKey:@"l2cache"];
	
	locResult = _cpuL3Cache(&tempNum);
	if (locResult != PFSKReturnSuccess) {
		[*ret setObject:@"-" forKey:@"l3cache"];
		errorOccured = 1;
	}
	else
		[*ret setObject:tempNum forKey:@"l3cache"];
	
finish:
	return locResult;
}

-(NSDictionary*) cpuCreateReport {
	NSMutableDictionary* ret = [NSMutableDictionary.alloc init];
	_error = _cpuCreateReport(&ret);
	[self setValue:[ret copy] forKey:@"cpuReport"];
	return [ret copy]; //ensure immutability
}

-(NSNumber*) cpuCount {
	NSNumber* ret = [NSNumber.alloc init];
	_error = _cpuCount(&ret);
	return ret;
}

-(NSString*) cpuBrand {
	NSString* ret = [NSString.alloc init];
	_error = _cpuBrand(&ret);
	return ret;
}

-(NSNumber*) cpuCoreCount {
	NSNumber* ret = [NSNumber.alloc init];
	_error = _cpuCoreCount(&ret);
	return ret;
}

-(NSNumber*) cpuThreadCount {
	NSNumber* ret = [NSNumber.alloc init];
	_error = _cpuThreadCount(&ret);
	return ret;
}

-(NSNumber*) cpuFrequency {
	NSNumber* ret = [NSNumber.alloc init];
	_error = _cpuFrequency(&ret);
	return ret;
}

-(NSNumber*) cpuL2Cache {
	NSNumber* ret = [NSNumber.alloc init];
	_error = _cpuL2Cache(&ret);
	return ret;
}

-(NSNumber*) cpuL3Cache {
	NSNumber* ret = [NSNumber.alloc init];
	_error = _cpuL3Cache(&ret);
	return ret;
}

-(PFSystemKitCPUArches) cpuArchitecture {
	PFSystemKitCPUArches ret;
	_error = _cpuArchitecture(&ret);
	return ret;
}
-(NSString*) cpuVendor {
	NSString* ret = [NSString.alloc init];
	_error = _cpuVendor(&ret);
	return ret;
}

+(PFSystemKitError) cpuCount:(NSNumber**)ret __attribute__((nonnull (1))) {
	return _cpuCount(ret);
}

+(PFSystemKitError) cpuCoreCount:(NSNumber**)ret __attribute__((nonnull (1))) {
	return _cpuCoreCount(ret);
}

+(PFSystemKitError) cpuThreadCount:(NSNumber**)ret __attribute__((nonnull (1))) {
	return _cpuThreadCount(ret);
}

+(PFSystemKitError) cpuBrand:(NSString**)ret __attribute__((nonnull (1))) {
	return _cpuBrand(ret);
}

+(PFSystemKitError) cpuFrequency:(NSNumber**)ret __attribute__((nonnull (1))) {
	return _cpuFrequency(ret);
}

+(PFSystemKitError) cpuL2Cache:(NSNumber**)ret __attribute__((nonnull (1))) {
	return _cpuL2Cache(ret);
}

+(PFSystemKitError) cpuL3Cache:(NSNumber**)ret __attribute__((nonnull (1))) {
	return _cpuL3Cache(ret);
}

+(PFSystemKitError) cpuArchitecture:(PFSystemKitCPUArches*)ret __attribute__((nonnull (1))) {
	return _cpuArchitecture(ret);
}

+(PFSystemKitError) cpuVendor:(NSString**)ret __attribute__((nonnull (1))) {
	return _cpuVendor(ret);
}

+(PFSystemKitError) cpuCreateReport:(NSMutableDictionary**)ret __attribute__((nonnull (1))) {
	return _cpuCreateReport(ret);
}

@end
