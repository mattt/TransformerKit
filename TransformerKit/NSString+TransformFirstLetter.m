//
//  NSString+TransformFirstLetter.m
//  TransformerKit Example
//
//  Created by Marius Rackwitz on 29.01.13.
//  Copyright (c) 2013 Mattt Thompson. All rights reserved.
//

#import "NSString+TransformFirstLetter.h"

@implementation NSString (TransformFirstLetter)

- (NSString *)firstLetterString {
    unichar firstLetter = [self characterAtIndex:0];
    return [NSString stringWithCharacters:&firstLetter length:1];
}

- (NSString *)lowercaseFirstLetterString {
    return [NSString stringWithFormat:@"%@%@", self.firstLetterString.lowercaseString, [self substringFromIndex:1]];
}

- (NSString *)uppercaseFirstLetterString {
    return [NSString stringWithFormat:@"%@%@", self.firstLetterString.uppercaseString, [self substringFromIndex:1]];
}

@end
