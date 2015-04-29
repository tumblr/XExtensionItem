#import <Foundation/Foundation.h>
#import "XExtensionItemDictionarySerializing.h"
@class XExtensionItemMutableSourceApplication;

/**
 A model object containing information about an application that is passing data into a share extension.
 */
@interface XExtensionItemSourceApplication : NSObject <NSCopying, NSMutableCopying, XExtensionItemDictionarySerializing>

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
 Create an immutable `XExtensionItemSourceApplication` instance by configuring a mutable instance passed into a 
 configuration block.
 
 @param initializationBlock Block to be called with a mutable source application instance to be configured.
 
 @return New source application instance populated with values from the mutable instance.
 */
- (instancetype)initWithBlock:(void (^)(XExtensionItemMutableSourceApplication *))initializationBlock;

/**
 Create an immutable `XExtensionItemSourceApplication` instance. Documentation for the arguments can be found on each of 
 this class’s properties.
 
 Immutable `XExtensionItemSourceApplication` instances can also be created by copying an 
 `XExtensionItemMutableSourceApplication` instance or by using the block-based convenience initializer.
 
 @param appName       (Optional) See `appName` property
 @param appStoreID    (Optional) See `appStoreID` property
 @param googlePlayID  (Optional) See `googlePlayID` property
 @param webURL        (Optional) See `webURL` property
 @param iOSAppURL     (Optional) See `iOSAppURL` property
 @param androidAppURL (Optional) See `androidAppURL` property
 
 @return New source application instance.
 */
- (instancetype)initWithAppName:(NSString *)appName
                     appStoreID:(NSString *)appStoreID
                   googlePlayID:(NSString *)googlePlayID
                         webURL:(NSURL *)webURL
                      iOSAppURL:(NSURL *)iOSAppURL
                  androidAppURL:(NSURL *)androidAppURL NS_DESIGNATED_INITIALIZER;

/**
 Create an immutable `XExtensionItemSourceApplication` instance. Documentation for the arguments can be found on each of
 this class’s properties.
 
 Immutable `XExtensionItemSourceApplication` instances can also be created by copying an
 `XExtensionItemMutableSourceApplication` instance or by using the block-based convenience initializer.
 
 @param bundle        (Optional) Bundle where the human-readable, localized bundle name should be retrieved from.
 @param appStoreID    (Optional) See `appStoreID` property
 @param googlePlayID  (Optional) See `googlePlayID` property
 @param webURL        (Optional) See `webURL` property
 @param iOSAppURL     (Optional) See `iOSAppURL` property
 @param androidAppURL (Optional) See `androidAppURL` property
 
 @return New source application instance.
 */
- (instancetype)initWithAppNameFromBundle:(NSBundle *)bundle
                               appStoreID:(NSString *)appStoreID
                             googlePlayID:(NSString *)googlePlayID
                                   webURL:(NSURL *)webURL
                                iOSAppURL:(NSURL *)iOSAppURL
                            androidAppURL:(NSURL *)androidAppURL;

@end
