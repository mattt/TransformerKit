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

NSString * const TTTDefaultDateStringTransformerName     = @"TTTDefaultDateStringTransformerName";
NSString * const TTTDateStringTransformerName            = @"TTTDateStringTransformerName";
NSString * const TTTDefaultStringDateTransformerName     = @"TTTDefaultStringDateTransformerName";
NSString * const TTTStringDateTransformerName            = @"TTTStringDateTransformerName";

NSString * const TTTDateTransformerCustomFormatKey       = @"TTTDateFormat";
NSString * const TTTDateTransformerCustomDateStringKey   = @"TTTDateStringValue";
NSString * const TTTDateTransformerCustomStringDateKey   = @"TTTStringDateValue";

@implementation TTTDateTransformers

+ (void)load {

    @autoreleasepool {
        [NSValueTransformer registerValueTransformerWithName:TTTDefaultDateStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {

            NSAssert([value isKindOfClass:[NSDate class]], @"Value must instance of NSDate");

            NSDateFormatter *formatter = [NSDateFormatter dateFormatterReader];

            return [formatter stringFromDate:value];
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTDateStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {

            NSAssert([value isKindOfClass:[NSDictionary class]], @"Value must instance of NSDictionary");

            NSDate *date               = value[TTTDateTransformerCustomDateStringKey] != nil ? value[TTTDateTransformerCustomDateStringKey] : [NSDate date];
            NSString *format           = value[TTTDateTransformerCustomFormatKey] != nil ? value[TTTDateTransformerCustomFormatKey] : TTTDateStandardFormat;
            NSDateFormatter *formatter = [NSDateFormatter dateFormatterWriter:format];

            return [formatter stringFromDate:date];
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTDefaultStringDateTransformerName transformedValueClass:[NSDate class] returningTransformedValueWithBlock:^id(id value) {

            NSAssert([value isKindOfClass:[NSString class]], @"Value must instance of NSString");

            NSDateFormatter *formatter = [NSDateFormatter dateFormatterReader];
            NSDate *finalDate          = [formatter dateFromString:value];

            return finalDate;
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTStringDateTransformerName transformedValueClass:[NSDate class] returningTransformedValueWithBlock:^id(id value) {

            NSAssert([value isKindOfClass:[NSDictionary class]], @"Value must instance of NSDictionary");
            NSAssert([value[TTTDateTransformerCustomStringDateKey] isKindOfClass:[NSString class]], @"Value must instance of NSString");

            NSString *dateString       = value[TTTDateTransformerCustomStringDateKey];
            NSString *format           = value[TTTDateTransformerCustomFormatKey] != nil ? value[TTTDateTransformerCustomFormatKey] : TTTDateStandardFormat;
            NSDateFormatter *formatter = [NSDateFormatter dateFormatterWriter:format];
            
            return [formatter dateFromString:dateString];
        }];
    }
}

@end
