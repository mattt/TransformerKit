TransformerKit
==============

**A block-based API for NSValueTransformer, with a growing collection of useful examples.**

[`NSValueTransformer`](http://nshipster.com/nsvaluetransformer/), while perhaps obscure to most iOS programmers, remains a staple of OS X development. Before Objective-C APIs got in the habit of flinging block parameters hither and thither with reckless abandon, `NSValueTransformer` was the go-to way to encapsulate mutation functionality--especially when it came to Bindings.

`NSValueTransformer` is convenient to use, but a pain to set up. Creating even a trivial value transformer required creating of its own subclass, implementing the handful of required methods, and registering a singleton instance by name.

TransformerKit breathes new life into `NSValueTransformer`, by making them dead-simple to define and register:

```objective-c
NSString * const TTTCapitalizedStringTransformerName = @"TTTCapitalizedStringTransformerName";

[NSValueTransformer registerValueTransformerWithName:TTTCapitalizedStringTransformerName
                               transformedValueClass:[NSString class]
                  returningTransformedValueWithBlock:^id(id value) {
  return [value capitalizedString];
}];
```

> TransformerKit pairs nicely with [InflectorKit](https://github.com/mattt/InflectorKit) & [FormatterKit](https://github.com/mattt/FormatterKit), providing well-designed APIs for manipulating user-facing content.

---

TransformerKit also contains a _growing_ number of convenient transformers that your apps will love and cherish:

### String Transformers

- Capitalized
- UPPERCASE
- lowercase
- CamelCase
- llamaCase
- snake_case
- train-case
- esreveR* _(Reverse)_
- Rémövê Dîaçritics _(Remove accents and combining marks)_
- ट्रांस्लितेराते स्ट्रिंग _(Transliterate to Latin)_
- Any Valid [ICU Transform](http://userguide.icu-project.org/transforms/general)*

### Image Transformers

- PNG Representation*
- JPEG Representation*

### Data Transformers

- Base16 String Encode / Decode
- Base32 String Encode / Decode
- Base64 String Encode / Decode
- Base85 String Encode / Decode

### Date Transformers

- ISO 8601 Timestamp*

### JSON Data Transformers

- JSON Transformer*

### Cryptographic Transformers _(OS X)_

- MD5, SHA-1, SHA-256, et al. Digest

> \* - **Reversible**

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## License

TransformerKit is available under the MIT license. See the LICENSE file for more info.
