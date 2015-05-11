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

@implementation PFSystemKit(RAM)
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
@end
