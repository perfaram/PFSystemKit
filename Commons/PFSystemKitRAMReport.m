//
//  PFSystemKitRAMStatistics.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 18.06.15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSystemKitRAMReport.h"

@implementation PFSystemKitRAMReport
@synthesize wired;
@synthesize active;
@synthesize inactive;
@synthesize free;

-(instancetype) initWithWired:(NSNumber*)wiredLocal
                       active:(NSNumber*)activeLocal
                     inactive:(NSNumber*)inactiveLocal
                         free:(NSNumber*)freeLocal

{
    if (!(self = [super init])) {
        return nil;
    }
    wired = wiredLocal;
    active = activeLocal;
    inactive = inactiveLocal;
    free = freeLocal;
    return self;
}
@end
