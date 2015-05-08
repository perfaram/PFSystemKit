//
//  PFSK_OSX.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
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
*/

+(PFSystemKitError) cpuBrand:(NSString**)ret __attribute__((nonnull (1)))
{
	std::string brand;
	PFSystemKitError locResult;
	locResult = [self.class sysctlStringForKey:(char*)"machdep.cpu.brand_string" intoSTDString:brand];
	if (locResult != PFSKReturnSuccess)
		goto finish;
	else
		*ret = [NSString stringWithSTDString:brand];
finish:
	return locResult;
}

+(PFSystemKitError) cpuFrequency:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat size = 0;
	PFSystemKitError result;
	result = [self.class sysctlFloatForKey:(char*)"hw.cpufrequency" intoFloat:size];
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(size/1000000000);//hertz in a gigahertz
finish:
	return result;
}

+(PFSystemKitError) cpuL2Cache:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat size = 0;
	PFSystemKitError result;
	result = [self.class sysctlFloatForKey:(char*)"hw.l2cachesize" intoFloat:size];
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(size/1048576);
finish:
	return result;
}

+(PFSystemKitError) cpuL3Cache:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat size = 0;
	PFSystemKitError result;
	result = [self.class sysctlFloatForKey:(char*)"hw.l3cachesize" intoFloat:size];
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(size/1048576);
finish:
	return result;
}

+(PFSystemKitError) memorySize:(NSNumber**)ret __attribute__((nonnull (1)))
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
	result = [self.class sysctlStringForKey:(char*)"hw.model" intoSTDString:machineModel];
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = [NSString stringWithSTDString:machineModel];
finish:
	return result;
}

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
