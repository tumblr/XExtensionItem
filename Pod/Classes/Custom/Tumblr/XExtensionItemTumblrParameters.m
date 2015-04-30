#import "XExtensionItemTumblrParameters.h"
#import "XExtensionItemTypeSafeDictionaryValues.h"

static NSString * const ParameterKeyCustomURLPathComponent = @"com.tumblr.tumblr.custom-url-path";
static NSString * const ParameterKeyRequestedPostType = @"com.tumblr.tumblr.requested-post-type";
static NSString * const ParameterKeyConsumerKey = @"com.tumblr.tumblr.consumer-key";
static NSString * const ParameterKeyCorrelationIdentifier = @"com.tumblr.tumblr.correlation-identifier";

@implementation XExtensionItemTumblrParameters

#pragma mark - Initialization

- (instancetype)initWithCustomURLPathComponent:(NSString *)customURLPathComponent
                                   consumerKey:(NSString *)consumerKey
                         correlationIdentifier:(NSString *)correlationIdentifier {
    return [self initWithCustomURLPathComponent:nil
                              requestedPostType:XExtensionItemTumblrPostTypeAny
                                    consumerKey:nil
                          correlationIdentifier:nil];
}

- (instancetype)initWithCustomURLPathComponent:(NSString *)customURLPathComponent
                             requestedPostType:(XExtensionItemTumblrPostType)requestedPostType
                                   consumerKey:(NSString *)consumerKey
                         correlationIdentifier:(NSString *)correlationIdentifier {
    self = [super init];
    if (self) {
        _customURLPathComponent = [customURLPathComponent copy];
        _requestedPostType = requestedPostType;
        _consumerKey = [consumerKey copy];
        _correlationIdentifier = [correlationIdentifier copy];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithCustomURLPathComponent:nil
                              requestedPostType:XExtensionItemTumblrPostTypeAny
                                    consumerKey:nil
                          correlationIdentifier:nil];
}

#pragma mark - XExtensionItemDictionarySerializing

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    XExtensionItemTypeSafeDictionaryValues *dictionaryValues = [[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:dictionary];
    
    return [self initWithCustomURLPathComponent:[dictionaryValues stringForKey:ParameterKeyCustomURLPathComponent]
                              requestedPostType:[dictionaryValues unsignedIntegerForKey:ParameterKeyRequestedPostType]
                                    consumerKey:[dictionaryValues stringForKey:ParameterKeyConsumerKey]
                          correlationIdentifier:[dictionaryValues stringForKey:ParameterKeyCorrelationIdentifier]];
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
    [mutableParameters setValue:self.customURLPathComponent forKey:ParameterKeyCustomURLPathComponent];
    [mutableParameters setValue:@(self.requestedPostType) forKey:ParameterKeyRequestedPostType];
    [mutableParameters setValue:self.consumerKey forKey:ParameterKeyConsumerKey];
    [mutableParameters setValue:self.correlationIdentifier forKey:ParameterKeyCorrelationIdentifier];
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
    
    if (self.correlationIdentifier) {
        [descriptionComponents addObject:[NSString stringWithFormat:@"correlationIdentifier: %@", self.correlationIdentifier]];
    }
    
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
    
    return [self.customURLPathComponent isEqual:other.customURLPathComponent] &&
    self.requestedPostType == other.requestedPostType &&
    [self.consumerKey isEqual:other.consumerKey] &&
    [self.correlationIdentifier isEqual:other.correlationIdentifier];
}

- (NSUInteger)hash {
    NSUInteger hash = 15;
    hash += self.customURLPathComponent.hash;
    hash += self.requestedPostType;
    hash += self.consumerKey.hash;
    hash += self.correlationIdentifier.hash;
    
    return hash * 41;
}

@end
