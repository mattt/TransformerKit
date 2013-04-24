//
//  TTTDateTransformers.m
//  TransformerKit Example
//
//  Created by Cory D. Wiles on 4/24/13.
//  Copyright (c) 2013 Mattt Thompson. All rights reserved.
//

#import "TTTDateTransformers.h"
#import "NSValueTransformer+TransformerKit.h"
#import "NSDateFormatter+TransformerKitAdditions.h"

NSString * const TTTDefaultDateTransformerName     = @"TTTDefaultDateTransformerName";
NSString * const TTTDateTransformerName            = @"TTTDateTransformerName";
NSString * const TTTDateTransformerCustomFormatKey = @"dateFormat";
NSString * const TTTDateTransformerCustomDateKey   = @"dateValue";

@implementation TTTDateTransformers

+ (void)load {

    @autoreleasepool {
        [NSValueTransformer registerValueTransformerWithName:TTTDefaultDateTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {

            NSAssert([value isKindOfClass:[NSDate class]], @"Value must instance of NSDate");

            NSDateFormatter *formatter = [NSDateFormatter dateFormatterReader];

            return [formatter stringFromDate:value];
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTDateTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {

            NSAssert([value isKindOfClass:[NSDictionary class]], @"Value must instance of NSDate");

            NSDate *date     = value[TTTDateTransformerCustomDateKey] != nil ? value[TTTDateTransformerCustomDateKey] : [NSDate date];
            NSString *format = value[TTTDateTransformerCustomFormatKey] != nil ? value[TTTDateTransformerCustomFormatKey] : TTTStandardFormat;

            NSDateFormatter *formatter = [NSDateFormatter dateFormatterWriter:format];

            return [formatter stringFromDate:date];
        }];
    }
}

@end
