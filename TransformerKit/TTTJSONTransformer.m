// TTTJSONTransformer.h
//
// Copyright (c) 2013 Mattt Thompson
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

#import "TTTJSONTransformer.h"
#import "NSValueTransformer+TransformerKit.h"

NSString * const TTTJSONTransformerName = @"TTTJSONTransformerName";

@implementation TTTJSONTransformer

+ (void)load {
    TTTJSONTransformer *transformer = [[self alloc] init];
    [self setValueTransformer:transformer forName:TTTJSONTransformerName];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSData class];
}

- (id)transformedValue:(id)value {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:value options:self.writingOptions error:&error];
    
    return data;
}

- (id)reverseTransformedValue:(id)value {
    id JSON = nil;
    NSError *error = nil;
    if ([value isKindOfClass:[NSString class]]) {
        JSON = [self reverseTransformedValue:[(NSString *)value dataUsingEncoding:NSUTF8StringEncoding]];
    } else if ([value isKindOfClass:[NSData class]]) {
        JSON = [NSJSONSerialization JSONObjectWithData:(NSData *)value options:self.readingOptions error:&error];
    } else if ([value isKindOfClass:[NSInputStream class]]) {
        JSON = [NSJSONSerialization JSONObjectWithStream:(NSInputStream *)value options:self.readingOptions error:&error];
    }
    
    return JSON;
}

@end
