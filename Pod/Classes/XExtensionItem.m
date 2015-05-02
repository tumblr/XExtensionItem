#import "XExtensionItem.h"
#import "XExtensionItemReferrer.h"
#import "XExtensionItemTypeSafeDictionaryValues.h"

static NSString * const ParameterKeyXExtensionItem = @"x-extension-item";
static NSString * const ParameterKeySourceURL = @"source-url";
static NSString * const ParameterKeyTags = @"tags";

@interface XExtensionItemSource ()

@property (nonatomic) id placeholderItem;
@property (nonatomic) NSArray *attachments;

@property (nonatomic) NSMutableDictionary *activityTypesToItemProviderBlocks;
@property (nonatomic) NSMutableDictionary *activityTypesToSubjects;
@property (nonatomic) NSMutableDictionary *activityTypesToThumbnailProviderBlocks;

@end

@implementation XExtensionItemSource

#pragma mark - Initialization

- (instancetype)initWithPlaceholderItem:(id)placeholderItem attachments:(NSArray *)attachments {
    NSParameterAssert(placeholderItem);
    NSParameterAssert(attachments);
    
    self = [super init];
    if (self) {
        _placeholderItem = placeholderItem;
        _attachments = [attachments copy];
        
        _activityTypesToItemProviderBlocks = [[NSMutableDictionary alloc] init];
        _activityTypesToSubjects = [[NSMutableDictionary alloc] init];
        _activityTypesToThumbnailProviderBlocks = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithPlaceholderItem:nil attachments:nil];
}

#pragma mark - XExtensionItemSource

- (void)addEntriesToUserInfo:(id <XExtensionItemDictionarySerializing>)dictionarySerializable {
    self.userInfo = ({
        NSMutableDictionary *mutableUserInfo = [[NSMutableDictionary alloc] initWithDictionary:self.userInfo];
        [mutableUserInfo addEntriesFromDictionary:dictionarySerializable.dictionaryRepresentation];
        mutableUserInfo;
    });
}

- (void)registerItemProvider:(XExtensionItemProvider)itemProvider forActivityType:(NSString *)activityType {
    NSParameterAssert(itemProvider);
    NSParameterAssert(activityType);
    
    if (activityType && itemProvider) {
        self.activityTypesToItemProviderBlocks[activityType] = itemProvider;
    }
}

- (void)registerSubject:(NSString *)subject forActivityType:(NSString *)activityType {
    NSParameterAssert(subject);
    NSParameterAssert(activityType);
    
    if (activityType && subject) {
        self.activityTypesToSubjects[activityType] = subject;
    }
}

- (void)registerThumbnailProvider:(XExtensionItemThumbnailProvider)thumbnailProvider forActivityType:(NSString *)activityType {
    NSParameterAssert(thumbnailProvider);
    NSParameterAssert(activityType);
    
    if (activityType && thumbnailProvider) {
        self.activityTypesToThumbnailProviderBlocks[activityType] = thumbnailProvider;
    }
}

#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return self.placeholderItem;
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController
              subjectForActivityType:(NSString *)activityType {
    return self.activityTypesToSubjects[activityType];
}

- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController
      thumbnailImageForActivityType:(NSString *)activityType
                      suggestedSize:(CGSize)size {
    XExtensionItemThumbnailProvider provider = self.activityTypesToThumbnailProviderBlocks[activityType];
    
    if (provider) {
        return provider(size);
    }
    else {
        return nil;
    }
}

- (id)activityViewController:(UIActivityViewController *)activityViewController
         itemForActivityType:(NSString *)activityType {
    XExtensionItemProvider itemProvider = self.activityTypesToItemProviderBlocks[activityType];
    
    if (itemProvider) {
        return itemProvider();
    }
    else {
        return self.extensionItemRepresentation;
    }
}

#pragma mark - Private

- (NSExtensionItem *)extensionItemRepresentation {
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.userInfo = ({
        NSMutableDictionary *mutableUserInfo = [[NSMutableDictionary alloc] init];
        [mutableUserInfo addEntriesFromDictionary:self.userInfo];
        
        NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
        [mutableParameters setValue:self.tags forKey:ParameterKeyTags];
        [mutableParameters setValue:self.sourceURL forKey:ParameterKeySourceURL];
        [mutableParameters addEntriesFromDictionary:self.referrer.dictionaryRepresentation];
        
        if ([mutableParameters count] > 0) {
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
    item.attachments = self.attachments;
    item.attributedTitle = self.attributedTitle;
    item.attributedContentText = self.attributedContentText;
    
    return item;
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

- (NSAttributedString *)attributedTitle {
    return self.extensionItem.attributedTitle;
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
    
    if (self.attributedTitle) {
        [mutableDescription appendFormat:@", attributedTitle: %@", self.attributedTitle];
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
