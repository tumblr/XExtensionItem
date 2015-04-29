#import "ShareViewController.h"
#import "TumblrCustomShareParameters.h"
#import <XExtensionItem/XExtensionItemParameters.h>

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
        
        NSLog(@"XExtensionItemParamters: %@", parameters);
        
        UIImage *thumbnail = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:parameters.imageURL]];
        
        if (thumbnail) {
            NSLog(@"Was able to read thumbnail data from URL: %@", parameters.imageURL);
        }
        
        TumblrCustomShareParameters *tumblrParameters = [[TumblrCustomShareParameters alloc] initWithDictionary:parameters.userInfo];
        NSLog(@"Tumblr custom URL slug: %@", tumblrParameters.customURLSlug);
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
