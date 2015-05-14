//
//  PFSK_OSX.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <sys/sysctl.h>
#import <CoreFoundation/CoreFoundation.h>
#import <string>
#import <vector>
#import "NSString+CPPAdditions.h"
#import "PFSKHelper.h"
#import "PFSK_OSX.h"
#import "PFSK_OSX+CPU.h"
#import "PFSK_OSX+GPU.h"
#import "PFSK_OSX+RAM.h"

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
	//@synchronized;
	return sharedInstance;
}


#pragma mark - Class methods (actual core code)

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

-(BOOL) refreshGroup:(PFSystemKitGroup)group {
	kern_return_t result;
	switch (group) {
		case PFSKGroupPlatformExpertDevice: {
			CFMutableDictionaryRef pexProps = NULL;
			pexEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("IOPlatformExpertDevice"));
			if (pexEntry == 0) {
				_error = PFSKReturnComponentUnavailable;
				return false;
			}
			result = IORegistryEntryCreateCFProperties(pexEntry, &pexProps, NULL, 0);
			if (result!=kIOReturnSuccess) {
				_error = PFSKReturnIOKitCFFailure;
				_extError = result;
				return false;
			} else {
				platformExpert = (__bridge NSDictionary*)pexProps;
				[self setValue:[platformExpert objectForKey:@"model"] forKey:@"model"];
				[self setValue:[platformExpert objectForKey:@"board-id"] forKey:@"boardID"];
				[self setValue:[platformExpert objectForKey:@kIOPlatformSerialNumberKey] forKey:@"serial"];
				[self setValue:[platformExpert objectForKey:@kIOPlatformUUIDKey] forKey:@"platformID"];
				//not related to expert device, but looks good here ;)
				val4Key("ramSize", [self memorySize]);
				val4Key("ramStats", [self memoryStats]);
				val4Key("cpuReport", [self cpuReport]);
				
			}
			CFRelease(pexProps);
		}
		/*case PFSKGroupROM: {
			CFMutableDictionaryRef romProps = NULL;
			romEntry = IORegistryEntryFromPath(masterPort, "IODeviceTree:/rom@0");
			if (romEntry == 0) {
				_error = PFSKReturnComponentUnavailable;
				return false;
			}
			result = IORegistryEntryCreateCFProperties(romEntry, &romProps, NULL, 0);
			if (result!=kIOReturnSuccess) {
				_error = PFSKReturnIOKitCFFailure;
				_extError = result;
				return false;
			} else {
				[self setValue:[NSString.alloc initWithData:(__bridge NSData*)CFDictionaryGetValue(romProps, "version") encoding:NSASCIIStringEncoding] forKey:@"romVersion"]; //wtf
				NSString* dateStr = [NSString.alloc initWithData:(__bridge NSData*)CFDictionaryGetValue(romProps, "release-date") encoding:NSASCIIStringEncoding];//(__bridge NSString*)CFDictionaryGetValue(romProps, "release-date")
				//[self setValue:[PFSKHelper parseDate:dateStr format:@"MM/dd/yy"] forKey:@"romReleaseDate"];
				NSDateComponents* romDateComps = [NSDateComponents.alloc init];
				NSArray* romDateStrSplitted = [dateStr componentsSeparatedByString:@"/"];
				[romDateComps setMonth:[[romDateStrSplitted objectAtIndex:0] integerValue]];
				[romDateComps setDay:[[romDateStrSplitted objectAtIndex:1] integerValue]];
				[romDateComps setYear:(2000+[[romDateStrSplitted objectAtIndex:2] integerValue])];
				[self setValue:[[NSCalendar currentCalendar] dateFromComponents:romDateComps] forKey:@"romReleaseDate"];
			}
			CFRelease(romProps);
		}
		case PFSKGroupNVRam: {
			CFMutableDictionaryRef 		nvrProps;
			nvrEntry = IORegistryEntryFromPath(masterPort, "IODeviceTree:/options");
			if (nvrEntry == 0) {
				_error = PFSKReturnComponentUnavailable;
				return false;
			}
			result = IORegistryEntryCreateCFProperties(nvrEntry, &nvrProps, NULL, 0);
			if (result!=kIOReturnSuccess) {
				_error = PFSKReturnIOKitCFFailure;
				_extError = result;
				return false;
			} else {
				[self setValue:[NSMutableDictionary.alloc init] forKey:@"nvramDict"];
				[(__bridge NSDictionary*)nvrProps enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
					NSString* representation = [NSString stringWithUTF8String:(const char*)[obj bytes]];
					if (representation!=nil) {
						[[self valueForKey:@"nvramDict"] setObject:representation forKey:key];
					} else {
						[[self valueForKey:@"nvramDict"] setObject:obj forKey:key];
					}
				}];
			}
			CFRelease(nvrProps);
		}
		case PFSKGroupSMC: {
			CFMutableDictionaryRef smcProps = NULL;
			smcEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("AppleSMC"));
			if (smcEntry == 0) {
				_error = PFSKReturnComponentUnavailable;
				return false;
			}
			
			result = IORegistryEntryCreateCFProperties(smcEntry, &smcProps, NULL, 0);
			if (result!=kIOReturnSuccess) {
				_error = PFSKReturnIOKitCFFailure;
				_extError = result;
				return false;
			} else {
				val4Key("smcVersion", (__bridge NSString*)CFDictionaryGetValue(smcProps, "smc-version"));
				[self setValue:(__bridge NSNumber*)CFDictionaryGetValue(smcProps, "SleepCause") forKey:@"sleepCause"];
				[self setValue:(__bridge NSNumber*)CFDictionaryGetValue(smcProps, "ShutdownCause") forKey:@"shutdownCause"];
			}
			CFRelease(smcProps);
		}
		case PFSKGroupGraphics: {
			[self setValue:[self listGraphics] forKey:@"graphics"];
		}
		case PFSKGroupLMU: {
			
		}
		case PFSKGroupTerminator: { //just in case
			;//return U MAD BRO
		}*/
	}
	_error = PFSKReturnSuccess;
	return true;
}

-(BOOL) refresh {
	BOOL ref = 0;
//	return [self refreshGroup:PFSKGroupPlatformExpertDevice];
	std::vector<PFSystemKitGroup> vGroups;
	for ( auto i = vGroups.begin(); i != vGroups.end(); i++ ) {
		ref = [self refreshGroup:*i]; //refresh data for each.
		if (ref!=true) { //It failed, so we
			break; //stop there
		}
	}
	
	if (ref!=true) { //we had to break because of error, we
		return false;//return false
	} else { //everything is good, we
		return true;//are happy !
	}
}

#pragma mark - Getters
@synthesize family;
@synthesize familyString;
@synthesize version;
@synthesize versionString;
@synthesize endianness;
@synthesize endiannessString;
@synthesize model;
@synthesize serial;

@synthesize boardID;
@synthesize platformID;
@synthesize ramSize;
@synthesize ramStats;
@synthesize cpuReport;


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
		
		/*BOOL REFresult = [self refresh];
		if (REFresult!=true) {
			//error/extError already setted
			return nil;
		}*/
	}
	return self;
}
@end
