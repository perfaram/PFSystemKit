//
//  PFSK_Common+Language.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 31/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
/* iOS imports */
#if TARGET_OS_IPHONE
#import <PFSystemKit/PFSK_iOS.h>
#endif
/* OS X imports */
#if !TARGET_OS_IPHONE
#import "PFSK_OSX.h"
#endif

@interface PFSystemKit(Language)
+(NSArray*) userPreferredLanguages;
@end
