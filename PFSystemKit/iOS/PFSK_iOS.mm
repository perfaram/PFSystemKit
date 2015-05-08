//
//  PFSK_iOS.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import "PFSK_iOS.h"

@implementation PFSystemKit

+(BOOL)isJailbroken{ //objc_copyImageNames() "can't" be fooled (checks for MobileSubstrate)
	
#if !(TARGET_IPHONE_SIMULATOR)
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]){
		return YES;
	}else if([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]){
		return YES;
	}else if([[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"]){
		return YES;
	}else if([[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"]){
		return YES;
	}else if([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"]){
		return YES;
	}
	
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]){
		return YES;
	}
	
	FILE *f = fopen("/bin/bash", "r");
	if (f != NULL) {
		fclose(f);
		return YES;
	}
	fclose(f);
	f = fopen("/Applications/Cydia.app", "r");
	if (f != NULL) {
		fclose(f);
		return YES;
	}
	fclose(f);
	f = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r");
	if (f != NULL) {
		fclose(f);
		return YES;
	}
	fclose(f);
	f = fopen("/etc/apt", "r");
	if (f != NULL) {
		fclose(f);
		return YES;
	}
	fclose(f);
	
#endif
	
	//All checks have failed. Most probably, the device is not jailbroken
	return NO;
}

+(NSString*)getCPUType
{
	NSMutableString *cpu = [[NSMutableString alloc] init];
	size_t size;
	cpu_type_t type;
	cpu_subtype_t subtype;
	size = sizeof(type);
	sysctlbyname("hw.cputype", &type, &size, NULL, 0);
	
	size = sizeof(subtype);
	sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
	
	// values for cputype and cpusubtype defined in mach/machine.h
	if (type == CPU_TYPE_ARM)
	{
		[cpu appendString:@"ARM "];
		switch(subtype)
		{
			case CPU_SUBTYPE_ARM_V7:
				[cpu appendString:@"V7"];
				break;
			case CPU_SUBTYPE_ARM_V4T:
				[cpu appendString:@"V4T"];
				break;
			case CPU_SUBTYPE_ARM_V6:
				[cpu appendString:@"V6"];
				break;
			case CPU_SUBTYPE_ARM_V5TEJ:
				[cpu appendString:@"V5TEJ"];
				break;
			case CPU_SUBTYPE_ARM_XSCALE:
				[cpu appendString:@"XSCALE"];
				break;
			case CPU_SUBTYPE_ARM_V7S:
				[cpu appendString:@"V7S"];
				break;
			case CPU_SUBTYPE_ARM_V7F:
				[cpu appendString:@"V7F"];
				break;
			case CPU_SUBTYPE_ARM_V7K:
				[cpu appendString:@"V7K"];
				break;
			case CPU_SUBTYPE_ARM_V6M:
				[cpu appendString:@"V6M"];
				break;
			case CPU_SUBTYPE_ARM_V7M:
				[cpu appendString:@"V7M"];
				break;
			case CPU_SUBTYPE_ARM_V7EM:
				[cpu appendString:@"V7EM"];
				break;
			case CPU_SUBTYPE_ARM_V8:
				[cpu appendString:@"V8"];
				break;
			case CPU_SUBTYPE_ARM_ALL:
				break;
		}
	} else if (type == CPU_TYPE_ARM64)
	{
		[cpu appendString:@"ARM "];
		switch(subtype)
		{
			case CPU_SUBTYPE_ARM_V8:
				[cpu appendString:@"V8"];
				break;
			case CPU_SUBTYPE_ARM_ALL:
				break;
		}
	}
	return cpu;
}

@end
