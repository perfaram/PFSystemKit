//
//  PFSystemKitRAMStatistics.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 18.06.15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSystemKitRAMReport.h"
#import "NSString+PFSKAdditions.h"
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/task_info.h>
#import <mach/task.h>

@implementation PFSystemKitRAMReport
@synthesize wired;
@synthesize active;
@synthesize inactive;
@synthesize free;
@synthesize total;
@synthesize stats;

BOOL getRAMSize(NSNumber Ind2_NNAR ret, NSError Ind2_NUAR error) {
    double size = 0;
    BOOL result = sysctlDoubleForKey((char*)"hw.memsize", size, error);
    if (!result) {
        *ret = @(-1);
        return false;
    }
    *ret = @(size/1073741824); //bytes to gibibytes ( https://en.wikipedia.org/wiki/Gibibyte )
    return true;

}

+(BOOL) size:(NSNumber Ind2_NNAR)ret error:(NSError Ind2_NUAR)error
{
    return getRAMSize(ret, error);
}

BOOL getRAMStatistics(PFSystemKitRAMStatistics *__nonnull ret, NSError Ind2_NUAR error) {
    /*
     * UNIX Wizardry : There be dragons
     */
    double pageSize = 0;
    BOOL result = sysctlDoubleForKey((char*)"hw.memsize", pageSize, error);
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
    llong wired = (vmstat.wire_count * pageSize) / bytesPerMB;
    llong active = (vmstat.active_count * pageSize) / bytesPerMB;
    llong inactive = (vmstat.inactive_count * pageSize) / bytesPerMB;
    llong free = (vmstat.free_count * pageSize) / bytesPerMB;
    
    *ret = PFSystemKitRAMStatisticsWithComponents(wired, active, inactive, free);
    return true;
}

+(BOOL) statistics:(PFSystemKitRAMStatistics *__nonnull)ret error:(NSError Ind2_NUAR)error
{
    return getRAMStatistics(ret, error);
}

-(instancetype) initWithError:(NSError Ind2_NUAR)error
{
    if (!(self = [super init])) {
        return nil;
    }
    
    BOOL locResult;
    BOOL errorOccured = false;
    
    NSNumber *ramSize;
    PFSystemKitRAMStatistics statistics;
    
    locResult = getRAMSize(&ramSize, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    locResult = getRAMStatistics(&statistics, error);
    if (locResult != PFSKReturnSuccess) {
        errorOccured = true;
    }
    
    total = ramSize;
    wired = @(stats.wired);
    active = @(stats.active);
    inactive = @(stats.inactive);
    free = @(stats.free);
    stats = statistics;
    return self;
}
@end
