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

template <class string_type>
inline typename string_type::value_type* NSWriteInto(NSString* str) {
	unsigned char *text = (unsigned char*)CFStringGetCStringPtr((CFStringRef)str, CFStringGetSystemEncoding());
	if (text != NULL)
	{
		memset(text, 0, [str length]);
	}
	return &text[0];
}

/*!
 //taken from the Chromium Project
 */
template <class string_type>
inline typename string_type::value_type* WriteInto(string_type* str,
												   size_t length_with_null) {
	str->reserve(length_with_null);
	str->resize(length_with_null - 1);
	return &((*str)[0]);
}