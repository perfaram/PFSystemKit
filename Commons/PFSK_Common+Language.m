//
//  PFSK_Common+Language.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 31/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "PFSK_Common+Language.h"

@implementation PFSystemKit(Language)
+(NSString*) userPreferredLanguages {
	// User preferred language
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defs objectForKey:@"AppleLanguages"];
	return (NSString*)[languages objectAtIndex:0];
}
@end
