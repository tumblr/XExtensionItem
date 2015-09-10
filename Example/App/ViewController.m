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
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    
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
    
    [self presentViewController:[[UIActivityViewController alloc] initWithActivityItems:
                                 @[@"Apple homepage", [NSURL URLWithString:@"http://apple.com"], itemSource] applicationActivities:nil]
                       animated:YES
                     completion:nil];
}

@end
