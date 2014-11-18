#import "XExtensionItemSourceApplication.h"

@implementation XExtensionItemSourceApplication

#pragma mark - Initialization

- (instancetype)initWithAppNameFromBundle:(NSBundle *)bundle appStoreURL:(NSURL *)appStoreURL iconURL:(NSURL *)iconURL {
    return [self initWithAppName:bundle.infoDictionary[(NSString *)kCFBundleNameKey] appStoreURL:appStoreURL iconURL:iconURL];
}

- (instancetype)initWithAppName:(NSString *)appName appStoreURL:(NSURL *)appStoreURL iconURL:(NSURL *)iconURL {
    if (self = [super init]) {
        _appName = [appName copy];
        _appStoreURL = [appStoreURL copy];
        _iconURL = [iconURL copy];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithAppName:nil appStoreURL:nil iconURL:nil];
}

#pragma mark - NSObject

- (NSString *)description {
    NSMutableString *mutableDescription = [[NSMutableString alloc] initWithString:[super description]];
    
    NSMutableArray *descriptionComponents = [[NSMutableArray alloc] init];

    if (self.appName) {
        [descriptionComponents addObject:[NSString stringWithFormat:@"appName: %@", self.appName]];
    }
    
    if (self.appStoreURL) {
        [descriptionComponents addObject:[NSString stringWithFormat:@"appStoreURL: %@", self.appStoreURL]];
    }
    
    if (self.iconURL) {
        [descriptionComponents addObject:[NSString stringWithFormat:@"iconURL: %@", self.iconURL]];
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
    
    return [self.appName isEqual:other.appName] && [self.appStoreURL isEqual:other.appStoreURL] && [self.iconURL isEqual:other.iconURL];
}

- (NSUInteger)hash {
    NSUInteger hash = 17;
    hash += self.appName.hash;
    hash += self.appStoreURL.hash;
    hash += self.iconURL.hash ;
    
    return hash * 39;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[XExtensionItemSourceApplication allocWithZone:zone] initWithAppName:self.appName appStoreURL:self.appStoreURL iconURL:self.iconURL];
}

@end
