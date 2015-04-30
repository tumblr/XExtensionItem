@interface XExtensionItemAttachment : NSObject

/**
 *  <#Description#>
 */
@property (nonatomic, readonly, nonnull) id <NSSecureCoding> item;

/**
 *  <#Description#>
 */
@property (nonatomic, readonly, nonnull) NSString *typeIdentifier;

/**
 *  <#Description#>
 *
 *  @param item           <#item description#>
 *  @param typeIdentifier <#typeIdentifier description#>
 *
 *  @return <#return value description#>
 */
- (nullable instancetype)initWithItem:(id <NSSecureCoding> __nullable)item
                       typeIdentifier:(NSString  * __nullable)typeIdentifier NS_DESIGNATED_INITIALIZER;

@end
