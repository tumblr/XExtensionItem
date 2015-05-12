#import <Foundation/Foundation.h>

/**
 A protocol for objects that model custom `XExtensionItem` parameters.
 
 Third-parties can provide custom classes conforming to `XExtensionItemDictionarySerializing` in order to augment the
 generic `XExtensionItem` values with service-specific ones. See `XExtensionItemTumblrParameters` for an example of 
 this.

 An application would use a custom class that conforms to `XExtensionItemCustomParameters` as follows:
 
 ```objc
 XExtensionItemSource *itemSource = …;
 [itemSource addCustomParameters:({
     [[XExtensionItemTumblrParameters alloc] initWith…];
 })];
 ```
 
 @discussion Conversion should be commutative and should not be lossy, such that the following conditions hold for a
 concrete class `A` that conforms to `XExtensionItemCustomParameters`:
 
 ```objc
 NSDictionary *dictionary = …;
 A *instance = [[A alloc] initWithDictionary:dictionary];
 [dictionary isEqual:instance.dictionaryRepresentation]; // YES
 ```
 
 As well as:
 
 ```objc
 A *instance = …;
 NSDictionary *dictionary = instance.dictionaryRepresentation;
 [A isEqual:[[A alloc] initWithDictionary:dictionary]]; // YES
 ```
 */
@protocol XExtensionItemCustomParameters <NSObject>

/**
 @param dictionary Dictionary whose values the object is to be populated with.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 Dictionary representation of the object. Keys returned in this dictionary should be properly namespaced and should 
 *not* start with `x-extension-item`, as those are used internally by this library.
 */
@property (nonatomic, readonly) NSDictionary *dictionaryRepresentation;

@end
