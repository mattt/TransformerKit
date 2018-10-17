// TTTDateTransformers.m
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

#import "TTTDateTransformers.h"

#import "NSValueTransformer+TransformerKit.h"

@import Darwin.C.time;
@import Darwin.C.xlocale;

NS_ASSUME_NONNULL_BEGIN

NSValueTransformerName const TTTISO8601DateTransformerName = @"TTTISO8601DateTransformerName";
NSValueTransformerName const TTTRFC2822DateTransformerName = @"TTTRFC2822DateTransformerName";

static NSString * TTTISO8601TimestampFromDate(NSDate *date) {
    static NSDateFormatter *_iso8601DateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _iso8601DateFormatter = [[NSDateFormatter alloc] init];
        [_iso8601DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [_iso8601DateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [_iso8601DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });

    return [_iso8601DateFormatter stringFromDate:date];
}

static NSDate * _Nullable TTTDateFromISO8601Timestamp(NSString *timestamp) {
    if (!timestamp) {
        return nil;
    }

    static unsigned int const ISO_8601_MAX_LENGTH = 29;
    
    const char *source = [timestamp cStringUsingEncoding:NSUTF8StringEncoding];
    char destination[ISO_8601_MAX_LENGTH];
    size_t length = strlen(source);
    
    if (length == 0) {
        return nil;
    }

    double milliseconds = 0.0;
    if (length == 20 && source[length - 1] == 'Z') {
        memcpy(destination, source, length - 1);
        strncpy(destination + length - 1, "+0000\0", 6);
    } else if (length == 24 && source[length - 5] == '.' && source[length - 1] == 'Z') {
        memcpy(destination, source, length - 5);
        strncpy(destination + length - 5, "+0000\0", 6);
        milliseconds = [[timestamp substringWithRange:NSMakeRange(20, 3)] doubleValue] / 1000.0;
    } else if (length == 25 && source[22] == ':') {
        memcpy(destination, source, 22);
        memcpy(destination + 22, source + 23, 2);
    } else if (length == 29 && source[26] == ':') {
        memcpy(destination, source, 26);
        memcpy(destination + 26, source + 27, 2);
        milliseconds = [[timestamp substringWithRange:NSMakeRange(20, 3)] doubleValue] / 1000.0;
    } else {
        memcpy(destination, source, MIN(length, ISO_8601_MAX_LENGTH - 1));
    }
    
    destination[sizeof(destination) - 1] = 0;

    struct tm time = {
        .tm_isdst = -1,
    };

    strptime_l(destination, "%FT%T%z", &time, NULL);

    return [NSDate dateWithTimeIntervalSince1970:mktime(&time) + milliseconds];
}

static NSString * TTTRFC2822TimestampFromDate(NSDate *date) {
    static NSDateFormatter *_rfc2822DateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _rfc2822DateFormatter = [[NSDateFormatter alloc] init];
        [_rfc2822DateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
        [_rfc2822DateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [_rfc2822DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });

    return [_rfc2822DateFormatter stringFromDate:date];
}

static inline const char * _Nullable TTTFormatForRFC2822Timestamp(const char *timestamp) {
    NSCParameterAssert(timestamp);

    size_t length = strlen(timestamp);
    switch (length) {
        case 11:
            return "%d %b %Y";
        case 15:
            return "%a %d %b %Y";
        case 16:
            if (timestamp[3] == ',') {
                return "%a, %d %b %Y";
            } else if (timestamp[14] == ':') {
                return "%d %b %Y %H:%M";
            }
            break;
        case 18:
            return "%d %b %Y %H:%M:%S";
        case 21:
            return "%a %d %b %Y %H:%M";
        case 22:
            return "%a, %d %b %Y %H:%M";
        case 24:
            return "%d %b %Y %H:%M:%S";
        case 25:
            return "%a, %d %b %Y %H:%M:%S";
        case 26:
            return "%d %b %Y %H:%M:%S %z";
        case 28:
        case 29:
            if (timestamp[3] == ',') {
                return "%a, %d %b %Y %H:%M:%S %Z";
            } else {
                return "%a %d %b %Y %H:%M:%S %Z";
            }
        case 30:
        case 31:
            if (timestamp[3] == ',') {
                return "%a, %d %b %Y %H:%M:%S %z";
            } else {
                return "%a %d %b %Y %H:%M:%S %z";
            }
        default:
            break;
    }

    return NULL;
}

static NSDate * _Nullable TTTDateFromRFC2822Timestamp(NSString *timestamp) {
    if (!timestamp) {
        return nil;
    }

    const char *source = [timestamp cStringUsingEncoding:NSUTF8StringEncoding];
    const char *format = TTTFormatForRFC2822Timestamp(source);

    if (format == NULL) {
        return nil;
    }

    struct tm time = {
        .tm_isdst = -1,
    };

    strptime_l(source, format, &time, NULL);

    return [NSDate dateWithTimeIntervalSince1970:mktime(&time)];
}

@implementation TTTDateTransformers

+ (void)load {
    @autoreleasepool {
        [NSValueTransformer registerValueTransformerWithName:TTTISO8601DateTransformerName transformedValueClass:[NSDate class] returningTransformedValueWithBlock:^id(id value) {
            return TTTISO8601TimestampFromDate(value);
        } allowingReverseTransformationWithBlock:^id(id value) {
            return TTTDateFromISO8601Timestamp(value);
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTRFC2822DateTransformerName transformedValueClass:[NSDate class] returningTransformedValueWithBlock:^id(id value) {
            return TTTRFC2822TimestampFromDate(value);
        } allowingReverseTransformationWithBlock:^id(id value) {
            return TTTDateFromRFC2822Timestamp(value);
        }];
    }
}

@end

NS_ASSUME_NONNULL_END
