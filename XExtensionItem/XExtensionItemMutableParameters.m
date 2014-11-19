#import "XExtensionItemMutableParameters.h"
#import "XExtensionItemParameters.h"

@implementation XExtensionItemMutableParameters

@synthesize attributedTitle;
@synthesize attributedContentText;
@synthesize attachments;
@synthesize tags;
@synthesize sourceURL;
@synthesize imageURL;
@synthesize sourceApplication;
@synthesize MIMETypesToContentRepresentations;
@synthesize userInfo;

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[XExtensionItemParameters allocWithZone:zone] initWithAttributedTitle:self.attributedTitle
                                                            attributedContentText:self.attributedContentText
                                                                      attachments:self.attachments
                                                                             tags:self.tags
                                                                        sourceURL:self.sourceURL
                                                                     thumbnailURL:self.imageURL
                                                                sourceApplication:self.sourceApplication
                                                MIMETypesToContentRepresentations:self.MIMETypesToContentRepresentations
                                                                         userInfo:self.userInfo];
}

@end
