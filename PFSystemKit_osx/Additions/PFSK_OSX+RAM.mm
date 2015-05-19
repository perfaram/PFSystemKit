//
//  PFSK_OSX+RAM.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 11/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_OSX+CPU.h"
#import "NSString+CPPAdditions.h"
#import <string>
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/task_info.h>
#import <mach/task.h>

@implementation PFSystemKit(RAM)
-(NSNumber*) memorySize {
	NSNumber* ret = [NSNumber.alloc init];
	_error = [self.class memorySize:&ret];
	val4Key("ramSize", ret);
	return ret;
}

-(NSDictionary*) memoryStats {
	NSDictionary* ret = [NSDictionary.alloc init];
	_error = [self.class memoryStats:&ret];
	val4Key("ramStats", ret);
	return ret;
}

+(PFSystemKitError) memorySize:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat size = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"hw.memsize", size);
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(size/1073741824);
finish:
	return result;
}

+(PFSystemKitError) memoryStats:(NSDictionary**)ret __attribute__((nonnull (1)))
{
	CGFloat pageSize = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"hw.pagesize", pageSize);
	
	mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
	vm_statistics_data_t vmstat;
	if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t) &vmstat, &count) != KERN_SUCCESS) {
		return PFSKReturnIOKitError;
	}
	
	task_basic_info_64_data_t infof;
	unsigned size = sizeof (infof);
	task_info(mach_task_self(), TASK_BASIC_INFO_64, (task_info_t)&infof, &size);

	const double bytesPerMB = 1024 * 1024;
	long long total = ((vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count) * pageSize) / bytesPerMB;
	long long wired = (vmstat.wire_count * pageSize) / bytesPerMB;
	long long active = (vmstat.active_count * pageSize) / bytesPerMB;
	long long inactive = (vmstat.inactive_count * pageSize) / bytesPerMB;
	long long free = (vmstat.free_count * pageSize) / bytesPerMB;
	*ret = [NSDictionary dictionaryWithObjectsAndKeys:@(total), @"total", @(wired), @"wired", @(active), @"active", @(inactive), @"inactive", @(free), @"free", nil];
	return PFSKReturnSuccess;
}
@end
