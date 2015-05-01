@import MobileCoreServices;
@import UIKit;
@import XCTest;
#import "CustomParameters.h"
#import "XExtensionItem.h"

@interface XExtensionItemParametersTests : XCTestCase
@end

@implementation XExtensionItemParametersTests

- (void)testAttributedTitle {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    itemSource.attributedTitle = [[NSAttributedString alloc] initWithString:@"Foo" attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:20] }];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:[itemSource activityViewController:nil itemForActivityType:nil]];
    
    XCTAssertEqualObjects(itemSource.attributedTitle.string, xExtensionItem.attributedTitle.string);
}

- (void)testAttributedContentText {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    itemSource.attributedContentText = [[NSAttributedString alloc] initWithString:@"Foo" attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:20] }];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:[itemSource activityViewController:nil itemForActivityType:nil]];
    
    XCTAssertEqual(itemSource.attributedContentText.hash, xExtensionItem.attributedContentText.hash);
}

- (void)testAttachments {
    NSURL *URL = [NSURL URLWithString:@"http://apple.com"];
    NSArray *attachments = @[[[NSItemProvider alloc] initWithItem:[NSURL URLWithString:@"http://apple.com"] typeIdentifier:(__bridge NSString *)kUTTypeURL]];
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithPlaceholderItem:URL
                                                                                 attachments:
                                        attachments];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:[itemSource activityViewController:nil itemForActivityType:nil]];
    
    XCTAssertEqualObjects(attachments, xExtensionItem.attachments);
}

- (void)testTags {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    itemSource.tags = @[@"foo", @"bar", @"baz"];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:[itemSource activityViewController:nil itemForActivityType:nil]];
    
    XCTAssertEqualObjects(itemSource.tags, xExtensionItem.tags);
}

- (void)testSourceURL {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    itemSource.sourceURL = [NSURL URLWithString:@"http://tumblr.com"];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:[itemSource activityViewController:nil itemForActivityType:nil]];
    
    XCTAssertEqualObjects(itemSource.sourceURL, xExtensionItem.sourceURL);
}

- (void)testSourceApplication {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    itemSource.sourceApplication = [[XExtensionItemReferrer alloc] initWithAppName:@"Tumblr"
                                                                                  appStoreID:@"12345"
                                                                                googlePlayID:@"54321"
                                                                                      webURL:[NSURL URLWithString:@"http://bryan.io/a94kan4"]
                                                                                   iOSAppURL:[NSURL URLWithString:@"tumblr://a94kan4"]
                                                                               androidAppURL:[NSURL URLWithString:@"tumblr://a94kan4"]];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:[itemSource activityViewController:nil itemForActivityType:nil]];
    
    XCTAssertEqualObjects(itemSource.sourceApplication, xExtensionItem.sourceApplication);
}

- (void)testSourceApplicationFromBundle {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    itemSource.sourceApplication = [[XExtensionItemReferrer alloc] initWithAppNameFromBundle:[NSBundle bundleForClass:[self class]]
                                                                                            appStoreID:@"12345"
                                                                                          googlePlayID:@"54321"
                                                                                                webURL:[NSURL URLWithString:@"http://bryan.io/a94kan4"]
                                                                                             iOSAppURL:[NSURL URLWithString:@"tumblr://a94kan4"]
                                                                                         androidAppURL:[NSURL URLWithString:@"tumblr://a94kan4"]];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:[itemSource activityViewController:nil itemForActivityType:nil]];
    
    XCTAssertEqualObjects(itemSource.sourceApplication, xExtensionItem.sourceApplication);
}

- (void)testUserInfo {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    itemSource.sourceURL = [NSURL URLWithString:@"http://tumblr.com"];
    itemSource.userInfo = @{ @"foo": @"bar" };
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:[itemSource activityViewController:nil itemForActivityType:nil]];
    
    // Output params user info dictionary should be a superset of input params user info dictionary
    
    [itemSource.userInfo enumerateKeysAndObjectsUsingBlock:^(id inputKey, id inputValue, BOOL *stop) {
        XCTAssertEqualObjects(xExtensionItem.userInfo[inputKey], inputValue);
    }];
}

- (void)testAddEntriesToUserInfo {
    CustomParameters *inputCustomParameters = [[CustomParameters alloc] init];
    inputCustomParameters.customParameter = @"Value";
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    [itemSource addEntriesToUserInfo:inputCustomParameters];

    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:[itemSource activityViewController:nil itemForActivityType:nil]];
    
    CustomParameters *outputCustomParameters = [[CustomParameters alloc] initWithDictionary:xExtensionItem.userInfo];
    
    XCTAssertEqualObjects(inputCustomParameters, outputCustomParameters);
}

- (void)testTypeSafety {
    /*
     Try to break things by intentionally using the wrong types for these keys, then calling methods that would only 
     exist on the correct object types
     */
    
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.userInfo = @{
        @"x-extension-item": @[],
    };
    
    item = [[NSExtensionItem alloc] init];
    item.userInfo = @{
        @"x-extension-item": @{
            @"source-url": @"",
            @"tags": @{},
            @"location": @"",
            @"referrer-name": @[],
            @"referrer-app-store-id": @[],
            @"referrer-google-play-id": @[],
            @"referrer-web-url": @[],
            @"referrer-ios-app-url": @[],
            @"referrer-android-app-url": @[]
        }
    };
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:item];
    XCTAssertNoThrow([xExtensionItem.sourceURL absoluteString]);
    XCTAssertNoThrow([xExtensionItem.sourceApplication.appName stringByAppendingString:@""]);
    XCTAssertNoThrow([xExtensionItem.sourceApplication.appStoreID stringByAppendingString:@""]);
    XCTAssertNoThrow([xExtensionItem.sourceApplication.googlePlayID stringByAppendingString:@""]);
    XCTAssertNoThrow([xExtensionItem.sourceApplication.webURL absoluteString]);
    XCTAssertNoThrow([xExtensionItem.sourceApplication.iOSAppURL absoluteString]);
    XCTAssertNoThrow([xExtensionItem.sourceApplication.androidAppURL absoluteString]);
}

@end
