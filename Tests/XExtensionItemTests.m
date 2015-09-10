@import MobileCoreServices;
@import UIKit;
@import XCTest;
#import "CustomParameters.h"
#import "XExtensionItem.h"
#import "XExtensionItemTestHelpers.h"

@interface XExtensionItemTests : XCTestCase
@end

@implementation XExtensionItemTests

#pragma mark - Output verification

- (void)testNilReturnedForSystemActivityThatCannotProcessExtensionItemInput {
    XExtensionItemSource *source = [[XExtensionItemSource alloc] init];
    
    XCTAssertEqualObjects(nil, [source activityViewController:nil itemForActivityType:UIActivityTypeMail]);
}

- (void)testExtensionItemReturnedForSystemActivityThatCanProcessExtensionItemInput {
    NSArray *attachments = @[[[NSItemProvider alloc] initWithItem:@"Bar" typeIdentifier:(NSString *)kUTTypeText]];
    
    XExtensionItemSource *source = [[XExtensionItemSource alloc] init];
    
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = attachments;
    
    id actual = [source activityViewController:nil itemForActivityType:UIActivityTypePostToTwitter];
    
    XCTAssertTrue([actual isKindOfClass:[NSExtensionItem class]]);
}

- (void)testExtensionItemReturnedForNonSystemExtension {
    NSArray *attachments = @[[[NSItemProvider alloc] initWithItem:@"Bar" typeIdentifier:(NSString *)kUTTypeText]];
    
    XExtensionItemSource *source = [[XExtensionItemSource alloc] init];
    
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = attachments;
    
    NSExtensionItem *actual = [source activityViewController:nil itemForActivityType:@"com.irace.me.SomeExtension"];
    
    XCTAssertTrue([actual isKindOfClass:[NSExtensionItem class]]);
}

#pragma mark - Parameters

- (void)testTags {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    itemSource.tags = @[@"foo", @"bar", @"baz"];
    
    XExtensionItem *xExtensionItem = [[XExtensionItemContext alloc] initWithExtensionConte:itemSource.facebookItem];
    
    XCTAssertEqualObjects(itemSource.tags, xExtensionItem.tags);
}

- (void)testReferrer {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];

    itemSource.referrer = [[XExtensionItemReferrer alloc] initWithAppName:@"Tumblr"
                                                               appStoreID:@"12345"
                                                             googlePlayID:@"54321"
                                                                   webURL:[NSURL URLWithString:@"http://bryan.io/a94kan4"]
                                                                iOSAppURL:[NSURL URLWithString:@"tumblr://a94kan4"]
                                                            androidAppURL:[NSURL URLWithString:@"tumblr://a94kan4"]];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];
    
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
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];
    
    XCTAssertEqualObjects(itemSource.referrer, xExtensionItem.referrer);
}

#pragma mark - Custom parameters

- (void)testUserInfo {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    itemSource.userInfo = @{ @"foo": @"bar" };
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];
    
    // Output params user info dictionary should be a superset of input params user info dictionary
    
    [itemSource.userInfo enumerateKeysAndObjectsUsingBlock:^(id inputKey, id inputValue, BOOL *stop) {
        XCTAssertEqualObjects(xExtensionItem.userInfo[inputKey], inputValue);
    }];
}

- (void)testCustomParameters {
    CustomParameters *inputCustomParameters = [[CustomParameters alloc] init];
    inputCustomParameters.customParameter = @"Value";

    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    [itemSource addCustomParameters:inputCustomParameters];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];
    
    CustomParameters *outputCustomParameters = [[CustomParameters alloc] initWithDictionary:xExtensionItem.userInfo];
    
    XCTAssertEqualObjects(inputCustomParameters, outputCustomParameters);
}

- (void)testUserInfoAndCustomParameters {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] init];
    itemSource.userInfo = @{ @"foo": @"bar" };
    
    CustomParameters *inputCustomParameters = [[CustomParameters alloc] init];
    inputCustomParameters.customParameter = @"Value";

    [itemSource addCustomParameters:inputCustomParameters];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];
    
    // Output params user info dictionary should be a superset of input params user info dictionary
    
    [itemSource.userInfo enumerateKeysAndObjectsUsingBlock:^(id inputKey, id inputValue, BOOL *stop) {
        XCTAssertEqualObjects(xExtensionItem.userInfo[inputKey], inputValue);
    }];
    
    CustomParameters *outputCustomParameters = [[CustomParameters alloc] initWithDictionary:xExtensionItem.userInfo];
    
    XCTAssertEqualObjects(inputCustomParameters, outputCustomParameters);
}

#pragma mark - Misc.

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
    XCTAssertNoThrow(xExtensionItem.tags.count);
    XCTAssertNoThrow([xExtensionItem.referrer.appName stringByAppendingString:@""]);
    XCTAssertNoThrow([xExtensionItem.referrer.appStoreID stringByAppendingString:@""]);
    XCTAssertNoThrow([xExtensionItem.referrer.googlePlayID stringByAppendingString:@""]);
    XCTAssertNoThrow([xExtensionItem.referrer.webURL absoluteString]);
    XCTAssertNoThrow([xExtensionItem.referrer.iOSAppURL absoluteString]);
    XCTAssertNoThrow([xExtensionItem.referrer.androidAppURL absoluteString]);
}

@end
