#import <UIKit/UIKit.h>
#import "XExtensionItemReferrer.h"
#import "XExtensionItemDictionarySerializing.h"

/**
 *  <#Description#>
 *
 *  @param activityType <#activityType description#>
 *
 *  @return <#return value description#>
 */
typedef id (^XExtensionItemProvidingBlock)(NSString *activityType);

/**
 *  <#Description#>
 *
 *  @param suggestedSize <#suggestedSize description#>
 *  @param activityType <#activityType description#>
 *
 *  @return <#return value description#>
 */
typedef UIImage *(^XExtensionItemThumbnailProvidingBlock)(CGSize suggestedSize, NSString *activityType);

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
 An optional title for the item. Also used as the subject for activities that support it (i.e. Mail and Messages)
 
 @see `NSExtensionItem`
 */
@property (nonatomic, copy) NSString *title;

/**
 An optional string describing the item content. In the case of social activities, for example, this text could be
 shared alongside a URL.
 
 Calling this setter is analogous to calling `setAttribuetdContentText:forActivityType:` with a `nil` activity type.
 
 @see `NSExtensionItem`
 */
@property (nonatomic, copy) NSAttributedString *attributedContentText;

/**
 *  <#Description#>
 *
 *  @param attributedContentText <#attributedContentText description#>
 *  @param activityType          <#activityType description#>
 */
- (void)setAttributedContentText:(NSAttributedString *)attributedContentText forActivityType:(NSString *)activityType;

/**
 An array of additional media associated with the extension item. These items must be of type `NSString`, `NSURL`,
 `UIImage`, or `NSItemProvider` and will be passed to the selected activity/extension. For example, you could add
 an image attachment to be shared alongside a URL.
 
 Calling this setter is analogous to calling `setAdditionalAttachments:forActivityType:` with a `nil` activity type.
 
 @see `NSExtensionItem`
 */
@property (nonatomic, copy) NSArray *additionalAttachments;

/**
 *  <#Description#>
 *
 *  @param attachments  <#attachments description#>
 *  @param activityType <#activityType description#>
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
 An optional dictionary of keys and values. Individual applications can add advertise whatever custom parameters they
 support, and extension developers can add values for those parameters in this dictionary.
 
 Custom user info keys should *not* start with `x-extension-item`, as those will be used internally by this library.
 */
@property (nonatomic, copy) NSDictionary *userInfo;

/**
 Add entries from a dictionary-serializable custom object to this paramter object’s `userInfo` dictionary.
 
 @param dictionarySerializable Object whose entries should be added to this paramter object’s `userInfo` dictionary.
 */
- (void)addEntriesToUserInfo:(id <XExtensionItemDictionarySerializing>)dictionarySerializable;

#pragma mark - Initialization

/**
 Initialize an item source from a URL.
 
 @param URL (Required) URL to be shared.
 
 @return New item source instance.
 */
- (instancetype)initWithURL:(NSURL *)URL;

/**
 Initialize an item source from a string.
 
 @param text (Required) Text to be shared.
 
 @return New item source instance.
 */
- (instancetype)initWithText:(NSString *)text;

/**
 Initialize an item source from an image.
 
 @param image (Required) Image to be shared.
 
 @return New item source instance.
 */
- (instancetype)initWithImage:(UIImage *)image;

/**
 Initialize an item source from data.
 
 @param data           (Required) Data to be shared.
 @param typeIdentifier (Required) Type of data.
 
 @return New item source instance.
 */
- (instancetype)initWithData:(NSData *)data typeIdentifier:(NSString *)typeIdentifier;

/**
 Initialize a new instance with a placeholder item, whose type will be used by the activity controller to determine
 which activities and extensions are displayed.
 
 @param placeholderItem (Required) A placeholder item whose type will be used by the activity controller to determine
 which activities and extensions are displayed.
 @param typeIdentifier  (Optional) A uniform type identifier describing the type of content being shared.
 @param itemBlock       (Optional) A block that can provide the item to be shared given the activity type.
 
 @return New item source instance.
 */
- (instancetype)initWithPlaceholderItem:(id)placeholderItem
                         typeIdentifier:(NSString *)typeIdentifier
                              itemBlock:(XExtensionItemProvidingBlock)itemBlock NS_DESIGNATED_INITIALIZER;

@end

/**
 *  A set of convenience initializers that allow items to be provided lazily rather than upfront.
 */
@interface XExtensionItemSource (ProviderBlockInitializers)

typedef NSURL *(^XExtensionItemURLProvidingBlock)(NSString *activityType);

typedef NSString *(^XExtensionItemStringProvidingBlock)(NSString *activityType);

typedef UIImage *(^XExtensionItemImageProvidingBlock)(NSString *activityType);

typedef NSData *(^XExtensionItemDataProvidingBlock)(NSString *activityType);

/**
 *  <#Description#>
 *
 *  @param URLProvider <#URLProvider description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithURLProvider:(XExtensionItemURLProvidingBlock)URLProvider;

/**
 *  <#Description#>
 *
 *  @param fileURL        <#fileURL description#>
 *  @param typeIdentifier <#typeIdentifier description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFileURLProvider:(XExtensionItemURLProvidingBlock)fileURL typeIdentifier:(NSString *)typeIdentifier;

/**
 *  <#Description#>
 *
 *  @param textProvider <#textProvider description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithTextProvider:(XExtensionItemStringProvidingBlock)textProvider;

/**
 *  <#Description#>
 *
 *  @param imageProvider <#imageProvider description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithImageProvider:(XExtensionItemImageProvidingBlock)imageProvider;

/**
 *  <#Description#>
 *
 *  @param dataProvider   <#dataProvider description#>
 *  @param typeIdentifier <#typeIdentifier description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithDataProvider:(XExtensionItemDataProvidingBlock)dataProvider typeIdentifier:(NSString *)typeIdentifier;

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
 *  @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSArray/*<NSItemProvider>*/ *attachments;

/**
 *  @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSAttributedString *attributedTitle;

/**
 *  @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSAttributedString *attributedContentText;

/**
 *  @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSArray/*<NSString>*/ *tags;

/**
 *  @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSURL *sourceURL;

/**
 *  @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) XExtensionItemReferrer *referrer;

/**
 *  @see `XExtensionItemSource`
 */
@property (nonatomic, readonly) NSDictionary *userInfo;

/**
 Inialize a new instance with an incoming `NSExtensionItem` from the share extension’s extension context.
 
 @param extensionItem Extension item retrieved from the share extension’s extension context.
 
 @return New instance populated with values from the extension item.
 */
- (instancetype)initWithExtensionItem:(NSExtensionItem *)extensionItem NS_DESIGNATED_INITIALIZER;

@end
