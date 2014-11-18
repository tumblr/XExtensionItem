@import Foundation;

/**
 *  A model object containing information about an application that is passing data into a share extension.
 */
@interface XExtensionItemSourceApplication : NSObject <NSCopying>

/**
 *  Name of the application that is passing data into the share extension.
 */
@property (nonatomic, readonly) NSString *appName;

/**
 *  URL where the application that is passing data into the share extension can be found in the iOS App Store.
 */
@property (nonatomic, readonly) NSURL *appStoreURL;

/**
 *  URL where an icon for the application that is passing data into the share extension can be found.
 */
@property (nonatomic, readonly) NSURL *iconURL;

/**
 *  @param appName     (Optional) See `appName` property
 *  @param appStoreURL (Optional) See `appStoreURL` property
 *  @param iconURL     (Optional) See `iconURL` property
 */
- (instancetype)initWithAppName:(NSString *)appName appStoreURL:(NSURL *)appStoreURL iconURL:(NSURL *)iconURL NS_DESIGNATED_INITIALIZER;

/**
 *  @param bundle      (Optional) Bundle where the human-readable, localized bundle name should be retrieved from.
 *  @param appStoreURL (Optional) See `appStoreURL` property
 *  @param iconURL     (Optional) See `iconURL` property
 */
- (instancetype)initWithAppNameFromBundle:(NSBundle *)bundle appStoreURL:(NSURL *)appStoreURL iconURL:(NSURL *)iconURL;

@end
