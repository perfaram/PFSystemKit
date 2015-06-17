//
//  PFSKHelper.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 18/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFSKHelper : NSObject
+(CFTypeRef) rawValue:(char*)value toCFTypeRef:(CFTypeID)typeID;
+(NSDictionary*)deltaFromDictionary:(NSDictionary*)a andDictionary:(NSDictionary*)b;
+(NSDate*)parseDate:(NSString*)inStrDate format:(NSString*)inFormat;
@end

/*!
 taken from the Chromium Project
 */
template <class string_type>
inline typename string_type::value_type* WriteInto(string_type* str,
												   size_t length_with_null) {
	str->reserve(length_with_null);
	str->resize(length_with_null - 1);
	return &((*str)[0]);
}