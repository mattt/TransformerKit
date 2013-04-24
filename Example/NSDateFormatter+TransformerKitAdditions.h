//
//  NSDateFormatter+TransformerKitAdditions.h
//  TransformerKit Example
//
//  Created by Cory D. Wiles on 4/24/13.
//  Copyright (c) 2013 Mattt Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const TTTDateStandardFormat;

@interface NSDateFormatter (TransformerKitAdditions)

+ (NSDateFormatter *)dateFormatterReader;
+ (NSDateFormatter *)dateFormatterWriter:(NSString *)format;

@end
