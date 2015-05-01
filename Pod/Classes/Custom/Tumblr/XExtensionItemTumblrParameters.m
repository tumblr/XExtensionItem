#import "XExtensionItemTumblrParameters.h"
#import "XExtensionItemTypeSafeDictionaryValues.h"

static NSString * const ParameterKeyCustomURLPathComponent = @"com.tumblr.tumblr.custom-url-path";
static NSString * const ParameterKeyRequestedPostType = @"com.tumblr.tumblr.requested-post-type";
static NSString * const ParameterKeyConsumerKey = @"com.tumblr.tumblr.consumer-key";
static NSString * const ParameterKeyCorrelationIdentifier = @"com.tumblr.tumblr.correlation-identifier";

@implementation XExtensionItemTumblrParameters

#pragma mark - Initialization

- (instancetype)initWithCustomURLPathComponent:(NSString *)customURLPathComponent
                                   consumerKey:(NSString *)consumerKey {
    return [self initWithCustomURLPathComponent:nil
                              requestedPostType:XExtensionItemTumblrPostTypeAny
                                    consumerKey:nil];
}

- (instancetype)initWithCustomURLPathComponent:(NSString *)customURLPathComponent
                             requestedPostType:(XExtensionItemTumblrPostType)requestedPostType
                                   consumerKey:(NSString *)consumerKey {
    self = [super init];
    if (self) {
        _customURLPathComponent = [customURLPathComponent copy];
        _requestedPostType = requestedPostType;
        _consumerKey = [consumerKey copy];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithCustomURLPathComponent:nil
                              requestedPostType:XExtensionItemTumblrPostTypeAny
                                    consumerKey:nil];
}

#pragma mark - XExtensionItemDictionarySerializing

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    XExtensionItemTypeSafeDictionaryValues *dictionaryValues = [[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:dictionary];
    
    return [self initWithCustomURLPathComponent:[dictionaryValues stringForKey:ParameterKeyCustomURLPathComponent]
                              requestedPostType:[dictionaryValues unsignedIntegerForKey:ParameterKeyRequestedPostType]
                                    consumerKey:[dictionaryValues stringForKey:ParameterKeyConsumerKey]];
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
    [mutableParameters setValue:self.customURLPathComponent forKey:ParameterKeyCustomURLPathComponent];
    [mutableParameters setValue:@(self.requestedPostType) forKey:ParameterKeyRequestedPostType];
    [mutableParameters setValue:self.consumerKey forKey:ParameterKeyConsumerKey];
    return [mutableParameters copy];
}

#pragma mark - NSObject

- (NSString *)description {
    NSMutableString *mutableDescription = [[NSMutableString alloc] initWithString:[super description]];
    
    NSMutableArray *descriptionComponents = [[NSMutableArray alloc] init];
    
    if (self.customURLPathComponent) {
        [descriptionComponents addObject:[NSString stringWithFormat:@"customURLPathComponent: %@", self.customURLPathComponent]];
    }
    
    [descriptionComponents addObject:[NSString stringWithFormat:@"requestedPostType: %lu", (unsigned long)self.requestedPostType]];
    
    if (self.consumerKey) {
        [descriptionComponents addObject:[NSString stringWithFormat:@"consumerKey: %@", self.consumerKey]];
    }
    
    [mutableDescription appendFormat:@"{ %@ }", [descriptionComponents componentsJoinedByString:@", "]];
    
    return [mutableDescription copy];
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (![object isKindOfClass:[XExtensionItemTumblrParameters class]]) {
        return NO;
    }
    
    XExtensionItemTumblrParameters *other = (XExtensionItemTumblrParameters *)object;
    
    return [self.customURLPathComponent isEqual:other.customURLPathComponent] && self.requestedPostType == other.requestedPostType && [self.consumerKey isEqual:other.consumerKey];
}

- (NSUInteger)hash {
    NSUInteger hash = 15;
    hash += self.customURLPathComponent.hash;
    hash += self.requestedPostType;
    hash += self.consumerKey.hash;
    
    return hash * 41;
}

@end
