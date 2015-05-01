#import "XExtensionItemParameters+Tumblr.h"
#import "XExtensionItemTumblrParameters.h"

@implementation XExtensionItemParameters (Tumblr)

- (XExtensionItemTumblrParameters *)tumblrParameters {
    return [[XExtensionItemTumblrParameters alloc] initWithDictionary:self.userInfo];
}

@end
