@class XExtensionItemMutableParameters;
@class XExtensionItemSourceApplication;

/**
 A data structure aimed at making it easier for developers to pass well-defined data structures from iOS applications
 into iOS 8 extensions. `XExtensionItemParameters` instances can be used by:
 
 A) Application developers who want to pass more than a single data type into share extensions.
 
 B) Extension developers who want to consume different types of data that a share extension may pass to them.
 
 @discussion App developers with numerous types of data to share may be inclined to add instances of classes like
 `NSURL`, `NSString`, or `UIImage` to their `UIActivityViewController`s' extension item arrays. This is problematic 
 because only extensions that explicitly accept *all* of the provided item types will be displayed in the controller.
 
 A better way to provide extensions with as much data as possible is to configure `UIActivityViewController` with a
 single `NSExtensionItem` instance, with metadata added to its `userInfo` dictionary. This can be done manually, but
 `XExtensionItemParameters` aids this process by:
 
 A) Providing accessors for broadly useful metadata, such as tags, a source URL, and different representations of the
    content being shared (keyed off of UTI). Apps and extensions should be able to output and input these values 
    without knowing the implementation details of the app/extension on the other side of the handshake.
 
 B) Making it easier to use the `NSExtensionItem` API. The `userInfo` dictionary actually backs the rest of an
    extension item's properties, which can lead to subtle bugs if `NSExtensionItem` setters are called in the wrong 
    order.
 
 ## Application developers
 
 Application developers can use an `XExtensionItemParameters` object when presenting a `UIActivityViewController`:
 
 ```objc
 XExtensionItemMutableParameters *parameters = [[XExtensionItemMutableParameters alloc] init];
 parameters.attachments = @[[[XExtensionItemAttachment alloc] initWithItem:[NSURL URLWithString:@"http://apple.com"]
                                                            typeIdentifier:(__bridge NSString *)kUTTypeURL]];
 parameters.attributedTitle = [[NSAttributedString alloc] initWithString:@"Apple"];
 parameters.attributedContentText = [[NSAttributedString alloc] initWithString:@"iPad Air 2. Change is in the air"];
 
 UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[parameters extensionItemRepresentation]
                                                                          applicationActivities:nil];
 ```
 
 ## Extension developers
 
 Convert incoming `NSExtensionItem` instances retrieved from an extension context into `XExtensionItemParameters`
 objects:
 
 ```objc
 for (NSExtensionItem *item in self.extensionContext.inputItems) {
     XExtensionItemParameters *parameters = [XExtensionItemParameters parametersFromExtensionItem:item];
     NSAttributedString *title = parameters.attributedTitle;
     NSAttributedString *contentText = parameters.attributedContentText;
     NSArray *tags = parameters.tags;
     NSString *customTumblrURL = parameters.userInfo[@"tumblr-custom-url"];
 }
 ```
 */
@interface XExtensionItemParameters : NSObject <NSCopying, NSMutableCopying, UIActivityItemSource>

@property (nonatomic, readonly) id placeholderItem;

/**
 An optional title for the item.
 
 @see `NSExtensionItem`
 */
@property (nonatomic, readonly) NSAttributedString *attributedTitle;

/**
 An optional string describing the extension item content.
 
 @see `NSExtensionItem`
 */
@property (nonatomic, readonly) NSAttributedString *attributedContentText;

/**
 An optional array of media data associated with the extension item. These items must be of type `NSItemProvider`
 
 @see `NSItemProvider`
 */
@property (nonatomic, readonly) NSArray *attachments;

/**
 An optional array of tag metadata, like on Twitter/Instagram/Tumblr.
 */
@property (nonatomic, readonly) NSArray *tags;

/**
 An optional URL specifying the source of the attachment data. If the attachment is an image, or a text excerpt, this 
 source URL might specify where that content could be found on the Internet.
 */
@property (nonatomic, readonly) NSURL *sourceURL;

/**
 An optional object specifying information about the application that is sharing this extension item.
 
 @see `XExtensionItemSourceApplication`
 */
@property (nonatomic, readonly) XExtensionItemSourceApplication *sourceApplication;

/**
 An optional dictionary of keys and values. Individual applications can add advertise whatever custom parameters they
 support, and extension developers can add values for those parameters in this dictionary.
 
 Custom user info keys should *not* start with `x-extension-item`, as those will be used internally by this library.
 */
@property (nonatomic, readonly) NSDictionary *userInfo;

#pragma mark - Initialization

/**
 For use in share extensions: convert an incoming `NSExtensionItem` into an `XExtensionItemParameters` instance.
 
 @param extensionItem Extension item retrieved from the share extension’s extension context.
 
 @return New parameters instance populated with values from the extension item.
 */
- (instancetype)initWithExtensionItem:(NSExtensionItem *)extensionItem;

/**
 For use in applications: create an immutable `XExtensionItemParameters` instance by configuring a mutable instance 
 passed into a configuration block.
 
 @param initializationBlock Block to be called with a mutable parameters instance to be configured.
 
 @return New parameters instance populated with values from the mutable instance.
 */
- (instancetype)initWithBlock:(void (^)(XExtensionItemMutableParameters *))initializationBlock;

/**
 For use in applications: create an immutable `XExtensionItemParameters` instance. Documentation for the arguments
 can be found on each of this class’s properties.
 
 Immutable `XExtensionItemParameters` instances can also be created by copying an `XExtensionItemMutableParameters`
 instance or by using the block-based convenience initializer.

 @param placeholderItem                    (Required) See `placeholderItem` property
 @param attributedTitle                    (Optional) See `attributedTitle` property
 @param attributedContentText              (Optional) See `attributedContentText` property
 @param attachments                        (Optional) See `attachments` property
 @param tags                               (Optional) See `tags` property
 @param sourceURL                          (Optional) See `sourceURL` property
 @param sourceApplication                  (Optional) See `sourceApplication` property
 @param userInfo                           (Optional) See `userInfo` property
 
 @return New parameters instance.
 */
- (instancetype)initWithPlaceholderItem:(id)placeholderItem
                        attributedTitle:(NSAttributedString *)attributedTitle
                  attributedContentText:(NSAttributedString *)attributedContentText
                            attachments:(NSArray *)attachments
                                   tags:(NSArray *)tags
                              sourceURL:(NSURL *)sourceURL
                      sourceApplication:(XExtensionItemSourceApplication *)sourceApplication
                               userInfo:(NSDictionary *)userInfo;

@end
