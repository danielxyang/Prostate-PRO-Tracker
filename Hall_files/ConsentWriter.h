//
//  ConsentWriter.h
//  Cardio-M
//
//  Created by E. Kevin Hall on 7/29/15.
//  Copyright (c) 2015 E. Kevin Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ResearchKit/ResearchKit.h>
#import "Constants.h"

@interface ConsentWriter : NSObject

+(BOOL)persistDoc:(ORKConsentDocument *)doc withMarker:(NSString *)marker andUUID:(NSString *)uuid andName:(NSString *)name;
@end
