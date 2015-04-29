@import MobileCoreServices;
#import "TumblrCustomShareParameters.h"
#import "ViewController.h"
#import <XExtensionItem/XExtensionItemMutableParameters.h>
#import <XExtensionItem/XExtensionItemSourceApplication.h>

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
    XExtensionItemParameters *parameters = ({
        XExtensionItemMutableParameters *mutableParameters = [[XExtensionItemMutableParameters alloc] init];
        mutableParameters.attributedTitle = [[NSAttributedString alloc] initWithString:@"Apple"];
        mutableParameters.attributedContentText = [[NSAttributedString alloc] initWithString:@"iPad Air 2. Change is in the air"];
        mutableParameters.attachments = @[[[NSItemProvider alloc] initWithItem:[NSURL URLWithString:@"https://www.apple.com/ipad-air-2/"]
                                                            typeIdentifier:(__bridge NSString *)kUTTypeURL]];
        mutableParameters.tags = @[@"apple", @"ipad", @"ios"];
        mutableParameters.sourceURL = [NSURL URLWithString:@"http://apple.com"];
        mutableParameters.imageURL = [[NSBundle mainBundle] URLForResource:@"thumbnail" withExtension:@"png"];
        mutableParameters.sourceApplication = [[XExtensionItemSourceApplication alloc] initWithAppNameFromBundle:[NSBundle mainBundle]
                                                                                                      appStoreID:@"12345"
                                                                                                    googlePlayID:@"12345"
                                                                                                          webURL:nil
                                                                                                       iOSAppURL:nil
                                                                                                   androidAppURL:nil];
        mutableParameters.alternateContentRepresentations = @{ @"text/html": @"<p><strong>Apple’s website markup</strong></p>" };
        
        [mutableParameters addEntriesToUserInfo:({
            TumblrCustomShareParameters *tumblrParameters = [[TumblrCustomShareParameters alloc] init];
            tumblrParameters.customURLSlug = @"want-this-for-xmas";
            tumblrParameters;
        })];
        
        [mutableParameters copy];
    });

    [self presentViewController:[[UIActivityViewController alloc] initWithActivityItems:@[parameters.extensionItemRepresentation]
                                                                  applicationActivities:nil]
                       animated:YES completion:nil];
}

@end
