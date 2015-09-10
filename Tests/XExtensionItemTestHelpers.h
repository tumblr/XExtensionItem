@interface XExtensionItemSource (Testing)

@property (nonatomic, readonly) id facebookItem;

@end

@implementation XExtensionItemSource (Testing)

- (id)facebookItem {
    return [self activityViewController:nil itemForActivityType:UIActivityTypePostToFacebook];
}

@end
