//
//  PFSK_OSX(CPU).m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSystemKitCPUReport.h"
#import "NSString+PFSKAdditions.h"
#import <string>

@implementation PFSystemKitCPUReport
@synthesize brand;
@synthesize vendor;
@synthesize count;
@synthesize coreCount;
#if !TARGET_OS_IPHONE
@synthesize threadCount;
@synthesize frequency;
#endif
#if TARGET_OS_IPHONE
@synthesize L1ICache;
@synthesize L1DCache;
#endif
@synthesize L2Cache;
#if !TARGET_OS_IPHONE
@synthesize L3Cache;
#endif
@synthesize architecture;
#if TARGET_OS_IPHONE
@synthesize subType;
#endif

#pragma mark ———Common———
BOOL getCPUCount(NSNumber Ind2_NNAR ret, NSError Ind2_NUAR error) {
    double count = 0;
    BOOL result = sysctlDoubleForKey((char*)"hw.packages", count, error);
    if (!result) {
#if ERRORS_USE_COMMON_SENSE
        *ret = @(1); // 1 CPU is sooo likely
#else
        *ret = @(-1);
#endif
        return false;
    }
    *ret = @(count);
    return true;
}

+(BOOL) count:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    return getCPUCount(ret, error);
}

#if !TARGET_OS_IPHONE
BOOL getCPUCoreCount(NSNumber Ind2_NNAR ret, NSError Ind2_NUAR error) {
    double count = 0;
    BOOL result = sysctlDoubleForKey((char*)"machdep.cpu.core_count", count, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(count);
    return true;
}
#else
BOOL getCPUCoreCount(NSNumber Ind2_NNAR ret, NSError Ind2_NUAR error) {
    double count = 0;
    BOOL result = sysctlDoubleForKey((char*)"hw.ncpu", count, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(count);
    return true;
}
#endif

+(BOOL) coreCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    return getCPUCoreCount(ret, error);
}

BOOL getCPUL2Cache(NSNumber Ind2_NNAR ret, NSError Ind2_NUAR error) {
    double size = 0;
    BOOL result = sysctlDoubleForKey((char*)"hw.l2cachesize", size, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1048576);
    return true;
}

+(BOOL) L2Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    return getCPUL2Cache(ret, error);
}

#pragma mark ———OSX———
#if !TARGET_OS_IPHONE
BOOL getCPUVendor(NSString Ind2_NNAR ret, NSError Ind2_NUAR error) {
    BOOL result = sysctlNSStringForKey((char*)"machdep.cpu.vendor", ret, error);
    if (!result) {
#if ERRORS_USE_COMMON_SENSE
        *ret = @"GenuineIntel"; // PPC aren't supported by PFSK, and hackintoshes running under AMD are quite rare
        return true; //That's a lie
#else
        *ret = @"-";
        return false;
#endif
    }
    return true;
}

+(BOOL) vendor:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    return getCPUVendor(ret, error);
}

BOOL getCPUBrand(NSString Ind2_NNAR ret, NSError Ind2_NUAR error) {
    BOOL result = sysctlNSStringForKey((char*)"machdep.cpu.brand_string", ret, error);
    if (!result) {
        *ret = @"-";
        return false;
    }
    return true;
}

+(BOOL) brand:(NSString Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    return getCPUBrand(ret, error);
}

BOOL getCPUThreadCount(NSNumber Ind2_NNAR ret, NSError Ind2_NUAR error) {
    double count = 0;
    BOOL result = sysctlDoubleForKey((char*)"machdep.cpu.thread_count", count, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(count);
    return true;
}

+(BOOL) threadCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    return getCPUThreadCount(ret, error);
}

BOOL getCPUFrequency(NSNumber Ind2_NNAR ret, NSError Ind2_NUAR error) {
    double freq = 0;
    BOOL result = sysctlDoubleForKey((char*)"hw.cpufrequency", freq, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(freq/1000000000);
    return true;
}

+(BOOL) frequency:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    return getCPUFrequency(ret, error);
}

BOOL getCPUL3Cache(NSNumber Ind2_NNAR ret, NSError Ind2_NUAR error) {
    double size = 0;
    BOOL result = sysctlDoubleForKey((char*)"hw.l3cachesize", size, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1048576);
    return true;
}

+(BOOL) L3Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error  {
    return getCPUL3Cache(ret, error);
}

BOOL getCPUArchitecture(PFSystemKitCPUArches*__nonnull ret, NSError Ind2_NUAR error) {
    double arch = 0;
    BOOL result = sysctlDoubleForKey((char*)"hw.cputype", arch, error);
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

+(BOOL) architecture:(PFSystemKitCPUArches*__nonnull)ret error:(NSError Ind2_NUAR)error {
    return getCPUArchitecture(ret, error);
}
#endif
#pragma mark ———IOS———
#if TARGET_OS_IPHONE
BOOL getCPUFeature(PFSystemKitCPUARMFeatures feature, BOOL* ret, NSError Ind2_NUAR error) {
    char* selector;
    switch (feature) {
        case PFSKCPUARMFeaturesFloatingPoint:
            selector = (char*)"hw.optional.floatingpoint";
            break;
        case PFSKCPUARMFeaturesVector:
            selector = (char*)"hw.vectorunit";
            break;
        case PFSKCPUARMFeaturesShortVector:
            selector = (char*)"hw.optional.vfp_shortvector";
            break;
        case PFSKCPUARMFeaturesNeon:
            selector = (char*)"hw.optional.neon";
            break;
        case PFSKCPUARMFeaturesNeonHPFP:
            selector = (char*)"hw.optional.neon_hpfp";
            break;
        default:
            if (error)
                *error = synthesizeError(PFSKReturnInvalidSelector);
            return false;
            break;
    }
    
    double hasFeat = 0;
    BOOL result = sysctlDoubleForKey(selector, hasFeat, error);
    if (!result) {
        return false;
    }
    
    switch (feature) {
        case PFSKCPUARMFeaturesFloatingPoint:
        case PFSKCPUARMFeaturesVector:
        case PFSKCPUARMFeaturesShortVector:
        case PFSKCPUARMFeaturesNeon:
        case PFSKCPUARMFeaturesNeonHPFP:
            if (hasFeat == 1)
                *ret = TRUE;
            break;
        default:
            if (error)
                *error = synthesizeError(PFSKReturnInvalidSelector);
            return false;
            break;
    }
    return true;
}

+(BOOL) hasFeature:(PFSystemKitCPUARMFeatures)feature toNumber:(BOOL*__nonnull)ret error:(NSError Ind2_NUAR)error {
    return getCPUFeature(feature, ret, error);
}

BOOL getCPUL1ICache(NSNumber Ind2_NNAR ret, NSError Ind2_NUAR error) {
    double size = 0;
    BOOL result = sysctlDoubleForKey((char*)"hw.l1icachesize", size, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1048576);
    return true;
}

+(BOOL) L1ICache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error {
    return getCPUL1ICache(ret, error);
}

BOOL getCPUL1DCache(NSNumber Ind2_NNAR ret, NSError Ind2_NUAR error) {
    double size = 0;
    BOOL result = sysctlDoubleForKey((char*)"hw.l1dcachesize", size, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1048576);
    return true;
}

+(BOOL) L1DCache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error {
    return getCPUL1DCache(ret, error);
}

BOOL getCPUL1Cache(NSNumber Ind2_NNAR ret, NSError Ind2_NUAR error) {
    double sizeI, sizeD = 0;
    BOOL result = sysctlDoubleForKey((char*)"hw.l1icachesize", sizeI, error);
    result = sysctlDoubleForKey((char*)"hw.l1dcachesize", sizeD, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(sizeI+sizeD/1048576);
    return true;
}

+(BOOL) L1Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error {
    return getCPUL1Cache(ret, error);
}

BOOL getCPUArchitecture(PFSystemKitCPUArches *__nonnull ret, PFSystemKitCPUArchesARMTypes*__nonnull sub, NSError Ind2_NUAR error) {
    double arch = 0;
    double archSubD = 0;
    BOOL result = sysctlDoubleForKey((char*)"hw.cputype", arch, error);
    if (!result) {
        *ret = PFSKCPUArchesUnknown;
        return false;
    }
    result = sysctlDoubleForKey((char*)"hw.cpusubtype", archSubD, error);
    int archSub = (int)archSubD;
    if (!result) {
        *ret = PFSKCPUArchesUnknown;
        return false;
    }
    // values for cputype and cpusubtype defined in mach/machine.h
    if (arch == CPU_TYPE_ARM) {
        *ret = PFSKCPUArchesARM;
        switch(archSub)
        {
            case CPU_SUBTYPE_ARM_V7:
                *sub = PFSKCPUArchesARM_V7;
                break;
            case CPU_SUBTYPE_ARM_V4T:
                *sub = PFSKCPUArchesARM_V4T;
                break;
            case CPU_SUBTYPE_ARM_V6:
                *sub = PFSKCPUArchesARM_V6;
                break;
            case CPU_SUBTYPE_ARM_V5TEJ:
                *sub = PFSKCPUArchesARM_V5TEJ;
                break;
            case CPU_SUBTYPE_ARM_XSCALE:
                *sub = PFSKCPUArchesARM_XSCALE;
                break;
            case CPU_SUBTYPE_ARM_V7S:
                *sub = PFSKCPUArchesARM_V7S;
                break;
            case CPU_SUBTYPE_ARM_V7F:
                *sub = PFSKCPUArchesARM_V7F;
                break;
            case CPU_SUBTYPE_ARM_V7K:
                *sub = PFSKCPUArchesARM_V7K;
                break;
            case CPU_SUBTYPE_ARM_V6M:
                *sub = PFSKCPUArchesARM_V6M;
                break;
            case CPU_SUBTYPE_ARM_V7M:
                *sub = PFSKCPUArchesARM_V7M;
                break;
            case CPU_SUBTYPE_ARM_V7EM:
                *sub = PFSKCPUArchesARM_V7EM;
                break;
            case CPU_SUBTYPE_ARM_V8:
                *sub = PFSKCPUArchesARM_V8;
                break;
            case CPU_SUBTYPE_ARM_ALL:
                *sub = PFSKCPUArchesARM_Unknown;
                break;
        }
    } else if (arch == CPU_TYPE_ARM64) {
        *ret = PFSKCPUArchesARM_64;
        switch(archSub)
        {
            case CPU_SUBTYPE_ARM_V8:
                *sub = PFSKCPUArchesARM_V8;
                break;
            case CPU_SUBTYPE_ARM_ALL:
                *sub = PFSKCPUArchesARM_Unknown;
                break;
        }
    }
    return true;
}

+(BOOL) architecture:(PFSystemKitCPUArches*__nonnull)ret subtype:(PFSystemKitCPUArchesARMTypes*__nonnull)sub error:(NSError Ind2_NUAR)error {
    return getCPUArchitecture(ret, sub, error);
}
#endif

#pragma mark ———INIT———

-(instancetype) initWithError:(NSError Ind2_NUAR)error //we don't care about having multiple errors, since they're all the same kind.
{
    if (!(self = [super init])) {
        return nil;
    }
    
    BOOL locResult;
    BOOL errorOccured = false;
    
    NSNumber *cpuS, *cpuCores, *cpuL2;
    
    locResult = getCPUCount(&cpuS, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    locResult = getCPUCoreCount(&cpuCores, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    locResult = getCPUL2Cache(&cpuL2, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    count = cpuS;
    coreCount = cpuCores;
    L2Cache = cpuL2;
    
#if !TARGET_OS_IPHONE
    NSString *cpuVendor, *cpuBrand;
    NSNumber *cpuThreads, *cpuFreq, *cpuL3;
    PFSystemKitCPUArches arch;
    
    locResult = getCPUVendor(&cpuVendor, error);
    if (locResult != true) {
        errorOccured = true;
    }
    
    locResult = getCPUBrand(&cpuBrand, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    locResult = getCPUThreadCount(&cpuThreads, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    locResult = getCPUFrequency(&cpuFreq, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    locResult = getCPUL3Cache(&cpuL3, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    locResult = getCPUArchitecture(&arch, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    vendor = cpuVendor;
    brand = cpuBrand;
    threadCount = cpuThreads;
    frequency = cpuFreq;
    L3Cache = cpuL3;
    architecture = arch;
    
#else
    
    NSNumber *l1i, *l1d, *l1,
    PFSystemKitCPUArches arch;
    PFSystemKitCPUArchesARMTypes type;
    PFSystemKitCPUARMFeatures feats;
    
    locResult = getCPUL1ICache(&l1i, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    locResult = getCPUL1DCache(&l1d, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    locResult = getCPUL1Cache(&l1, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    locResult = getCPUArchitecture(&arch, &type, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    L1ICache = l1i;
    L1DCache = l1d;
    L1Cache = l1;
    architecture = arch;
    subType = type;
    
#endif
    
    return self;
}
@end
