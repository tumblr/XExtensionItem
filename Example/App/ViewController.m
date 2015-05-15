@import MobileCoreServices;
#import "ViewController.h"
#import <XExtensionItem/XExtensionItem.h>
#import <XExtensionItem/XExtensionItemTumblrParameters.h>

@implementation ViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                          target:self
                                                                                          action:@selector(action)];
}

#pragma mark - Actions

- (void)action {
    /*
     An item source must be initialized with a single item. This item’s type will be used to determine which activities 
     and extensions are displayed; for example, here we’re initializing with a URL so any system activity or third-party 
     share extension that can take a URL as input will be displayed.
     
     You can create an item source out of any raw data so long as you specify its type identifier, but there are 
     convenience initializers for creating out of a URL, a string, or an image.
     
     Additionally, convenient block-based initializers allow you to lazily construct the item once the user has selected 
     an activity (a placeholder will be used in the interim).
     */
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithURL:[NSURL URLWithString:@"http://apple.com/ipad-air-2/"]];
    
    /*
     If the user selects a system activity that isn’t smart enough to receive structured data (e.g. “Copy”), the item 
     that your item source was initialized with will simply be passed to it.
     
     If the user selects a third-party share extension, however, we’ll pass not only the primary item but also the 
     following additional attachments.
     
     These attachments can be URLs, strings, images, or `NSItemProvider` instances for more advanced functionality 
     (check out the `NSItemProvider` documentation).
     */
    itemSource.additionalAttachments = @[@"String of text", [UIImage imageNamed:@"thumbnail"]];
    
    /*
     XExtensionItem contains a number of “generic parameters” which are not specific to any share extension. Apps should
     populate them in order to benefit from extensions that choose to consume them.
     
     Some built-in activities (e.g. `UIActivityTypePostToTwitter`) will consume the attributed content text field (if 
     populated), while others (e.g. “Copy” or “Add to Reading List”) only know how to accept a single attachment. 
     XExtensionItem is smart enough to handle this for you.
     */
    itemSource.title = @"Apple";
    itemSource.attributedContentText = [[NSAttributedString alloc] initWithString:@"iPad Air 2. Change is in the air"];
    itemSource.tags = @[@"apple", @"ipad", @"ios"];
    itemSource.sourceURL = [NSURL URLWithString:@"http://apple.com"];
    itemSource.referrer = [[XExtensionItemReferrer alloc] initWithAppNameFromBundle:[NSBundle mainBundle]
                                                                         appStoreID:@"12345"
                                                                       googlePlayID:@"12345"
                                                                             webURL:[NSURL URLWithString:@"http://myservice.com/a94ks0583k"]
                                                                          iOSAppURL:[NSURL URLWithString:@"myservice://content/a94ks0583k"]
                                                                      androidAppURL:[NSURL URLWithString:@"myservice://content/a94ks0583k"]];
    
    /*
     Third-party extension developers can add support for custom parameters by creating a class that conforms to 
     `XExtensionItemCustomParameters` and adding it to XExtensionItem. 
     
     Here’s an example of a custom parameters class created by Tumblr.
     */
    [itemSource addCustomParameters:[[XExtensionItemTumblrParameters alloc] initWithCustomURLPathComponent:@"want-this-for-xmas"
                                                                                         requestedPostType:XExtensionItemTumblrPostTypeLink
                                                                                               consumerKey:@"YOUR_CONSUMER_KEY_HERE"]];
    
    [self presentViewController:[[UIActivityViewController alloc] initWithActivityItems:@[itemSource] applicationActivities:nil]
                       animated:YES
                     completion:nil];
}

@end
