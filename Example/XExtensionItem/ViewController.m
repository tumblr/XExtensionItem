@import MobileCoreServices;
#import "TumblrCustomShareParameters.h"
#import "ViewController.h"
#import <XExtensionItem/XExtensionItem.h>

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
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithPlaceholderItem:[NSURL URLWithString:@"http://apple.com/ipad-air-2/"]
                                                                                 attachments:@[[[NSItemProvider alloc] initWithItem:[NSURL URLWithString:@"https://www.apple.com/ipad-air-2/"]
                                                                                                                     typeIdentifier:(__bridge NSString *)kUTTypeURL],
                                                                                               [[NSItemProvider alloc] initWithItem:@"String of text"
                                                                                                                     typeIdentifier:(__bridge NSString *)kUTTypeText]]];
    itemSource.attributedTitle = [[NSAttributedString alloc] initWithString:@"Apple"];
    itemSource.attributedContentText = [[NSAttributedString alloc] initWithString:@"iPad Air 2. Change is in the air"];
    itemSource.tags = @[@"apple", @"ipad", @"ios"];
    itemSource.sourceURL = [NSURL URLWithString:@"http://apple.com"];
    itemSource.referrer = [[XExtensionItemReferrer alloc] initWithAppNameFromBundle:[NSBundle mainBundle]
                                                                         appStoreID:@"12345"
                                                                       googlePlayID:@"12345"
                                                                             webURL:nil
                                                                          iOSAppURL:nil
                                                                      androidAppURL:nil];
    [itemSource addEntriesToUserInfo:({
        TumblrCustomShareParameters *tumblrParameters = [[TumblrCustomShareParameters alloc] init];
        tumblrParameters.customURLSlug = @"want-this-for-xmas";
        tumblrParameters;
    })];
    
    [self presentViewController:[[UIActivityViewController alloc] initWithActivityItems:@[itemSource] applicationActivities:nil]
                       animated:YES
                     completion:nil];
}

@end
