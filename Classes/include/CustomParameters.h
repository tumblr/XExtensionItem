@import Foundation;
#import "XExtensionItemCustomParameters.h"

/**
 *  Just a unit test helper, a simple class that conforms to `XExtensionItemDictionarySerializing` so we can make sure 
 *  that adding custom parameters works.
 */
@interface CustomParameters : NSObject <XExtensionItemCustomParameters>

@property (nonatomic, copy) NSString *customParameter;

@end
