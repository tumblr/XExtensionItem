#import "XExtensionItemMutableParameters.h"
#import "XExtensionItemParameters.h"
#import "XExtensionItemSourceApplication.h"
#import "XExtensionItemTypeSafeDictionaryValues.h"

static NSString * const ParameterKeyXExtensionItem = @"x-extension-item";
static NSString * const ParameterKeyImageURL = @"image-url";
static NSString * const ParameterKeyLocation = @"location";
static NSString * const ParameterKeyUTIsToContentRepresentations = @"utis-to-content-representations";
static NSString * const ParameterKeySourceURL = @"source-url";
static NSString * const ParameterKeyTags = @"tags";

@implementation XExtensionItemParameters

#pragma mark - Initialization

- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle
                  attributedContentText:(NSAttributedString *)attributedContentText
                            attachments:(NSArray *)attachments
                                   tags:(NSArray *)tags
                              sourceURL:(NSURL *)sourceURL
                               imageURL:(NSURL *)imageURL
                               location:(CLLocation *)location
                      sourceApplication:(XExtensionItemSourceApplication *)sourceApplication
           UTIsToContentRepresentations:(NSDictionary *)UTIsToContentRepresentations
                               userInfo:(NSDictionary *)userInfo {
    if (self = [super init]) {
        _attributedTitle = [attributedTitle copy];
        _attributedContentText = [attributedContentText copy];
        _attachments = [attachments copy];
        _tags = [tags copy];
        _sourceURL = [sourceURL copy];
        _imageURL = [imageURL copy];
        _location = [location copy];
        _sourceApplication = sourceApplication;
        _UTIsToContentRepresentations = [UTIsToContentRepresentations copy];
        _userInfo = [userInfo copy];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithAttributedTitle:nil
                   attributedContentText:nil
                             attachments:nil
                                    tags:nil
                               sourceURL:nil
                                imageURL:nil
                                location:nil
                       sourceApplication:nil
            UTIsToContentRepresentations:nil
                                userInfo:nil];
}

#pragma mark - NSExtensionItem conversion

- (instancetype)initWithExtensionItem:(NSExtensionItem *)extensionItem {
    NSDictionary *parameterDictionary = [[[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:extensionItem.userInfo]
                                         dictionaryForKey:ParameterKeyXExtensionItem];
    
    XExtensionItemTypeSafeDictionaryValues *parameters = [[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:parameterDictionary];

    XExtensionItemSourceApplication *sourceApplication = [[XExtensionItemSourceApplication alloc] initWithDictionary:parameterDictionary];
    
    return [self initWithAttributedTitle:extensionItem.attributedTitle
                   attributedContentText:extensionItem.attributedContentText
                             attachments:extensionItem.attachments
                                    tags:[parameters arrayForKey:ParameterKeyTags]
                               sourceURL:[parameters URLForKey:ParameterKeySourceURL]
                                imageURL:[parameters URLForKey:ParameterKeyImageURL]
                                location:^CLLocation *{
                                    NSData *data = [parameters dataForKey:ParameterKeyLocation];
                                    
                                    if (data) {
                                        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
                                    }
                                    else {
                                        return nil;
                                    }
                                }()
                       sourceApplication:sourceApplication
            UTIsToContentRepresentations:[parameters dictionaryForKey:ParameterKeyUTIsToContentRepresentations]
                                userInfo:extensionItem.userInfo];
}

- (NSExtensionItem *)extensionItemRepresentation {
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.userInfo = ({
        NSMutableDictionary *mutableUserInfo = [[NSMutableDictionary alloc] init];
        [mutableUserInfo addEntriesFromDictionary:self.userInfo];
        
        NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
        [mutableParameters setValue:self.tags forKey:ParameterKeyTags];
        [mutableParameters setValue:self.sourceURL forKey:ParameterKeySourceURL];
        [mutableParameters setValue:self.imageURL forKey:ParameterKeyImageURL];
        [mutableParameters setValue:self.UTIsToContentRepresentations forKey:ParameterKeyUTIsToContentRepresentations];
        [mutableParameters setValue:[NSKeyedArchiver archivedDataWithRootObject:self.location] forKey:ParameterKeyLocation];
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
    
    if (self.imageURL) {
        [mutableDescription appendFormat:@", imageURL: %@", self.imageURL];
    }

    if (self.location) {
        [mutableDescription appendFormat:@", location: %@", self.location];
    }
    
    if (self.sourceApplication) {
        [mutableDescription appendFormat:@", sourceApplication: %@", self.sourceApplication];
    }
    
    if (self.UTIsToContentRepresentations) {
        [mutableDescription appendFormat:@", UTIsToContentRepresentations: %@", self.UTIsToContentRepresentations];
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
    return [[XExtensionItemMutableParameters alloc] initWithAttributedTitle:self.attributedTitle
                                                      attributedContentText:self.attributedContentText
                                                                attachments:self.attachments
                                                                       tags:self.tags
                                                                  sourceURL:self.sourceURL
                                                                   imageURL:self.imageURL
                                                                   location:self.location
                                                          sourceApplication:self.sourceApplication
                                               UTIsToContentRepresentations:self.UTIsToContentRepresentations
                                                                   userInfo:self.userInfo];
}

@end
