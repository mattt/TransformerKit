// TTTStringTransformers.m
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

#import "TTTStringTransformers.h"

#import "NSValueTransformer+TransformerKit.h"

NSString * const TTTCapitalizedStringTransformerName = @"TTTCapitalizedStringTransformerName";
NSString * const TTTUppercaseStringTransformerName = @"TTTUppercaseStringTransformer";
NSString * const TTTLowercaseStringTransformerName = @"TTTLowercaseStringTransformer";
NSString * const TTTCamelCaseStringTransformerName = @"TTTCamelCaseStringTransformer";
NSString * const TTTLlamaCaseStringTransformerName = @"TTTLlamaCaseStringTransformer";
NSString * const TTTSnakeCaseStringTransformerName = @"TTTSnakeCaseStringTransformer";
NSString * const TTTTrainCaseStringTransformerName = @"TTTTrainCaseStringTransformer";
NSString * const TTTReverseStringTransformerName = @"TTTReverseStringTransformer";
NSString * const TTTRemoveDiacriticStringTransformerName = @"TTTRemoveDiacriticStringTransformer";
NSString * const TTTTransliterateStringToLatinTransformerName = @"TTTTransliterateStringToLatinTransformer";

static NSArray * TTTComponentsBySplittingOnWhitespaceWithString(NSString *string) {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    
    return components;
}

static NSArray * TTTComponentsBySplittingOnUppercaseWithString(NSString *string) {
    NSMutableString *mutableString = [string mutableCopy];
    NSMutableArray *mutableComponents = [[NSMutableArray alloc] init];
    
    NSRange uppercaseRange;
    while ((uppercaseRange = [mutableString rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]]).location != NSNotFound) {
        NSRange componentRange = NSMakeRange(0, uppercaseRange.location);
        
        [mutableComponents addObject:[mutableString substringWithRange:componentRange]];
        [mutableString deleteCharactersInRange:componentRange];
        
        [mutableString replaceCharactersInRange:NSMakeRange(0, 1) withString:[[mutableString substringToIndex:1] lowercaseString]];
    }
    [mutableComponents addObject:mutableString];
    
    [mutableComponents filterUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    
    return [NSArray arrayWithArray:mutableComponents];
}

static NSString * TTTReversedStringWithString(NSString *string) {
    __block NSMutableString *reversedString = [NSMutableString stringWithCapacity:[string length]];
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange __unused substringRange, NSRange __unused enclosingRange, BOOL __unused *stop) {
        [reversedString appendString:substring];
    }];
    
    return reversedString;
}

NSValueTransformer * TTTStringTransformerForICUTransform(NSString *transform) {
    NSString *transformerName = [NSString stringWithFormat:@"TTTStringICUTransformer(%@)", transform];
    if (![[NSValueTransformer valueTransformerNames] containsObject:transformerName]) {
        BOOL success = [NSValueTransformer registerValueTransformerWithName:transformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            NSMutableString *mutableString = [NSMutableString stringWithString:[value description]];
            CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, (__bridge CFStringRef)transform, NO);
            return [NSString stringWithString:mutableString];
        } allowingReverseTransformationWithBlock:^id(id value) {
            NSMutableString *mutableString = [NSMutableString stringWithString:[value description]];
            CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, (__bridge CFStringRef)transform, YES);
            return [NSString stringWithString:mutableString];
        }];
    
        if (!success) {
            return nil;
        }
    }
    
    return [NSValueTransformer valueTransformerForName:transformerName];
}

@implementation TTTStringTransformers

+ (void)load {
    @autoreleasepool {
        [NSValueTransformer registerValueTransformerWithName:TTTCapitalizedStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            return [value capitalizedString];
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTUppercaseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            return [value uppercaseString];
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTLowercaseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            return [value lowercaseString];
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTCamelCaseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            NSArray *components = TTTComponentsBySplittingOnWhitespaceWithString(value);
            NSMutableArray *mutableComponents = [NSMutableArray arrayWithCapacity:[components count]];
            [components enumerateObjectsUsingBlock:^(id component, NSUInteger __unused idx, BOOL __unused *stop) {
                [mutableComponents addObject:[component capitalizedString]];
            }];

            return [mutableComponents componentsJoinedByString:@""];
        } allowingReverseTransformationWithBlock:^id(id value) {
            NSArray *components = TTTComponentsBySplittingOnUppercaseWithString(value);
            
            return [components componentsJoinedByString:@" "];
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTLlamaCaseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            NSArray *components = TTTComponentsBySplittingOnWhitespaceWithString(value);
            NSMutableArray *mutableComponents = [NSMutableArray arrayWithCapacity:[components count]];
            [components enumerateObjectsUsingBlock:^(id component, NSUInteger __unused idx, BOOL __unused *stop) {
                [mutableComponents addObject:(idx == 0 ? [component lowercaseString] : [component capitalizedString])];
            }];

            return [mutableComponents componentsJoinedByString:@""];
        } allowingReverseTransformationWithBlock:^id(id value) {
            NSArray *components = TTTComponentsBySplittingOnUppercaseWithString(value);
            
            return [components componentsJoinedByString:@" "];
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTSnakeCaseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            NSArray *components = TTTComponentsBySplittingOnWhitespaceWithString(value);
            NSMutableArray *mutableComponents = [NSMutableArray arrayWithCapacity:[components count]];
            [components enumerateObjectsUsingBlock:^(id component, NSUInteger __unused idx, BOOL __unused *stop) {
                [mutableComponents addObject:[component lowercaseString]];
            }];

            return [mutableComponents componentsJoinedByString:@"_"];
        } allowingReverseTransformationWithBlock:^id(id value) {
            NSArray *components = [value componentsSeparatedByString:@"_"];
            
            return [components componentsJoinedByString:@" "];
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTTrainCaseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            NSArray *components = TTTComponentsBySplittingOnWhitespaceWithString(value);
            NSMutableArray *mutableComponents = [NSMutableArray arrayWithCapacity:[components count]];
            [components enumerateObjectsUsingBlock:^(id component, NSUInteger __unused idx, BOOL __unused *stop) {
                [mutableComponents addObject:[component lowercaseString]];
            }];

            return [mutableComponents componentsJoinedByString:@"-"];
        } allowingReverseTransformationWithBlock:^id(id value) {
            NSArray *components = [value componentsSeparatedByString:@"-"];
            
            return [components componentsJoinedByString:@" "];
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTReverseStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            return TTTReversedStringWithString(value);
        } allowingReverseTransformationWithBlock:^id(id value) {
            return TTTReversedStringWithString(value);
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTRemoveDiacriticStringTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            NSMutableString *mutableString = [value mutableCopy];
            CFStringTransform((__bridge CFMutableStringRef)(mutableString), NULL, kCFStringTransformStripCombiningMarks, NO);

            return mutableString;
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTTransliterateStringToLatinTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            NSMutableString *mutableString = [value mutableCopy];
            CFStringTransform((__bridge CFMutableStringRef)(mutableString), NULL, kCFStringTransformToLatin, NO);
            CFStringTransform((__bridge CFMutableStringRef)(mutableString), NULL, kCFStringTransformStripCombiningMarks, NO);

            return mutableString;
        }];
    }
}

@end
