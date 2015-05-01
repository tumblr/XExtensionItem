#import "XExtensionItemReferrer.h"
#import "XExtensionItemTypeSafeDictionaryValues.h"

static NSString * const InfoPlistBundleDisplayNameKey = @"CFBundleDisplayName";

static NSString * const ParameterKeyReferrerName = @"referrer-name";
static NSString * const ParameterKeyReferrerAppStoreID = @"referrer-app-store-id";
static NSString * const ParameterKeyReferrerGooglePlayID = @"referrer-google-play-id";
static NSString * const ParameterKeyReferrerWebURL = @"referrer-web-url";
static NSString * const ParameterKeyReferreriOSAppURL = @"referrer-ios-app-url";
static NSString * const ParameterKeyReferrerAndroidAppURL = @"referrer-android-app-url";

@implementation XExtensionItemReferrer

#pragma mark - Initialization

- (instancetype)initWithAppNameFromBundle:(NSBundle *)bundle
                               appStoreID:(NSString *)appStoreID
                             googlePlayID:(NSString *)googlePlayID
                                   webURL:(NSURL *)webURL
                                iOSAppURL:(NSURL *)iOSAppURL
                            androidAppURL:(NSURL *)androidAppURL {
    NSString *displayName = bundle.infoDictionary[InfoPlistBundleDisplayNameKey] ?: bundle.infoDictionary[(NSString *)kCFBundleNameKey];
                                
    return [self initWithAppName:displayName
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
    
    return [self initWithAppName:[dictionaryValues stringForKey:ParameterKeyReferrerName]
                      appStoreID:[dictionaryValues stringForKey:ParameterKeyReferrerAppStoreID]
                    googlePlayID:[dictionaryValues stringForKey:ParameterKeyReferrerGooglePlayID]
                          webURL:[dictionaryValues URLForKey:ParameterKeyReferrerWebURL]
                       iOSAppURL:[dictionaryValues URLForKey:ParameterKeyReferreriOSAppURL]
                   androidAppURL:[dictionaryValues URLForKey:ParameterKeyReferrerAndroidAppURL]];
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
    [mutableParameters setValue:self.appName forKey:ParameterKeyReferrerName];
    [mutableParameters setValue:self.appStoreID forKey:ParameterKeyReferrerAppStoreID];
    [mutableParameters setValue:self.googlePlayID forKey:ParameterKeyReferrerGooglePlayID];
    [mutableParameters setValue:self.webURL forKey:ParameterKeyReferrerWebURL];
    [mutableParameters setValue:self.iOSAppURL forKey:ParameterKeyReferreriOSAppURL];
    [mutableParameters setValue:self.androidAppURL forKey:ParameterKeyReferrerAndroidAppURL];
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
    
    if (![object isKindOfClass:[XExtensionItemReferrer class]]) {
        return NO;
    }
    
    XExtensionItemReferrer *other = (XExtensionItemReferrer *)object;
    
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

@end
