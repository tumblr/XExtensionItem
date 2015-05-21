#import <UIKit/UIKit.h>
#import "XExtensionItemReferrer.h"
#import "XExtensionItemCustomParameters.h"

/**
 A data structure that application developers can use to pass well-defined data structures into iOS 8 extensions 
 (extension developers can then use the `XExtensionItem` class to read this data).
 
 @discussion App developers with numerous types of data to share may be inclined to add instances of classes like
 `NSURL`, `NSString`, and `UIImage` all to their `UIActivityViewController`s' extension item arrays. This is problematic
 because only share extensions that explicitly accept *all* of the provided item types will be displayed in the 
 controller. `XExtensionItemSource`’s primary goal is to alleviate this problem.

 A single `XExtensionItemSource` instance can be populated with all of the items that you would’ve otherwise passed 
 directly to your activity controller. It exposes only a single type of your choosing – e.g. `NSURL` – to the activity 
 controller, such that all system activities and extensions with support for this type will be available for the user to 
 choose from. When the user chooses an activity, *all of your items will be passed through to it*.

 `XExtensionItem’s secondary goal is to providing type-safe accessors for broadly useful metadata, such as tags, 
 a source URL, and information about the application being shared from. Apps and extensions should be able to output and 
 input these values without knowing the specific implementation details of the app/extension on the other side of the 
 handshake.
 
 Here’s how to use `XExtensionItemSource` when presenting a `UIActivityViewController`:
 
 ```objc
 // At the very least, we want to share a URL outwards. We’ll also send a photo and some other metadata in case the 
 // receiving app knows to look for those, but this URL will be what activities and extensions receive by default.
 
 NSURL *URL = [NSURL URLWithString:@"http://apple.com/featured"];
 
 UIImage *image = [UIImage imageNamed:@"tumblr-featured-on-apple-homepage.png"];
 
 XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithURL:URL];
 itemSource.additionalAttachments = @[image];
 itemSource.title = @"Tumblr featured on Apple.com!";
 itemSource.tags = @[@"tumblr", @"featured", @"so cool"];
 
 UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[itemSource]
 applicationActivities:nil];
 ```
 
 ## Extension developers
 */
@interface XExtensionItemSource : NSObject <UIActivityItemSource>

/**
 A block that can lazily provide an item of a predetermined type.
 
 @param activityType The selected activity type.
 
 @return Item to be provided to the activity.
 */
typedef id (^XExtensionItemProvidingBlock)(NSString *activityType);

/**
 A block that can lazily provide a thumbnail image.
 
 @param suggestedSize The suggested size for the thumbnail image, in points. You should provide an image using the
 appropriate scale for the screen. Images provided at the suggested size will result in the best experience.
 @param activityType The selected activity type.
 
 @return Thumbnail image to be provided to the activity.
 */
typedef UIImage *(^XExtensionItemThumbnailProvidingBlock)(CGSize suggestedSize, NSString *activityType);

/**
 An optional title for the item. Also used as the subject for activities that support it (i.e. Mail and Messages)
 
 @see `NSExtensionItem`
 */
@property (nonatomic, copy) NSString *title;

/**
 An optional string describing the item content. In the case of social activities, for example, this text could be
 shared alongside a URL.
 
 Calling this setter is analogous to calling `setAttribuetdContentText:forActivityType:` with a `nil` activity type, 
 causing the provided content text to be used for all types.
 
 @see `NSExtensionItem`
 */
@property (nonatomic, copy) NSAttributedString *attributedContentText;

/**
 Specify attributed content text to be used for a specific activity type only. Passing `nil` for the activity type will 
 cause the provided content text to be used for all types.
 
 @param attributedContentText Attributed content text.
 @param activityType          Activity type to use attribuetd content text for.
 */
- (void)setAttributedContentText:(NSAttributedString *)attributedContentText forActivityType:(NSString *)activityType;

/**
 An array of additional media associated with the extension item. These items must be of type `NSString`, `NSURL`,
 `UIImage`, or `NSItemProvider` and will be passed to the selected activity/extension. For example, you could add
 an image attachment to be shared alongside a URL.
 
 Calling this setter is analogous to calling `setAdditionalAttachments:forActivityType:` with a `nil` activity type, 
 causing the provided attachments to be used for all types.
 
 @see `NSExtensionItem`
 */
@property (nonatomic, copy) NSArray *additionalAttachments;

/**
 Specify additional attachments to be used for a specific activity type only. Passing `nil` for the activity type will
 cause the provided attachments to be used for all types.
 
 @param additionalAttachments Attachments.
 @param activityType          Activity type to use attachments for.
 */
- (void)setAdditionalAttachments:(NSArray *)attachments forActivityType:(NSString *)activityType;

/**
 An optional array of tag metadata, like on Twitter/Instagram/Tumblr.
 */
@property (nonatomic, copy) NSArray *tags;

/**
 An optional URL specifying the source of the attachment data. If the attachment is an image, or a text excerpt, this
 source URL might specify where that content could be found on the Internet, for example.
 */
@property (nonatomic, copy) NSURL *sourceURL;

/**
 An optional object specifying information about the application where the content is being passed from.
 
 @see `XExtensionItemReferrer`
 */
@property (nonatomic) XExtensionItemReferrer *referrer;

/**
 A block that will be called with the suggested size for the thumbnail image, in points, and the activity type chosen by 
 the user. It should return an image using the appropriate scale for the screen. Images provided at the suggested size 
 will result in the best experience.
 */
@property (nonatomic, copy) XExtensionItemThumbnailProvidingBlock thumbnailProvider;

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

/**
 Initialize an item source with a URL.
 
 @param URL (Required) URL to be shared.
 
 @return New item source instance.
 */
- (instancetype)initWithURL:(NSURL *)URL;

/**
 Initialize an item source with a string.
 
 @param string (Required) String to be shared.
 
 @return New item source instance.
 */
- (instancetype)initWithString:(NSString *)string;

/**
 Initialize an item source with an image.
 
 @param image (Required) Image to be shared.
 
 @return New item source instance.
 */
- (instancetype)initWithImage:(UIImage *)image;

/**
 Initialize an item source with data.
 
 @param data           (Required) Data to be shared.
 
 @return New item source instance.
 */
- (instancetype)initWithData:(NSData *)data;

/**
 Initialize a new instance with a placeholder item, whose type will be used by the activity controller to determine
 which activities and extensions are displayed.
 
 @param placeholderItem (Required) A placeholder item whose type will be used by the activity controller to determine
 which activities and extensions are displayed.
 @param itemBlock       (Optional) A block that can provide the item to be shared given the activity type.
 
 @return New item source instance.
 */
- (instancetype)initWithPlaceholderItem:(id)placeholderItem
                              itemBlock:(XExtensionItemProvidingBlock)itemBlock NS_DESIGNATED_INITIALIZER;

@end

/**
 A set of convenience initializers that allow items to be provided lazily rather than upfront.
 */
@interface XExtensionItemSource (ProviderBlockInitializers)

/**
 A block that can lazily provide a URL.

 @param activityType The selected activity type.

 @return Item to be provided to the activity. Can be something other than a URL if you know the selected activity type accepts it.
 */
typedef id (^XExtensionItemURLProvidingBlock)(NSString *activityType);

/**
 A block that can lazily provide a string.

 @param activityType The selected activity type.

 @return String to be provided to the activity. Can be something other than a string if you know the selected activity type accepts it.
 */
typedef id (^XExtensionItemStringProvidingBlock)(NSString *activityType);

/**
 A block that can lazily provide an image.

 @param activityType The selected activity type.

 @return Image to be provided to the activity. Can be something other than an image if you know the selected activity type accepts it.
 */
typedef id (^XExtensionItemImageProvidingBlock)(NSString *activityType);

/**
 A block that can lazily provide data of a predetermined type.

 @param activityType The selected activity type.

 @return Data to be provided to the activity. Can be something other than data if you know the selected activity type accepts it.
 */
typedef id (^XExtensionItemDataProvidingBlock)(NSString *activityType);

/**
 Initialize an item source with a block that can provide a URL.
 
 @param URLProvider (Required) URL-providing block.
 
 @return New item source instance.
 */
- (instancetype)initWithURLProvider:(XExtensionItemURLProvidingBlock)URLProvider;

/**
 Initialize an item source with a block that can provide a file URL.
 
 @param fileURL        (Required) File URL-providing block.
 
 @return New item source instance.
 */
- (instancetype)initWithFileURLProvider:(XExtensionItemURLProvidingBlock)fileURL;

/**
 Initialize an item source with a block that can provide a string.
 
 @param stringProvider (Required) String-providing block.
 
 @return New item source instance.
 */
- (instancetype)initWithStringProvider:(XExtensionItemStringProvidingBlock)stringProvider;

/**
 Initialize an item source with a block that can provide an image.
 
 @param imageProvider (Required) Image-providing block.
 
 @return New item source instance.
 */
- (instancetype)initWithImageProvider:(XExtensionItemImageProvidingBlock)imageProvider;

/**
 Initialize an item source with a block that can provide data.
 
 @param dataProvider   (Required) Data-providing block.
 
 @return New item source instance.
 */
- (instancetype)initWithDataProvider:(XExtensionItemDataProvidingBlock)dataProvider;

@end



/**
 A data structure that iOS 8 extension developers can use to retrieve well-defined data structures from applications 
 (application developers will have provided this data using the `XExtensionItemSource` class).
 
 @discussion Convert incoming `NSExtensionItem` instances retrieved from an extension context into `XExtensionItem` 
 instances:
 
 ```objc
 for (NSExtensionItem *inputItem in self.extensionContext.inputItems) {
    XExtensionItem *extensionItem = [[XExtensionItem alloc] initWithExtensionItem:inputItem];
    NSAttributedString *title = extensionItem.attributedTitle;
    NSAttributedString *contentText = extensionItem.attributedContentText;
    NSArray *tags = extensionItem.tags;
    NSString *customTumblrURL = extensionItem.userInfo[@"tumblr-custom-url"];
 }
 ```
 */
@interface XExtensionItem : NSObject

/**
 @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSArray/*<NSItemProvider>*/ *attachments;

/**
 @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSString *title;

/**
 @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSAttributedString *attributedContentText;

/**
 @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSArray/*<NSString>*/ *tags;

/**
 @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSURL *sourceURL;

/**
 @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) XExtensionItemReferrer *referrer;

/**
 @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSDictionary *userInfo;

/**
 Inialize a new instance with an incoming `NSExtensionItem` from the share extension’s extension context.
 
 @param extensionItem Extension item retrieved from the share extension’s extension context.
 
 @return New instance populated with values from the extension item.
 */
- (instancetype)initWithExtensionItem:(NSExtensionItem *)extensionItem NS_DESIGNATED_INITIALIZER;

@end
