//
//  PFSK_OSX+GPU.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 13/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_OSX+GPU.h"
#import "PFSystemKit/PCI.h"

@implementation PFSystemKit(GPU)
-(NSArray *)listGraphics
{
	NSMutableArray *temp = [NSMutableArray array];
	io_iterator_t itThis;
	io_service_t service;
	io_service_t parent;
	io_name_t name;
	
	if (IOServiceGetMatchingServices(masterPort, IOServiceMatching("AtiFbStub"), &itThis) == KERN_SUCCESS) {
		NSMutableDictionary *card;
		int ports = 0;
		unsigned long long old = 0;
		unsigned long long new = 0;
		service = 1;
		while(service) {
			service = IOIteratorNext(itThis);
			if (!card && !service) break;
			IORegistryEntryGetParentEntry(service, kIOServicePlane, &parent);
			IORegistryEntryGetRegistryEntryID(parent, &new);
			if (card && new!=old){
				[card setObject:@(ports) forKey:@"ports"];
				[temp addObject:[card copy]];
				card = nil;
				ports = 0;
			}
			if (!card && service) {
				IORegistryEntryGetRegistryEntryID(parent, &old);
				IORegistryEntryGetName(service, name);
				card = [@{@"device":[pciDevice create:parent], @"model":[pciDevice grabString:CFSTR("model") forService:parent], @"framebuffer":@(name)} mutableCopy];
			}
			ports++;
			IOObjectRelease(parent);
			IOObjectRelease(service);
		}
		IOObjectRelease(itThis);
	}
	if (IOServiceGetMatchingServices(masterPort, IOServiceMatching("IONDRVDevice"), &itThis) == KERN_SUCCESS){
		NSMutableDictionary *card;
		int ports = 0;
		unsigned long long old = 0;
		unsigned long long new = 0;
		service = 1;
		while(service) {
			service = IOIteratorNext(itThis);
			if (!card && !service) break;
			IORegistryEntryGetParentEntry(service, kIOServicePlane, &parent);
			IORegistryEntryGetRegistryEntryID(parent, &new);
			if (card && new!=old){
				[card setObject:@(ports) forKey:@"ports"];
				[temp addObject:[card copy]];
				card = nil;
				ports = 0;
			}
			if (!card && service) {
				io_service_t child;
				IORegistryEntryGetChildEntry(service, kIOServicePlane, &child);
				IORegistryEntryGetRegistryEntryID(parent, &old);
				IORegistryEntryGetName(child, name);
				card = [@{@"device":[pciDevice create:parent], @"model":[pciDevice grabString:CFSTR("model") forService:parent], @"framebuffer":@(name)} mutableCopy];
				IOObjectRelease(child);
			}
			ports++;
			IOObjectRelease(parent);
			IOObjectRelease(service);
		}
		IOObjectRelease(itThis);
	}
	if (IOServiceGetMatchingServices(masterPort, IOServiceMatching("AppleIntelFramebuffer"), &itThis) == KERN_SUCCESS){
		NSMutableDictionary *card;
		int ports = 0;
		unsigned long long old = 0;
		unsigned long long new = 0;
		service = 1;
		while(service) {
			service = IOIteratorNext(itThis);
			if (!card && !service) break;
			IORegistryEntryGetParentEntry(service, kIOServicePlane, &parent);
			IORegistryEntryGetRegistryEntryID(parent, &new);
			if (card && new!=old){
				[card setObject:@(ports) forKey:@"ports"];
				[temp addObject:[card copy]];
				card = nil;
				ports = 0;
			}
			if (!card && service) {
				io_service_t child;
				IORegistryEntryGetChildEntry(parent, kIOServicePlane, &child);
				IORegistryEntryGetRegistryEntryID(parent, &old);
				NSUInteger framebuffer = [[pciDevice grabNumber:CFSTR("AAPL,ig-platform-id") forService:parent] longValue];
				if (framebuffer) sprintf(name, "0x%08lX", framebuffer);
				else IORegistryEntryGetName(child, name);
				card = [@{@"device":[pciDevice create:parent], @"model":[pciDevice grabString:CFSTR("model") forService:parent], @"framebuffer":@(name)} mutableCopy];
				IOObjectRelease(child);
			}
			ports++;
			IOObjectRelease(parent);
			IOObjectRelease(service);
		}
		IOObjectRelease(itThis);
	}
	return [temp copy];
}
@end
