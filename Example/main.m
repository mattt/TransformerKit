//
//  main.m
//  TransformerKit Example
//
//  Created by Mattt Thompson on 2012/11/09.
//  Copyright (c) 2012年 Mattt Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TransformerKit.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [@{
         @"Capitalized String" : TTTCapitalizedStringTransformerName,
         @"Uppercase String" : TTTUppercaseStringTransformerName,
         @"Lowercase String" : TTTLowercaseStringTransformerName,
         @"Camel Case String" : TTTCamelCaseStringTransformerName,
         @"Llama Case String" : TTTLlamaCaseStringTransformerName,
         @"Snake Case String" : TTTSnakeCaseStringTransformerName,
         @"Train Case String" : TTTTrainCaseStringTransformerName,
         @"Reversed String" : TTTReverseStringTransformerName,
         @"Rémövê Dîaçritics" : TTTRemoveDiacriticStringTransformerName,
         @"ट्रांस्लितेराते स्ट्रिंग" : TTTTransliterateStringToLatinTransformerName,
        } enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"%@: %@", key, [[NSValueTransformer valueTransformerForName:obj] transformedValue:key]);
        }];

        NSDictionary *customDateDictionary       = @{TTTDateTransformerCustomDateStringKey : [NSDate date], TTTDateTransformerCustomFormatKey : @"yyyy-MM-dd HH:mm:ss zzz"};
        NSDictionary *customStringDateDictionary = @{TTTDateTransformerCustomStringDateKey : @"2013-04-24 13:43:28 EDT", TTTDateTransformerCustomFormatKey : @"yyyy-MM-dd HH:mm:ss zzz"};
        NSString *sampleDateForStandard          = @"04-13-2012";

        NSLog(@"Standard date to string: %@", [[NSValueTransformer valueTransformerForName:TTTDefaultDateStringTransformerName] transformedValue:[NSDate date]]);
        NSLog(@"Custom date to string: %@", [[NSValueTransformer valueTransformerForName:TTTDateStringTransformerName] transformedValue:customDateDictionary]);

        NSLog(@"Standard string to date: %@", [[NSValueTransformer valueTransformerForName:TTTDefaultStringDateTransformerName] transformedValue:sampleDateForStandard]);
        NSLog(@"Custom string to date: %@", [[NSValueTransformer valueTransformerForName:TTTStringDateTransformerName] transformedValue:customStringDateDictionary]);
    }
    
    return 0;
}

