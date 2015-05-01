#import "XExtensionItemMutableParameters.h"
@class XExtensionItemTumblrParameters;

/**
 Convenience category for getting/setting Tumblr-specific parameters from/on an `XExtensionItemParameters` instance.
 */
@interface XExtensionItemMutableParameters (Tumblr)

/**
 Tumblr-specific parameters.
 */
@property (nonatomic) XExtensionItemTumblrParameters *tumblrParameters;

@end
