// NSValueTransformer+TransformerKit.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me)
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

#import "NSValueTransformer+TransformerKit.h"

#import <Availability.h>
#import <objc/runtime.h>

@implementation NSValueTransformer (TransformerKit)

+ (BOOL)registerValueTransformerWithName:(NSString *)name
                   transformedValueClass:(Class)transformedValueClass
      returningTransformedValueWithBlock:(id (^)(id value))transformedValueBlock
{
    return [self registerValueTransformerWithName:name transformedValueClass:transformedValueClass returningTransformedValueWithBlock:transformedValueBlock allowingReverseTransformationWithBlock:nil];
}

+ (BOOL)registerValueTransformerWithName:(NSString *)name
                   transformedValueClass:(Class)transformedValueClass
      returningTransformedValueWithBlock:(id (^)(id value))transformedValueBlock
  allowingReverseTransformationWithBlock:(id (^)(id value))reverseTransformedValueBlock
{
    NSParameterAssert(name);
    NSParameterAssert(transformedValueClass);
    NSParameterAssert(transformedValueBlock);
    
    if (objc_lookUpClass([name UTF8String])) {
        return NO;
    }
    
    if ([NSValueTransformer valueTransformerForName:name]) {
        return NO;
    }
    
    Class class = objc_allocateClassPair([NSValueTransformer class], [name UTF8String], 0);
    if (!class) {
        return NO;
    }
    
    SEL transformedValueClassSelector = @selector(transformedValueClass);
    IMP transformedValueClassImplementation = imp_implementationWithBlock(^Class {
        return transformedValueClass;
    });
    Method transformedValueClassMethod = class_getClassMethod(class, transformedValueClassSelector);
    class_replaceMethod(class, transformedValueClassSelector, transformedValueClassImplementation, method_getTypeEncoding(transformedValueClassMethod));
    
    SEL transformedValueSelector = @selector(transformedValue:);
    IMP transformedValueImplementation = imp_implementationWithBlock(^id (id __unused _self, id _value){
        return transformedValueBlock(_value);
    });
    Method transformedValueMethod = class_getInstanceMethod(class, transformedValueSelector);
    class_replaceMethod(class, transformedValueSelector, transformedValueImplementation, method_getTypeEncoding(transformedValueMethod));
    
    if (reverseTransformedValueBlock) {
        SEL allowsReverseTransformationSelector = @selector(allowsReverseTransformation);
        IMP allowsReverseTransformationImplementation = imp_implementationWithBlock(^BOOL (id __unused _self) {
            return YES;
        });

        Method allowsReverseTransformationMethod;
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && (!defined(__IPHONE_5_0) || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0)
        allowsReverseTransformationMethod = class_getClassMethod(class, allowsReverseTransformationSelector);
#elif defined(MAC_OS_X_VERSION_MIN_REQUIRED) && (!defined(MAC_OS_X_VERSION_10_8) || MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_8)
        allowsReverseTransformationMethod = class_getClassMethod(class, allowsReverseTransformationSelector);
#else
        allowsReverseTransformationMethod = class_getInstanceMethod(class, allowsReverseTransformationSelector);
#endif

        class_replaceMethod(class, allowsReverseTransformationSelector, allowsReverseTransformationImplementation, method_getTypeEncoding(allowsReverseTransformationMethod));
        
        SEL reverseTransformedValueSelector = @selector(reverseTransformedValue:);
        IMP reverseTransformedValueImplementation = imp_implementationWithBlock(^id (id __unused _self, id _value){
            return reverseTransformedValueBlock(_value);
        });
        Method reverseTransformedValueMethod = class_getInstanceMethod(class, reverseTransformedValueSelector);
        class_replaceMethod(class, reverseTransformedValueSelector, reverseTransformedValueImplementation, method_getTypeEncoding(reverseTransformedValueMethod));
    }
    
    objc_registerClassPair(class);
    
    NSValueTransformer *valueTransformer = [[class alloc] init];
    [self setValueTransformer:valueTransformer forName:name];

    return YES;
}

@end
