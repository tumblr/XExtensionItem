#import "XExtensionItemDictionarySerializing.h"
#import "XExtensionItemMutableParameters.h"
#import "XExtensionItemParameters.h"

@implementation XExtensionItemMutableParameters

@synthesize placeholderItem;
@synthesize attributedTitle;
@synthesize attributedContentText;
@synthesize attachments;
@synthesize tags;
@synthesize sourceURL;
@synthesize sourceApplication;
@synthesize userInfo;

- (void)addEntriesToUserInfo:(id <XExtensionItemDictionarySerializing>)dictionarySerializable {
    self.userInfo = ({
        NSMutableDictionary *mutableUserInfo = [[NSMutableDictionary alloc] initWithDictionary:self.userInfo];
        [mutableUserInfo addEntriesFromDictionary:dictionarySerializable.dictionaryRepresentation];
        mutableUserInfo;
    });
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[XExtensionItemParameters allocWithZone:zone] initWithPlaceholderItem:self.placeholderItem
                                                                  attributedTitle:self.attributedTitle
                                                            attributedContentText:self.attributedContentText
                                                                      attachments:self.attachments
                                                                             tags:self.tags
                                                                        sourceURL:self.sourceURL
                                                                sourceApplication:self.sourceApplication
                                                                         userInfo:self.userInfo];
}

@end
