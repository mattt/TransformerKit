// main.swift
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

import Foundation

let stringTransforms: [(AnyObject, String)] = [("Capitalized String", TTTCapitalizedStringTransformerName),
                        ("Uppercase String", TTTUppercaseStringTransformerName),
                        ("Lowercase String", TTTLowercaseStringTransformerName),
                        ("Camel Case String", TTTCamelCaseStringTransformerName),
                        ("Llama Case String", TTTLlamaCaseStringTransformerName),
                        ("Snake Case String", TTTSnakeCaseStringTransformerName),
                        ("Train Case String", TTTTrainCaseStringTransformerName),
                        ("Reversed String", TTTReverseStringTransformerName),
                        ("Rémövê Dîaçritics", TTTRemoveDiacriticStringTransformerName),
                        ("ट्रांस्लितेराते स्ट्रिंग", TTTTransliterateStringToLatinTransformerName),
                        (["key": "value"], TTTJSONTransformerName)]

let reverseStringTransforms = [("CamelCaseString", TTTCamelCaseStringTransformerName),
                        ("llamaCaseString", TTTLlamaCaseStringTransformerName),
                        ("snake_case_string", TTTSnakeCaseStringTransformerName),
                        ("train-case-string", TTTTrainCaseStringTransformerName),
                        ("gnirtS desreveR", TTTReverseStringTransformerName)]

let dateTransforms = [TTTISO8601DateTransformerName, TTTRFC2822DateTransformerName]

//let cryptoTransforms = [TTTMD5TransformerName, TTTSHA1TransformerName, TTTSHA256TransformerName]

let dataTransforms = [TTTBase16EncodedDataTransformerName, TTTBase32EncodedDataTransformerName, TTTBase64EncodedDataTransformerName, TTTBase85EncodedDataTransformerName]

for (source, name) in stringTransforms {
    let transformer = NSValueTransformer(forName: name)
    println("\(source): \(transformer?.transformedValue(source))")
}

for (source, name) in reverseStringTransforms {
    let transformer = NSValueTransformer(forName: name)
    println("\(source): \(transformer?.reverseTransformedValue(source))")
}

let _ = { [ source = "s\\v'ErStS", icuTransform = "IPA-XSampa" ] in
    println("\(source): \(TTTStringTransformerForICUTransform(icuTransform)?.reverseTransformedValue(source))")
}()

for name in dateTransforms {
    let transformer = NSValueTransformer(forName: name)
    let transformedValue = transformer?.transformedValue(NSDate()) as? String
    let reversedValue = transformer?.reverseTransformedValue(transformedValue) as? NSDate
    println("\(name) (Timestamp): \(transformedValue)")
    println("\(name) (Date): \(reversedValue)")
}

//for name in cryptoTransforms {
//    let transformer = NSValueTransformer(forName: name)
//    println("\(name): \(transformer?.transformedValue(name.dataUsingEncoding(NSASCIIStringEncoding)))")
//}

for name in dataTransforms {
    let transformer = NSValueTransformer(forName: name)
    let data = name.dataUsingEncoding(NSASCIIStringEncoding)
    
    println("\(name): \(transformer?.transformedValue(data))")
    
    if let equal = data?.isEqualToData(transformer?.reverseTransformedValue(transformer?.transformedValue(data)) as NSData) {
        println(equal ? "Equal" : "Not equal!")
    }
}
