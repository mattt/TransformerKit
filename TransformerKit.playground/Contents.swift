import Foundation
import TransformerKit

// String Transformers

let stringTransformers: [String: NSValueTransformerName] = [
    "Capitalized String": .capitalizedStringTransformerName,
    "Uppercase String": .uppercaseStringTransformerName,
    "Lowercase String": .lowercaseStringTransformerName,
    "Camel Case String": .camelCaseStringTransformerName,
    "Llama Case String": .llamaCaseStringTransformerName,
    "Snake Case String": .snakeCaseStringTransformerName,
    "Train Case String": .trainCaseStringTransformerName,
    "Reversed String": .reverseStringTransformerName,
    "Rémövê Dîaçritics": .removeDiacriticStringTransformerName,
    "ट्रांस्लितेराते स्ट्रिंग": .transliterateStringToLatinTransformerName
]

for (source, name) in stringTransformers {
    guard let transformer = ValueTransformer(forName: name),
        let result = transformer.transformedValue(source)
    else {
        fatalError()
    }

    print("\(source): \(result)")
}

// Reversable String Transformers

let reverseStringTransformers: [String: NSValueTransformerName] = [
    "CamelCaseString": .camelCaseStringTransformerName,
    "llamaCaseString": .llamaCaseStringTransformerName,
    "snake_case_string": .snakeCaseStringTransformerName,
    "train-case-string": .trainCaseStringTransformerName,
    "gnirtS desreveR": .reverseStringTransformerName
]

for (source, name) in reverseStringTransformers {
    guard let transformer = ValueTransformer(forName: name),
        let result = transformer.transformedValue(source)
        else {
            fatalError()
    }

    print("\(source): \(result)")
}

// Date Transformers

let dateTransformers: [String: NSValueTransformerName] = [
    "ISO 8601": .iso8601DateTransformerName,
    "RFC 2822": .rfc2822DateTransformerName
]

for (description, name) in dateTransformers {
    guard let transformer = ValueTransformer(forName: name),
        let timestamp = transformer.transformedValue(Date()) as? String,
        let date = transformer.reverseTransformedValue(timestamp) as? Date
    else {
        fatalError()
    }

    print("\(description): \(timestamp) - \(date)")
}

// Data Transformers

let dataTransformers: [String: NSValueTransformerName] = [
    "Base16Encode": .base16EncodedDataTransformerName,
    "Base32Encode": .base32EncodedDataTransformerName,
    "Base64Encode": .base64EncodedDataTransformerName,
    "Base85Encode": .base85EncodedDataTransformerName
]

for (source, name) in dataTransformers {
    guard let transformer = ValueTransformer(forName: name),
        let data = source.data(using: .utf8),
        let result = transformer.transformedValue(data) as? String
    else {
        fatalError()
    }

    print("\(source): \(result)")
}


let cryptoTransformers: [String: NSValueTransformerName] = [
    "MD5 Digest": .md5TransformerName,
    "SHA-1 Digest": .sha1TransformerName,
    "SHA-256 Digest": .sha256TransformerName
]

// Cryptographic Transformers

for (source, name) in cryptoTransformers {
    guard let transformer = ValueTransformer(forName: name),
        let data = source.data(using: .utf8),
        let result = transformer.transformedValue(data) as? Data
    else {
        fatalError()
    }

    print("\(source): \(result)")
}
