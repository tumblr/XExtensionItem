#import "XExtensionItem.h"
#import "XExtensionItemTumblrParameters.h"

@interface XExtensionItem (Tumblr)

/**
 Tumblr-specific parameters.
 */
@property (nonatomic, readonly) XExtensionItemTumblrParameters *tumblrParameters;

@end
