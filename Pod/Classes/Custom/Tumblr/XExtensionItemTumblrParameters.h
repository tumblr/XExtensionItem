#import "XExtensionItemCustomParameters.h"

typedef NS_ENUM(NSUInteger, XExtensionItemTumblrPostType) {
    XExtensionItemTumblrPostTypeAny,
    XExtensionItemTumblrPostTypeText,
    XExtensionItemTumblrPostTypeQuote,
    XExtensionItemTumblrPostTypeChat,
    XExtensionItemTumblrPostTypeLink,
    XExtensionItemTumblrPostTypePhoto,
    XExtensionItemTumblrPostTypeVideo
};

/**
 Custom parameters that will be consumed by the Tumblr share extension.
 */
@interface XExtensionItemTumblrParameters : NSObject <XExtensionItemCustomParameters>

/**
 Provide a custom path component for the post being created, e.g. the “pancakes” in http://bryan.io/post/116820149416/pancakes
 */
@property (nonatomic, readonly) NSString *customURLPathComponent;

/**
 Specify which Tumblr post type you would like to create. This is only a suggestion and will only be taken into
 consideration if the type of content being passed in matches up with the requested post type.
 
 To give an example, suppose that your application passes an `NSString` into the Tumblr share extension. By default, we 
 allow the user to create a text post, quote post, or chat post out of this string. If your extension specifies 
 `XExtensionItemTumblrPostTypeQuote`, we will default to a quote post rather than giving the user the choice of text or 
 chat as well. If your extension specifies `XExtensionItemTumblrPostTypePhoto`, however, we will ignore this suggestion 
 since a photo post cannot be created out of a string.
 */
@property (nonatomic, readonly) XExtensionItemTumblrPostType requestedPostType;

/**
 Tumblr API consumer key. Passing this allows us to correlate posts created using our share extension with your Tumblr 
 API application (https://www.tumblr.com/oauth/apps), which we use to provide attribution and link back to applications 
 that post to Tumblr.
 */
@property (nonatomic, readonly) NSString *consumerKey;

/**
 Convenience initializer that calls the designated initializer with a requested post type value of `XExtensionItemTumblrPostTypeAny`.
 
 @param customURLPathComponent (Optional) See `customURLPathComponent` property documentation.
 @param consumerKey            (Optional) See `consumerKey` property documentation.

 @return New parameters instance.
 */
- (instancetype)initWithCustomURLPathComponent:(NSString *)customURLPathComponent
                                   consumerKey:(NSString *)consumerKey;

/**
 Initializes a custom Tumblr parameters object.
 
 @param customURLPathComponent (Optional) See `customURLPathComponent` property documentation.
 @param requestedPostType      See `requestedPostType` property documentation. Default value: `XExtensionItemTumblrPostTypeAny`
 @param consumerKey            (Optional) See `consumerKey` property documentation.
 
 @return New parameters instance.
 */
- (instancetype)initWithCustomURLPathComponent:(NSString *)customURLPathComponent
                             requestedPostType:(XExtensionItemTumblrPostType)requestedPostType
                                   consumerKey:(NSString *)consumerKey NS_DESIGNATED_INITIALIZER;

@end
