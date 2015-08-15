//
//  PFSK_iOS+RAM.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 12.08.15.
//
//

#import "PFSK_iOS+RAM.h"
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/task_info.h>
#import <mach/task.h>

@implementation PFSystemKit(RAM)

+(BOOL) ramSize:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    double size = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.memsize", size, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1073741824); //bytes to gibibytes ( https://en.wikipedia.org/wiki/Gibibyte )
    return true;
}

+(BOOL) ramStatistics:(PFSystemRAMStatistics Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    double pageSize = 0;
    BOOL result = sysctlDoubleForKeySynthesizing((char*)"hw.memsize", pageSize, error);
    if (!result) {
        return false;
    }
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    vm_statistics_data_t vmstat;
    kern_return_t hostResult = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t) &vmstat, &count);
    if (hostResult != KERN_SUCCESS) {
        if (error)
            *error = synthesizeErrorExtIO(PFSKReturnIOKitError, hostResult);
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
