//
//  NSString+PFSKAdditions.m
//  PFSystemKit
//
//  Portions by "Matt" on 04/03/08. Retrieved on : http://lists.apple.com/archives/cocoa-dev/2008/Mar/msg00255.html
//  Portions by Sahil Desai from Domainr on 20/10/09. Retrieved on : https://github.com/Sahil/domainr-alpha
//

#import "NSString+PFSKAdditions.h"
#import <string>

@implementation NSString(PFSKAdditions)

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

-(NSString*) removePrefix:(NSString*)thePrefix
{
    if ([self hasPrefix: thePrefix]) {
        return [self substringFromIndex: [thePrefix length]];
    } else {
        return self;
    }
}

-(NSString*) removeSuffix:(NSString*)theSuffix
{
    if ([self hasSuffix: theSuffix]) {
        return [self substringToIndex: [self length]-[theSuffix length]];
    } else {
        return self;
    }
}

-(NSString*) replaceString:(NSString*)original byString:(NSString*)replacement
{
    id result = [NSMutableString stringWithString:self];
    [result replaceOccurrencesOfString:original withString:replacement options:0 range:NSMakeRange(0, [result length])];
    return result;
}

-(BOOL) containsString:(NSString *)aString
{
    return [self rangeOfString:aString options:NSCaseInsensitiveSearch].location == NSNotFound ? false : true;
}

@end