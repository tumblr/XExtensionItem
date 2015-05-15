@import MobileCoreServices;
@import UIKit;
@import XCTest;
#import "CustomParameters.h"
#import "XExtensionItem.h"
#import "XExtensionItemTestHelpers.h"

@interface XExtensionItemTests : XCTestCase
@end

@implementation XExtensionItemTests

#pragma mark - Initializers

- (void)testURLInitializerThrowsIfNil {
    XCTAssertThrows([[XExtensionItemSource alloc] initWithURL:nil]);
}

- (void)testURLInitializerProducesExtensionItemWithURLAttachment {
    NSURL *URL = [NSURL URLWithString:@"http://tumblr.com"];
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithURL:URL];
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = @[[[NSItemProvider alloc] initWithItem:URL typeIdentifier:(NSString *)kUTTypeURL]];

    XExtensionItemAssertEqualItems(itemSource.facebookItem, expected);
}

- (void)testURLInitializerProducesExtensionItemWithFileURLAttachment {
    NSURL *URL = [NSURL fileURLWithPath:[[NSBundle bundleForClass:self.class] pathForResource:@"mountain" ofType:@"png"]];
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithURL:URL];
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = @[[[NSItemProvider alloc] initWithItem:URL typeIdentifier:(NSString *)kUTTypePNG]];
    
    XExtensionItemAssertEqualItems(itemSource.facebookItem, expected);
}

- (void)testStringInitializerThrowsIfNil {
    XCTAssertThrows([[XExtensionItemSource alloc] initWithString:nil]);
}

- (void)testStringInitializerProducesExtensionItemWithStringAttachment {
    NSString *string = @"foo";
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:string];
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = @[[[NSItemProvider alloc] initWithItem:string typeIdentifier:(NSString *)kUTTypePlainText]];
    
    XExtensionItemAssertEqualItems(itemSource.facebookItem, expected);
}

- (void)testImageInitializerThrowsIfNil {
    XCTAssertThrows([[XExtensionItemSource alloc] initWithImage:nil]);
}

- (void)testImageInitializerProducesExtensionItemWithImageAttachment {
    UIImage *image = [[UIImage alloc] init];
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithImage:image];
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = @[[[NSItemProvider alloc] initWithItem:image typeIdentifier:(NSString *)kUTTypePNG]];
    
    XExtensionItemAssertEqualItems(itemSource.facebookItem, expected);
}

- (void)testDataInitializerThrowsIfNil {
    XCTAssertThrows([[XExtensionItemSource alloc] initWithData:nil typeIdentifier:(NSString *)kUTTypeGIF]);
}

- (void)testDataInitializerThrowsIfTypeIdentifierIsNil {
    XCTAssertThrows([[XExtensionItemSource alloc] initWithData:[[NSData alloc] init] typeIdentifier:nil]);
}

- (void)testDataInitializerProducesExtensionItemWithDataAttachment {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"mountain" ofType:@"png"]];

    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithData:data typeIdentifier:(NSString *)kUTTypePNG];
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = @[[[NSItemProvider alloc] initWithItem:data typeIdentifier:(NSString *)kUTTypePNG]];
    
    XExtensionItemAssertEqualItems(itemSource.facebookItem, expected);
}

- (void)testPlaceholderInitializerThrowsIfNil {
    XCTAssertThrows([[XExtensionItemSource alloc] initWithPlaceholderItem:nil typeIdentifier:nil itemBlock:nil]);
}

- (void)testPlaceholderInitializerProducesDifferentItemsBasedOnActivityType {
    NSString *defaultString = @"foo";
    NSString *twitterString = @"bar";
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithPlaceholderItem:@"placeholder" typeIdentifier:nil itemBlock:^id(NSString *activityType) {
        if (activityType == UIActivityTypePostToTwitter) {
            return twitterString;
        }
        else {
            return defaultString;
        }
    }];
    
    NSExtensionItem *expectedTwitter = [[NSExtensionItem alloc] init];
    expectedTwitter.attachments = @[[[NSItemProvider alloc] initWithItem:twitterString typeIdentifier:(NSString *)kUTTypePlainText]];
    
    XExtensionItemAssertEqualItems(expectedTwitter, [itemSource activityViewController:nil itemForActivityType:UIActivityTypePostToTwitter]);
    
    NSExtensionItem *expectedNonTwitter = [[NSExtensionItem alloc] init];
    expectedNonTwitter.attachments = @[[[NSItemProvider alloc] initWithItem:defaultString typeIdentifier:(NSString *)kUTTypePlainText]];
    
    XExtensionItemAssertEqualItems(expectedNonTwitter, [itemSource activityViewController:nil itemForActivityType:UIActivityTypePostToFacebook]);
}

- (void)testPlaceholderProvidedTypeIdentifierIsReturnedByActivityItemSourceDelegateMethod {
    NSString *dataTypeIdentifier = (NSString *)kUTTypeVideo;
    
    XExtensionItemSource *source = [[XExtensionItemSource alloc] initWithPlaceholderItem:[[NSData alloc] init]
                                                                          typeIdentifier:dataTypeIdentifier
                                                                               itemBlock:nil];
    
    XCTAssertEqualObjects(dataTypeIdentifier, [source activityViewController:nil dataTypeIdentifierForActivityType:nil]);
}

- (void)testPlaceholderTypeIdentifierIsInferredForURL {
    XExtensionItemSource *source = [[XExtensionItemSource alloc] initWithURL:[NSURL URLWithString:@"http://irace.me"]];
    
    XCTAssertEqualObjects((NSString *)kUTTypeURL, [source activityViewController:nil dataTypeIdentifierForActivityType:nil]);
}

- (void)testPlaceholderTypeIdentifierIsInferredForFileURL {
    XExtensionItemSource *source = [[XExtensionItemSource alloc] initWithURL:
                                    [NSURL fileURLWithPath:[[NSBundle bundleForClass:self.class] pathForResource:@"mountain"
                                                                                                          ofType:@"png"]]];
    
    XCTAssertEqualObjects((NSString *)kUTTypePNG, [source activityViewController:nil dataTypeIdentifierForActivityType:nil]);
}

- (void)testPlaceholderTypeIdentifierIsInferredForString {
    XExtensionItemSource *source = [[XExtensionItemSource alloc] initWithString:@"Foo"];
    
    XCTAssertEqualObjects((NSString *)kUTTypePlainText, [source activityViewController:nil dataTypeIdentifierForActivityType:nil]);
}

- (void)testPlaceholderTypeIdentifierIsInferredForImage {
    XExtensionItemSource *source = [[XExtensionItemSource alloc] initWithImage:[[UIImage alloc] init]];
    
    XCTAssertEqualObjects((NSString *)kUTTypeImage, [source activityViewController:nil dataTypeIdentifierForActivityType:nil]);
}

#pragma mark - Output verification

- (void)testTextReturnedForSystemActivityThatCannotProcessExtensionItemInput {
    NSString *text = @"Foo";
    
    XExtensionItemSource *source = [[XExtensionItemSource alloc] initWithString:text];
    source.additionalAttachments = @[[[NSItemProvider alloc] initWithItem:@"Bar" typeIdentifier:(NSString *)kUTTypeText]];
    
    XCTAssertEqualObjects(text, [source activityViewController:nil itemForActivityType:UIActivityTypeMail]);
}

- (void)testExtensionItemReturnedForSystemActivityThatCanProcessExtensionItemInput {
    NSArray *attachments = @[[[NSItemProvider alloc] initWithItem:@"Bar" typeIdentifier:(NSString *)kUTTypeText]];
    
    XExtensionItemSource *source = [[XExtensionItemSource alloc] initWithString:@""];
    source.additionalAttachments = attachments;
    
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = attachments;
    
    id actual = [source activityViewController:nil itemForActivityType:UIActivityTypePostToTwitter];
    
    XCTAssertTrue([actual isKindOfClass:[NSExtensionItem class]]);
}

- (void)testExtensionItemReturnedForNonSystemExtension {
    NSArray *attachments = @[[[NSItemProvider alloc] initWithItem:@"Bar" typeIdentifier:(NSString *)kUTTypeText]];
    
    XExtensionItemSource *source = [[XExtensionItemSource alloc] initWithString:@""];
    source.additionalAttachments = attachments;
    
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = attachments;
    
    NSExtensionItem *actual = [source activityViewController:nil itemForActivityType:@"com.irace.me.SomeExtension"];
    
    XCTAssertTrue([actual isKindOfClass:[NSExtensionItem class]]);
}

#pragma mark - Title/content text

- (void)testTitle {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
    itemSource.title = @"Foo";
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];
    
    XCTAssertEqualObjects(itemSource.title, xExtensionItem.title);
}

- (void)testTitleReturnedForSubject {
    NSString *subject = @"Subject";
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
    itemSource.title = subject;
    
    XCTAssertEqualObjects(subject, [itemSource activityViewController:nil subjectForActivityType:UIActivityTypeMail]);
}

- (void)testAttributedContentText {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
    itemSource.attributedContentText = [[NSAttributedString alloc] initWithString:@"Foo" attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:20] }];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];
    
    XCTAssertEqual(itemSource.attributedContentText.hash, xExtensionItem.attributedContentText.hash);
}

- (void)testSeparateAttributedContentTextValueForTwitter {
    NSAttributedString *defaultContentText = [[NSAttributedString alloc] initWithString:@"Foo" attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:20] }];
    NSAttributedString *twitterContentText = [[NSAttributedString alloc] initWithString:@"Bar" attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:10] }];
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
    itemSource.attributedContentText = defaultContentText;
    [itemSource setAttributedContentText:twitterContentText forActivityType:UIActivityTypePostToTwitter];

    NSExtensionItem *defaultExtensionItem = [itemSource activityViewController:nil itemForActivityType:nil];
    
    // Wish I could test `NSAttributedString` equality here, but `NSExtensionItem`’s `attributedContentText` setter appears to add an `NSParagraphStyle` attribute
    XCTAssertEqualObjects(defaultContentText.string, defaultExtensionItem.attributedContentText.string);
    
    NSExtensionItem *twitterExtensionItem = [itemSource activityViewController:nil itemForActivityType:UIActivityTypePostToTwitter];
    
    // Wish I could test `NSAttributedString` equality here, but `NSExtensionItem`’s `attributedContentText` setter appears to add an `NSParagraphStyle` attribute
    XCTAssertEqualObjects(twitterContentText.string, twitterExtensionItem.attributedContentText.string);
}

- (void)testAttributedContentForActivityTypeClearedByPassingNil {
    NSAttributedString *defaultContentText = [[NSAttributedString alloc] initWithString:@"Foo" attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:20] }];
    NSAttributedString *twitterContentText = [[NSAttributedString alloc] initWithString:@"Bar" attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:10] }];
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
    itemSource.attributedContentText = defaultContentText;
    [itemSource setAttributedContentText:twitterContentText forActivityType:UIActivityTypePostToTwitter];
    
    NSExtensionItem *defaultExtensionItem = [itemSource activityViewController:nil itemForActivityType:nil];
    NSExtensionItem *twitterExtensionItem = [itemSource activityViewController:nil itemForActivityType:UIActivityTypePostToTwitter];
    
    XCTAssertNotNil(defaultExtensionItem.attributedContentText);
    XCTAssertNotNil(twitterExtensionItem.attributedContentText);
    
    [itemSource setAttributedContentText:nil forActivityType:nil];
    
    defaultExtensionItem = [itemSource activityViewController:nil itemForActivityType:nil];
    twitterExtensionItem = [itemSource activityViewController:nil itemForActivityType:UIActivityTypePostToTwitter];
    
    XCTAssertNil(defaultExtensionItem.attributedContentText);
    XCTAssertNotNil(twitterExtensionItem.attributedContentText);
    
    [itemSource setAttributedContentText:nil forActivityType:UIActivityTypePostToTwitter];

    defaultExtensionItem = [itemSource activityViewController:nil itemForActivityType:nil];
    twitterExtensionItem = [itemSource activityViewController:nil itemForActivityType:UIActivityTypePostToTwitter];
    
    XCTAssertNil(defaultExtensionItem.attributedContentText);
    XCTAssertNil(twitterExtensionItem.attributedContentText);
}

#pragma mark - Attachments

- (void)testAttachments {
    NSURL *URL = [NSURL URLWithString:@"http://apple.com"];
    
    NSArray *additionalAttachments = @[
        [[NSItemProvider alloc] initWithItem:[NSURL URLWithString:@"http://apple.com"] typeIdentifier:(__bridge NSString *)kUTTypeURL],
        [[NSItemProvider alloc] initWithItem:@"Apple’s website" typeIdentifier:(__bridge NSString *)kUTTypeText]
    ];
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithURL:URL];
    itemSource.additionalAttachments = additionalAttachments;
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];

    NSArray *expected = ({
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[[NSItemProvider alloc] initWithItem:URL typeIdentifier:(NSString *)kUTTypeURL]];
        [array addObjectsFromArray:additionalAttachments];
        [array copy];
    });
    
    XExtensionItemAssertEqualItemProviderArrays(expected, xExtensionItem.attachments);
}

- (void)testItemProviderCreatedFromURLAdditionalAttachment {
    NSString *text = @"foo";
    NSURL *URL = [NSURL URLWithString:@"http://tumblr.com"];
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@"foo"];
    itemSource.additionalAttachments = @[URL];
    
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = @[[[NSItemProvider alloc] initWithItem:text typeIdentifier:(NSString *)kUTTypePlainText],
                             [[NSItemProvider alloc] initWithItem:URL typeIdentifier:(NSString *)kUTTypeURL]];
    
    XExtensionItemAssertEqualItems(itemSource.facebookItem, expected);
}

- (void)testItemProviderCreatedFromFileURLAdditionalAttachment {
    NSString *text = @"foo";
    NSURL *URL = [NSURL fileURLWithPath:[[NSBundle bundleForClass:self.class] pathForResource:@"mountain"
                                                                                       ofType:@"png"]];
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@"foo"];
    itemSource.additionalAttachments = @[URL];
    
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = @[[[NSItemProvider alloc] initWithItem:text typeIdentifier:(NSString *)kUTTypePlainText],
                             [[NSItemProvider alloc] initWithItem:URL typeIdentifier:(NSString *)kUTTypePNG]];
    
    XExtensionItemAssertEqualItems(itemSource.facebookItem, expected);
}

- (void)testItemProviderCreatedFromStringAdditionalAttachment {
    NSString *text = @"foo";
    NSString *text2 = @"bar";
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@"foo"];
    itemSource.additionalAttachments = @[text2];
    
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = @[[[NSItemProvider alloc] initWithItem:text typeIdentifier:(NSString *)kUTTypePlainText],
                             [[NSItemProvider alloc] initWithItem:text2 typeIdentifier:(NSString *)kUTTypePlainText]];
    
    XExtensionItemAssertEqualItems(itemSource.facebookItem, expected);
}

- (void)testItemProviderCreatedFromImageAdditionalAttachment {
    NSString *text = @"foo";
    UIImage *image = [[UIImage alloc] init];
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@"foo"];
    itemSource.additionalAttachments = @[image];
    
    NSExtensionItem *expected = [[NSExtensionItem alloc] init];
    expected.attachments = @[[[NSItemProvider alloc] initWithItem:text typeIdentifier:(NSString *)kUTTypePlainText],
                             [[NSItemProvider alloc] initWithItem:image typeIdentifier:(NSString *)kUTTypePNG]];
    
    XExtensionItemAssertEqualItems(itemSource.facebookItem, expected);
}

- (void)testSeparateAdditionalAttachmentsForTwitter {
    NSURL *URL = [NSURL URLWithString:@"http://tumblr.com"];
    NSString *defaultText = @"foo";
    NSString *twitterText = @"bar";
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithURL:URL];
    itemSource.additionalAttachments = @[defaultText];
    [itemSource setAdditionalAttachments:@[twitterText] forActivityType:UIActivityTypePostToTwitter];
    
    NSExtensionItem *defaultExpected = [[NSExtensionItem alloc] init];
    defaultExpected.attachments = @[[[NSItemProvider alloc] initWithItem:URL typeIdentifier:(NSString *)kUTTypeURL],
                                    [[NSItemProvider alloc] initWithItem:defaultText typeIdentifier:(NSString *)kUTTypePlainText]];
    
    XExtensionItemAssertEqualItems(defaultExpected, [itemSource activityViewController:nil itemForActivityType:nil]);
    
    NSExtensionItem *twitterExpected = [[NSExtensionItem alloc] init];
    twitterExpected.attachments = @[[[NSItemProvider alloc] initWithItem:URL typeIdentifier:(NSString *)kUTTypeURL],
                                    [[NSItemProvider alloc] initWithItem:twitterText typeIdentifier:(NSString *)kUTTypePlainText]];
    
    XExtensionItemAssertEqualItems(twitterExpected, [itemSource activityViewController:nil itemForActivityType:UIActivityTypePostToTwitter]);
}

- (void)testAdditionalAttachmentsForActivityTypeClearedByPassingNil {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
    [itemSource setAdditionalAttachments:@[@"String"] forActivityType:UIActivityTypeMail];
    [itemSource setAdditionalAttachments:nil forActivityType:UIActivityTypeMail];
    
    XExtensionItem *extensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];
    XCTAssertEqual(extensionItem.attachments.count, 1);
}

#pragma mark - Parameters

- (void)testTags {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
    itemSource.tags = @[@"foo", @"bar", @"baz"];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];
    
    XCTAssertEqualObjects(itemSource.tags, xExtensionItem.tags);
}

- (void)testSourceURL {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
    itemSource.sourceURL = [NSURL URLWithString:@"http://tumblr.com"];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];
    
    XCTAssertEqualObjects(itemSource.sourceURL, xExtensionItem.sourceURL);
}

- (void)testReferrer {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];

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
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
    itemSource.referrer = [[XExtensionItemReferrer alloc] initWithAppNameFromBundle:[NSBundle bundleForClass:[self class]]
                                                                         appStoreID:@"12345"
                                                                       googlePlayID:@"54321"
                                                                             webURL:[NSURL URLWithString:@"http://bryan.io/a94kan4"]
                                                                          iOSAppURL:[NSURL URLWithString:@"tumblr://a94kan4"]
                                                                      androidAppURL:[NSURL URLWithString:@"tumblr://a94kan4"]];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];
    
    XCTAssertEqualObjects(itemSource.referrer, xExtensionItem.referrer);
}

- (void)testThumbnailProvider {
    UIImage *emailImage = [[UIImage alloc] initWithData:[@"123" dataUsingEncoding:NSUTF8StringEncoding]];
    UIImage *defaultImage = [[UIImage alloc] initWithData:[@"456" dataUsingEncoding:NSUTF8StringEncoding]];
    
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
    itemSource.thumbnailProvider = ^(CGSize suggestedSize, NSString *activityType) {
        if (activityType == UIActivityTypeMail) {
            return emailImage;
        }
        else {
            return defaultImage;
        }
        
    };
    
    XCTAssertEqualObjects(emailImage, [itemSource activityViewController:nil thumbnailImageForActivityType:UIActivityTypePostToTwitter suggestedSize:CGSizeZero]);
    XCTAssertEqualObjects(defaultImage, [itemSource activityViewController:nil thumbnailImageForActivityType:UIActivityTypeMail suggestedSize:CGSizeZero]);
}

- (void)testActivityItemSourceDelegateDoesNotThrowIfNoThumbnailBlock {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];

    XCTAssertNoThrow([itemSource activityViewController:nil thumbnailImageForActivityType:UIActivityTypePostToTwitter suggestedSize:CGSizeZero]);
}

#pragma mark - Custom parameters

- (void)testUserInfo {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
    itemSource.sourceURL = [NSURL URLWithString:@"http://tumblr.com"];
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

    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
    [itemSource addCustomParameters:inputCustomParameters];
    
    XExtensionItem *xExtensionItem = [[XExtensionItem alloc] initWithExtensionItem:itemSource.facebookItem];
    
    CustomParameters *outputCustomParameters = [[CustomParameters alloc] initWithDictionary:xExtensionItem.userInfo];
    
    XCTAssertEqualObjects(inputCustomParameters, outputCustomParameters);
}

- (void)testUserInfoAndCustomParameters {
    XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithString:@""];
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

@end
