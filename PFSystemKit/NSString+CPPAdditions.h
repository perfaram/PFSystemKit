//
//  NSString+CPPAdditions.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 04/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <string>

@interface NSString (CPPAdditions)
+(NSString*) stringWithSTDwString:(const std::wstring&)string;
+(NSString*) stringWithSTDString:(const std::string&)string;
-(std::wstring) getwString;
-(std::string) getString;
@end