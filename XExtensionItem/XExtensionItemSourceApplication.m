#import "XExtensionItemSourceApplication.h"
#import "XExtensionItemTypeSafeDictionaryValues.h"

static NSString * const ParameterKeySourceApplicationName = @"source-application-name";
static NSString * const ParameterKeySourceApplicationAppStoreID = @"source-application-app-store-id";
static NSString * const ParameterKeySourceApplicationGooglePlayID = @"source-application-google-play-id";
static NSString * const ParameterKeySourceApplicationWebURL = @"source-application-web-url";
static NSString * const ParameterKeySourceApplicationiOSAppURL = @"source-application-ios-app-url";
static NSString * const ParameterKeySourceApplicationAndroidAppURL = @"source-application-android-app-url";

@implementation XExtensionItemSourceApplication

#pragma mark - Initialization

- (instancetype)initWithAppNameFromBundle:(NSBundle *)bundle
                               appStoreID:(NSString *)appStoreID
                             googlePlayID:(NSString *)googlePlayID
                                   webURL:(NSURL *)webURL
                                iOSAppURL:(NSURL *)iOSAppURL
                            androidAppURL:(NSURL *)androidAppURL {
    return [self initWithAppName:bundle.infoDictionary[(NSString *)kCFBundleNameKey]
                      appStoreID:appStoreID
                    googlePlayID:googlePlayID
                          webURL:webURL
                       iOSAppURL:iOSAppURL
                   androidAppURL:androidAppURL];
}

- (instancetype)initWithAppName:(NSString *)appName
                     appStoreID:(NSString *)appStoreID
                   googlePlayID:(NSString *)googlePlayID
                         webURL:(NSURL *)webURL
                      iOSAppURL:(NSURL *)iOSAppURL
                  androidAppURL:(NSURL *)androidAppURL {
    if (self = [super init]) {
        _appName = [appName copy];
        _appStoreID = [appStoreID copy];
        _googlePlayID = [googlePlayID copy];
        _webURL = [webURL copy];
        _iOSAppURL = [iOSAppURL copy];
        _androidAppURL = [androidAppURL copy];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithAppName:nil
                      appStoreID:nil
                    googlePlayID:nil
                          webURL:nil
                       iOSAppURL:nil
                   androidAppURL:nil];
}

#pragma mark - XExtensionItemDictionarySerializing

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    XExtensionItemTypeSafeDictionaryValues *dictionaryValues = [[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:dictionary];
    
    return [self initWithAppName:[dictionaryValues stringForKey:ParameterKeySourceApplicationName]
                      appStoreID:[dictionaryValues stringForKey:ParameterKeySourceApplicationAppStoreID]
                    googlePlayID:[dictionaryValues stringForKey:ParameterKeySourceApplicationGooglePlayID]
                          webURL:[dictionaryValues URLForKey:ParameterKeySourceApplicationWebURL]
                       iOSAppURL:[dictionaryValues URLForKey:ParameterKeySourceApplicationiOSAppURL]
                   androidAppURL:[dictionaryValues URLForKey:ParameterKeySourceApplicationAndroidAppURL]];
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
    [mutableParameters setValue:self.appName forKey:ParameterKeySourceApplicationName];
    [mutableParameters setValue:self.appStoreID forKey:ParameterKeySourceApplicationAppStoreID];
    [mutableParameters setValue:self.googlePlayID forKey:ParameterKeySourceApplicationGooglePlayID];
    [mutableParameters setValue:self.webURL forKey:ParameterKeySourceApplicationWebURL];
    [mutableParameters setValue:self.iOSAppURL forKey:ParameterKeySourceApplicationiOSAppURL];
    [mutableParameters setValue:self.androidAppURL forKey:ParameterKeySourceApplicationAndroidAppURL];
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

    if (self.googlePlayID) {
        [descriptionComponents addObject:[NSString stringWithFormat:@"googlePlayID: %@", self.googlePlayID]];
    }
    
    if (self.webURL) {
        [descriptionComponents addObject:[NSString stringWithFormat:@"webURL: %@", self.webURL]];
    }
    
    if (self.iOSAppURL) {
        [descriptionComponents addObject:[NSString stringWithFormat:@"iOSAppURL: %@", self.iOSAppURL]];
    }
    
    if (self.androidAppURL) {
        [descriptionComponents addObject:[NSString stringWithFormat:@"androidAppURL: %@", self.androidAppURL]];
    }
    
    if (descriptionComponents.count > 0) {
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
    hash += self.googlePlayID.hash;
    hash += self.webURL.hash;
    hash += self.iOSAppURL.hash;
    hash += self.androidAppURL.hash;

    return hash * 39;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[XExtensionItemSourceApplication allocWithZone:zone] initWithAppName:self.appName
                                                                      appStoreID:self.appStoreID
                                                                    googlePlayID:self.googlePlayID
                                                                          webURL:self.webURL
                                                                       iOSAppURL:self.iOSAppURL
                                                                   androidAppURL:self.androidAppURL];
}

@end
