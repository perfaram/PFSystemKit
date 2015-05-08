//
//  NSString+CPPAdditions.m
//  PFSystemKit
//
//  Created by "Matt" on 04/03/08. Retrieved on : http://lists.apple.com/archives/cocoa-dev/2008/Mar/msg00255.html
//

#import <Foundation/Foundation.h>
#import <string>

@interface NSString (CPPAdditions)
+(NSString*) stringWithSTDwString:(const std::wstring&)string;
+(NSString*) stringWithSTDString:(const std::string&)string;
-(std::wstring) getwString;
-(std::string) getString;
@end