//
//  ConsentWriter.m
//  Cardio-M
//
//  Created by E. Kevin Hall on 7/29/15.
//  Copyright (c) 2015 E. Kevin Hall. All rights reserved.
//

#import "ConsentWriter.h"
#import "Prostate_PRO_Tracker_v2-Swift.h"

@implementation ConsentWriter

+(BOOL)persistDoc:(ORKConsentDocument *)doc withMarker:(NSString *)marker andUUID:(NSString *)uuid andName:(NSString *)name {
  [doc makePDFWithCompletionHandler:^(NSData *pdfData, NSError *error) {
    NSArray  * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * fileName = [NSString stringWithFormat:@"%@-%@-%@.pdf",
                           uuid, name, marker];
    NSString * file = [documentsDirectory stringByAppendingPathComponent:fileName];
    if ([pdfData writeToFile:file options:NSDataWritingAtomic error:&error]) {
      NSLog(@"File Saved to %@", file);
      
      [[CMPersist sharedInstance] dbPostPDF:fileName fileString:file];
      
    } else {
      NSLog(@"Unable to write PDF to %@. Error: %@", file, error);
    }
  }];
  return YES;
}
@end
