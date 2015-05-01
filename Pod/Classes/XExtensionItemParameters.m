#import "XExtensionItemMutableParameters.h"
#import "XExtensionItemParameters.h"
#import "XExtensionItemSourceApplication.h"
#import "XExtensionItemTypeSafeDictionaryValues.h"

static NSString * const ParameterKeyXExtensionItem = @"x-extension-item";
static NSString * const ParameterKeySourceURL = @"source-url";
static NSString * const ParameterKeyTags = @"tags";

@implementation XExtensionItemParameters

#pragma mark - Public initializers

- (instancetype)initWithPlaceholderItem:(id)placeholderItem
                        attributedTitle:(NSAttributedString *)attributedTitle
                  attributedContentText:(NSAttributedString *)attributedContentText
                            attachments:(NSArray *)attachments
                                   tags:(NSArray *)tags
                              sourceURL:(NSURL *)sourceURL
                      sourceApplication:(XExtensionItemSourceApplication *)sourceApplication
                               userInfo:(NSDictionary *)userInfo {
    NSParameterAssert(placeholderItem);
    
    self = [self initWithAttributedTitle:attributedTitle
                   attributedContentText:attributedContentText
                             attachments:attachments
                                    tags:tags
                               sourceURL:sourceURL
                       sourceApplication:sourceApplication
                                userInfo:userInfo];
    if (self) {
        _placeholderItem = placeholderItem;
        
    }
    
    return self;
}

- (instancetype)initWithBlock:(void (^)(XExtensionItemMutableParameters *))initializationBlock {
    NSParameterAssert(initializationBlock);
    
    XExtensionItemMutableParameters *parameters = [[XExtensionItemMutableParameters alloc] init];
    
    if (initializationBlock) {
        initializationBlock(parameters);
    }
    
    return [self initWithPlaceholderItem:parameters.placeholderItem
                         attributedTitle:parameters.attributedTitle
                   attributedContentText:parameters.attributedContentText
                             attachments:parameters.attachments
                                    tags:parameters.tags
                               sourceURL:parameters.sourceURL
                       sourceApplication:parameters.sourceApplication
                                userInfo:parameters.userInfo];
}

- (instancetype)initWithExtensionItem:(NSExtensionItem *)extensionItem {
    NSDictionary *parameterDictionary = [[[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:extensionItem.userInfo]
                                         dictionaryForKey:ParameterKeyXExtensionItem];
    
    XExtensionItemTypeSafeDictionaryValues *dictionaryValues = [[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:parameterDictionary];
    
    XExtensionItemSourceApplication *sourceApplication = [[XExtensionItemSourceApplication alloc] initWithDictionary:parameterDictionary];
    
    return [self initWithAttributedTitle:extensionItem.attributedTitle
                   attributedContentText:extensionItem.attributedContentText
                             attachments:extensionItem.attachments
                                    tags:[dictionaryValues arrayForKey:ParameterKeyTags]
                               sourceURL:[dictionaryValues URLForKey:ParameterKeySourceURL]
                       sourceApplication:sourceApplication
                                userInfo:extensionItem.userInfo];
}

- (instancetype)init {
#warning Someone could call this on the non-mutable version, argh
    return [self initWithAttributedTitle:nil
                   attributedContentText:nil
                             attachments:nil
                                    tags:nil
                               sourceURL:nil
                       sourceApplication:nil
                                userInfo:nil];
}

#pragma mark - Private initializers

- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle
                  attributedContentText:(NSAttributedString *)attributedContentText
                            attachments:(NSArray *)attachments
                                   tags:(NSArray *)tags
                              sourceURL:(NSURL *)sourceURL
                      sourceApplication:(XExtensionItemSourceApplication *)sourceApplication
                               userInfo:(NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        _attributedTitle = [attributedTitle copy];
        _attributedContentText = [attributedContentText copy];
        _attachments = attachments;
        _tags = [tags copy];
        _sourceURL = [sourceURL copy];
        _sourceApplication = sourceApplication;
        _userInfo = [userInfo copy];
    }
    
    return self;
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
    
    if (self.sourceApplication) {
        [mutableDescription appendFormat:@", sourceApplication: %@", self.sourceApplication];
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

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[XExtensionItemMutableParameters alloc] initWithPlaceholderItem:self.placeholderItem
                                                            attributedTitle:self.attributedTitle
                                                      attributedContentText:self.attributedContentText
                                                                attachments:self.attachments
                                                                       tags:self.tags
                                                                  sourceURL:self.sourceURL
                                                          sourceApplication:self.sourceApplication
                                                                   userInfo:self.userInfo];
}

#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return self.placeholderItem;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.userInfo = ({
        NSMutableDictionary *mutableUserInfo = [[NSMutableDictionary alloc] init];
        [mutableUserInfo addEntriesFromDictionary:self.userInfo];
        
        NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
        [mutableParameters setValue:self.tags forKey:ParameterKeyTags];
        [mutableParameters setValue:self.sourceURL forKey:ParameterKeySourceURL];
        [mutableParameters addEntriesFromDictionary:self.sourceApplication.dictionaryRepresentation];
        
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
