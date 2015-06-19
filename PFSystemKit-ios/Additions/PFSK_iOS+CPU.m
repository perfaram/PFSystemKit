//
//  PFSK_iOS+CPU.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 31/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_iOS+CPU.h"

@implementation PFSystemKit(CPU)
+(BOOL) cpuArchitecture:(PFSystemKitCPUArches*)ret subtype:(PFSystemKitCPUArchesARMTypes*)sub error:(NSError**)error __attribute__((nonnull (1,2)))
{
    CGFloat arch = 0;
    CGFloat archSub = 0;
    PFSystemKitError locResult;
    locResult = _sysctlFloatForKey((char*)"hw.cputype", arch);
    *error = synthesizeError(locResult);
    if (locResult != PFSKReturnSuccess) {
        *ret = PFSKCPUArchesUnknown;
        return false;
    }
    locResult = _sysctlFloatForKey((char*)"hw.cpusubtype", archSub);
    if (locResult != PFSKReturnSuccess) {
        *error = synthesizeError(locResult); //don't re-synthesize if both succeeded - saves a few cycles
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
