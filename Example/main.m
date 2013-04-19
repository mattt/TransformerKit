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
    }
    
    return 0;
}

