#import "XExtensionItemParameters.h"
@protocol XExtensionItemDictionarySerializing;

/**
 Mutable `XExtensionItemParameters` variant.
 
 @see `XExtensionItemParameters`
 */
@interface XExtensionItemMutableParameters : XExtensionItemParameters <NSCopying>

@property (nonatomic) id placeholderItem;
@property (nonatomic, copy) NSAttributedString *attributedTitle;
@property (nonatomic, copy) NSAttributedString *attributedContentText;
@property (nonatomic, copy) NSArray *attachments;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSURL *sourceURL;
@property (nonatomic, copy) XExtensionItemSourceApplication *sourceApplication;
@property (nonatomic, copy) NSDictionary *userInfo;

/**
 Add entries from a dictionary-serializable custom object to this paramter object’s `userInfo` dictionary.
 
 @param dictionarySerializable Object whose entries should be added to this paramter object’s `userInfo` dictionary.
 */
- (void)addEntriesToUserInfo:(id <XExtensionItemDictionarySerializing>)dictionarySerializable;

@end
