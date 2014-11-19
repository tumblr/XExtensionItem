#import "XExtensionItemParameters.h"

/**
 *  Mutable `XExtensionItemParameters` variant.
 *
 *  @see `XExtensionItemParameters`
 */
@interface XExtensionItemMutableParameters : XExtensionItemParameters <NSCopying>

@property (nonatomic, copy) NSAttributedString *attributedTitle;
@property (nonatomic, copy) NSAttributedString *attributedContentText;
@property (nonatomic, copy) NSArray *attachments;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSURL *sourceURL;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, copy) XExtensionItemSourceApplication *sourceApplication;
@property (nonatomic, copy) NSDictionary *MIMETypesToContentRepresentations;
@property (nonatomic, copy) NSDictionary *userInfo;

@end
