@import MobileCoreServices;
@import UIKit;
@import XCTest;
#import "XExtensionItemMutableParameters.h"
#import "XExtensionItemSourceApplication.h"

@interface CustomParameters : NSObject <XExtensionItemDictionarySerializing>

@property (nonatomic) NSString *customParameter;

@end

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

- (void)testLocation {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.location = [[CLLocation alloc] initWithLatitude:100 longitude:50];
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
    XCTAssertEqual([inputParams.location distanceFromLocation:outputParams.location], 0);
}

- (void)testSourceApplication {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.sourceApplication = [[XExtensionItemSourceApplication alloc] initWithAppName:@"Tumblr"
                                                                                  appStoreID:@(12345)];
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
    XCTAssertEqualObjects(inputParams.sourceApplication, outputParams.sourceApplication);
}

- (void)testUTIsToContentRepresentations {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.UTIsToContentRepresentations = @{ @"text/html": @"<p><strong>Foo</strong></p>" };
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
    XCTAssertEqualObjects(inputParams.UTIsToContentRepresentations, outputParams.UTIsToContentRepresentations);
}

- (void)testUserInfo {
    XExtensionItemMutableParameters *inputParams = [[XExtensionItemMutableParameters alloc] init];
    inputParams.sourceURL = [NSURL URLWithString:@"http://tumblr.com"];
    inputParams.userInfo = @{ @"foo": @"bar" };
    
    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
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

    XExtensionItemParameters *outputParams = [XExtensionItemParameters parametersFromExtensionItem:[inputParams extensionItemRepresentation]];
    
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
    
    XExtensionItemParameters *params = [XExtensionItemParameters parametersFromExtensionItem:item];
    
    item = [[NSExtensionItem alloc] init];
    item.userInfo = @{
        @"x-extension-item": @{
            @"utis-to-content-representations": @"",
            @"source-url": @"",
            @"tags": @{},
            @"image-url": @"",
            @"location": @"",
            @"source-application-name": @[],
            @"source-application-store-id": @[]
        }
    };
    
    params = [XExtensionItemParameters parametersFromExtensionItem:item];
    XCTAssertNoThrow([params.UTIsToContentRepresentations allKeys]);
    XCTAssertNoThrow([params.sourceURL absoluteString]);
    XCTAssertNoThrow([params.imageURL absoluteString]);
    XCTAssertNoThrow(params.location.timestamp);
    XCTAssertNoThrow([params.sourceApplication.appName stringByAppendingString:@""]);
    XCTAssertNoThrow(params.sourceApplication.appStoreID);
}

@end

@implementation CustomParameters

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _customParameter = [dictionary valueForKey:[[self class] customParameterKey]];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithDictionary:nil];
}

#pragma mark - XExtensionItemDictionarySerializing

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [mutableDictionary setValue:self.customParameter forKey:[[self class] customParameterKey]];
    return [mutableDictionary copy];
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && [self.customParameter isEqualToString:((CustomParameters *)object).customParameter];
}

- (NSUInteger)hash {
    NSUInteger hash = 17;
    hash += self.customParameter.hash;
    return hash * 39;
}

#pragma mark - Private

+ (NSString *)customParameterKey {
    return @"customParameterKey";
}

@end
