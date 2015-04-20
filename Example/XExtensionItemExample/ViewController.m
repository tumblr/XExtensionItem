@import CoreLocation;
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
        mutableParameters.location = [[CLLocation alloc] initWithLatitude:25 longitude:50];
        mutableParameters.sourceApplication = [[XExtensionItemSourceApplication alloc] initWithAppNameFromBundle:[NSBundle mainBundle]
                                                                                                      appStoreID:@12345];
        mutableParameters.UTIsToContentRepresentations = @{ @"text/html": @"<p><strong>Apple’s website markup</strong></p>" };
        
        [mutableParameters addEntriesToUserInfo:({
            TumblrCustomShareParameters *tumblrParameters = [[TumblrCustomShareParameters alloc] init];
            tumblrParameters.customURLSlug = @"want-this-for-xmas";
            tumblrParameters;
        })];
        
        [mutableParameters copy];
    });
    
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.attachments = @[
                         [[NSItemProvider alloc] initWithItem:[NSURL URLWithString:@"http://bryan.io"]
                                               typeIdentifier:(__bridge NSString *)kUTTypeURL],
                         [[NSItemProvider alloc] initWithItem:[[NSBundle mainBundle] URLForResource:@"thumbnail" withExtension:@"png"]
                                               typeIdentifier:(__bridge NSString *)kUTTypePNG]
                         ];
    
    [self presentViewController:[[UIActivityViewController alloc] initWithActivityItems:@[item]
                                                                  applicationActivities:nil]
                       animated:YES completion:nil];
}

@end
