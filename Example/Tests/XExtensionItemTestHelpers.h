@interface XExtensionItemSource (Testing)

@property (nonatomic, readonly) id item;

@end

@implementation XExtensionItemSource (Testing)

- (id)item {
    return [self activityViewController:nil itemForActivityType:nil];
}

@end

#define XExtensionItemAssertEqualItemProviderArrays(itemProviders, otherItemProviders)\
    { \
        XCTestExpectation *expectation = [self expectationWithDescription:@"Load item provider attachments"]; \
        \
        itemsForItemProviders(itemProviders, ^(NSArray *items) { \
            itemsForItemProviders(otherItemProviders, ^(NSArray *otherItems) { \
                XCTAssertEqualObjects(items, otherItems); \
                \
                [expectation fulfill]; \
            }); \
        }); \
        \
        [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) { \
            if (error) { \
                XCTFail(@"Expectation failed with error: %@", error); \
            } \
        }]; \
    }

#define XExtensionItemAssertEqualItems(object1, object2) \
    { \
        XCTAssertTrue([object1 isKindOfClass:[NSExtensionItem class]]); \
        XCTAssertTrue([object2 isKindOfClass:[NSExtensionItem class]]); \
        \
        NSExtensionItem *item1 = (NSExtensionItem *)object1;\
        NSExtensionItem *item2 = (NSExtensionItem *)object2;\
        \
        XCTAssertEqualObjects(item1.attributedTitle, item2.attributedTitle); \
        XCTAssertEqualObjects(item1.attributedContentText, item2.attributedContentText); \
        XCTAssertEqualObjects(dictionaryByRemovingExtensionItemSystemKeys(item1.userInfo), dictionaryByRemovingExtensionItemSystemKeys(item2.userInfo)); \
        \
        XExtensionItemAssertEqualItemProviderArrays(item1.attachments, item2.attachments); \
    }

static NSDictionary *dictionaryByRemovingExtensionItemSystemKeys(NSDictionary *dictionary) {
    NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
    
    for (NSString *key in @[NSExtensionItemAttributedTitleKey, NSExtensionItemAttributedContentTextKey, NSExtensionItemAttachmentsKey]) {
        [mutableDictionary removeObjectForKey:key];
    }
    
    return [mutableDictionary copy];
}

static void itemsForItemProvider(NSItemProvider *provider, void (^block)(NSArray *items)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        for (NSString *identifier in provider.registeredTypeIdentifiers) {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            
            [provider loadItemForTypeIdentifier:identifier options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                [items addObject:item];
                
                dispatch_semaphore_signal(semaphore);
            }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        block(items);
    });
}

static void itemsForItemProviders(NSArray/*<NSItemProvider>*/ *providers, void (^block)(NSArray *items)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        for (NSItemProvider *provider in providers) {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            
            itemsForItemProvider(provider, ^(NSArray *providerItems) {
                [items addObjectsFromArray:providerItems];
                
                dispatch_semaphore_signal(semaphore);
            });
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        block(items);
    });
}
