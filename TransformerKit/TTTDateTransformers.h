//
//  TTTDateTransformers.h
//  TransformerKit Example
//
//  Created by Cory D. Wiles on 4/24/13.
//  Copyright (c) 2013 Mattt Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Reference to transformer that will take a date object and return 
 * a string using the default formatter
 * @see NSDateFormatter+TransformerKitAdditions for standard format
 */
extern NSString * const TTTDefaultDateStringTransformerName;

/**
 * Reference to transformer that will take a date object and return
 * a string using a custom format string
 */
extern NSString * const TTTDateStringTransformerName;

/**
 * Reference to transformer that will take a date string and return
 * a date object using the default formatter
 * @see NSDateFormatter+TransformerKitAdditions for standard format
 */
extern NSString * const TTTDefaultStringDateTransformerName;

/**
 * Reference to transformer that will take a date string and return
 * a date object using a custom format string
 */
extern NSString * const TTTStringDateTransformerName;

/**
 * If you are going to use a custom formatter than you need to pass then this
 * is the dictionary key that must be used.
 */
extern NSString * const TTTDateTransformerCustomFormatKey;

/**
 * If you are going to use a custom formatter than you need to pass then this
 * is the dictionary key that must be used that references your date object.
 */
extern NSString * const TTTDateTransformerCustomDateStringKey;

/**
 * If you are going to use a custom formatter than you need to pass then this
 * is the dictionary key that must be used that references your string 
 * representation of a date
 */
extern NSString * const TTTDateTransformerCustomStringDateKey;

@interface TTTDateTransformers : NSObject

@end
