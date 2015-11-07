// TTTDataTransformers.m
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

#import <Security/Security.h>

#import "TTTDataTransformers.h"

#import "NSValueTransformer+TransformerKit.h"

NSString * const TTTBase2EncodedDataTransformerName = @"TTTBase2EncodedDataTransformer";

NSString * const TTTBase16EncodedDataTransformerName = @"TTTBase16EncodedDataTransformer";

NSString * const TTTBase32EncodedDataTransformerName = @"TTTBase32EncodedDataTransformer";

NSString * const TTTBase64EncodedDataTransformerName = @"TTTBase64EncodedDataTransformer";

NSString * const TTTBase85EncodedDataTransformerName = @"TTTBase85EncodedDataTransformer";

#define TTTBinaryStringEncodedDataTransformerName TTTBase2EncodedDataTransformerName
#define TTTHexadecimalStringEncodedDataTransformerName TTTBase16EncodedDataTransformerName
#define TTTAscii85EncodedDataTransformerName TTTBase85EncodedDataTransformerName

#pragma mark -

const char _base16Alphabet[16] = "0123456789ABCDEF";

static NSString * TTTBase16EncodedStringFromData(NSData *data) {
    const uint8_t *inputBuffer = [data bytes];

    NSUInteger length = [data length];
    NSMutableString *mutableString = [NSMutableString stringWithCapacity:length  * 2];

    for (NSUInteger i = 0; i < length; i++) {
        char characters[2] = {};
		characters[0] = _base16Alphabet[(*(inputBuffer + i) & /* 0b11110000 */ 240) >> 4];
		characters[1] = _base16Alphabet[(*(inputBuffer + i) & /* 0b00001111 */ 15)  >> 0];
		[mutableString appendString:[[NSString alloc] initWithBytes:characters length:2 encoding:NSASCIIStringEncoding]];
    }

	return mutableString;
}

static NSData * TTTDataFromBase16EncodedString(NSString *string) {
    NSString *base16String = [string uppercaseString];
    if (([base16String length] % 2) != 0) {
        return nil;
    }

    static NSCharacterSet *base16CharacterSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *mutableBase16CharacterSet = [[NSMutableCharacterSet alloc] init];
        [mutableBase16CharacterSet addCharactersInString:[[NSString alloc] initWithBytes:_base16Alphabet length:16 encoding:NSASCIIStringEncoding]];
        base16CharacterSet = mutableBase16CharacterSet;
    });

	if ([[base16String stringByTrimmingCharactersInSet:base16CharacterSet] length] != 0) {
        return nil;
    }

	NSMutableData *output = [NSMutableData dataWithCapacity:([base16String length] / 2)];

	NSUInteger characterOffset = 0;
	while (characterOffset < [base16String length]) {
		uint8_t values[2] = {0};
		for (NSUInteger valueIndex = 0; valueIndex < 2; valueIndex++) {
			unichar currentCharacter = [base16String characterAtIndex:(characterOffset + valueIndex)];
            const char *ptr = strchr(_base16Alphabet, currentCharacter);
            if (ptr) {
                values[valueIndex] = (ptr - _base16Alphabet);
            }
		}

		uint8_t byte = 0;
		byte = byte | (values[0] << 4);
		byte = byte | (values[1] << 0);

		[output appendBytes:&byte length:1];
		characterOffset += 2;
	}

	return output;
}

static NSString * TTTBase32EncodedStringFromData(NSData *data) {
    SecTransformRef transform = SecEncodeTransformCreate(kSecBase32Encoding, NULL);
    SecTransformSetAttribute(transform, kSecTransformInputAttributeName, (__bridge CFDataRef)data, NULL);
    NSData *encodedData = (__bridge_transfer NSData *)SecTransformExecute(transform, NULL);
    CFRelease(transform);

    return [[NSString alloc] initWithData:encodedData encoding:NSUTF8StringEncoding];
}

static NSData * TTTDataFromBase32EncodedString(NSString *string) {
    SecTransformRef transform = SecDecodeTransformCreate(kSecBase32Encoding, NULL);
    SecTransformSetAttribute(transform, kSecTransformInputAttributeName, (__bridge CFDataRef)[string dataUsingEncoding:NSUTF8StringEncoding], NULL);
    NSData *decodedData = (__bridge_transfer NSData *)SecTransformExecute(transform, NULL);
    CFRelease(transform);

    return decodedData;
}

static NSString * TTTBase64EncodedStringFromData(NSData *data) {
    SecTransformRef transform = SecEncodeTransformCreate(kSecBase64Encoding, NULL);
    SecTransformSetAttribute(transform, kSecTransformInputAttributeName, (__bridge CFDataRef)data, NULL);
    NSData *encodedData = (__bridge_transfer NSData *)SecTransformExecute(transform, NULL);
    CFRelease(transform);

    return [[NSString alloc] initWithData:encodedData encoding:NSUTF8StringEncoding];
}

static NSData * TTTDataFromBase64EncodedString(NSString *string) {
    SecTransformRef transform = SecDecodeTransformCreate(kSecBase64Encoding, NULL);
    SecTransformSetAttribute(transform, kSecTransformInputAttributeName, (__bridge CFDataRef)[string dataUsingEncoding:NSUTF8StringEncoding], NULL);
    NSData *decodedData = (__bridge_transfer NSData *)SecTransformExecute(transform, NULL);
    CFRelease(transform);

    return decodedData;
}

static NSString * TTTBase85EncodedStringFromData(NSData *data) {
    static uint8_t const _b85encode[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#$%&()*+-;<=>?@^_`{|}~";

    NSUInteger length = [data length];
    NSUInteger numberOfBlocks = length / 4;
    NSUInteger remainder = length % 4;

    NSMutableData *output = [NSMutableData dataWithLength:(numberOfBlocks * 5) + (remainder + 1)];
    uint8_t *outputBuffer = [output mutableBytes];
    NSUInteger outputLength = 0;

    for (NSUInteger i = 0; i < numberOfBlocks; i++) {
        uint32_t x = CFSwapInt32BigToHost(*(uint32_t *)([[data subdataWithRange:NSMakeRange(i * 4, 4)] bytes]));
        for (NSUInteger j = 0; j < 5; j++) {
            outputBuffer[outputLength + (4 - j)] = _b85encode[x % 85];
            x /= 85;
        }

        outputLength += 5;
    }

    if (remainder > 0) {
        uint32_t x = CFSwapInt32BigToHost(*(uint32_t*)([[data subdataWithRange:NSMakeRange(numberOfBlocks * 4, remainder)] bytes]));
        for (NSUInteger j = 0; j < 5; j++) {
            outputBuffer[outputLength + (4 - j)] = _b85encode[x % 85];
            x /= 85;
        }

        outputLength += (remainder + 1);
    }

    return [[NSString alloc] initWithBytes:outputBuffer length:outputLength encoding:NSASCIIStringEncoding];
}

static NSData * TTTDataFromBase85EncodedString(NSString *string) {
    static const unsigned char _b85decode[] = {
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
        0, 62,  0, 63, 64, 65, 66,  0, 67, 68, 69, 70,  0, 71,  0,  0,
        0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  0, 72, 73, 74, 75, 76,
        77, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
        25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,  0,  0,  0, 78, 79,
        80, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
        51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 81, 82, 83, 84,  0,
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    };

    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    NSUInteger length = [string lengthOfBytesUsingEncoding:NSASCIIStringEncoding];
    NSUInteger numberOfBlocks = length / 5;
    NSUInteger remainder = length % 5;

    NSMutableData *output = [NSMutableData dataWithLength:numberOfBlocks * 4 + remainder];
    NSUInteger outputLength = 0;

    for (NSUInteger i = 0; i < numberOfBlocks; i++) {
        uint32_t x = 0;
        for (NSUInteger j = 0; j < 5; j++) {
            x = x * 85 + _b85decode[characters[(i * 5) + j]];
        }

        x = CFSwapInt32HostToBig(x);
        [output replaceBytesInRange:NSMakeRange(i * 4, 4) withBytes:&x];
        outputLength += 4;
    }

    if (remainder > 0) {
        uint32_t x = 0;
        for (NSUInteger i = 0; i < remainder; i++) {
            x = x * 85 + _b85decode[characters[(numberOfBlocks * 5) + i]];
        }

        x *= pow(85, 5 - remainder);
        if (remainder > 1) {
            x += 0xffffff >> (remainder - 2) * 8;
        }
        
        x = CFSwapInt32HostToBig(x);
        [output replaceBytesInRange:NSMakeRange((numberOfBlocks * 4), 4) withBytes:&x];
        outputLength += (remainder - 1);
    }
    
    return [output subdataWithRange:NSMakeRange(0, outputLength)];
}

@implementation TTTDataTransformers

+ (void)load {
    @autoreleasepool {
        [NSValueTransformer registerValueTransformerWithName:TTTBase16EncodedDataTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            return TTTBase16EncodedStringFromData(value);
        } allowingReverseTransformationWithBlock:^id(id value) {
            return TTTDataFromBase16EncodedString(value);
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTBase32EncodedDataTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            return TTTBase32EncodedStringFromData(value);
        } allowingReverseTransformationWithBlock:^id(id value) {
            return TTTDataFromBase32EncodedString(value);
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTBase64EncodedDataTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            return TTTBase64EncodedStringFromData(value);
        } allowingReverseTransformationWithBlock:^id(id value) {
            return TTTDataFromBase64EncodedString(value);
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTBase85EncodedDataTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
            return TTTBase85EncodedStringFromData(value);
        } allowingReverseTransformationWithBlock:^id(id value) {
            return TTTDataFromBase85EncodedString(value);
        }];
    }
}


@end
