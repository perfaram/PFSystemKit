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

+(PFSystemKitError) cpuCount:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat count = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"hw.packages", count);
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(count);
finish:
	return result;
}

+(PFSystemKitError) cpuCoreCount:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat count = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"machdep.cpu.core_count", count);
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(count);
finish:
	return result;
}

+(PFSystemKitError) cpuThreadCount:(NSNumber**)ret __attribute__((nonnull (1)))
{
	CGFloat count = 0;
	PFSystemKitError result;
	result = _sysctlFloatForKey((char*)"machdep.cpu.thread_count", count);
	if (result != PFSKReturnSuccess)
		goto finish;
	else
		*ret = @(count);
finish:
	return result;
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

+(PFSystemKitError)systemEndianness:(PFSystemKitEndianness*)ret __attribute__((nonnull (1)))
{
	CGFloat order = 0;
	PFSystemKitError locResult;
	locResult = _sysctlFloatForKey((char*)"hw.byteorder", order);
	if (locResult != PFSKReturnSuccess) {
		//memcpy(ret, (const int*)PFSKEndiannessUnknown, sizeof(PFSystemKitEndianness*));
		*ret = PFSKEndiannessUnknown;
		goto finish;
	}
	else {
		if (order == 1234) {
			//memcpy(ret, (const int*)PFSKEndiannessLittleEndian, sizeof(PFSystemKitEndianness*));
			*ret = PFSKEndiannessLittleEndian;
		} else if (order == 4321) {
			//memcpy(ret, (const int*)PFSKEndiannessBigEndian, sizeof(PFSystemKitEndianness*));
			*ret = PFSKEndiannessBigEndian;
		} else {
			//memcpy(ret, (const int*)PFSKEndiannessUnknown, sizeof(PFSystemKitEndianness*));
			*ret = PFSKEndiannessUnknown;
		}
		goto finish;
	}
finish:
	return locResult;
}

+(PFSystemKitError) cpuBrand:(NSString**)ret __attribute__((nonnull (1)))
{
	std::string brand;
	PFSystemKitError locResult;
	locResult = _sysctlStringForKey((char*)"machdep.cpu.brand_string", brand);
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
	result = _sysctlFloatForKey((char*)"hw.cpufrequency", size);
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
	result = _sysctlFloatForKey((char*)"hw.l2cachesize", size);
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
	result = _sysctlFloatForKey((char*)"hw.l3cachesize", size);
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
	result = _sysctlFloatForKey((char*)"hw.memsize", size);
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
	result = _sysctlStringForKey((char*)"hw.model", machineModel);
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
