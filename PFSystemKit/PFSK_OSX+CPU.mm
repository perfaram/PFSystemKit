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

+(PFSystemKitError) cpuType:(PFSystemKitArches*)ret __attribute__((nonnull (1))) {
	CGFloat arch = 0;
	PFSystemKitError locResult;
	locResult = _sysctlFloatForKey((char*)"hw.cputype", arch);
	if (locResult != PFSKReturnSuccess) {
		//memcpy(ret, (const int*)PFSKEndiannessUnknown, sizeof(PFSystemKitEndianness*));
		*ret = PFSystemKitArchesUnknown;
		goto finish;
	}
	else {
		// values for cputype and cpusubtype defined in mach/machine.h
		if (arch == CPU_TYPE_X86)
		{
			if (arch == CPU_TYPE_X86_64)
				*ret = PFSystemKitArchesX86_64;
			*ret = PFSystemKitArchesX86;
		} else if (arch == CPU_TYPE_POWERPC)
		{
			if (arch == CPU_TYPE_POWERPC64)
				*ret = PFSystemKitArchesPPC_64;
			*ret = PFSystemKitArchesPPC;
		} else if (arch == CPU_TYPE_I860)
		{
			*ret = PFSystemKitArchesI860;
		}
		goto finish;
	}
finish:
	return locResult;
}

@end
