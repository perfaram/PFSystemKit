//
//  PFSK_OSX.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <sys/sysctl.h>
#import <string>
#import "NSString+CPPAdditions.h"
#import "PFSK_OSX.h"

io_connect_t conn;
static mach_port_t   		masterPort;
static io_registry_entry_t 	nvrEntry;
static io_registry_entry_t 	pexEntry;
static io_registry_entry_t 	smcEntry;
static io_registry_entry_t 	romEntry;

@interface PFSK_Common()
//+(PFSystemKitError) sysctlStringForKey:(char*)key intoChar:(std::string&)answerChar;
//+(PFSystemKitError) sysctlFloatForKey:(char*)key intoFloat:(CGFloat&)answerFloat;
@end

@implementation PFSystemKit
#pragma mark - Singleton pattern
/**
 * PFSystemKit singleton instance retrieval method
 */
+(instancetype) investigate{
	static id sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	
	return sharedInstance;
}


#pragma mark - Class methods (actual core code)

+(NSString *) cpuCount
{
	size_t len = 0;
	sysctlbyname("hw.packages", NULL, &len, NULL, 0);
	if (len)
	{
		int count = 0;
		sysctlbyname("hw.packages", &count, &len, NULL, 0);
		NSString* coreCount = [NSString stringWithFormat:@"%i", count];
		return coreCount;
	}
	return @"-"; //in case count can't be read
}

+(NSString *) coreCount
{
	size_t len = 0;
	sysctlbyname("machdep.cpu.core_count", NULL, &len, NULL, 0);
	if (len)
	{
		int count = 0;
		sysctlbyname("machdep.cpu.core_count", &count, &len, NULL, 0);
		NSString* coreCount = [NSString stringWithFormat:@"%i", count];
		return coreCount;
	}
	return @"-"; //in case count can't be read
}

+(NSString *) threadCount
{
	size_t len = 0;
	sysctlbyname("machdep.cpu.thread_count", NULL, &len, NULL, 0);
	if (len)
	{
		int count = 0;
		sysctlbyname("machdep.cpu.thread_count", &count, &len, NULL, 0);
		NSString* coreCount = [NSString stringWithFormat:@"%i", count];
		return coreCount;
	}
	return @"-"; //in case count can't be read
}

+(NSString*) cpuType {
	size_t size;
	cpu_type_t type;
	size = sizeof(type);
	sysctlbyname("hw.cputype", &type, &size, NULL, 0);
	
	// values for cputype and cpusubtype defined in mach/machine.h
	if (type == CPU_TYPE_X86)
	{
		if (type == CPU_TYPE_X86_64)
			return @"x86_64";
		return @"x86";
		
	} else if (type == CPU_TYPE_POWERPC)
	{
		if (type == CPU_TYPE_POWERPC64)
			return @"PowerPC_64";
		return @"PowerPC";
	} else if (type == CPU_TYPE_I860)
	{
		return @"i860";
	}
	return @"Unknown";
}
/*
+(PFSystemKitEndianness)systemEndianness {
	size_t len = 0;
	sysctlbyname("hw.byteorder", NULL, &len, NULL, 0);
	
	if (len)
	{
		char *end = malloc(len*sizeof(char));
		sysctlbyname("hw.byteorder", end, &len, NULL, 0);
		NSString *endStr = [NSString stringWithUTF8String:end];
		free(end);
		if ([endStr isEqualToString:@"1234"]) {
			return PFSKEndiannessLittleEndian;
		} else if (1) check{
			return PFSKEndiannessBigEndian;
		} else {
			return PFSKEndiannessUnknown;
		}
	}
	return PFSKEndiannessUnknown;
}

+(NSString*) cpuVendor {
	host_basic_info_data_t hostInfo;
	mach_msg_type_number_t infoCount;
	
	infoCount = HOST_BASIC_INFO_COUNT;
	kern_return_t ret = host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
	
	if ((KERN_SUCCESS == ret) && (hostInfo.cpu_type == CPU_TYPE_POWERPC)) {
		return @"IBM PowerPC";
	}
	
	size_t len = 0;
	sysctlbyname("machdep.cpu.vendor", NULL, &len, NULL, 0);
	
	if (len)
	{
		char *model = malloc(len*sizeof(char));
		sysctlbyname("machdep.cpu.vendor", model, &len, NULL, 0);
		NSString *model_ns = [NSString stringWithUTF8String:model];
		free(model);
		return model_ns;
	}
	
	return @"-";
}

+(NSString *) cpuBrandString
{
	size_t len = 0;
	sysctlbyname("machdep.cpu.brand_string", NULL, &len, NULL, 0);
	
	if (len)
	{
		char *model = malloc(len*sizeof(char));
		sysctlbyname("machdep.cpu.brand_string", model, &len, NULL, 0);
		NSString *model_ns = [NSString stringWithUTF8String:model];
		free(model);
		return model_ns;
	}
	
	return @"-";
}
*/
+(NSString *) cpuFrequency
{
	size_t len = 0;
	sysctlbyname("hw.l2cachesize", NULL, &len, NULL, 0);
	if (len)
	{
		int freq = 0;
		sysctlbyname("hw.l2cachesize", &freq, &len, NULL, 0);
		NSString* cpuFreq = [NSString stringWithFormat:@"%i", freq];
		return cpuFreq;
	}
	return @"-";
}

+(NSString *) cpuL2Cache
{
	size_t len = 0;
	sysctlbyname("hw.l2cachesize", NULL, &len, NULL, 0);
	if (len)
	{
		int cache = 0;
		sysctlbyname("hw.l2cachesize", &cache, &len, NULL, 0);
		NSString* cpuL2 = [NSString stringWithFormat:@"%i", cache];
		return cpuL2;
	}
	return @"-";
}

+(NSString *) cpuL3Cache
{
	size_t len = 0;
	sysctlbyname("hw.l3cachesize", NULL, &len, NULL, 0);
	if (len)
	{
		int cache = 0;
		sysctlbyname("hw.l3cachesize", &cache, &len, NULL, 0);
		NSString* cpuL3 = [NSString stringWithFormat:@"%i", cache];
		return cpuL3;
	}
	return @"-";
}

+(PFSystemKitError) memSize:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat size = 0;
	PFSystemKitError result;
	result = [self.class sysctlFloatForKey:(char*)"hw.memsize" intoFloat:size];
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(size/1073741824);
finish:
	return result;
}

+(PFSystemKitError) machineModel:(NSString**)ret __attribute__((nonnull (1)))
{
	std::string machineModel;
	PFSystemKitError result;
	result = [self.class sysctlStringForKey:(char*)"hw.model" intoChar:machineModel];
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = [NSString stringWithSTDString:machineModel];
finish:
	return result;
}

/*+(PFSystemKitError) machineModel:(NSString**)ret __attribute__((nonnull (1)))
{
	size_t len = 0;
	sysctlbyname("hw.model", NULL, &len, NULL, 0);
	
	if (len)
	{
		char *model = new char[len];
		sysctlbyname("hw.model", model, &len, NULL, 0);
		*ret = [NSString stringWithUTF8String:model];
		return PFSKReturnSuccess;
	}
	
//finish:
	return PFSKReturnSysCtlError;
}*/

#pragma mark - Getters
@synthesize family;
@synthesize familyString;
@synthesize version;
@synthesize versionString;
@synthesize endianness;
@synthesize endiannessString;
@synthesize model;


#pragma mark - NSObject std methods

-(void) finalize { //cleanup everything
	IOObjectRelease(nvrEntry);
	IOObjectRelease(pexEntry);
	IOObjectRelease(smcEntry);
	IOObjectRelease(romEntry);
	[super finalize];
	return;
}

-(void) dealloc {
	//[super dealloc];
}

-(id) init {
	self = [super init];
	if (self) {
		_writeLockState = PFSKLockStateLocked;
		_error = PFSKReturnUnknown;
		_extError = 0;
		
		kern_return_t IOresult;
		IOresult = IOMasterPort(bootstrap_port, &masterPort);
		if (IOresult!=kIOReturnSuccess) {
			_error = PFSKReturnNoMasterPort;
			_extError = IOresult;
			return nil;
		}
		
		BOOL REFresult = [self refresh];
		if (REFresult!=true) {
			//error/extError already setted
			return nil;
		}
	}
	return self;
}
@end
