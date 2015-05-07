#import <Foundation/Foundation.h>

/**
 A protocol for objects that can be converted to and from dictionaries.
 
 Third-parties can provide custom classes conforming to `XExtensionItemDictionarySerializing` in order to augment the
 generic `XExtensionItem` values with service-specific ones. For example, a `XExtensionItemTumblrParameters` object may 
 define a custom URL property, which applications can set in order to pass a custom URL component to posts created using 
 the Tumblr share extension.
 
 An application would use a custom class that conforms to `XExtensionItemDictionarySerializing` as follows:
 
 ```objc
 XExtensionItemSource *itemSource = …;
 [itemSource addEntriesToUserInfo:({
     [[XExtensionItemTumblrParameters alloc] initWith…];
 })];
 ```
 
 @discussion Conversion should be commutative and should not be lossy, such that the following conditions hold for a
 concrete class `A` that conforms to `XExtensionItemDictionarySerializing`:
 
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
@protocol XExtensionItemDictionarySerializing <NSObject>

/**
 @param dictionary Dictionary whose values the object is to be populated with.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 Dictionary representation of the object.
 */
@property (nonatomic, readonly) NSDictionary *dictionaryRepresentation;

@end
