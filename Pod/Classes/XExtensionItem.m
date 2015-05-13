#import "XExtensionItem.h"
#import "XExtensionItemReferrer.h"
#import "XExtensionItemTypeSafeDictionaryValues.h"
#import <MobileCoreServices/MobileCoreServices.h>

static NSString * const ParameterKeyXExtensionItem = @"x-extension-item";
static NSString * const ParameterKeySourceURL = @"source-url";
static NSString * const ParameterKeyTags = @"tags";
static NSString * const ActivityTypeCatchAll = @"*";

@interface XExtensionItemSource ()

@property (nonatomic) id placeholderItem;
@property (nonatomic, copy) XExtensionItemProvidingBlock activityItemBlock;
@property (nonatomic, copy) NSString *typeIdentifier;

@property (nonatomic) NSMutableDictionary *additionalAttachmentsByActivityType;
@property (nonatomic) NSMutableDictionary *attributedContentTextByActivityType;
@property (nonatomic) NSMutableDictionary *customParameters;

@end

@implementation XExtensionItemSource

#pragma mark - Initialization

- (instancetype)initWithPlaceholderItem:(id)placeholderItem typeIdentifier:(NSString *)typeIdentifier itemBlock:(XExtensionItemProvidingBlock)activityItemBlock {
    NSParameterAssert(placeholderItem);
    
    self = [super init];
    if (self) {
        _placeholderItem = placeholderItem;
        _activityItemBlock = [activityItemBlock copy];
        
        _typeIdentifier = ^{
            if (typeIdentifier) {
                return [typeIdentifier copy];
            }
            else {
                return [typeIdentifierForActivityItem(placeholderItem) copy];
            }
        }();
        
        _additionalAttachmentsByActivityType = [[NSMutableDictionary alloc] init];
        _attributedContentTextByActivityType = [[NSMutableDictionary alloc] init];
        _customParameters = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithPlaceholderItem:URL
                          typeIdentifier:nil // This will be either `kUTTypeURL` or, if a file URL, derived from the file on disk
                               itemBlock:nil];
}

- (instancetype)initWithText:(NSString *)text {
    return [self initWithPlaceholderItem:text
                          typeIdentifier:(NSString *)kUTTypePlainText
                               itemBlock:nil];
}

- (instancetype)initWithImage:(UIImage *)image {
    return [self initWithPlaceholderItem:image
                          typeIdentifier:(NSString *)kUTTypeImage
                               itemBlock:nil];
}

- (instancetype)initWithData:(NSData *)data typeIdentifier:(NSString *)typeIdentifier {
    NSParameterAssert(typeIdentifier);
    
    return [self initWithPlaceholderItem:data
                          typeIdentifier:typeIdentifier
                               itemBlock:nil];
}

- (instancetype)init {
    return [self initWithPlaceholderItem:nil
                          typeIdentifier:nil
                               itemBlock:nil];
}

#pragma mark - XExtensionItemSource

- (void)addCustomParameters:(id<XExtensionItemCustomParameters>)customParameters {
    [self.customParameters addEntriesFromDictionary:customParameters.dictionaryRepresentation];
}

- (void)setAttributedContentText:(NSAttributedString *)attributedContentText {
    [self setAttributedContentText:attributedContentText forActivityType:nil];
}

- (NSAttributedString *)attributedContentText {
    return [self attributedContentTextForActivityType:nil];
}

- (void)setAttributedContentText:(NSAttributedString *)attributedContentText forActivityType:(NSString *)activityType {
    activityType = activityType ?: ActivityTypeCatchAll;
    
    if (attributedContentText) {
        self.attributedContentTextByActivityType[activityType] = attributedContentText;
    }
    else {
        [self.attributedContentTextByActivityType removeObjectForKey:activityType];
    }
}

- (void)setAdditionalAttachments:(NSArray *)attachments {
    [self setAdditionalAttachments:attachments forActivityType:nil];
}

- (NSArray *)additionalAttachments {
    return [self additionalAttachmentsForActivityType:nil];
}

- (void)setAdditionalAttachments:(NSArray *)attachments forActivityType:(NSString *)activityType {
    activityType = activityType ?: ActivityTypeCatchAll;
    
    if (attachments) {
        self.additionalAttachmentsByActivityType[activityType] = attachments;
    }
    else {
        [self.additionalAttachmentsByActivityType removeObjectForKey:activityType];
    }
}

#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return self.placeholderItem;
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    return self.title;
}

- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size {
    XExtensionItemThumbnailProvidingBlock thumbnailBlock = self.thumbnailProvider;
    
    if (thumbnailBlock) {
        return thumbnailBlock(size, activityType);
    }
    else {
        return nil;
    }
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController dataTypeIdentifierForActivityType:(NSString *)activityType {
    return self.typeIdentifier;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    if (isExtensionItemInputAcceptedByActivityType(activityType)) {
        /*
         Share extensions take `NSExtensionItem` instances as input, and *some* system activities do as well, but some 
         do not. Unfortunately we need to maintain a hardcoded list of which system activities we can pass extension 
         items to.
         
         Trying to pass an extension item into a system activity that doesn’t know how to process it will result in no 
         data making it’s way through. In these cases, we’ll pass the placeholder item that this instance was 
         initialized with instead.
         */
        
        NSExtensionItem *item = [[NSExtensionItem alloc] init];
        item.userInfo = ({
            NSMutableDictionary *mutableUserInfo = [[NSMutableDictionary alloc] init];
            [mutableUserInfo addEntriesFromDictionary:self.customParameters];
            [mutableUserInfo addEntriesFromDictionary:self.userInfo];
            
            NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
            [mutableParameters setValue:self.tags forKey:ParameterKeyTags];
            [mutableParameters setValue:self.sourceURL forKey:ParameterKeySourceURL];
            [mutableParameters addEntriesFromDictionary:self.referrer.dictionaryRepresentation];
            
            if (mutableParameters.count > 0) {
                mutableUserInfo[ParameterKeyXExtensionItem] = [mutableParameters copy];
            }
            
            mutableUserInfo;
        });
        
        /*
         The `userInfo` setter *must* be called before the following three setters, which merely provide syntactic sugar for
         populating the `userInfo` dictionary with the following keys:
         
         * `NSExtensionItemAttributedTitleKey`,
         * `NSExtensionItemAttributedContentTextKey`
         * `NSExtensionItemAttachmentsKey`.
         
         */
            
        item.attachments = ({
            id activityItem = [self activityItemForActivityType:activityType];
            
            NSItemProvider *mainAttachment = [[NSItemProvider alloc] initWithItem:activityItem typeIdentifier:self.typeIdentifier];
            
            if (self.thumbnailProvider) {
                mainAttachment.previewImageHandler = ^(NSItemProviderCompletionHandler completionHandler, Class expectedValueClass, NSDictionary *options) {
                    CGSize preferredImageSize = [[options objectForKey:NSItemProviderPreferredImageSizeKey] CGSizeValue];
                    UIImage *thumbnail = self.thumbnailProvider(preferredImageSize, activityType);
                    completionHandler(thumbnail, nil);
                };
            }
            
            NSMutableArray *attachments = [[NSMutableArray alloc] initWithObjects:mainAttachment, nil];

            for (id attachmentItem in [self additionalAttachmentsForActivityType:activityType]) {
                if ([attachmentItem isKindOfClass:[NSItemProvider class]]) {
                    [attachments addObject:attachmentItem];
                }
                else {
                    NSString *typeIdentifier = typeIdentifierForActivityItem(attachmentItem);
                    
                    if (typeIdentifier) {
                        NSItemProvider *attachmentProvider = [[NSItemProvider alloc] initWithItem:attachmentItem typeIdentifier:typeIdentifier];
                        [attachments addObject:attachmentProvider];
                    }
                }
            }
            
            attachments;
        });
        
        item.attributedContentText = [self attributedContentTextForActivityType:activityType];
        
        if (self.title) {
            item.attributedTitle = [[NSAttributedString alloc] initWithString:self.title];
        }
        
        return item;
    }
    else {
        return [self activityItemForActivityType:activityType];
    }
}

#pragma mark - Private

- (id)activityItemForActivityType:(NSString *)activityType {
    if (self.activityItemBlock) {
        return self.activityItemBlock(activityType);
    }
    else {
        return self.placeholderItem;
    }
}

- (NSAttributedString *)attributedContentTextForActivityType:(NSString *)activityType {
    return self.attributedContentTextByActivityType[activityType ?: ActivityTypeCatchAll];
}

- (NSArray *)additionalAttachmentsForActivityType:(NSString *)activityType {
    return self.additionalAttachmentsByActivityType[activityType ?: ActivityTypeCatchAll];
}

static NSString *typeIdentifierForActivityItem(id item) {
    if ([item isKindOfClass:[NSURL class]]) {
        NSURL *URL = (NSURL *)item;
        
        if (URL.isFileURL) {
            NSString *typeIdentifier = nil;
            [item getResourceValue:&typeIdentifier forKey:NSURLTypeIdentifierKey error:nil];
            return typeIdentifier;
        }
        
        return (NSString *)kUTTypeURL;
    }
    else if ([item isKindOfClass:[NSString class]]) {
        return (NSString *)kUTTypePlainText;
    }
    else if ([item isKindOfClass:[UIImage class]]) {
        return (NSString *)kUTTypeImage;
    }
    else {
        return nil;
    }
}

static BOOL isExtensionItemInputAcceptedByActivityType(NSString *activityType) {
    if (![NSExtensionItem class])
        return NO;
    
    NSSet *unacceptingTypes = [[NSSet alloc] initWithArray:@[
                                                             UIActivityTypeMessage,
                                                             UIActivityTypeMail,
                                                             UIActivityTypePrint,
                                                             UIActivityTypeCopyToPasteboard,
                                                             UIActivityTypeAssignToContact,
                                                             UIActivityTypeSaveToCameraRoll,
                                                             UIActivityTypeAddToReadingList,
                                                             UIActivityTypeAirDrop,
                                                             ]];
    
    /*
     The following activities are capable of taking `NSExtensionItem` instances as input. They display system share 
     sheets that consume the extension item’s `attributedContentText` value.
     */
    NSSet *acceptingTypes = [[NSSet alloc] initWithArray:@[
                                                           UIActivityTypePostToTwitter,
                                                           UIActivityTypePostToVimeo,
                                                           UIActivityTypePostToWeibo,
                                                           UIActivityTypePostToTencentWeibo,
                                                           
                                                           /*
                                                            If the official Facebook or Flickr apps are installed, they 
                                                            take precedent over the system sheets and do *not* consume 
                                                            `attributedContentText`.
                                                            */
                                                           UIActivityTypePostToFacebook,
                                                           UIActivityTypePostToFlickr,
                                                           ]];
    
    if ([unacceptingTypes containsObject:activityType]) {
        return NO;
    }
    else if ([acceptingTypes containsObject:activityType]) {
        return YES;
    }
    else {
        return YES;
    }
}

@end

@implementation XExtensionItemSource (ProviderBlockInitializers)

- (instancetype)initWithURLProvider:(XExtensionItemURLProvidingBlock)URLProvider {
    NSParameterAssert(URLProvider);
    
    return [self initWithPlaceholderItem:[NSURL URLWithString:@"http://example.com"]
                          typeIdentifier:(NSString *)kUTTypeURL
                               itemBlock:URLProvider];
}

- (instancetype)initWithFileURLProvider:(XExtensionItemURLProvidingBlock)fileURLProvider typeIdentifier:(NSString *)typeIdentifier {
    NSParameterAssert(fileURLProvider);
    NSParameterAssert(typeIdentifier);
    
    return [self initWithPlaceholderItem:[NSURL fileURLWithPath:@"/"]
                          typeIdentifier:typeIdentifier
                               itemBlock:fileURLProvider];
}

- (instancetype)initWithTextProvider:(XExtensionItemStringProvidingBlock)textProvider {
    NSParameterAssert(textProvider);
    
    return [self initWithPlaceholderItem:[[NSString alloc] init]
                          typeIdentifier:(NSString *)kUTTypePlainText
                               itemBlock:textProvider];
}

- (instancetype)initWithImageProvider:(XExtensionItemImageProvidingBlock)imageProvider {
    NSParameterAssert(imageProvider);
    
    return [self initWithPlaceholderItem:[[UIImage alloc] init]
                          typeIdentifier:(NSString *)kUTTypeImage
                               itemBlock:imageProvider];
}

- (instancetype)initWithDataProvider:(XExtensionItemDataProvidingBlock)dataProvider typeIdentifier:(NSString *)typeIdentifier {
    NSParameterAssert(dataProvider);
    NSParameterAssert(typeIdentifier);
    
    return [self initWithPlaceholderItem:[[NSData alloc] init]
                          typeIdentifier:typeIdentifier
                               itemBlock:dataProvider];
}

@end

@interface XExtensionItem ()

@property (nonatomic) NSExtensionItem *extensionItem;
@property (nonatomic) NSExtensionItem *item;

@end

@implementation XExtensionItem

#pragma mark - Initialization

- (instancetype)initWithExtensionItem:(NSExtensionItem *)extensionItem {
    NSParameterAssert(extensionItem);
    
    self = [super init];
    if (self) {
        _extensionItem = extensionItem;
        
        NSDictionary *dictionary = [[[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:extensionItem.userInfo]
                                    dictionaryForKey:ParameterKeyXExtensionItem];
        
        XExtensionItemTypeSafeDictionaryValues *dictionaryValues = [[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:dictionary];
        
        _tags = [[dictionaryValues arrayForKey:ParameterKeyTags] copy];
        _sourceURL = [[dictionaryValues URLForKey:ParameterKeySourceURL] copy];
        _referrer = [[XExtensionItemReferrer alloc] initWithDictionary:dictionary];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithExtensionItem:nil];
}

#pragma mark - Proxied NSExtensionItem getters

- (NSArray *)attachments {
    return self.extensionItem.attachments;
}

- (NSString *)title {
    return self.extensionItem.attributedTitle.string;
}

- (NSAttributedString *)attributedContentText {
    return self.extensionItem.attributedContentText;
}

- (NSDictionary *)userInfo {
    return self.extensionItem.userInfo;
}

#pragma mark - NSObject

- (NSString *)description {
    NSMutableString *mutableDescription = [[NSMutableString alloc] initWithFormat:@"%@ { attachments: %@",
                                           [super description], self.attachments];
    
    if (self.title) {
        [mutableDescription appendFormat:@", title: %@", self.title];
    }
    
    if (self.attributedContentText) {
        [mutableDescription appendFormat:@", attributedContentText: %@", self.attributedContentText];
    }
    
    if (self.tags) {
        [mutableDescription appendFormat:@", tags: %@", self.tags];
    }
    
    if (self.sourceURL) {
        [mutableDescription appendFormat:@", sourceURL: %@", self.sourceURL];
    }
    
    if (self.referrer) {
        [mutableDescription appendFormat:@", sourceApplication: %@", self.referrer];
    }
    
    if (self.userInfo) {
        [mutableDescription appendFormat:@", userInfo: %@", ({
            NSMutableDictionary *mutableUserInfo = [self.userInfo mutableCopy];
            
            for (NSString *key in @[NSExtensionItemAttributedTitleKey, NSExtensionItemAttributedContentTextKey, NSExtensionItemAttachmentsKey]) {
                [mutableUserInfo removeObjectForKey:key];
            }
            
            // Remove values used internally by this class
            [mutableUserInfo removeObjectForKey:ParameterKeyXExtensionItem];
            
            [mutableUserInfo copy];
        })];
    }
    
    [mutableDescription appendFormat:@" }"];
    
    return [mutableDescription copy];
}

@end
