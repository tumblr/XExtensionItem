//
//  XExtensionItemTypeSafeDictionaryValuesTests.m
//  XExtensionItem
//
//  Created by Bryan Irace on 12/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

@import XCTest;
#import "XExtensionItemTypeSafeDictionaryValues.h"

static NSString * const Key = @"key";

@interface XExtensionItemTypeSafeDictionaryValuesTests : XCTestCase
@end

@implementation XExtensionItemTypeSafeDictionaryValuesTests

- (void)testStringForKey {
    NSString *string = @"string";
    
    XCTAssertEqualObjects(string, [safeDictionaryValuesWithSingleEntryForKeyConstant(string) stringForKey:Key]);
}

- (void)testNumberForKey {
    NSNumber *number = @1;
    
    XCTAssertEqualObjects(number, [safeDictionaryValuesWithSingleEntryForKeyConstant(number) numberForKey:Key]);
}

- (void)testURLForKey {
    NSURL *URL = [NSURL URLWithString:@"http://tumblr.com"];
    
    XCTAssertEqualObjects(URL, [safeDictionaryValuesWithSingleEntryForKeyConstant(URL) URLForKey:Key]);
}

- (void)testDictionaryForKey {
    NSDictionary *dictionary = @{ @"foo": @"bar" };
    
    XCTAssertEqualObjects(dictionary, [safeDictionaryValuesWithSingleEntryForKeyConstant(dictionary) dictionaryForKey:Key]);
}

- (void)testArrayForKey {
    NSArray *array = @[ @"foo", @"bar" ];
    
    XCTAssertEqualObjects(array, [safeDictionaryValuesWithSingleEntryForKeyConstant(array) arrayForKey:Key]);
}

- (void)testDataForKey {
    NSData *data = [@"string" dataUsingEncoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(data, [safeDictionaryValuesWithSingleEntryForKeyConstant(data) dataForKey:Key]);
}

#pragma mark - Verify nil returned on type mismatches

- (void)testStringForKeyReturnsNilForValueOfWrongType {
    XCTAssertNil([safeDictionaryValuesWithSingleEntryForKeyConstant(@1) stringForKey:Key]);
}

- (void)testNumberForKeyReturnsNilForValueOfWrongType {
    XCTAssertNil([safeDictionaryValuesWithSingleEntryForKeyConstant(@"1") numberForKey:Key]);
}

- (void)testURLForKeyReturnsNilForValueOfWrongType {
    XCTAssertNil([safeDictionaryValuesWithSingleEntryForKeyConstant(@1) URLForKey:Key]);
}

- (void)testDictionaryForKeyReturnsNilForValueOfWrongType {
    XCTAssertNil([safeDictionaryValuesWithSingleEntryForKeyConstant(@1) dictionaryForKey:Key]);
}

- (void)testArrayForKeyReturnsNilForValueOfWrongType {
    XCTAssertNil([safeDictionaryValuesWithSingleEntryForKeyConstant(@1) arrayForKey:Key]);
}

- (void)testDataForKeyReturnsNilForValueOfWrongType {
    XCTAssertNil([safeDictionaryValuesWithSingleEntryForKeyConstant(@1) dataForKey:Key]);
}

#pragma mark - Private

static XExtensionItemTypeSafeDictionaryValues *safeDictionaryValuesWithSingleEntryForKeyConstant(id value) {
    return [[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:@{ Key: value }];
}

@end
