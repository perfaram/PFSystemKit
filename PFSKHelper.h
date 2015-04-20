//
//  PFSKHelper.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 18/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFSKHelper : NSObject
+(BOOL) NSString:(NSString*)string contains:(NSString*)contains;
+(NSString*) NSString:(NSString*)string removePrefix:(NSString*)thePrefix;
+(NSString*) NSString:(NSString*)string removeSuffix:(NSString*)theSuffix;
+(NSString*) NSString:(NSString*)string replaceString:(NSString*)a byString:(NSString*)b;
+(CFTypeRef) rawValue:(char*)value toCFTypeRef:(CFTypeID)typeID;
+(NSDictionary*)deltaFromDictionary:(NSDictionary*)a andDictionary:(NSDictionary*)b;
+(NSDate*)parseDate:(NSString*)inStrDate format:(NSString*)inFormat;
@end
