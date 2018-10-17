// TTTStringTransformers.h
//
// Copyright (c) 2012 - 2018 Mattt (https://mat.tt)
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

@import Foundation;
#import "NSValueTransformerName.h"

NS_ASSUME_NONNULL_BEGIN

/**
 
 */
extern NSValueTransformerName const TTTCapitalizedStringTransformerName NS_SWIFT_NAME(capitalizedStringTransformerName);

/**
 
 */
extern NSValueTransformerName const TTTUppercaseStringTransformerName NS_SWIFT_NAME(uppercaseStringTransformerName);

/**
 
 */
extern NSValueTransformerName const TTTLowercaseStringTransformerName NS_SWIFT_NAME(lowercaseStringTransformerName);

/**
 
 */
extern NSValueTransformerName const TTTCamelCaseStringTransformerName NS_SWIFT_NAME(camelCaseStringTransformerName);

/**
 
 */
extern NSValueTransformerName const TTTLlamaCaseStringTransformerName NS_SWIFT_NAME(llamaCaseStringTransformerName);

/**
 
 */
extern NSValueTransformerName const TTTSnakeCaseStringTransformerName NS_SWIFT_NAME(snakeCaseStringTransformerName);

/**
 
 */
extern NSValueTransformerName const TTTTrainCaseStringTransformerName NS_SWIFT_NAME(trainCaseStringTransformerName);

/**
 
 */
extern NSValueTransformerName const TTTReverseStringTransformerName NS_SWIFT_NAME(reverseStringTransformerName);

/**
 
 */
extern NSValueTransformerName const TTTRemoveDiacriticStringTransformerName NS_SWIFT_NAME(removeDiacriticStringTransformerName);

/**
 
 */
extern NSValueTransformerName const TTTTransliterateStringToLatinTransformerName NS_SWIFT_NAME(transliterateStringToLatinTransformerName);

/**
 
 */
extern NSValueTransformer * _Nullable TTTStringTransformerForICUTransform(NSString *transform) NS_SWIFT_NAME(StringTransformerForICUTransform(_:));

@interface TTTStringTransformers : NSObject

@end

NS_ASSUME_NONNULL_END
