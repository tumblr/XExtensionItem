@import MobileCoreServices;
@import UIKit;
@import XCTest;
#import "CustomParameters.h"
#import "XExtensionItem.h"

#define XExtensionItemAssertEqualItems(item1, item2) \
    XCTAssertTrue([item1 isKindOfClass:[NSExtensionItem class]]); \
    XCTAssertTrue([item2 isKindOfClass:[NSExtensionItem class]]); \
    XCTAssertEqualObjects(item1.attributedTitle, item2.attributedTitle); \
    XCTAssertEqualObjects(item1.attributedContentText, item2.attributedContentText); \
    XCTAssertEqualObjects(item1.userInfo, item2.userInfo); \
    XCTAssertEqualObjects(item1.attachments, item2.attachments);

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
    NSArray *attachments = @[
        [[NSItemProvider alloc] initWithItem:[NSURL URLWithString:@"http://apple.com"] typeIdentifier:(__bridge NSString *)kUTTypeURL],
        [[NSItemProvider alloc] initWithItem:@"Apple’s website" typeIdentifier:(__bridge NSString *)kUTTypeText]
    ];
    
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

- (void)testReferrer {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    itemSource.referrer = [[XExtensionItemReferrer alloc] initWithAppName:@"Tumblr"
                                                               appStoreID:@"12345"
                                                             googlePlayID:@"54321"
                                                                   webURL:[NSURL URLWithString:@"http://bryan.io/a94kan4"]
                                                                iOSAppURL:[NSURL URLWithString:@"tumblr://a94kan4"]
                                                            androidAppURL:[NSURL URLWithString:@"tumblr://a94kan4"]];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:[itemSource activityViewController:nil itemForActivityType:nil]];
    
    XCTAssertEqualObjects(itemSource.referrer, xExtensionItem.referrer);
}

- (void)testReferrerFromBundle {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    itemSource.referrer = [[XExtensionItemReferrer alloc] initWithAppNameFromBundle:[NSBundle bundleForClass:[self class]]
                                                                         appStoreID:@"12345"
                                                                       googlePlayID:@"54321"
                                                                             webURL:[NSURL URLWithString:@"http://bryan.io/a94kan4"]
                                                                          iOSAppURL:[NSURL URLWithString:@"tumblr://a94kan4"]
                                                                      androidAppURL:[NSURL URLWithString:@"tumblr://a94kan4"]];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:[itemSource activityViewController:nil itemForActivityType:nil]];
    
    XCTAssertEqualObjects(itemSource.referrer, xExtensionItem.referrer);
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
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:item];
    XCTAssertNoThrow([xExtensionItem.sourceURL absoluteString]);
    
    item = [[NSExtensionItem alloc] init];
    item.userInfo = @{
        @"x-extension-item": @{
            @"source-url": @"",
            @"tags": @{},
            @"referrer-name": @[],
            @"referrer-app-store-id": @[],
            @"referrer-google-play-id": @[],
            @"referrer-web-url": @[],
            @"referrer-ios-app-url": @[],
            @"referrer-android-app-url": @[]
        }
    };
    
    xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:item];
    XCTAssertNoThrow([xExtensionItem.sourceURL absoluteString]);
    XCTAssertNoThrow(xExtensionItem.tags.count);
    XCTAssertNoThrow([xExtensionItem.referrer.appName stringByAppendingString:@""]);
    XCTAssertNoThrow([xExtensionItem.referrer.appStoreID stringByAppendingString:@""]);
    XCTAssertNoThrow([xExtensionItem.referrer.googlePlayID stringByAppendingString:@""]);
    XCTAssertNoThrow([xExtensionItem.referrer.webURL absoluteString]);
    XCTAssertNoThrow([xExtensionItem.referrer.iOSAppURL absoluteString]);
    XCTAssertNoThrow([xExtensionItem.referrer.androidAppURL absoluteString]);
}

- (void)testDataTypeIdentifierPassedToInitializerIsReturnedByActivityItemSourceDelegateMethods {
    NSString *dataTypeIdentifier = (NSString *)kUTTypeVideo;
    
    XExtensionItemSource *source = [[XExtensionItemSource alloc] initWithPlaceholderData:[[NSData alloc] init]
                                                                      dataTypeIdentifier:dataTypeIdentifier
                                                                             attachments:@[]];
    
    XCTAssertEqualObjects(dataTypeIdentifier, [source activityViewController:nil dataTypeIdentifierForActivityType:nil]);
}

- (void)testPlaceholderReturnedForSystemActivityThatCantProcessExtensionItemInput {
    NSString *placeholder = @"Foo";
    
    XExtensionItemSource *source = [[XExtensionItemSource alloc] initWithPlaceholderItem:placeholder attachments:
                                    @[[[NSItemProvider alloc] initWithItem:@"Bar" typeIdentifier:(NSString *)kUTTypeText]]];
    
    XCTAssertEqualObjects(placeholder, [source activityViewController:nil itemForActivityType:UIActivityTypeMail]);
}

- (void)testExtensionItemReturnedForSystemActivityThatCanProcessExtensionItemInput {
    NSArray *attachments = @[[[NSItemProvider alloc] initWithItem:@"Bar" typeIdentifier:(NSString *)kUTTypeText]];
    
    XExtensionItemSource *source = [[XExtensionItemSource alloc] initWithPlaceholderItem:@"Foo" attachments:attachments];
    
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = attachments;
    
    NSExtensionItem *actual = [source activityViewController:nil itemForActivityType:UIActivityTypePostToTwitter];
    
    XExtensionItemAssertEqualItems(expected, actual);
}

- (void)testExtensionItemReturnedForNonSystemExtension {
    NSArray *attachments = @[[[NSItemProvider alloc] initWithItem:@"Bar" typeIdentifier:(NSString *)kUTTypeText]];
    
    XExtensionItemSource *source = [[XExtensionItemSource alloc] initWithPlaceholderItem:@"Foo" attachments:attachments];
    
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = attachments;
    
    NSExtensionItem *actual = [source activityViewController:nil itemForActivityType:@"com.irace.me.SomeExtension"];
    
    XExtensionItemAssertEqualItems(expected, actual);
}

@end
