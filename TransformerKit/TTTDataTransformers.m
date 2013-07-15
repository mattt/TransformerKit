//
//  TTTDataTransformers.m
//  TransformerKit Example
//
//  Created by Paulo Andrade on 7/15/13.
//  Copyright (c) 2013 Mattt Thompson. All rights reserved.
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


#import "TTTDataTransformers.h"
#import "NSValueTransformer+TransformerKit.h"

NSString * const TTTHexDataTransformerName = @"TTTHexDataTransformerName";

static NSData *TTTHexDataFromString(NSString *hexString){
    const char *pos = [hexString UTF8String];
    unsigned char dataOut[strlen(pos)];
    int i = 0;
    
    while( *pos ){
        sscanf(pos, "%02x", (unsigned int*)&dataOut[i]);
        pos += 2; i++;
    }
    return [NSData dataWithBytes:dataOut length:i];
}

static NSString *TTTHexStringFromData(NSData *data){
    unsigned char *bytes = (unsigned char *)[data bytes];
    int length = (int)[data length];
    char *hex = (char*)malloc(2*length+1);
    
    int j = 0;
    for(int i = 0; i<length; i++, j+=2){
        sprintf(hex+j, "%02x", bytes[i]);
    }
    hex[j] = '\0';
    
    return [[NSString alloc] initWithBytesNoCopy:hex length:j encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@implementation TTTDataTransformers

+ (void)load {
    @autoreleasepool {
        [NSValueTransformer registerValueTransformerWithName:TTTHexDataTransformerName transformedValueClass:[NSData class] returningTransformedValueWithBlock:^id(id value) {
            return TTTHexStringFromData(value);
        } allowingReverseTransformationWithBlock:^id(id value) {
            return TTTHexDataFromString(value);
        }];
    }
}

@end
