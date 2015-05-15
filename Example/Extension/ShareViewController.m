#import "ShareViewController.h"
#import <XExtensionItem/XExtensionItem.h>
#import <XExtensionItem/XExtensionItemTumblrParameters.h>

@implementation ShareViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSExtensionItem *extensionItem in self.extensionContext.inputItems) {
        /*
         Loop through the incoming `NSExtensionItem` instances and create an `XExtensionItem` instance out of each.
         */
        XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:extensionItem];
        
        NSLog(@"XExtensionItem: %@", xExtensionItem);
        
        /*
         Look through each extension item’s attachments array and load each attachments’ items.
         */
        for (NSItemProvider *itemProvider in xExtensionItem.attachments) {
            for (NSString *typeIdentifier in itemProvider.registeredTypeIdentifiers) {
                [itemProvider loadItemForTypeIdentifier:typeIdentifier options:nil completionHandler:^(id <NSSecureCoding> attachmentItem, NSError *error) {
                    NSLog(@"Attachment item: %@", attachmentItem);
                }];
            }
        }
        
        /*
         Pull out some generic parameters.
         */
        NSLog(@"Tags: %@", xExtensionItem.tags);
        NSLog(@"Referrer: %@", xExtensionItem.referrer);
        
        /*
         Pull out custom parameter values by initializing a custom parameter class with the extension item’s `userInfo` 
         dictionary.
         */
        XExtensionItemTumblrParameters *tumblrParameters = [[XExtensionItemTumblrParameters alloc] initWithDictionary:xExtensionItem.userInfo];
        
        NSLog(@"Tumblr custom URL path component: %@", tumblrParameters.customURLPathComponent);
    }
}

#pragma mark - SLComposeServiceViewController

- (BOOL)isContentValid {
    return YES;
}

- (void)didSelectPost {
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    return @[];
}

@end
