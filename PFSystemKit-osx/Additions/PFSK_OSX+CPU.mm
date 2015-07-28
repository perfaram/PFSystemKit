//
//  PFSK_OSX(CPU).m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_OSX+CPU.h"
#import "NSString+PFSKAdditions.h"
#import <string>

@implementation PFSystemKit(CPU)

+(BOOL) cpuCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    double count = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.packages", count, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(count);
    return true;
}

+(BOOL) cpuCoreCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    double count = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"machdep.cpu.core_count", count, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(count);
    return true;
}

+(BOOL) cpuThreadCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    double count = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"machdep.cpu.thread_count", count, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(count);
    return true;
}

+(BOOL) cpuBrand:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    BOOL result = sysctlNSStringForKeySynthesizing((char*)"machdep.cpu.brand_string", ret, error);
    if (!result) {
        *ret = @"-";
        return false;
    }
    return true;
}

+(BOOL) cpuFrequency:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    double freq = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.cpufrequency", freq, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(freq/1000000000);
    return true;
}

+(BOOL) cpuL2Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    double size = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.l2cachesize", size, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1048576);
    return true;
}

+(BOOL) cpuL3Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    double size = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.l3cachesize", size, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1048576);
    return true;
}

+(BOOL) cpuArchitecture:(PFSystemKitCPUArches*__nonnull)ret error:(NSError Ind2_NUAR)error {
    double arch = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.cputype", arch, error);
    if (!result) {
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

+(BOOL) cpuVendor:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    BOOL result = sysctlNSStringForKeySynthesizing((char*)"machdep.cpu.vendor", ret, error);
    if (!result) {
        *ret = @"-";
        return false;
    }
    return true;
}

+(BOOL) cpuCreateReport:(PFSystemCPUReport Ind2_NNAR)ret error:(NSError Ind2_NUAR)error //we don't care about having multiple errors, since they're all the same kind.
{
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
