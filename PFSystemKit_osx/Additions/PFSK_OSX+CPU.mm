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

+(BOOL) cpuCount:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1,2))) {
    CGFloat count = 0;
    PFSystemKitError locResult;
    locResult = _sysctlFloatForKey((char*)"hw.packages", count);
    *error = synthesizeError(locResult);
    if (locResult != PFSKReturnSuccess) {
        *ret = @(-1);
        return false;
    }
    *ret = @(count);
    return true;
}

+(BOOL) cpuCoreCount:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1,2))) {
    CGFloat count = 0;
    PFSystemKitError locResult;
    locResult = _sysctlFloatForKey((char*)"machdep.cpu.core_count", count);
    *error = synthesizeError(locResult);
    if (locResult != PFSKReturnSuccess) {
        *ret = @(-1);
        return false;
    }
    *ret = @(count);
    return true;
}

+(BOOL) cpuThreadCount:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1,2))) {
    CGFloat count = 0;
    PFSystemKitError locResult;
    locResult = _sysctlFloatForKey((char*)"machdep.cpu.thread_count", count);
    *error = synthesizeError(locResult);
    if (locResult != PFSKReturnSuccess) {
        *ret = @(-1);
        return false;
    }
    *ret = @(count);
    return true;
}

+(BOOL) cpuBrand:(NSString**)ret error:(NSError**)error __attribute__((nonnull (1,2))) {
    std::string brand;
    PFSystemKitError locResult;
    locResult = _sysctlStringForKey((char*)"machdep.cpu.brand_string", brand);
    *error = synthesizeError(locResult);
    if (locResult != PFSKReturnSuccess) {
        *ret = @"-";
        return false;
    }
    *ret = [NSString stringWithSTDString:brand];
    return true;
}

+(BOOL) cpuFrequency:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1,2))) {
    CGFloat size = 0;
    PFSystemKitError locResult;
    locResult = _sysctlFloatForKey((char*)"hw.cpufrequency", size);
    *error = synthesizeError(locResult);
    if (locResult != PFSKReturnSuccess) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1000000000);//hertz in a gigahertz
    return true;
}

+(BOOL) cpuL2Cache:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1,2))) {
    CGFloat size = 0;
    PFSystemKitError locResult;
    locResult = _sysctlFloatForKey((char*)"hw.l2cachesize", size);
    *error = synthesizeError(locResult);
    if (locResult != PFSKReturnSuccess) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1048576);
    return true;
}

+(BOOL) cpuL3Cache:(NSNumber**)ret error:(NSError**)error __attribute__((nonnull (1,2))) {
    CGFloat size = 0;
    PFSystemKitError locResult;
    locResult = _sysctlFloatForKey((char*)"hw.l3cachesize", size);
    *error = synthesizeError(locResult);
    if (locResult != PFSKReturnSuccess) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1048576);
    return true;
}

+(BOOL) cpuArchitecture:(PFSystemKitCPUArches*)ret error:(NSError**)error __attribute__((nonnull (1,2))) {
    CGFloat arch = 0;
    PFSystemKitError locResult;
    locResult = _sysctlFloatForKey((char*)"hw.cputype", arch);
    *error = synthesizeError(locResult);
    if (locResult != PFSKReturnSuccess) {
        *ret = PFSKCPUArchesUnknown;
        return false;
    }
    // values for cputype and cpusubtype defined in mach/machine.h
    if (arch == CPU_TYPE_X86) {
        if (arch == CPU_TYPE_X86_64)
            *ret = PFSKCPUArchesX86_64;
        *ret = PFSKCPUArchesX86;
    } else if (arch == CPU_TYPE_POWERPC) {
        if (arch == CPU_TYPE_POWERPC64)
            *ret = PFSKCPUArchesPPC_64;
        *ret = PFSKCPUArchesPPC;
    } else if (arch == CPU_TYPE_I860) {
        *ret = PFSKCPUArchesI860;
    }
    return true;
}

+(BOOL) cpuVendor:(NSString**)ret error:(NSError**)error __attribute__((nonnull (1,2))) {
    std::string vendor;
    PFSystemKitError locResult;
    locResult = _sysctlStringForKey((char*)"machdep.cpu.vendor", vendor);
    *error = synthesizeError(locResult);
    if (locResult != PFSKReturnSuccess) {
        *ret = @"-";
        return false;
    }
    *ret = [NSString stringWithSTDString:vendor];
    return true;
}

+(BOOL) cpuCreateReport:(PFSystemCPUReport**)ret error:(NSError**)error __attribute__((nonnull (1))) {
    BOOL locResult;
    BOOL errorOccured = false;
    
    NSString *cpuVendor, *cpuBrand;
    NSNumber *cpuThreads, *cpuCores, *cpuS, *cpuFreq, *cpuL2, *cpuL3;
	PFSystemKitCPUArches arch;
	
	locResult = [self cpuVendor:&cpuVendor error:error];
	if (locResult != true) {
		cpuVendor = @"-";
		errorOccured = true;
	}
	
	locResult = [self cpuBrand:&cpuBrand error:error];
	if (locResult != PFSKReturnSuccess) {
		cpuBrand = @"-";
		errorOccured = true;
	}
	
	locResult = [self cpuArchitecture:&arch error:error];
	if (locResult != PFSKReturnSuccess) {
		arch = PFSKCPUArchesUnknown;
        errorOccured = true;
	}
	
	locResult = [self cpuThreadCount:&cpuThreads error:error];
	if (locResult != PFSKReturnSuccess) {
		cpuThreads = @(-1);
		errorOccured = true;
	}
	
	locResult = [self cpuCoreCount:&cpuCores error:error];
	if (locResult != PFSKReturnSuccess) {
		cpuCores = @(-1);
		errorOccured = true;
	}
	
	locResult = [self cpuCount:&cpuS error:error];
	if (locResult != PFSKReturnSuccess) {
		cpuS = @(-1);
		errorOccured = true;
	}
	
	locResult = [self cpuFrequency:&cpuFreq error:error];
	if (locResult != PFSKReturnSuccess) {
		cpuFreq = @(-1);
		errorOccured = true;
	}
	
	locResult = [self cpuL2Cache:&cpuL2 error:error];
	if (locResult != PFSKReturnSuccess) {
		cpuL2 = @(-1);
		errorOccured = true;
	}
	
	locResult = [self cpuL3Cache:&cpuL3 error:error];
	if (locResult != PFSKReturnSuccess) {
		cpuL3 = @(-1);
		errorOccured = true;
	}
	
	*ret = [PFSystemCPUReport.alloc initWithCount:cpuS
										   brand:cpuBrand
									   coreCount:cpuCores
									 threadCount:cpuThreads
									   frequency:cpuFreq
											  l2:cpuL2
											  l3:cpuL3
									architecture:arch
										  vendor:cpuVendor];
	
	if (errorOccured != false) {
		return false;
	}
	return true;
}

@end
