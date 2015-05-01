#import "XExtensionItem+Tumblr.h"

@implementation XExtensionItem (Tumblr)

- (XExtensionItemTumblrParameters *)tumblrParameters {
    return [[XExtensionItemTumblrParameters alloc] initWithDictionary:self.userInfo];
}

@end
