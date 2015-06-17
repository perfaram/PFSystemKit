//
//  PFSystemExpertReport.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 09/06/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSystemPlatformReport.h"

@implementation PFSystemPlatformReport
#if !TARGET_OS_IPHONE
@synthesize boardID;
@synthesize hardwareUUID;
@synthesize romVersion;
@synthesize romReleaseDate;
@synthesize smcVersion;
@synthesize sleepCause;
@synthesize shutdownCause;
#endif
@synthesize family;
@synthesize familyString;
@synthesize version;
@synthesize versionString;
@synthesize endianness;
@synthesize endiannessString;
@synthesize model;
@synthesize serial;
@synthesize memorySize;
#if !TARGET_OS_IPHONE
-(instancetype) initWithBoardID:(NSString*)boardIDLocal
                   hardwareUUID:(NSString*)UUIDLocal
                     romVersion:(NSString*)romVersionLocal
                 romReleaseDate:(NSString*)romReleaseDateLocal
                     smcVersion:(NSString*)smcVersionLocal
                  shutdownCause:(NSNumber*)shutdownCauseLocal
                         family:(PFSystemKitDeviceFamily)familyLocal
                   familyString:(NSString*)familyStringLocal
                        version:(PFSystemKitDeviceVersion)versionLocal
                  versionString:(NSString*)versionStringLocal
                     endianness:(PFSystemKitEndianness)endiannessLocal
               endiannessString:(NSString*)endiannessStringLocal
                          model:(NSString*)modelStringLocal
                         serial:(NSString*)serialLocal
                     memorySize:(NSNumber*)memorySizeLocal
{
    if (!(self = [super init])) {
        return nil;
    }
    boardID = boardIDLocal;
    hardwareUUID = UUIDLocal;
    romVersion = romVersionLocal;
    romReleaseDate = romReleaseDateLocal;
    smcVersion = smcVersionLocal;
    shutdownCause = shutdownCauseLocal;
    family = familyLocal;
    familyString = familyStringLocal;
    version = versionLocal;
    versionString = versionStringLocal;
    endianness = endiannessLocal;
    endiannessString = endiannessStringLocal;
    model = modelStringLocal;
    serial = serialLocal;
    memorySize = memorySizeLocal;
    return self;
}
-(void) updateWithSleepCause:(NSNumber*)sleepCauseLocal {
    sleepCause = sleepCauseLocal;
}
#endif
#if TARGET_OS_IPHONE
-(instancetype) initWithFamily:(PFSystemKitDeviceFamily)familyLocal
                   familyString:(NSString*)familyStringLocal
                        version:(PFSystemKitDeviceVersion)versionLocal
                  versionString:(NSString*)versionStringLocal
                     endianness:(PFSystemKitEndianness)endiannessLocal
               endiannessString:(NSString*)endiannessStringLocal
                          model:(NSString*)modelStringLocal
                         serial:(NSString*)serialLocal
                     memorySize:(NSNumber*)memorySizeLocal
{
    if (!(self = [super init])) {
        return nil;
    }
    family = familyLocal;
    familyString = familyStringLocal;
    version = versionLocal;
    versionString = versionStringLocal;
    endianness = endiannessLocal;
    endiannessString = endiannessStringLocal;
    model = modelStringLocal;
    serial = serialLocal;
    memorySize = memorySizeLocal;
    return self;
}
#endif
@end
