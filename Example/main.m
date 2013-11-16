// main.m
// Copyright (c) 2012 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

#import "TransformerKit.h"

int main(int __unused argc, const char __unused *argv[]) {
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
            @{@"key" : @"value"} : TTTJSONTransformerName
        } enumerateKeysAndObjectsUsingBlock:^(__unused id value, __unused id name, __unused BOOL *stop) {
            NSLog(@"%@: %@", value, [[NSValueTransformer valueTransformerForName:name] transformedValue:value]);
        }];
        
        [@{
           @"s\\v'ErStS": @"IPA-XSampa"
        } enumerateKeysAndObjectsUsingBlock:^(__unused id value, __unused id transform, __unused BOOL *stop) {
            NSLog(@"%@: %@", value, [TTTStringTransformerForICUTransform(transform) reverseTransformedValue:value]);
        }];
        
        [@{
            @"CamelCaseString" : TTTCamelCaseStringTransformerName,
            @"llamaCaseString" : TTTLlamaCaseStringTransformerName,
            @"snake_case_string" : TTTSnakeCaseStringTransformerName,
            @"train-case-string" : TTTTrainCaseStringTransformerName,
            @"gnirtS desreveR" : TTTReverseStringTransformerName,
        } enumerateKeysAndObjectsUsingBlock:^(__unused id value, __unused id name, __unused BOOL *stop) {
            NSLog(@"%@ (Reversed): %@", value, [[NSValueTransformer valueTransformerForName:name] reverseTransformedValue:value]);
        }];

        [@[TTTISO8601DateTransformerName] enumerateObjectsUsingBlock:^(id name, __unused NSUInteger idx, __unused BOOL *stop) {
            NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:name];
            NSLog(@"%@ (Timestamp): %@", name, [transformer transformedValue:[NSDate date]]);
            NSLog(@"%@ (Date): %@", name, [transformer reverseTransformedValue:[transformer transformedValue:[NSDate date]]]);
        }];
    }

    return 0;
}

