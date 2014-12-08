//
//  TumblrCustomShareParameters.h
//  XExtensionItemExample
//
//  Created by Bryan Irace on 12/8/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

@import Foundation;
#import <XExtensionItem/XExtensionItemDictionarySerializing.h>

/**
 *  In practice a custom parameters class like this would be provided by a third party, e.g. Tumblr.
 */
@interface TumblrCustomShareParameters : NSObject <XExtensionItemDictionarySerializing>

@property (nonatomic, copy) NSString *customURLSlug;

@end
