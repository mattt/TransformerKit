// TTTCryptographyTransformers.m
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
#import "TTTCryptographyTransformers.h"

#import "NSValueTransformer+TransformerKit.h"

#import <CommonCrypto/CommonCrypto.h>

NSString * const TTTMD2TransformerName = @"TTTMD2Transformer";
NSString * const TTTMD4TransformerName = @"TTTMD4Transformer";
NSString * const TTTMD5TransformerName = @"TTTMD5Transformer";

NSString * const TTTSHA1TransformerName = @"TTTSHA1Transformer";
NSString * const TTTSHA224TransformerName = @"TTTSHA224Transformer";
NSString * const TTTSHA256TransformerName = @"TTTSHA256Transformer";
NSString * const TTTSHA384TransformerName = @"TTTSHA384Transformer";
NSString * const TTTSHA512TransformerName = @"TTTSHA512Transformer";

NSString * TTTCryptographicHashTransformerNameWithAlgorithm(TTTDigestAlgorithm algorithm) {
    switch (algorithm) {
        case TTTMD2:
            return TTTMD2TransformerName;
        case TTTMD4:
            return TTTMD4TransformerName;
        case TTTMD5:
            return TTTMD5TransformerName;
        case TTTSHA1:
            return TTTSHA1TransformerName;
        case TTTSHA224:
            return TTTSHA224TransformerName;
        case TTTSHA256:
            return TTTSHA256TransformerName;
        case TTTSHA384:
            return TTTSHA384TransformerName;
        case TTTSHA512:
            return TTTSHA512TransformerName;
        default:
            return nil;
    }
}

#pragma mark -

static inline __attribute__((const)) unsigned int TTTDigestLengthForAlgorithm(TTTDigestAlgorithm algorithm) {
    switch (algorithm) {
        case TTTMD2:
            return CC_MD2_DIGEST_LENGTH;
        case TTTMD4:
            return CC_MD4_DIGEST_LENGTH;
        case TTTMD5:
            return CC_MD5_DIGEST_LENGTH;
        case TTTSHA1:
            return CC_SHA1_DIGEST_LENGTH;
        case TTTSHA224:
            return CC_SHA224_DIGEST_LENGTH;
        case TTTSHA256:
            return CC_SHA256_DIGEST_LENGTH;
        case TTTSHA384:
            return CC_SHA384_DIGEST_LENGTH;
        case TTTSHA512:
        default:
            return CC_SHA512_DIGEST_LENGTH;
    }
}

NSData * TTTDigestWithAlgorithmForString(TTTDigestAlgorithm algorithm, NSString *string) {
    return TTTDigestWithAlgorithmForData(algorithm, [string dataUsingEncoding:NSASCIIStringEncoding]);
}

NSData * TTTDigestWithAlgorithmForData(TTTDigestAlgorithm algorithm, NSData *data) {
    if (!data) {
        return nil;
    }

    unsigned int length = TTTDigestLengthForAlgorithm(algorithm);
    unsigned char output[length];

    switch (algorithm) {
        case TTTMD2:
            CC_MD2(data.bytes, (CC_LONG)data.length, output);
            break;
        case TTTMD4:
            CC_MD4(data.bytes, (CC_LONG)data.length, output);
            break;
        case TTTMD5:
            CC_MD5(data.bytes, (CC_LONG)data.length, output);
            break;
        case TTTSHA1:
            CC_SHA1(data.bytes, (CC_LONG)data.length, output);
            break;
        case TTTSHA224:
            CC_SHA224(data.bytes, (CC_LONG)data.length, output);
            break;
        case TTTSHA256:
            CC_SHA256(data.bytes, (CC_LONG)data.length, output);
            break;
        case TTTSHA384:
            CC_SHA384(data.bytes, (CC_LONG)data.length, output);
            break;
        case TTTSHA512:
            CC_SHA512(data.bytes, (CC_LONG)data.length, output);
            break;
    }

    return [NSData dataWithBytes:output length:length];
}

#pragma mark -

static inline __attribute__((const)) CCHmacAlgorithm TTTHMACAlgorithmForDigestAlgorithm(TTTDigestAlgorithm algorithm) {
    switch (algorithm) {
        case TTTMD2:
        case TTTMD4:
        case TTTMD5:
            return kCCHmacAlgMD5;
        case TTTSHA224:
            return kCCHmacAlgSHA224;
        case TTTSHA384:
            return kCCHmacAlgSHA384;
        case TTTSHA512:
            return kCCHmacAlgSHA512;
        case TTTSHA256:
            return kCCHmacAlgSHA256;
        case TTTSHA1:
        default:
            return kCCHmacAlgSHA1;
    }
}

__attribute__((overloadable)) NSString * TTTHMACWithDigestAlgorithmForKeyAndData(TTTDigestAlgorithm algorithm, NSString *key, NSData *data) {
    return TTTHMACWithDigestAlgorithmForKeyAndData(algorithm, [key dataUsingEncoding:NSASCIIStringEncoding], data);
}

__attribute__((overloadable)) NSString * TTTHMACWithDigestAlgorithmForKeyAndData(TTTDigestAlgorithm algorithm, NSData *key, NSData *data) {
    unsigned int length = TTTDigestLengthForAlgorithm(algorithm);
    unsigned char output[length];

    CCHmac(TTTHMACAlgorithmForDigestAlgorithm(algorithm), key.bytes, key.length, data.bytes, data.length, output);

    return [NSData dataWithBytes:output length:length];
}

@implementation TTTCryptographyTransformers

+ (void)load {
    @autoreleasepool {
        [NSValueTransformer registerValueTransformerForDigestAlgorithm:TTTMD5];
        [NSValueTransformer registerValueTransformerForDigestAlgorithm:TTTSHA1];
        [NSValueTransformer registerValueTransformerForDigestAlgorithm:TTTSHA256];
    }
}

@end

@implementation NSValueTransformer (TTTCryptography)

+ (void)registerValueTransformerForDigestAlgorithm:(TTTDigestAlgorithm)algorithm {
    [NSValueTransformer registerValueTransformerWithName:TTTCryptographicHashTransformerNameWithAlgorithm(algorithm) transformedValueClass:[NSData class] returningTransformedValueWithBlock:^id(id value) {
        return TTTDigestWithAlgorithmForData(algorithm, value);
    }];
}

@end
#endif
