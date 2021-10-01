// TTTCryptographyTransformers.h
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
#import <TransformerKit/NSValueTransformerName.h>

NS_ASSUME_NONNULL_BEGIN

/**

 */
extern NSValueTransformerName TTTMD5TransformerName NS_SWIFT_NAME(md5TransformerName);

/**

 */
extern NSValueTransformerName TTTSHA1TransformerName NS_SWIFT_NAME(sha1TransformerName);

/**

 */
extern NSValueTransformerName TTTSHA256TransformerName NS_SWIFT_NAME(sha256TransformerName);

#pragma mark -

typedef NSUInteger TTTDigestAlgorithm NS_SWIFT_NAME(DigestAlgorithm);

/**

 */
typedef NS_ENUM(TTTDigestAlgorithm, TTTMessageDigestAlgorithm) {
    TTTMD2 = 2,
    TTTMD4 = 4,
    TTTMD5 = 5,
} NS_SWIFT_NAME(MessageDigestAlgorithm);

/**

 */
typedef NS_ENUM(TTTDigestAlgorithm, TTTSecureHashAlgorithm) {
    TTTSHA1 = 1,
    TTTSHA224 = 224,
    TTTSHA256 = 256,
    TTTSHA384 = 384,
    TTTSHA512 = 512,
} NS_SWIFT_NAME(SecureHashAlgorithm);

///

/**

 */
extern NSData * TTTDigestWithAlgorithmForString(TTTDigestAlgorithm algorithm, NSString *string) NS_SWIFT_NAME(digest(with:for:));

/**

 */
extern NSData * TTTDigestWithAlgorithmForData(TTTDigestAlgorithm algorithm, NSData *data) NS_SWIFT_NAME(digest(with:for:));

/**

 */
extern __attribute__((overloadable)) NSData * TTTHMACWithDigestAlgorithmForKeyAndData(TTTDigestAlgorithm algorithm, NSString *key, NSData *data) NS_SWIFT_NAME(hmac(with:for:and:));

/**

 */
extern __attribute__((overloadable)) NSData * TTTHMACWithDigestAlgorithmForKeyAndData(TTTDigestAlgorithm algorithm, NSData *key, NSData *data) NS_SWIFT_NAME(hmac(with:for:and:));

#pragma mark -

/**

 */
extern NSString * TTTCryptographicHashTransformerNameWithAlgorithm(TTTMessageDigestAlgorithm algorithm) NS_SWIFT_NAME(crypographicHashTransformer(with:));

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
+ (void)registerValueTransformerForDigestAlgorithm:(TTTDigestAlgorithm)algorithm NS_SWIFT_NAME(registerValueTransformer(for:));

@end

NS_ASSUME_NONNULL_END
