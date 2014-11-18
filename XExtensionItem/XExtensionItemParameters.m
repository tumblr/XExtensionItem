#import "XExtensionItemParameters.h"
#import "XExtensionItemSourceApplication.h"

static NSString * const XExtensionItemParameterKeyMIMETypesToContentRepresentations = @"x-extension-item-mime-types-to-content-representations";
static NSString * const XExtensionItemParameterKeySourceURL = @"x-extension-item-source-url";
static NSString * const XExtensionItemParameterKeySourceApplicationName = @"x-extension-item-source-application-name";
static NSString * const XExtensionItemParameterKeySourceApplicationStoreURL = @"x-extension-item-source-application-store-url";
static NSString * const XExtensionItemParameterKeySourceApplicationIconURL = @"x-extension-item-source-application-icon-url";
static NSString * const XExtensionItemParameterKeyTags = @"x-extension-item-tags";
static NSString * const XExtensionItemParameterKeyThumbnailURL = @"x-extension-item-thumbnail-url";

@interface XExtensionItemParameters()

@end

@implementation XExtensionItemParameters

#pragma mark - Initialization

- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle
                  attributedContentText:(NSAttributedString *)attributedContentText
                            attachments:(NSArray *)attachments
                                   tags:(NSArray *)tags
                              sourceURL:(NSURL *)sourceURL
                           thumbnailURL:(NSURL *)thumbnailURL
                      sourceApplication:(XExtensionItemSourceApplication *)sourceApplication
      MIMETypesToContentRepresentations:(NSDictionary *)MIMETypesToContentRepresentations
                               userInfo:(NSDictionary *)userInfo {
    if (self = [super init]) {
        _attributedTitle = [attributedTitle copy];
        _attributedContentText = [attributedContentText copy];
        _attachments = [attachments copy];
        _tags = [tags copy];
        _sourceURL = [sourceURL copy];
        _thumbnailURL = [thumbnailURL copy];
        _sourceApplication = sourceApplication;
        _MIMETypesToContentRepresentations = [MIMETypesToContentRepresentations copy];
        _userInfo = [userInfo copy];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithAttributedTitle:nil attributedContentText:nil attachments:nil tags:nil sourceURL:nil
                            thumbnailURL:nil sourceApplication:nil MIMETypesToContentRepresentations:nil userInfo:nil];
}

#pragma mark - NSExtensionItem conversion

+ (instancetype)parametersFromExtensionItem:(NSExtensionItem *)extensionItem {
    XExtensionItemSourceApplication *sourceApplication =
    [[XExtensionItemSourceApplication alloc] initWithAppName:extensionItem.userInfo[XExtensionItemParameterKeySourceApplicationName]
                                                 appStoreURL:extensionItem.userInfo[XExtensionItemParameterKeySourceApplicationStoreURL]
                                                     iconURL:extensionItem.userInfo[XExtensionItemParameterKeySourceApplicationIconURL]];
    
    return [[self alloc] initWithAttributedTitle:extensionItem.attributedTitle
                           attributedContentText:extensionItem.attributedContentText
                                     attachments:extensionItem.attachments
                                            tags:extensionItem.userInfo[XExtensionItemParameterKeyTags]
                                       sourceURL:extensionItem.userInfo[XExtensionItemParameterKeySourceURL]
                                    thumbnailURL:extensionItem.userInfo[XExtensionItemParameterKeyThumbnailURL]
                               sourceApplication:sourceApplication
               MIMETypesToContentRepresentations:extensionItem.userInfo[XExtensionItemParameterKeyMIMETypesToContentRepresentations]
                                        userInfo:extensionItem.userInfo];
}

- (NSExtensionItem *)extensionItemRepresentation {
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.userInfo = ({
        NSMutableDictionary *mutableUserInfo = [[NSMutableDictionary alloc] init];
        [mutableUserInfo addEntriesFromDictionary:self.userInfo];
        
        [mutableUserInfo setValue:self.tags forKey:XExtensionItemParameterKeyTags];
        
        // Source application
        [mutableUserInfo setValue:self.sourceApplication.appName forKey:XExtensionItemParameterKeySourceApplicationName];
        [mutableUserInfo setValue:self.sourceApplication.appStoreURL forKey:XExtensionItemParameterKeySourceApplicationStoreURL];
        [mutableUserInfo setValue:self.sourceApplication.iconURL forKey:XExtensionItemParameterKeySourceApplicationIconURL];
        
        [mutableUserInfo setValue:self.sourceURL forKey:XExtensionItemParameterKeySourceURL];
        [mutableUserInfo setValue:self.thumbnailURL forKey:XExtensionItemParameterKeyThumbnailURL];
        [mutableUserInfo setValue:self.MIMETypesToContentRepresentations forKey:XExtensionItemParameterKeyMIMETypesToContentRepresentations];
        
        [mutableUserInfo copy];
    });
    
    /*
     The `userInfo` setter *must* be called before the following three setters, which merely provide syntactic sugar for
     populating the `userInfo` dictionary with the following keys:
     * `NSExtensionItemAttributedTitleKey`,
     * `NSExtensionItemAttributedContentTextKey`
     * `NSExtensionItemAttributedAttachmentsKey`.
     */
    item.attachments = self.attachments;
    item.attributedTitle = self.attributedTitle;
    item.attributedContentText = self.attributedContentText;
    
    return item;
}

@end
