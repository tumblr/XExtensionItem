#import "XExtensionItemCustomParameters.h"

/**
 A model object containing information about the application where the content is being passed from.
 */
@interface XExtensionItemReferrer : NSObject <XExtensionItemCustomParameters>

/**
 Name of the application that is passing data into the share extension.
 */
@property (nonatomic, readonly) NSString *appName;

/**
 Apple App Store ID of the application that is passing data into the share extension.
 */
@property (nonatomic, readonly) NSString *appStoreID;

/**
 Google Play Store ID of the application that is passing data into the share extension.
 */
@property (nonatomic, readonly) NSString *googlePlayID;

/**
 URL where the content being shared can be found on the web.
 */
@property (nonatomic, readonly) NSURL *webURL;

/**
 URL where the content being shared can be deep-linked into on iOS, e.g. `tumblr://x-callback-url/blog?blogName=bryan&postID=43724939726`
 */
@property (nonatomic, readonly) NSURL *iOSAppURL;

/**
 URL where the content being shared can be deep-linked into on Android, e.g. `tumblr://blog?blogName=bryan&postID=43724939726`
 */
@property (nonatomic, readonly) NSURL *androidAppURL;

/**
 Create an `XExtensionItemReferrer` instance. Documentation for the arguments can be found on each of this
 class’s properties.
 
 @param appName       (Optional) See `appName` property
 @param appStoreID    (Optional) See `appStoreID` property
 @param googlePlayID  (Optional) See `googlePlayID` property
 @param webURL        (Optional) See `webURL` property
 @param iOSAppURL     (Optional) See `iOSAppURL` property
 @param androidAppURL (Optional) See `androidAppURL` property
 
 @return New referrer instance.
 */
- (instancetype)initWithAppName:(NSString *)appName
                     appStoreID:(NSString *)appStoreID
                   googlePlayID:(NSString *)googlePlayID
                         webURL:(NSURL *)webURL
                      iOSAppURL:(NSURL *)iOSAppURL
                  androidAppURL:(NSURL *)androidAppURL NS_DESIGNATED_INITIALIZER;

/**
 Create an `XExtensionItemReferrer` instance. Documentation for the arguments can be found on each of this
 class’s properties.
 
 @param bundle        (Optional) Bundle where the human-readable, localized bundle name should be retrieved from.
 @param appStoreID    (Optional) See `appStoreID` property
 @param googlePlayID  (Optional) See `googlePlayID` property
 @param webURL        (Optional) See `webURL` property
 @param iOSAppURL     (Optional) See `iOSAppURL` property
 @param androidAppURL (Optional) See `androidAppURL` property
 
 @return New referrer instance.
 */
- (instancetype)initWithAppNameFromBundle:(NSBundle *)bundle
                               appStoreID:(NSString *)appStoreID
                             googlePlayID:(NSString *)googlePlayID
                                   webURL:(NSURL *)webURL
                                iOSAppURL:(NSURL *)iOSAppURL
                            androidAppURL:(NSURL *)androidAppURL;

@end
