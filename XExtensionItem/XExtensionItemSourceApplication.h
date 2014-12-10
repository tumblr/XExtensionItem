#import <Foundation/Foundation.h>
#import "XExtensionItemDictionarySerializing.h"

/**
 A model object containing information about an application that is passing data into a share extension.
 */
@interface XExtensionItemSourceApplication : NSObject <NSCopying, XExtensionItemDictionarySerializing>

/**
 Name of the application that is passing data into the share extension.
 */
@property (nonatomic, readonly) NSString *appName;

/**
 Apple App Store ID of the application that is passing data into the share extension.
 */
@property (nonatomic, readonly) NSNumber *appStoreID;

/**
 @param appName     (Optional) See `appName` property
 @param appStoreURL (Optional) See `appStoreURL` property
 */
- (instancetype)initWithAppName:(NSString *)appName appStoreID:(NSNumber *)appStoreID NS_DESIGNATED_INITIALIZER;

/**
 @param bundle      (Optional) Bundle where the human-readable, localized bundle name should be retrieved from.
 @param appStoreURL (Optional) See `appStoreURL` property
 */
- (instancetype)initWithAppNameFromBundle:(NSBundle *)bundle appStoreID:(NSNumber *)appStoreID;

@end
