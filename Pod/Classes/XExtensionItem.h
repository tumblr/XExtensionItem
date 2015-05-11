#import <UIKit/UIKit.h>
#import "XExtensionItemReferrer.h"
#import "XExtensionItemDictionarySerializing.h"

typedef id (^XExtensionItemProvidingBlock)(NSString *activityType);
typedef UIImage *(^XExtensionItemThumbnailProvidingBlock)(CGSize suggestedSize, NSString *activityType);

@interface XExtensionItemSource : NSObject <UIActivityItemSource>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *attributedContentText;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSURL *sourceURL;
@property (nonatomic) XExtensionItemReferrer *referrer;
@property (nonatomic, copy) NSDictionary *userInfo;

- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithData:(NSData *)data ofType:(NSString *)typeIdentifier;

- (instancetype)initWithPlaceholderItem:(id)placeholderItem typeIdentifier:(NSString *)typeIdentifier itemBlock:(XExtensionItemProvidingBlock)itemBlock NS_DESIGNATED_INITIALIZER;

- (void)addEntriesToUserInfo:(id <XExtensionItemDictionarySerializing>)dictionarySerializable;

// Use these methods to add additional attachments to your content. For example, you could add an image attachment to be shared alongside a URL.
// Attachments can be of type NSString, NSURL, UIImage, or NSItemProvider.
- (void)setAttachments:(NSArray *)attachments;
- (void)setAttachments:(NSArray *)attachments forActivityType:(NSString *)activityType;

// Set this if you can provide a thumbnail for this content.
- (void)setThumbnailProvider:(XExtensionItemThumbnailProvidingBlock)thumbnailProvider;

@end

@interface XExtensionItemSource (ProviderBlockInitializers)

- (instancetype)initWithURLProvider:(NSURL *(^)(NSString *activityType))urlProvider;
- (instancetype)initWithFileURLProvider:(NSURL *(^)(NSString *activityType))fileURL ofType:(NSString *)typeIdentifier;
- (instancetype)initWithTextProvider:(NSString *(^)(NSString *activityType))textProvider;
- (instancetype)initWithImageProvider:(UIImage *(^)(NSString *activityType))imageProvider;
- (instancetype)initWithDataProvider:(NSData *(^)(NSString *activityType))dataProvider ofType:(NSString *)typeIdentifier;

@end

@interface XExtensionItem : NSObject

@property (nonatomic, readonly) NSArray/*<NSItemProvider>*/ *attachments;
@property (nonatomic, readonly) NSAttributedString *attributedTitle;
@property (nonatomic, readonly) NSAttributedString *attributedContentText;
@property (nonatomic, readonly) NSArray/*<NSString>*/ *tags;
@property (nonatomic, readonly) NSURL *sourceURL;
@property (nonatomic, readonly) XExtensionItemReferrer *referrer;
@property (nonatomic, readonly) NSDictionary *userInfo;

- (instancetype)initWithExtensionItem:(NSExtensionItem *)extensionItem NS_DESIGNATED_INITIALIZER;

@end
