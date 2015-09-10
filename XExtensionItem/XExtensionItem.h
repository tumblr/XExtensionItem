#import <UIKit/UIKit.h>
#import "XExtensionItemReferrer.h"
#import "XExtensionItemCustomParameters.h"

/**
 A data structure that application developers can use to pass well-defined data structures into iOS 8 extensions 
 (extension developers can then use the `XExtensionItem` class to read this data).
 
 @discussion `XExtensionItem’s provides type-safe accessors for broadly useful metadata, such as tags and information 
 about the application being shared from. Apps and extensions should be able to output and input these values without 
 knowing the specific implementation details of the app/extension on the other side of the
 handshake.
 
 Here’s how to use `XExtensionItemSource` when presenting a `UIActivityViewController`:
 
 ```objc
 // At the very least, we want to share a URL outwards. We’ll also send a photo and some other metadata in case the 
 // receiving app knows to look for those, but this URL will be what activities and extensions receive by default.
 
 NSURL *URL = [NSURL URLWithString:@"http://apple.com/featured"];
 
 UIImage *image = [UIImage imageNamed:@"tumblr-featured-on-apple-homepage.png"];
 
 XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithURL:URL];
 itemSource.tags = @[@"tumblr", @"featured", @"so cool"];
 
 UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[itemSource]
 applicationActivities:nil];
 ```
 
 ## Extension developers
 */
@interface XExtensionItemSource : NSObject <UIActivityItemSource>

/**
 An optional array of tag metadata, like on Twitter/Instagram/Tumblr.
 */
@property (nonatomic, copy) NSArray *tags;

/**
 An optional object specifying information about the application where the content is being passed from.
 
 @see `XExtensionItemReferrer`
 */
@property (nonatomic) XExtensionItemReferrer *referrer;

/**
 Add parameters from a custom parameters object.
 
 @discussion third-party developers to create an object that conforms to `XExtensionItemCustomParameters`, and open a 
 pull request to add it to the `XExtensionItem` repository. See `XExtensionItemTumblrParameters` for an example of this.
 
 @param customParameters A custom parameters object.
 */
- (void)addCustomParameters:(id <XExtensionItemCustomParameters>)customParameters;

/**
 An optional dictionary of keys and values.
 
 @discussion Please look at `addCustomParameters` and the `XExtensionItemCustomParameters` protocol before considering
 populating this dictionary directly.
 
 Individual applications can add advertise the custom parameter keys that they support, and extension developers can add 
 values for those parameters to this dictionary, but a better solution is for third-party developers to create an object 
 that conforms to `XExtensionItemCustomParameters`, and open a pull request to add it to the `XExtensionItem` 
 repository. See `XExtensionItemTumblrParameters` for an example of this.
 
 Custom user info keys should *not* start with `x-extension-item`, as those are used internally by this library. Custom 
 user info keys are also at risk of colliding with keys found in the dictionary representations of custom parameters 
 objects added via `addCustomParameters:`.
 */
@property (nonatomic, copy) NSDictionary *userInfo;

#pragma mark - Initialization

@end


/**
 A data structure that iOS 8 extension developers can use to retrieve well-defined data structures from applications 
 (application developers will have provided this data using the `XExtensionItemSource` class).
 
 @discussion Convert incoming `NSExtensionItem` instances retrieved from an extension context into `XExtensionItem` 
 instances:
 
 ```objc
 XExtensionItemContext *context = [[XExtensionItemContext alloc] initWithExtensionContext:self.extensionContext];
 NSArray *tags = context.tags;
 NSString *customTumblrURL = context.userInfo[@"tumblr-custom-url"];
 
 for (NSExtensionItem *inputItem in context.inputItems) {
    // Load attachments, introspect attributed title/content text, etc.
 }
 ```
 */
@interface XExtensionItemContext : NSObject

/**
 @see `NSExtensionContext`
 */
@property (nonatomic, readonly) NSArray/*<NSExtensionItem>*/ *inputItems;

/**
 @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSArray/*<NSString>*/ *tags;

/**
 @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) XExtensionItemReferrer *referrer;

/**
 @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSDictionary *userInfo;

/**
 Inialize a new instance with an incoming `NSExtensionContext`.
 
 @param extensionItemContext Extension context.
 
 @return New instance populated with the extension context.
 */
- (instancetype)initWithExtensionContext:(NSExtensionContext *)extensionContext NS_DESIGNATED_INITIALIZER;

@end
