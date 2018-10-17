// TTTImageTransformers.h
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

#import <Foundation/Foundation.h>
#import "NSValueTransformerName.h"

NS_ASSUME_NONNULL_BEGIN

#if defined(UIKIT_EXTERN) || defined(_APPKITDEFINES_H)

#define kTTTJPEGRepresentationCompressionQuality 0.75

/**
 
 */
extern NSValueTransformerName const TTTPNGRepresentationImageTransformerName NS_SWIFT_NAME(pngRepresentationImageTransformerName);

/**
 
 */
extern NSValueTransformerName const TTTJPEGRepresentationImageTransformerName NS_SWIFT_NAME(jpegRepresentationImageTransformerName);

#if __MAC_OS_X_VERSION_MIN_REQUIRED
/**
 
 */
extern NSValueTransformerName const TTTGIFRepresentationImageTransformerName NS_SWIFT_NAME(gifRepresentationImageTransformerName);

/**
 
 */
extern NSValueTransformerName const TTTTIFFRepresentationImageTransformerName NS_SWIFT_NAME(tiffRepresentationImageTransformerName);
#endif

@interface TTTImageTransformers : NSObject

@end

#endif

NS_ASSUME_NONNULL_END
