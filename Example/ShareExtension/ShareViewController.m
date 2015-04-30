#import "ShareViewController.h"
#import "XExtensionItem+Tumblr.h"

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        XExtensionItemParameters *parameters = [[XExtensionItemParameters alloc] initWithExtensionItem:item];
        
        for (NSItemProvider *itemProvider in parameters.attachments) {
            for (NSString *typeIdentifier in itemProvider.registeredTypeIdentifiers) {
                [itemProvider loadItemForTypeIdentifier:typeIdentifier options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                    NSLog(@"Attachment item: %@", item);
                }];
            }
        }
        
        NSLog(@"XExtensionItemParameters: %@", parameters);
        
        UIImage *thumbnail = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:parameters.imageURL]];
        
        if (thumbnail) {
            NSLog(@"Was able to read thumbnail data from URL: %@", parameters.imageURL);
        }

        NSLog(@"Tumblr custom parameters: %@", parameters.tumblrParameters);
    }
}

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
