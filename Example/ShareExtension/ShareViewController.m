#import "ShareViewController.h"
#import <XExtensionItem/XExtensionItem+Tumblr.h>

@implementation ShareViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSExtensionItem *extensionItem in self.extensionContext.inputItems) {
        XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:extensionItem];
        
        for (NSItemProvider *itemProvider in xExtensionItem.attachments) {
            for (NSString *typeIdentifier in itemProvider.registeredTypeIdentifiers) {
                [itemProvider loadItemForTypeIdentifier:typeIdentifier options:nil completionHandler:^(id <NSSecureCoding> attachmentItem, NSError *error) {
                    NSLog(@"Attachment item: %@", attachmentItem);
                }];
            }
        }
        
        NSLog(@"XExtensionItem: %@", xExtensionItem);

        NSLog(@"Tumblr custom parameters: %@", xExtensionItem.tumblrParameters);
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
