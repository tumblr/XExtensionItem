#import "XExtensionItemReferrer.h"
#import "XExtensionItemDictionarySerializing.h"

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
typedef id (^XExtensionItemProvidingBlock)();

/**
 *  <#Description#>
 *
 *  @param suggestedSize <#suggestedSize description#>
 *
 *  @return <#return value description#>
 */
typedef UIImage *(^XExtensionItemThumbnailProvidingBlock)(CGSize suggestedSize);

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
 
 XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithPlaceholder:URL
                                                                          attachments:@[
    [[NSItemProvider alloc] initWithItem:URL typeIdentifier:(__bridge NSString *)kUTTypeURL],
    [[NSItemProvider alloc] initWithItem:image typeIdentifier:(__bridge NSString *)kUTTypeImage],
 ]];
 
 itemSource.attributedTitle = [[NSAttributedString alloc] initWithString:@"Tumblr featured on Apple.com!"];
 itemSource.tags = @[@"tumblr", @"featured", @"so cool"];
 
 UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[itemSource]
                                                                          applicationActivities:nil];
 ```
 
 ## Extension developers
 */
@interface XExtensionItemSource : NSObject <UIActivityItemSource>

/**
 An optional title for the item.
 
 @see `NSExtensionItem`
 */
@property (nonatomic, copy) NSAttributedString *attributedTitle;

/**
 An optional string describing the item content.
 
 @see `NSExtensionItem`
 */
@property (nonatomic, copy) NSAttributedString *attributedContentText;

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
 An optional dictionary of keys and values. Individual applications can add advertise whatever custom parameters they
 support, and extension developers can add values for those parameters in this dictionary.
 
 Custom user info keys should *not* start with `x-extension-item`, as those will be used internally by this library.
 */
@property (nonatomic, copy) NSDictionary *userInfo;

/**
 Initialize a new instance with a placeholder item, whose type will be used by the activity controller to determine
 which activities and extensions are displayed, and an array of attachments that will actually be passed to the selected 
 activity/extension.
 
 @param placeholderItem (Required) A placeholder item whose type will be used by the activity controller to determine
 which activities and extensions are displayed. System activities that do not accept `NSExtensionItem` input will 
 receive this placeholder instead.
 @param attachments     An array of media data associated with the extension item. These items must be of
 type `NSItemProvider` and will be passed to the selected activity/extension.
 
 @return New item source instance.
 */
- (instancetype)initWithPlaceholderItem:(id)placeholderItem
                            attachments:(NSArray/*<NSItemProvider>*/ *)attachments NS_DESIGNATED_INITIALIZER;

/**
 Initialize a new instance with placeholder data and a type identifier which will be used by the activity controller to 
 determine which activities and extensions are displayed, and an array of attachments that will actually be passed to 
 the selected activity/extension.
 
 @param placeholderData    (Required) Placeholder data. System activities that do not accept `NSExtensionItem` input
 will receive this placeholder instead.
 @param dataTypeIdentifier (Required) The UTI for the placeholder data.
 @param attachments        An array of media data associated with the extension item. These items must be of
 
 @return New item source instance.
 */
- (instancetype)initWithPlaceholderData:(id)placeholderData
                     dataTypeIdentifier:(NSString *)dataTypeIdentifier
                            attachments:(NSArray/*<NSItemProvider>*/ *)attachments;

/**
 Add entries from a dictionary-serializable custom object to this paramter object’s `userInfo` dictionary.
 
 @param dictionarySerializable Object whose entries should be added to this paramter object’s `userInfo` dictionary.
 */
- (void)addEntriesToUserInfo:(id <XExtensionItemDictionarySerializing>)dictionarySerializable;

/**
 *  Register an item to be provided if a specific activity is selected e.g. `UIActivityTypePostToFacebook`. 
 *  
 *  @discussion By default, this class provides an `NSExtensionItem` that includes all of the attachments passed to this 
 *  instance’s initializer, plus any of this class’s other properties which have been populated. This method should be 
 *  used if you’d like to provide an alternative item on a per-activity basis. 
 *  
 *  A good example usage would be to provide a special HTML string in the event that `UIActivityTypeMail` is selected.
 *
 *  @param itemBlock    (Required) A block that will be called if the activity with the specified type is selected. It
 *  should return the item to be provided to this activity.
 *  @param activityType (Required) The activity type that the subject should be provided to.
 */
- (void)registerItemProvidingBlock:(XExtensionItemProvidingBlock)itemBlock forActivityType:(NSString *)activityType;

/**
 *  Registers a subject for activities that support separate subject and data fields.
 *
 *  @param subject      (Required) A string to use as the contents of the subject field.
 *  @param activityType (Required) The activity type that the subject should be provided to.
 */
- (void)registerSubject:(NSString *)subject forActivityType:(NSString *)activityType;

/**
 *  Registers a thumbnail preview image for activities that support a preview image.
 *
 *  @param thumbnailBlock    (Required) A block that will be called with the suggested size for the thumbnail image, in
 *  points. It should return an image using the appropriate scale for the screen. Images provided at the suggested size 
 *  will result in the best experience.
 *  @param activityType      (Required) The activity type that the subject should be provided to.
 */
- (void)registerThumbnailProvidingBlock:(XExtensionItemThumbnailProvidingBlock)thumbnailBlock forActivityType:(NSString *)activityType;

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
