#import "XExtensionItemSourceApplication.h"

/**
 Mutable `XExtensionItemSourceApplication` variant.
 
 @see `XExtensionItemSourceApplication`
 */
@interface XExtensionItemMutableSourceApplication : XExtensionItemSourceApplication <NSCopying>

@property (nonatomic, copy, readonly) NSString *appName;
@property (nonatomic, copy, readonly) NSString *appStoreID;
@property (nonatomic, copy, readonly) NSString *googlePlayID;
@property (nonatomic, copy, readonly) NSURL *webURL;
@property (nonatomic, copy, readonly) NSURL *iOSAppURL;
@property (nonatomic, copy, readonly) NSURL *androidAppURL;

@end
