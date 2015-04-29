#import "XExtensionItemMutableSourceApplication.h"

@implementation XExtensionItemMutableSourceApplication

@dynamic appName;
@dynamic appStoreID;
@dynamic googlePlayID;
@dynamic webURL;
@dynamic iOSAppURL;
@dynamic androidAppURL;

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[XExtensionItemSourceApplication allocWithZone:zone] initWithAppName:self.appName
                                                                      appStoreID:self.appStoreID
                                                                    googlePlayID:self.googlePlayID
                                                                          webURL:self.webURL
                                                                       iOSAppURL:self.iOSAppURL
                                                                   androidAppURL:self.androidAppURL];
}

@end
