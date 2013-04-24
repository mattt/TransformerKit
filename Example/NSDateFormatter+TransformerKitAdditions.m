//
//  NSDateFormatter+TransformerKitAdditions.m
//  TransformerKit Example
//
//  Created by Cory D. Wiles on 4/24/13.
//  Copyright (c) 2013 Mattt Thompson. All rights reserved.
//

#import "NSDateFormatter+TransformerKitAdditions.h"
#import <objc/runtime.h>

static const NSString *TTTNSDateFormatterReadDictionaryKey   = @"TTTDateReader";
static const NSString *TTTNSDateFormatterWriterDictionaryKey = @"TTTDateWriter";

static char TTTDateFormatterDictionarCacheKey;

NSString * const TTTDateStandardFormat = @"MM-dd-yyyy";

@implementation NSDateFormatter (TransformerKitAdditions)

+ (void)load {

    NSMutableDictionary *formatterCache = [NSMutableDictionary new];

    objc_setAssociatedObject(self, &TTTDateFormatterDictionarCacheKey, formatterCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSDateFormatter *)dateFormatterReader {

    static NSString *__standardFormat = nil;

    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateReader     = [dictionary objectForKey:TTTNSDateFormatterReadDictionaryKey];

    if (!dateReader) {

        if (__standardFormat == nil) {
            __standardFormat = TTTDateStandardFormat;
        }

        dateReader = [[self alloc] init];

        dateReader.locale     = [NSLocale currentLocale];
        dateReader.timeZone   = [NSTimeZone systemTimeZone];
        dateReader.dateFormat = __standardFormat;

        [dictionary setObject:dateReader forKey:TTTNSDateFormatterReadDictionaryKey];
    }

    return dateReader;
}

+ (NSDateFormatter *)dateFormatterWriter:(NSString *)format {

    NSMutableDictionary *formatterCache   = objc_getAssociatedObject(self, &TTTDateFormatterDictionarCacheKey);
    NSDateFormatter *cachedFormatter      = formatterCache[format];
    NSMutableDictionary *dictionary       = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *currentDateFormatter = [dictionary objectForKey:TTTNSDateFormatterWriterDictionaryKey];

    if (cachedFormatter) {

        [dictionary setObject:cachedFormatter forKey:TTTNSDateFormatterWriterDictionaryKey];

        return cachedFormatter;
    }

    if (!currentDateFormatter) {

        currentDateFormatter = [[self alloc] init];

        currentDateFormatter.locale     = [NSLocale currentLocale];
        currentDateFormatter.timeZone   = [NSTimeZone systemTimeZone];
        currentDateFormatter.dateFormat = format;

        [dictionary setObject:currentDateFormatter forKey:TTTNSDateFormatterWriterDictionaryKey];

        formatterCache[format] = currentDateFormatter;
    }
    
    return currentDateFormatter;
}

@end
