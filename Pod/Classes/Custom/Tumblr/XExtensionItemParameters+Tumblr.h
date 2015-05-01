#import "XExtensionItemParameters.h"
@class XExtensionItemTumblrParameters;

/**
 Convenience category for getting Tumblr-specific parameters from an `XExtensionItemParameters` instance.
 */
@interface XExtensionItemParameters (Tumblr)

/**
 Tumblr-specific parameters.
 */
@property (nonatomic, readonly) XExtensionItemTumblrParameters *tumblrParameters;

@end
