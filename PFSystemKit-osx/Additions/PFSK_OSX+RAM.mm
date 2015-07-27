//
//  PFSK_OSX+RAM.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 11/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_OSX+RAM.h"
#import "NSString+PFSKAdditions.h"
#import <string>
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/task_info.h>
#import <mach/task.h>

@implementation PFSystemKit(RAM)

+(BOOL) ramSize:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error 
{
    CGFloat size = 0;
    PFSystemKitError locResult;
    locResult = _sysctlFloatForKey((char*)"hw.memsize", size);
    *error = synthesizeError(locResult);
    if (locResult != PFSKReturnSuccess) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1073741824); //bytes to gibibytes ( https://en.wikipedia.org/wiki/Gibibyte )
    return true;
}

+(BOOL) ramStatistics:(PFSystemRAMStatistics Ind2_NNAR)ret error:(NSError Ind2_NUAR)error 
{
    CGFloat pageSize = 0;
    PFSystemKitError result;
    result = _sysctlFloatForKey((char*)"hw.pagesize", pageSize);
    *error = synthesizeError(PFSKReturnSuccess);
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    vm_statistics_data_t vmstat;
    kern_return_t hostResult = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t) &vmstat, &count);
    if (hostResult != KERN_SUCCESS) {
        *error = synthesizeErrorExt(PFSKReturnIOKitError, hostResult);
        return false;
    }
    
    task_basic_info_64_data_t infof;
    unsigned size = sizeof (infof);
    task_info(mach_task_self(), TASK_BASIC_INFO_64, (task_info_t)&infof, &size); //don't check for success, black magic incoming
    
    const double bytesPerMB = 1024 * 1024;
    long long wired = (vmstat.wire_count * pageSize) / bytesPerMB;
    long long active = (vmstat.active_count * pageSize) / bytesPerMB;
    long long inactive = (vmstat.inactive_count * pageSize) / bytesPerMB;
    long long free = (vmstat.free_count * pageSize) / bytesPerMB;
    *ret = [PFSystemRAMStatistics.alloc initWithWired:@(wired) active:@(active) inactive:@(inactive) free:@(free)];
    return true;
}
@end
