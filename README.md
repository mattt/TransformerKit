# TransformerKit

**A block-based API for NSValueTransformer,
with a growing collection of useful examples.**

[`NSValueTransformer`](https://nshipster.com/nsvaluetransformer/),
while perhaps obscure to most iOS programmers,
remains a staple of OS X development.
Before Objective-C APIs got in the habit of
flinging block parameters hither and thither with reckless abandon, `NSValueTransformer` was the go-to way to encapsulate mutation functionality --- especially when it came to Bindings.

`NSValueTransformer` is convenient to use but a pain to set up.
To create a value transformer you have to
create a subclass,
implement a handful of required methods,
and register a singleton instance by name.

TransformerKit breathes new life into `NSValueTransformer`
by making them dead-simple to define and register:

```objective-c
NSString * const TTTCapitalizedStringTransformerName = @"TTTCapitalizedStringTransformerName";

[NSValueTransformer registerValueTransformerWithName:TTTCapitalizedStringTransformerName
                               transformedValueClass:[NSString class]
                  returningTransformedValueWithBlock:^id(id value) {
  return [value capitalizedString];
}];
```

> TransformerKit pairs nicely with
> [InflectorKit](https://github.com/mattt/InflectorKit) and
> [FormatterKit](https://github.com/mattt/FormatterKit),
> providing well-designed APIs for manipulating user-facing content.

---

TransformerKit also contains a _growing_ number of convenient transformers
that your apps will love and cherish:

### String Transformers

- Capitalized
- UPPERCASE
- lowercase
- CamelCase
- llamaCase
- snake_case
- train-case
- esreveR\* _(Reverse)_
- Rémövê Dîaçritics _(Remove accents and combining marks)_
- ट्रांस्लितेराते स्ट्रिंग _(Transliterate to Latin)_
- Any Valid [ICU Transform](http://userguide.icu-project.org/transforms/general)\*

### Image Transformers

- PNG Representation\*
- JPEG Representation\*

### Data Transformers

- Base16 String Encode / Decode
- Base32 String Encode / Decode
- Base64 String Encode / Decode
- Base85 String Encode / Decode

### Date Transformers

- [ISO 8601](http://www.iso.org/iso/home/standards/iso8601.htm) Timestamp\*
- [RFC 2822](https://www.ietf.org/rfc/rfc2822) Timestamp\*

### JSON Data Transformers

- JSON Transformer\*

### Cryptographic Transformers _(OS X)_

- MD5, SHA-1, SHA-256, et al. Digests

> \* - **Reversible**

## Contact

Mattt ([@mattt](https://twitter.com/mattt))

## License

TransformerKit is released under the MIT license.
See the LICENSE file for more info.
