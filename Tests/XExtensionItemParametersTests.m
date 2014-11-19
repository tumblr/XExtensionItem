//
//  XExtensionItemParametersTests.m
//  Tests
//
//  Created by Bryan Irace on 11/18/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

@import MobileCoreServices;
@import UIKit;
@import XCTest;
#import "XExtensionItemMutableParameters.h"
#import "XExtensionItemSourceApplication.h"

@interface XExtensionItemParametersTests : XCTestCase

@end

@implementation XExtensionItemParametersTests

- (void)testAttributedTitle {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.attributedTitle = [[NSAttributedString alloc] initWithString:@"Foo" attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:20] }];
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
    XCTAssertEqualObjects(inputParams.attributedTitle.string, outputParams.attributedTitle.string);
}

- (void)testAttributedContentText {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.attributedContentText = [[NSAttributedString alloc] initWithString:@"Foo" attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:20] }];
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
    XCTAssertEqual(inputParams.attributedContentText.hash, outputParams.attributedContentText.hash);
}

- (void)testAttachments {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.attachments = @[[[NSItemProvider alloc] initWithItem:[NSURL URLWithString:@"http://apple.com"]
                                                      typeIdentifier:(__bridge NSString *)kUTTypeURL]];
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
    XCTAssertEqualObjects(inputParams.attachments, outputParams.attachments);
}

- (void)testTags {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.tags = @[@"foo", @"bar", @"baz"];
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
    XCTAssertEqualObjects(inputParams.tags, outputParams.tags);
}

- (void)testSourceURL {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.sourceURL = [NSURL URLWithString:@"http://tumblr.com"];
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
    XCTAssertEqualObjects(inputParams.sourceURL, outputParams.sourceURL);
}

- (void)testImageURL {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.imageURL = [NSURL URLWithString:@"http://tumblr.com/image.png"];
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
    XCTAssertEqualObjects(inputParams.imageURL, outputParams.imageURL);
}

- (void)testSourceApplication {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.sourceApplication = [[XExtensionItemSourceApplication alloc] initWithAppName:@"Tumblr"
                                                                                 appStoreURL:[NSURL URLWithString:@"http://appstore.com/tumblr"]
                                                                                     iconURL:[NSURL URLWithString:@"http://tumblr.com/logo.png"]];
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
    XCTAssertEqualObjects(inputParams.sourceApplication, outputParams.sourceApplication);
}

- (void)testMIMETypesToContentRepresentations {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.MIMETypesToContentRepresentations = @{ @"text/html": @"<p><strong>Foo</strong></p>" };
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
    XCTAssertEqualObjects(inputParams.MIMETypesToContentRepresentations, outputParams.MIMETypesToContentRepresentations);
}

- (void)testUserInfo {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.userInfo = @{ @"foo": @"bar" };
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
    XCTAssertEqualObjects(inputParams.userInfo, outputParams.userInfo);
}

- (void)testTypeSafety {
    // Try to break things by intentionally using the wrong types for these keys.
    
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.userInfo = @{
        @"x-extension-item-mime-types-to-content-representations": @[],
        @"x-extension-item-source-url": @"",
        @"x-extension-item-source-application-name": @[],
        @"x-extension-item-source-application-store-url": @"",
        @"x-extension-item-source-application-icon-url": @"",
        @"x-extension-item-tags": @{},
        @"x-extension-item-image-url": @""
    };
    
    // Call methods that would only exist on the correct object types
    
    XExtensionItemParameters *params = [XExtensionItemParameters parametersFromExtensionItem:item];
    XCTAssertNoThrow([params.MIMETypesToContentRepresentations allKeys]);
    XCTAssertNoThrow([params.sourceURL absoluteString]);
    XCTAssertNoThrow([params.sourceApplication.appName stringByAppendingString:@""]);
    XCTAssertNoThrow([params.sourceApplication.appStoreURL absoluteString]);
    XCTAssertNoThrow([params.sourceApplication.iconURL absoluteString]);
    XCTAssertNoThrow([params.imageURL absoluteString]);
}

@end
