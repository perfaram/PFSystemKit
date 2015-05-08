//
//  NSString+CPPAdditions.m
//  PFSystemKit
//
//  Created by "Matt" on 04/03/08. Retrieved on : http://lists.apple.com/archives/cocoa-dev/2008/Mar/msg00255.html
//

#import "NSString+CPPAdditions.h"

@implementation NSString (CPPAdditions)

#if TARGET_RT_BIG_ENDIAN
const NSStringEncoding kEncoding_wchar_t = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF32BE);
#else
const NSStringEncoding kEncoding_wchar_t = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF32LE);
#endif

+(NSString*) stringWithSTDwString:(const std::wstring&)ws
{
	char* data = (char*)ws.data();
	unsigned size = ws.size() * sizeof(wchar_t);
	
	NSString* result = [[NSString alloc] initWithBytes:data length:size encoding:kEncoding_wchar_t];
	return result;
}
+(NSString*) stringWithSTDString:(const std::string&)s
{
	NSString* result = [[NSString alloc] initWithUTF8String:s.c_str()];
	return result;
}

-(std::wstring) getwString
{
	NSData* asData = [self dataUsingEncoding:kEncoding_wchar_t];
	return std::wstring((wchar_t*)[asData bytes], [asData length] / sizeof(wchar_t));
}
-(std::string) getString
{
	return [self UTF8String];
}

@end