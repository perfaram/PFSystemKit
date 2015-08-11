//
//  PFSK_iOS+CPU.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 31/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_iOS+CPU.h"
#import <mach/machine.h>

@implementation PFSystemKit(CPU)
+(BOOL) cpuCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    double count = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.packages", count, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(count);
    return true;
}

+(BOOL) cpuCoreCount:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    double count = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.ncpu", count, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(count);
    return true;
}

+(BOOL) cpuHasFeature:(PFSystemKitCPUARMFeatures)feature toNumber:(BOOL*)ret error:(NSError Ind2_NUAR)error
{
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
            *error = synthesizeError(PFSKReturnInvalidSelector);
            return false;
            break;
    }
    
    double hasFeat = 0;
    BOOL result = sysctlDoubleForKeySynthesizing(selector, hasFeat, error);
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
            *error = synthesizeError(PFSKReturnInvalidSelector);
            return false;
            break;
    }
    return true;
}

+(BOOL) cpuL1ICache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    double size = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.l1icachesize", size, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1048576);
    return true;
}

+(BOOL) cpuL1DCache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    double size = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.l1dcachesize", size, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1048576);
    return true;
}

+(BOOL) cpuL1Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    double sizeI, sizeD = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.l1icachesize", sizeI, error);
    result = sysctlDoubleForKeySynthesizing((char*)"hw.l1dcachesize", sizeD, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(sizeI+sizeD/1048576);
    return true;
}

+(BOOL) cpuL2Cache:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    double size = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.l2cachesize", size, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1048576);
    return true;
}

+(BOOL) cpuArchitecture:(PFSystemKitCPUArches*__nonnull)ret subtype:(PFSystemKitCPUArchesARMTypes*__nonnull)sub error:(NSError Ind2_NUAR)error
{
    double arch = 0;
    double archSubD = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.cputype", arch, error);
    if (!result) {
        *ret = PFSKCPUArchesUnknown;
        return false;
    }
    result = sysctlDoubleForKeySynthesizing((char*)"hw.cpusubtype", archSubD, error);
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
@end
