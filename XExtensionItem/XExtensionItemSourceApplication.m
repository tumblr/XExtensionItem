#import "XExtensionItemSourceApplication.h"
#import "XExtensionItemTypeSafeDictionaryValues.h"

static NSString * const ParameterKeySourceApplicationName = @"source-application-name";
static NSString * const ParameterKeySourceApplicationStoreID = @"source-application-store-id";

@implementation XExtensionItemSourceApplication

#pragma mark - Initialization

- (instancetype)initWithAppNameFromBundle:(NSBundle *)bundle appStoreID:(NSNumber *)appStoreID {
    return [self initWithAppName:bundle.infoDictionary[(NSString *)kCFBundleNameKey] appStoreID:appStoreID];
}

- (instancetype)initWithAppName:(NSString *)appName appStoreID:(NSNumber *)appStoreID {
    if (self = [super init]) {
        _appName = [appName copy];
        _appStoreID = [appStoreID copy];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithAppName:nil appStoreID:nil];
}

#pragma mark - XExtensionItemDictionarySerializing

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    XExtensionItemTypeSafeDictionaryValues *dictionaryValues = [[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:dictionary];
    
    return [self initWithAppName:[dictionaryValues stringForKey:ParameterKeySourceApplicationName]
                      appStoreID:[dictionaryValues numberForKey:ParameterKeySourceApplicationStoreID]];
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
    [mutableParameters setValue:self.appName forKey:ParameterKeySourceApplicationName];
    [mutableParameters setValue:self.appStoreID forKey:ParameterKeySourceApplicationStoreID];
    return [mutableParameters copy];
}

#pragma mark - NSObject

- (NSString *)description {
    NSMutableString *mutableDescription = [[NSMutableString alloc] initWithString:[super description]];
    
    NSMutableArray *descriptionComponents = [[NSMutableArray alloc] init];

    if (self.appName) {
        [descriptionComponents addObject:[NSString stringWithFormat:@"appName: %@", self.appName]];
    }
    
    if (self.appStoreID) {
        [descriptionComponents addObject:[NSString stringWithFormat:@"appStoreID: %@", self.appStoreID]];
    }
    
    if ([descriptionComponents count] > 0) {
        [mutableDescription appendFormat:@"{ %@ }", [descriptionComponents componentsJoinedByString:@", "]];
    }
    
    return [mutableDescription copy];
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (![object isKindOfClass:[XExtensionItemSourceApplication class]]) {
        return NO;
    }
    
    XExtensionItemSourceApplication *other = (XExtensionItemSourceApplication *)object;
    
    return [self.appName isEqual:other.appName] && [self.appStoreID isEqual:other.appStoreID];
}

- (NSUInteger)hash {
    NSUInteger hash = 17;
    hash += self.appName.hash;
    hash += self.appStoreID.hash;

    return hash * 39;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[XExtensionItemSourceApplication allocWithZone:zone] initWithAppName:self.appName appStoreID:self.appStoreID];
}

@end
