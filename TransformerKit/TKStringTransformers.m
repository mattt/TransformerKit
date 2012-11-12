// TKStringTransformers.m
//
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

#import "TKStringTransformers.h"

#import "NSValueTransformer+TransformerKit.h"

NSString * const TKCapitalizedStringTransformerName = @"TKCapitalizedStringTransformerName";
NSString * const TKUppercaseStringTransformerName = @"TKUppercaseStringTransformer";
NSString * const TKLowercaseStringTransformerName = @"TKLowercaseStringTransformer";
NSString * const TKCamelCaseStringTransformerName = @"TKCamelCaseStringTransformer";
NSString * const TKLlamaCaseStringTransformerName = @"TKLlamaCaseStringTransformer";
NSString * const TKSnakeCaseStringTransformerName = @"TKSnakeCaseStringTransformer";
NSString * const TKTrainCaseStringTransformerName = @"TKTrainCaseStringTransformer";
NSString * const TKReverseStringTransformerName = @"TKReverseStringTransformer";
NSString * const TKRemoveDiacriticStringTransformerName = @"TKRemoveDiacriticStringTransformer";
NSString * const TKTransliterateStringToLatinTransformerName = @"TKTransliterateStringToLatinTransformer";

static NSArray * TKComponentsBySplittingOnWhitespaceWithString(NSString *string) {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    
    return components;
}

static NSString * TKReversedStringWithString(NSString *string) {
    __block NSMutableString *reversedString = [NSMutableString stringWithCapacity:[string length]];
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reversedString appendString:substring];
    }];
    
    return reversedString;
}

@implementation TKStringTransformers

+ (void)load {
    [NSValueTransformer registerValueTransformerWithName:TKCapitalizedStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
        return [value capitalizedString];
    }];
    
    [NSValueTransformer registerValueTransformerWithName:TKUppercaseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
        return [value uppercaseString];
    }];
    
    [NSValueTransformer registerValueTransformerWithName:TKLowercaseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
        return [value lowercaseString];
    }];
    
    [NSValueTransformer registerValueTransformerWithName:TKCamelCaseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
        NSArray *components = TKComponentsBySplittingOnWhitespaceWithString(value);
        NSMutableArray *mutableComponents = [NSMutableArray arrayWithCapacity:[components count]];
        [components enumerateObjectsUsingBlock:^(id component, NSUInteger idx, BOOL *stop) {
            [mutableComponents addObject:[component capitalizedString]];
        }];
        
        return [mutableComponents componentsJoinedByString:@""];
    }];
    
    [NSValueTransformer registerValueTransformerWithName:TKLlamaCaseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
        NSArray *components = TKComponentsBySplittingOnWhitespaceWithString(value);
        NSMutableArray *mutableComponents = [NSMutableArray arrayWithCapacity:[components count]];
        [components enumerateObjectsUsingBlock:^(id component, NSUInteger idx, BOOL *stop) {
            [mutableComponents addObject:(idx == 0 ? [component lowercaseString] : [component capitalizedString])];
        }];
        
        return [mutableComponents componentsJoinedByString:@""];
    }];
    
    [NSValueTransformer registerValueTransformerWithName:TKSnakeCaseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
        NSArray *components = TKComponentsBySplittingOnWhitespaceWithString(value);
        NSMutableArray *mutableComponents = [NSMutableArray arrayWithCapacity:[components count]];
        [components enumerateObjectsUsingBlock:^(id component, NSUInteger idx, BOOL *stop) {
            [mutableComponents addObject:[component lowercaseString]];
        }];
        
        return [mutableComponents componentsJoinedByString:@"_"];
    }];
    
    [NSValueTransformer registerValueTransformerWithName:TKTrainCaseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
        NSArray *components = TKComponentsBySplittingOnWhitespaceWithString(value);
        NSMutableArray *mutableComponents = [NSMutableArray arrayWithCapacity:[components count]];
        [components enumerateObjectsUsingBlock:^(id component, NSUInteger idx, BOOL *stop) {
            [mutableComponents addObject:[component lowercaseString]];
        }];
        
        return [mutableComponents componentsJoinedByString:@"-"];
    }];
    
    [NSValueTransformer registerValueTransformerWithName:TKReverseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
        return TKReversedStringWithString(value);
    } allowingReverseTransformationWithBlock:^id(id value) {
        return TKReversedStringWithString(value);
    }];
    
    [NSValueTransformer registerValueTransformerWithName:TKRemoveDiacriticStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
        NSMutableString *mutableString = [value mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)(mutableString), NULL, kCFStringTransformStripCombiningMarks, NO);
        
        return mutableString;
    }];
    
    [NSValueTransformer registerValueTransformerWithName:TKTransliterateStringToLatinTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
        NSMutableString *mutableString = [value mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)(mutableString), NULL, kCFStringTransformToLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)(mutableString), NULL, kCFStringTransformStripCombiningMarks, NO);
        
        return mutableString;
    }];
}

@end


