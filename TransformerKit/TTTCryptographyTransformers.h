// TTTCryptographyTransformers.h
//
// Copyright (c) 2014 Mattt Thompson (http://mattt.me)
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

#if __MAC_OS_X_VERSION_MIN_REQUIRED
#import <Foundation/Foundation.h>

/**
 
 */
extern NSString * const TTTMD5TransformerName;

/**
 
 */
extern NSString * const TTTSHA1TransformerName;

/**
 
 */
extern NSString * const TTTSHA256TransformerName;

#pragma mark -

typedef NSUInteger TTTDigestAlgorithm;

/**
 
 */
typedef NS_ENUM(TTTDigestAlgorithm, TTTMessageDigestAlgorithm) {
    TTTMD2 = 2,
    TTTMD4 = 4,
    TTTMD5 = 5,
};

/**
 
 */
typedef NS_ENUM(TTTDigestAlgorithm, TTTSecureHashAlgorithm) {
    TTTSHA1 = 1,
    TTTSHA224 = 224,
    TTTSHA256 = 256,
    TTTSHA384 = 384,
    TTTSHA512 = 512,
};

///

/**
 
 */
extern NSData * TTTDigestWithAlgorithmForString(TTTDigestAlgorithm algorithm, NSString *string);

/**
 
 */
extern NSData * TTTDigestWithAlgorithmForData(TTTDigestAlgorithm algorithm, NSData *data);

/**
 
 */
extern __attribute__((overloadable)) NSString * TTTHMACWithDigestAlgorithmForKeyAndData(TTTDigestAlgorithm algorithm, NSString *key, NSData *data);

/**
 
 */
extern __attribute__((overloadable)) NSString * TTTHMACWithDigestAlgorithmForKeyAndData(TTTDigestAlgorithm algorithm, NSData *key, NSData *data);

#pragma mark -

/**
 
 */
extern NSString * TTTCryptographicHashTransformerNameWithAlgorithm(TTTMessageDigestAlgorithm algorithm);

/**
 
 */
@interface TTTCryptographyTransformers : NSObject

@end

#pragma mark -

/**
 
 */
@interface NSValueTransformer (TTTCryptography)

/**

 */
+ (void)registerValueTransformerForDigestAlgorithm:(TTTDigestAlgorithm)algorithm;

@end
#endif