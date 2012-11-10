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
         @"Capitalized String" : TKCapitalizedStringTransformerName,
         @"Uppercase String" : TKUppercaseStringTransformerName,
         @"Lowercase String" : TKLowercaseStringTransformerName,
         @"Camel Case String" : TKCamelCaseStringTransformerName,
         @"Llama Case String" : TKLlamaCaseStringTransformerName,
         @"Snake Case String" : TKSnakeCaseStringTransformerName,
         @"Train Case String" : TKTrainCaseStringTransformerName,
         @"Reversed String" : TKReverseStringTransformerName,
         @"Rémövê Dîaçritics" : TKRemoveDiacriticStringTransformerName,
         @"ट्रांस्लितेराते स्ट्रिंग" : TKTransliterateStringToLatinTransformerName,
        } enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"%@: %@", key, [[NSValueTransformer valueTransformerForName:obj] transformedValue:key]);
        }];
    }
    
    return 0;
}

