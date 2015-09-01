//
//  PFSK_OSX+GPU.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 13/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_OSX+GPU.h"
#import "PCI.h"
@implementation PFSystemKit(GPU)
-(BOOL)graphicsCreateReport:(GPUArray Ind2_NNAR)ret error:(NSError Ind2_NUAR)finError
{
    NSMutableArray *temp = [NSMutableArray array];
    io_iterator_t itThis;
    io_service_t service;
    io_service_t parent;
    io_name_t name;
    kern_return_t result;
    PFSystemKitError locError = PFSKReturnSuccess;
    
    if (IOServiceGetMatchingServices(masterPort, IOServiceMatching("AtiFbStub"), &itThis) == KERN_SUCCESS) {
        NSMutableDictionary *card;
        int ports = 0;
        unsigned long long _old = 0;
        unsigned long long _new = 0;
        service = 1;
        while(service) {
            service = IOIteratorNext(itThis);
            if (!card && !service) break;
            IORegistryEntryGetParentEntry(service, kIOServicePlane, &parent);
            IORegistryEntryGetRegistryEntryID(parent, &_new);
            if (card && _new!=_old){
                [card setObject:@(ports) forKey:@"ports"];
                [temp addObject:[card copy]];
                card = nil;
                ports = 0;
            }
            if (!card && service) {
                result = IORegistryEntryGetRegistryEntryID(parent, &_old);
                result = IORegistryEntryGetName(service, name);
                if (result!=kIOReturnSuccess) {
                    locError = PFSKReturnIOKitError;
                    continue;
                }
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
        unsigned long long _old = 0;
        unsigned long long _new = 0;
        service = 1;
        while(service) {
            service = IOIteratorNext(itThis);
            if (!card && !service) break;
            IORegistryEntryGetParentEntry(service, kIOServicePlane, &parent);
            IORegistryEntryGetRegistryEntryID(parent, &_new);
            if (card && _new!=_old){
                [card setObject:@(ports) forKey:@"ports"];
                [temp addObject:[card copy]];
                card = nil;
                ports = 0;
            }
            if (!card && service) {
                io_service_t child;
                result = IORegistryEntryGetChildEntry(service, kIOServicePlane, &child);
                result = IORegistryEntryGetRegistryEntryID(parent, &_old);
                result = IORegistryEntryGetName(child, name);
                if (result!=kIOReturnSuccess) {
                    locError = PFSKReturnIOKitError;
                    continue;
                }
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
        unsigned long long _old = 0;
        unsigned long long _new = 0;
        service = 1;
        while(service) {
            service = IOIteratorNext(itThis);
            if (!card && !service) break;
            /*result = */IORegistryEntryGetParentEntry(service, kIOServicePlane, &parent);
            /*if (result!=kIOReturnSuccess) {
             _error = PFSKReturnIOKitError;
             _extError = result;
             //continue;
             }*/
            /*result = */IORegistryEntryGetRegistryEntryID(parent, &_new);
            /*if (result!=kIOReturnSuccess) {
             _error = PFSKReturnIOKitError;
             _extError = result;
             //continue;
             }*/
            if (card && _new!=_old){
                [card setObject:@(ports) forKey:@"ports"];
                [temp addObject:[card copy]];
                card = nil;
                ports = 0;
            }
            if (!card && service) {
                io_service_t child;
                result = IORegistryEntryGetChildEntry(parent, kIOServicePlane, &child);
                result = IORegistryEntryGetRegistryEntryID(parent, &_old);
                if (result!=kIOReturnSuccess) {
                    locError = PFSKReturnIOKitError;
                    continue;
                }
                NSUInteger framebuffer = [[pciDevice grabNumber:CFSTR("AAPL,ig-platform-id") forService:parent] longValue];
                if (framebuffer) sprintf(name, "0x%08lX", framebuffer);
                else result = IORegistryEntryGetName(child, name);
                if (result!=kIOReturnSuccess) {
                    locError = PFSKReturnIOKitError;
                    continue;
                }
                card = [@{@"device":[pciDevice create:parent], @"model":[pciDevice grabString:CFSTR("model") forService:parent], @"framebuffer":@(name)} mutableCopy];
                IOObjectRelease(child);
            }
            ports++;
            IOObjectRelease(parent);
            IOObjectRelease(service);
        }
        IOObjectRelease(itThis);
    }
    *ret = [temp copy];
    if (finError)
        *finError = synthesizeError(locError);
    if ([temp count] <= 0) {
        return false;
    }
    return true;
}

+(BOOL)graphicsCreateReport:(GPUArray Ind2_NNAR)ret error:(NSError Ind2_NUAR)finError
{
	NSMutableArray *temp = [NSMutableArray array];
	io_iterator_t itThis;
	io_service_t service;
	io_service_t parent;
	io_name_t name;
	kern_return_t result;
    PFSystemKitError locError = PFSKReturnSuccess;
	
	if (IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("AtiFbStub"), &itThis) == KERN_SUCCESS) {
		NSMutableDictionary *card;
		int ports = 0;
		unsigned long long _old = 0;
		unsigned long long _new = 0;
		service = 1;
		while(service) {
			service = IOIteratorNext(itThis);
			if (!card && !service) break;
			IORegistryEntryGetParentEntry(service, kIOServicePlane, &parent);
			IORegistryEntryGetRegistryEntryID(parent, &_new);
			if (card && _new!=_old){
				[card setObject:@(ports) forKey:@"ports"];
				[temp addObject:[card copy]];
				card = nil;
				ports = 0;
			}
			if (!card && service) {
				result = IORegistryEntryGetRegistryEntryID(parent, &_old);
				result = IORegistryEntryGetName(service, name);
				if (result!=kIOReturnSuccess) {
					locError = PFSKReturnIOKitError;
					continue;
				}
				card = [@{@"device":[pciDevice create:parent], @"model":[pciDevice grabString:CFSTR("model") forService:parent], @"framebuffer":@(name)} mutableCopy];
			}
			ports++;
			IOObjectRelease(parent);
			IOObjectRelease(service);
		}
		IOObjectRelease(itThis);
	}
	if (IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IONDRVDevice"), &itThis) == KERN_SUCCESS){
		NSMutableDictionary *card;
		int ports = 0;
		unsigned long long _old = 0;
		unsigned long long _new = 0;
		service = 1;
		while(service) {
			service = IOIteratorNext(itThis);
			if (!card && !service) break;
			IORegistryEntryGetParentEntry(service, kIOServicePlane, &parent);
			IORegistryEntryGetRegistryEntryID(parent, &_new);
			if (card && _new!=_old){
				[card setObject:@(ports) forKey:@"ports"];
				[temp addObject:[card copy]];
				card = nil;
				ports = 0;
			}
			if (!card && service) {
				io_service_t child;
				result = IORegistryEntryGetChildEntry(service, kIOServicePlane, &child);
				result = IORegistryEntryGetRegistryEntryID(parent, &_old);
				result = IORegistryEntryGetName(child, name);
				if (result!=kIOReturnSuccess) {
					locError = PFSKReturnIOKitError;
					continue;
				}
				card = [@{@"device":[pciDevice create:parent], @"model":[pciDevice grabString:CFSTR("model") forService:parent], @"framebuffer":@(name)} mutableCopy];
				IOObjectRelease(child);
			}
			ports++;
			IOObjectRelease(parent);
			IOObjectRelease(service);
		}
		IOObjectRelease(itThis);
	}
	if (IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("AppleIntelFramebuffer"), &itThis) == KERN_SUCCESS){
		NSMutableDictionary *card;
		int ports = 0;
		unsigned long long _old = 0;
		unsigned long long _new = 0;
		service = 1;
		while(service) {
			service = IOIteratorNext(itThis);
			if (!card && !service) break;
			/*result = */IORegistryEntryGetParentEntry(service, kIOServicePlane, &parent);
			/*if (result!=kIOReturnSuccess) {
				_error = PFSKReturnIOKitError;
				_extError = result;
				//continue;
			 }*/
			/*result = */IORegistryEntryGetRegistryEntryID(parent, &_new);
			/*if (result!=kIOReturnSuccess) {
				_error = PFSKReturnIOKitError;
				_extError = result;
				//continue;
			 }*/
			if (card && _new!=_old){
				[card setObject:@(ports) forKey:@"ports"];
				[temp addObject:[card copy]];
				card = nil;
				ports = 0;
			}
			if (!card && service) {
				io_service_t child;
				result = IORegistryEntryGetChildEntry(parent, kIOServicePlane, &child);
				result = IORegistryEntryGetRegistryEntryID(parent, &_old);
				if (result!=kIOReturnSuccess) {
					locError = PFSKReturnIOKitError;
					continue;
				}
				NSUInteger framebuffer = [[pciDevice grabNumber:CFSTR("AAPL,ig-platform-id") forService:parent] longValue];
				if (framebuffer) sprintf(name, "0x%08lX", framebuffer);
				else result = IORegistryEntryGetName(child, name);
				if (result!=kIOReturnSuccess) {
					locError = PFSKReturnIOKitError;
					continue;
				}
				card = [@{@"device":[pciDevice create:parent], @"model":[pciDevice grabString:CFSTR("model") forService:parent], @"framebuffer":@(name)} mutableCopy];
				IOObjectRelease(child);
			}
			ports++;
			IOObjectRelease(parent);
			IOObjectRelease(service);
		}
		IOObjectRelease(itThis);
	}
	*ret = [temp copy];
    if (finError)
        *finError = synthesizeError(locError);
    if ([temp count] <= 0) {
        return false;
    }
	return true;
}
@end
