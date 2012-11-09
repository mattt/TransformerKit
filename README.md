TransformerKit
==============

**Transforming Ordinary Code into Awesomesauce**

`NSValueTransformer`, while somewhat obscure to most iOS programmers, is a mainstay of OS X development. Before Objective-C APIs had the ability to fling hither and thither with reckless abandon, `NSValueTransformer` was the go-to way to encapsulate mutation functionality--especially when it came to Bindings.

Back in those early days, `NSValueTransformer` was convenient to use, but a pain to set up. Creating even a trivial value transformer required creating of its own subclass, implementing the handful of required methods, and registering a singleton instance by name.

TransformerKit breathes new life into `NSValueTransformer`, by making them dead-simple to define and register:

```objective-c
NSString * const TKCapitalizedStringTransformerName = @"TKCapitalizedStringTransformerName";

[NSValueTransformer registerValueTransformerWithName:TKCapitalizedStringTransformerName 
                               transformedValueClass:[NSString class] 
                  returningTransformedValueWithBlock:^id(id value) {
  return [value capitalizedString];
}];
```

TransformerKit also contains a _growing_ number of convenient transformers that your apps will love and cherish:

### String Transformers

- Capitalized
- UPPERCASE
- lowercase
- CamelCase
- llamaCase
- snake_case
- train-case

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## License

TransformerKit is available under the MIT license. See the LICENSE file for more info.
