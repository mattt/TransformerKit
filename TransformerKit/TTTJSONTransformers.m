//
//  TTTJSONTransformers.m
//  TransformerKit Example
//
//  Created by Carl Jahn on 07.10.13.
//  Copyright (c) 2013 Mattt Thompson. All rights reserved.
//

#import "TTTJSONTransformers.h"
#import "NSValueTransformer+TransformerKit.h"

NSString * const TTTJSONTransformerName = @"TTTJSONTransformerName";

static NSString * NSObjectToJSONString(NSObject *object) {

  NSError *error = nil;
  NSData *result = [NSJSONSerialization dataWithJSONObject:object options: NSJSONWritingPrettyPrinted error: &error];
  if (error) {
    return nil;
  }
  
  NSString *resultString = [[NSString alloc] initWithData: result encoding: NSUTF8StringEncoding];
  
#if ! __has_feature(objc_arc)
  [resultString autorelease];
#endif
  
  return resultString;
}

static id JSONStringToNSObject(NSString *json) {

  NSData *jsonData = [json dataUsingEncoding: NSUTF8StringEncoding];
  
  NSError *error = nil;
  id result = [NSJSONSerialization JSONObjectWithData: jsonData options: kNilOptions error: &error];
  if (error) {
    return nil;
  }
  
  return result;
}

@implementation TTTJSONTransformers

+ (void)load {
  
  @autoreleasepool {
    
    [NSValueTransformer registerValueTransformerWithName:TTTJSONTransformerName
                                   transformedValueClass:[NSObject class]
                      returningTransformedValueWithBlock:^id(id value){
                        return NSObjectToJSONString(value);
                      }
                  allowingReverseTransformationWithBlock:^id(id value){
                    return JSONStringToNSObject(value);
                  }
     ];
    
  }
  
  
}

@end
