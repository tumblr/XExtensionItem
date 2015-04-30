#import "XExtensionItemParameters+Tumblr.h"
#import "XExtensionItemMutableParameters+Tumblr.h"
#import "XExtensionItemTumblrParameters.h"

@implementation XExtensionItemMutableParameters (Tumblr)

- (void)setTumblrParameters:(XExtensionItemTumblrParameters *)tumblrParameters {
    [self addEntriesToUserInfo:tumblrParameters];
}

@end
