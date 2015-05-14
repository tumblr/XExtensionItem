![XExtensionItem](https://github.com/tumblr/XExtensionItem/blob/master/Assets/logo.png)

# XExtensionItem

[![Build Status](https://img.shields.io/travis/tumblr/XExtensionItem.svg?style=flat)](https://travis-ci.org/tumblr/XExtensionItem)
[![Version](http://img.shields.io/cocoapods/v/XExtensionItem.svg?style=flat)](http://cocoapods.org/?q=XExtensionItem)
[![Platform](http://img.shields.io/cocoapods/p/XExtensionItem.svg?style=flat)]()
[![License](http://img.shields.io/cocoapods/l/XExtensionItem.svg?style=flat)](https://github.com/tumblr/XExtensionItem/blob/master/LICENSE)

XExtensionItem is a tiny library allowing for easier sharing of structured data between iOS applications and share extensions. It is targeted at developers of both share extensions and apps that display a [`UIActivityViewController`](https://developer.apple.com/library/ios/documentation/Uikit/reference/UIActivityViewController_Class/index.html).

We’d love your [thoughts](https://github.com/tumblr/XExtensionItem/issues) on how XExtensionItem could be made more useful. This library’s value comes from how useful it is for apps and extensions of all shapes and sizes.

- [Why?](#why)
- [Getting started](#getting-started)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
- [Usage](#usage)
    - [Applications](#applications)
        - [Advanced attachments](#advanced-attachments)
        - [Generic parameters](#generic-parameters)
        - [Custom parameters](#custom-parameters)
    - [Extensions](#extensions)
- [Examples](#examples)
- [Apps that use XExtensionItem](#apps-that-use-xextensionitem)
- [Contributing](#contributing)
- [Contact](#contact)
- [License](#license)

## Why?

Currently, iOS has an [unfortunate limitation](https://github.com/tumblr/ios-extension-issues/issues/5) which causes only share extensions that explicitly accept *all* provided activity item types to show up in a `UIActivityViewController`. This makes it difficult for an application to share multiple pieces of data without causing extensions that aren’t as flexible with their allowed inputs to not show up at all. Consider the following example:

* A developer wants their app’s users to be able to share a URL as well as some text to go along with it (perhaps the title of the page, or an excerpt from it). An extension for a read later service like Instapaper might only save the URL, but one for a social network like Tumblr or Twitter could incorporate both.
* The application displays a `UIActivityViewController` and puts both an `NSURL` and `NSString` in its activity items array.
* Only extensions that are explicitly defined to accept both URLs *and* strings will be displayed in the activity controller. To continue the examples from above, Tumblr would be displayed in the activity controller but Instapaper would not.

Rather than passing in multiple activity items and losing support for inflexible extensions, its best to use a single `NSExtensionItem` that encapsulates multiple attachments and additional metadata as well. This can be difficult to get exactly right, however. XExtensionItem makes this easy by providing a layer of abstraction on these compmlicated APIs, dealing with all of their intricacies so you don’t have to.

Apps should be able to pass rich, structured attachments and metadata to extensions without worrying about the implementation details on the other end of the handshake. XExtensionItem facilitates exactly this.

## Getting started

XExtensionItem is available through your Objective-C package manager of choice:

### CocoaPods

Simply add the following to your [Podfile](https://guides.cocoapods.org/syntax/podfile.html):

```
pod 'XExtensionItem'
```

### Carthage

Simply add the following to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```
github "tumblr/XExtensionItem"
```

## Usage

### Applications

You may currently be initializing your `UIActivityViewController` instances like this:

```objc
[[UIActivityViewController alloc] initWithActivityItems:@[URL, string, image] 
                                  applicationActivities:nil];
```

As outlined above, this is problematic because your users will only be presented with extensions that explicitly accept URLs _and_ strings _and_ images. XExtensionItem provides a better way.

```objc
XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithURL:URL];
itemSource.additionalAttachments = @[string, image];

[[UIActivityViewController alloc] initWithActivityItems:@[itemSource] 
                                  applicationActivities:nil];
```

`XExtensionItemSource` needs to be initialized with a main attachment (an `NSURL` in the above example). The main attachment’s type will determine which system activities and extensions are presented to the user. In this case, all extensions and system activities that at least accept URLs will be displayed, but **all three attachments will be passed to the one that the user selects**. 

In addition to a URL, an `XExtensionItemSource` instance can also be initialized with:

* An `NSString`
* A `UIImage`
* `NSData` along with a type identifier
* A placeholder item and a block to lazily provide the actual item, once an activity has been chosen (an included `XExtensionItemSource` category provides additional convenience identifiers for lazily supplying URLs, strings, images, or data)

#### Advanced attachments

Additional attachments can be provided for all activity types:

```objc
itemSource.additionalAttachments = @[string, image];
```

As well as on a per-activity type basis:

```objc
[itemSource setAdditionalAttachments:@[tweetLengthString, image] 
                     forActivityType:UIActivityTypePostToTwitter];
```

In addition to `NSURL`, `NSString`, and `UIImage`, the additional attachments array can also include `NSItemProvider` instances, which gives applications some more flexibility around lazy item loading. See the [`NSItemProvider` Class Reference](https://developer.apple.com/library/prerelease/ios/documentation/Foundation/Reference/NSItemProvider_Class/index.html) for more details.

#### Generic parameters

In addition to multiple attachments, XExtensionItem also allows applications to pass generic metadata paremters to extensions.

The following parameters are currently supported (more information on each can be found in the `XExtensionItemSource` [header documentation](XExtensionItem/XExtensionItem.h)):

* A title
* Attributed content text (can also be specific on a per-activity type basis)
* A thumbanil image
* Tags
* A source URL
* Referrer information
    * App Name
    * App store IDs (iTunes and Google Play)
    * URLs where the content being shared can be linked to on the web, or natively deep-linked on iOS and Android

If you have an idea for a parameter that would be broadly useful (i.e. not specific to any particular share extension or service), please create an [issue](https://github.com/tumblr/XExtensionItem/issues) or open a [pull request](https://github.com/tumblr/XExtensionItem/pulls).

#### Custom parameters

Generic parameters are great, in that they allow applications and share extensions to interoperate without knowing the specifics about how the other is implemented. But XExtensionItem also makes it trivial for extension developers to add support for custom parameters as well.

Extension developers can create a class that conforms to the `XExtensionItemCustomParameters`, which application developers will then be able to populate. Here’s a Tumblr-specific example:

```objc
XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithURL:URL];
itemSource.additionalAttachments = @[string, image];
itemSource.tags = @[@"lol", @"haha"];

// Provided by Tumblr’s developers. If you’re an extension developer, you can provide your own!
XExtensionItemTumblrParameters *tumblrParameters = 
    [[XExtensionItemTumblrParameters alloc] initWithCustomURLPathComponent:@"best-post-ever"
                                                               consumerKey:nil];

[itemSource addCustomParameters:tumblrParameters];
```

If you’re an extension developer and would like to add custom parameters for your extension to XExtensionItem, please see [this guide](https://github.com/tumblr/XExtensionItem/wiki/Guide-to-adding-custom-parameters) containing more information on how to do so.

By default, all custom parameter classes will be included when you pull XExtensionItem into your application. If you want more granular control over what is included, we’ve added support for this in the form of subspecs (CocoaPods) and submodules (Carthage).

Have a look at the [apps that use XExtensionItem](#apps-that-use-xextensionitem) section for a list of all supported custom parameters.

### Extensions

Convert incoming `NSExtensionItem` instances retrieved from an extension context into `XExtensionItemParameters` 
objects:

```objc
 for (NSExtensionItem *inputItem in self.extensionContext.inputItems) {
    XExtensionItem *extensionItem = [[XExtensionItem alloc] initWithExtensionItem:inputItem];

    NSString *title = extensionItem.title;
    NSAttributedString *contentText = extensionItem.attributedContentText;

    NSArray *tags = extensionItem.tags;

    NSString *tumblrCustomURLPathComponent = extensionItem.tumblrParameters.customURLPathComponent;
 }
```

## Examples

This repository includes a [sample project](https://github.com/tumblr/XExtensionItem/tree/master/Example) which may help explain how the library is to be used. It has targets for both a share extension and an application; you can run the former using the latter as the host application and see [the data from the application](https://github.com/tumblr/XExtensionItem/blob/master/Example/XExtensionItemExample/ViewController.m#L23) get [passed through to the extension](https://github.com/tumblr/XExtensionItem/blob/master/Example/XExtensionItemShareExtensionExample/ShareViewController.m#L10).

Here’s a [hypothetical example](https://github.com/tumblr/XExtensionItem/wiki/Hypothetical-Tumblr-XExtensionItem-integration-documentation) of how XExtensionItem’s parameters could map to values that the Tumblr iOS share extension would consume.

## Apps that use XExtensionItem

Please create a [pull request](https://github.com/tumblr/XExtensionItem/pulls) or [let us know](#contact) if you're using XExtensionItem in either your application or your extension.

## Contributing

Please see [CONTRIBUTING.md](https://github.com/tumblr/XExtensionItem/blob/master/CONTRIBUTING.md) for information on how to help out.

## Contact

[Bryan Irace](mailto:bryan@tumblr.com)

### Thank you

Many thanks to [Ari Weinstein](https://github.com/arix) for his contributions towards shaping XExtensionItem’s API, as well as [Matt Bischoff](https://github.com/mattbischoff), [Oisín Prendiville](https://github.com/prendio2), and [Padraig Kennedy](https://github.com/padraigk) for their invaluable feedback.

## License

Copyright 2014 Tumblr, Inc.

Licensed under the Apache License, Version 2.0 (the “License”); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

> Unless required by applicable law or agreed to in writing, software
> distributed under the License is distributed on an “AS IS” BASIS, WITHOUT
> WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
> License for the specific language governing permissions and limitations under
> the License.
