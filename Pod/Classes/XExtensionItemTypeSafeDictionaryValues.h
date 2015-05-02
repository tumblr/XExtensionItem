/**
 Helper class for extracting type-safe values out of an `NSDictionary`. Useful when implementing a custom parameters 
 class that conforms to `XExtensionItemDictionarySerializing` (see `XExtensionItemTumblrParameters`).
 */
@interface XExtensionItemTypeSafeDictionaryValues : NSObject

/**
 @param dictionary Dictionary to read values from.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

#pragma mark - Type-safe accessors

/**
 @param key The key for which to return the corresponding value.
 
 @return The string associated with the key, or `nil` if the key either doesn’t exist in the dictionary or maps to a 
 value that isn’t a string.
 */
- (NSString *)stringForKey:(NSString *)key;

/**
 @param key The key for which to return the corresponding value.
 
 @return The number associated with the key, or `nil` if the key either doesn’t exist in the dictionary or maps to a
 value that isn’t a number.
 */
- (NSNumber *)numberForKey:(NSString *)key;

/**
 @param key The key for which to return the corresponding value.
 
 @return The URL associated with the key, or `nil` if the key either doesn’t exist in the dictionary or maps to a 
 value that isn’t a URL.
 */
- (NSURL *)URLForKey:(NSString *)key;

/**
 @param key The key for which to return the corresponding value.
 
 @return The dictionary associated with the key, or `nil` if the key either doesn’t exist in the dictionary or maps 
 to a value that isn’t a dictionary.
 */
- (NSDictionary *)dictionaryForKey:(NSString *)key;

/**
 @param key The key for which to return the corresponding value.
 
 @return The array associated with the key, or `nil` if the key either doesn’t exist in the dictionary or maps to a 
 value that isn’t a string.
 */
- (NSArray *)arrayForKey:(NSString *)key;

/**
 @param key The key for which to return the corresponding value.
 
 @return The data associated with the key, or `nil` if the key either doesn’t exist in the dictionary or maps to a 
 value that isn’t a data.
 */
- (NSData *)dataForKey:(NSString *)key;

/**
 @param key The key for which to return the corresponding value.
 
 @return The unsigned integer associated with the key, or `NSNotFound` if the key either doesn’t exist in the dictionary 
 or maps to a value that isn’t an unsigned integer.
 */
- (NSUInteger)unsignedIntegerForKey:(NSString *)key;

@end
