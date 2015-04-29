@import Foundation;
#import <XExtensionItem/XExtensionItemDictionarySerializing.h>

/**
 *  In practice a custom parameters class like this would be provided by a third party, e.g. Tumblr.
 */
@interface TumblrCustomShareParameters : NSObject <XExtensionItemDictionarySerializing>

@property (nonatomic, copy) NSString *customURLSlug;

@end
