@import MobileCoreServices;
@import UIKit;
@import XCTest;
#import "CustomParameters.h"
#import "XExtensionItemMutableParameters.h"
#import "XExtensionItemSourceApplication.h"

@interface XExtensionItemParametersTests : XCTestCase
@end

@implementation XExtensionItemParametersTests

- (void)testAttributedTitle {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.attributedTitle = [[NSAttributedString alloc] initWithString:@"Foo" attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:20] }];
    
    XExtensionItemParameters *outputParams = [[XExtensionItemParameters alloc] initWithExtensionItem:inputParams.extensionItemRepresentation];
    
    XCTAssertEqualObjects(inputParams.attributedTitle.string, outputParams.attributedTitle.string);
}

- (void)testAttributedContentText {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.attributedContentText = [[NSAttributedString alloc] initWithString:@"Foo" attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:20] }];
    
    XExtensionItemParameters *outputParams = [[XExtensionItemParameters alloc] initWithExtensionItem:inputParams.extensionItemRepresentation];
    
    XCTAssertEqual(inputParams.attributedContentText.hash, outputParams.attributedContentText.hash);
}

- (void)testAttachments {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.attachments = @[[[NSItemProvider alloc] initWithItem:[NSURL URLWithString:@"http://apple.com"]
                                                      typeIdentifier:(__bridge NSString *)kUTTypeURL]];
    
    XExtensionItemParameters *outputParams = [[XExtensionItemParameters alloc] initWithExtensionItem:inputParams.extensionItemRepresentation];
    
    XCTAssertEqualObjects(inputParams.attachments, outputParams.attachments);
}

- (void)testTags {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.tags = @[@"foo", @"bar", @"baz"];
    
    XExtensionItemParameters *outputParams = [[XExtensionItemParameters alloc] initWithExtensionItem:inputParams.extensionItemRepresentation];
    
    XCTAssertEqualObjects(inputParams.tags, outputParams.tags);
}

- (void)testSourceURL {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.sourceURL = [NSURL URLWithString:@"http://tumblr.com"];
    
    XExtensionItemParameters *outputParams = [[XExtensionItemParameters alloc] initWithExtensionItem:inputParams.extensionItemRepresentation];
    
    XCTAssertEqualObjects(inputParams.sourceURL, outputParams.sourceURL);
}

- (void)testImageURL {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.imageURL = [NSURL URLWithString:@"http://tumblr.com/image.png"];
    
    XExtensionItemParameters *outputParams = [[XExtensionItemParameters alloc] initWithExtensionItem:inputParams.extensionItemRepresentation];
    
    XCTAssertEqualObjects(inputParams.imageURL, outputParams.imageURL);
}

- (void)testSourceApplication {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.sourceApplication = [[XExtensionItemSourceApplication alloc] initWithAppName:@"Tumblr"
                                                                                  appStoreID:@(12345)];
    
    XExtensionItemParameters *outputParams = [[XExtensionItemParameters alloc] initWithExtensionItem:inputParams.extensionItemRepresentation];
    
    XCTAssertEqualObjects(inputParams.sourceApplication, outputParams.sourceApplication);
}

- (void)testSourceApplicationFromBundle {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.sourceApplication = [[XExtensionItemSourceApplication alloc] initWithAppNameFromBundle:[NSBundle bundleForClass:[self class]]
                                                                                  appStoreID:@(12345)];
    
    XExtensionItemParameters *outputParams = [[XExtensionItemParameters alloc] initWithExtensionItem:inputParams.extensionItemRepresentation];
    
    XCTAssertEqualObjects(inputParams.sourceApplication, outputParams.sourceApplication);
}

- (void)testTypeIdentifiersToContentRepresentations {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.typeIdentifiersToContentRepresentations = @{ @"text/html": @"<p><strong>Foo</strong></p>" };
    
    XExtensionItemParameters *outputParams = [[XExtensionItemParameters alloc] initWithExtensionItem:inputParams.extensionItemRepresentation];
    
    XCTAssertEqualObjects(inputParams.typeIdentifiersToContentRepresentations, outputParams.typeIdentifiersToContentRepresentations);
}

- (void)testUserInfo {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.sourceURL = [NSURL URLWithString:@"http://tumblr.com"];
    inputParams.userInfo = @{ @"foo": @"bar" };
    
    XExtensionItemParameters *outputParams = [[XExtensionItemParameters alloc] initWithExtensionItem:inputParams.extensionItemRepresentation];
    
    // Output params user info dictionary should be a superset of input params user info dictionary
    
    [inputParams.userInfo enumerateKeysAndObjectsUsingBlock:^(id inputKey, id inputValue, BOOL *stop) {
        XCTAssertEqualObjects(outputParams.userInfo[inputKey], inputValue);
    }];
}

- (void)testAddEntriesToUserInfo {
    CustomParameters *inputCustomParameters = [[CustomParameters alloc] init];
    inputCustomParameters.customParameter = @"Value";
    
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    [inputParams addEntriesToUserInfo:inputCustomParameters];

    XExtensionItemParameters *outputParams = [[XExtensionItemParameters alloc] initWithExtensionItem:inputParams.extensionItemRepresentation];
    
    CustomParameters *outputCustomParameters = [[CustomParameters alloc] initWithDictionary:outputParams.userInfo];
    
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
    
    XExtensionItemParameters *params = [[XExtensionItemParameters alloc] initWithExtensionItem:item];
    
    item = [[NSExtensionItem alloc] init];
    item.userInfo = @{
        @"x-extension-item": @{
            @"type-identifiers-to-content-representations": @"",
            @"source-url": @"",
            @"tags": @{},
            @"image-url": @"",
            @"location": @"",
            @"source-application-name": @[],
            @"source-application-store-id": @[]
        }
    };
    
    params = [[XExtensionItemParameters alloc] initWithExtensionItem:item];
    XCTAssertNoThrow([params.typeIdentifiersToContentRepresentations allKeys]);
    XCTAssertNoThrow([params.sourceURL absoluteString]);
    XCTAssertNoThrow([params.imageURL absoluteString]);
    XCTAssertNoThrow([params.sourceApplication.appName stringByAppendingString:@""]);
    XCTAssertNoThrow(params.sourceApplication.appStoreID);
}

@end
