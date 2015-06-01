//
//  NSProcessInfo+MacAddress.m
//
//  Created by John Winter <john@aptonic.com>
//  MIT License
//

#import "NSProcessInfo+MACAddress.h"
#import <IOKit/IOKitLib.h>
#import <IOKit/network/IOEthernetInterface.h>
#import <IOKit/network/IONetworkInterface.h>
#import <IOKit/network/IOEthernetController.h>

static kern_return_t FindEthernetInterfaces(io_iterator_t *matchingServices)
{
	kern_return_t		kernResult;
	CFMutableDictionaryRef	matchingDict;
	CFMutableDictionaryRef	propertyMatchDict;
	
	matchingDict = IOServiceMatching(kIOEthernetInterfaceClass);
	
	if (NULL == matchingDict) {
		printf("IOServiceMatching returned a NULL dictionary.\n");
	}
	else {
		
		propertyMatchDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0,
													  &kCFTypeDictionaryKeyCallBacks,
													  &kCFTypeDictionaryValueCallBacks);
		
		if (NULL == propertyMatchDict) {
			printf("CFDictionaryCreateMutable returned a NULL dictionary.\n");
		}
		else {
			CFDictionarySetValue(propertyMatchDict, CFSTR(kIOPrimaryInterface), kCFBooleanTrue);
			
			CFDictionarySetValue(matchingDict, CFSTR(kIOPropertyMatchKey), propertyMatchDict);
			CFRelease(propertyMatchDict);
		}
	}
	
	kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, matchingServices);
	if (KERN_SUCCESS != kernResult) {
		printf("IOServiceGetMatchingServices returned 0x%08x\n", kernResult);
	}
	
	return kernResult;
}

static kern_return_t GetMACAddress(io_iterator_t intfIterator, UInt8 *MACAddress, UInt8 bufferSize)
{
	io_object_t		intfService;
	io_object_t		controllerService;
	kern_return_t	kernResult = KERN_FAILURE;
	
	if (bufferSize < kIOEthernetAddressSize) {
		return kernResult;
	}
	
	bzero(MACAddress, bufferSize);
	while ((intfService = IOIteratorNext(intfIterator)))
	{
		CFTypeRef	MACAddressAsCFData;
		kernResult = IORegistryEntryGetParentEntry(intfService,
												   kIOServicePlane,
												   &controllerService);
		
		if (KERN_SUCCESS != kernResult) {
			printf("IORegistryEntryGetParentEntry returned 0x%08x\n", kernResult);
		}
		else {
			MACAddressAsCFData = IORegistryEntryCreateCFProperty(controllerService,
																 CFSTR(kIOMACAddress),
																 kCFAllocatorDefault,
																 0);
			if (MACAddressAsCFData) {
				//CFShow(MACAddressAsCFData);
				
				CFDataGetBytes(MACAddressAsCFData, CFRangeMake(0, kIOEthernetAddressSize), MACAddress);
				CFRelease(MACAddressAsCFData);
			}
			
			(void) IOObjectRelease(controllerService);
		}
		
		(void) IOObjectRelease(intfService);
	}
	
	return kernResult;
}

@implementation NSProcessInfo(MacAddress)
+(NSString*) macAddress {
	kern_return_t	kernResult = KERN_SUCCESS;
	io_iterator_t	intfIterator;
	UInt8			MACAddress[kIOEthernetAddressSize];
	
	kernResult = FindEthernetInterfaces(&intfIterator);
	
	if (KERN_SUCCESS != kernResult) {
		printf("FindEthernetInterfaces returned 0x%08x\n", kernResult);
	}
	else {
		kernResult = GetMACAddress(intfIterator, MACAddress, sizeof(MACAddress));
		
		if (KERN_SUCCESS != kernResult) {
			printf("GetMACAddress returned 0x%08x\n", kernResult);
		}
		else {
			char buffer[500];
			
			sprintf(buffer, "%02x%02x%02x%02x%02x%02x",
					MACAddress[0], MACAddress[1], MACAddress[2], MACAddress[3], MACAddress[4], MACAddress[5]);
			
			NSString*macAddress = [NSString stringWithUTF8String:buffer];
			return macAddress;
		}
	}
	
	(void)IOObjectRelease(intfIterator);	// Release the iterator.
	
	return nil;
}

@end