<p align="center"><img src="https://github.com/tumblr/XExtensionItem/blob/master/Assets/logo.png"></p>

<h1 align="center">XExtensionItem</p></h1>

<p align="center">
<a href="https://travis-ci.org/tumblr/XExtensionItem"><img src="https://img.shields.io/travis/tumblr/XExtensionItem.svg?style=flat" alt="Build Status"></a>
<a href="http://cocoapods.org/?q=XExtensionItem"><img src="http://img.shields.io/cocoapods/v/XExtensionItem.svg?style=flat" alt="Version"></a>
<img src="http://img.shields.io/cocoapods/p/XExtensionItem.svg?style=flat" alt="Platform">
<a href="https://github.com/tumblr/XExtensionItem/blob/master/LICENSE"><img src="http://img.shields.io/cocoapods/l/XExtensionItem.svg?style=flat" alt="License"></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatibile"></a>
</p>

XExtensionItem is a tiny library allowing for easier sharing of structured data between iOS applications and share extensions. It is targeted at developers of both share extensions and apps that display a [`UIActivityViewController`](https://developer.apple.com/library/ios/documentation/Uikit/reference/UIActivityViewController_Class/index.html).

We’d love your [thoughts](https://github.com/tumblr/XExtensionItem/issues) on how XExtensionItem could be made more useful. This library’s value comes from how useful it is for apps and extensions of all shapes and sizes.

- [Why?](#why)
    - [Multiple attachments](#multiple-attachments)
    - [Metadata parameters](#metadata-parameters)
- [Getting started](#getting-started)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
- [Usage](#usage)
    - [Applications](#applications)
        - [Advanced attachments](#advanced-attachments)
        - [Generic metadata parameters](#generic-metadata-parameters)
        - [Custom metadata parameters](#custom-metadata-parameters)
    - [Extensions](#extensions)
- [Apps that use XExtensionItem](#apps-that-use-xextensionitem)
    - [Apps](#apps)
    - [Extensions](#extensions)
- [Contributing](#contributing)
- [Contact](#contact)
    - [Thank you](#thank-you)
- [License](#license)

## Why?

### Multiple attachments

Currently, iOS has an [unfortunate limitation](https://github.com/tumblr/ios-extension-issues/issues/5) which causes only share extensions that explicitly accept *all* provided activity item types to show up in a `UIActivityViewController`. This makes it difficult for an application to share multiple pieces of data without causing extensions that aren’t as flexible with their allowed inputs to not show up at all. Consider the following example:

* A developer wants their app’s users to be able to share a URL as well as some text to go along with it (perhaps the title of the page, or an excerpt from it). An extension for a read later service (like Instapaper or Pocket) might only save the URL, but one for a social network (like Tumblr or Twitter) could incorporate both.
* The application displays a `UIActivityViewController` and puts both an `NSURL` and `NSString` in its activity items array.
* Only extensions that are explicitly defined to accept both URLs *and* strings will be displayed in the activity controller. To continue the examples from above, Tumblr/Twitter would be displayed in the activity controller but Instapaper/Pocket would not.

Rather than passing in multiple activity items and losing support for inflexible extensions, its best to use a single `NSExtensionItem` that encapsulates multiple attachments. This can be difficult to get exactly right, however. XExtensionItem makes this easy by providing a layer of abstraction on these complicated APIs, dealing with all of their intricacies so you don’t have to.

### Metadata parameters

Being able to pass metadata parameters to a share extension is extremely useful, but the iOS SDK doesn’t currently provide a generic way to do so. Individual developers would need to come up with a contract, such that the extension knows how to deserialize and parse the parameters that the application has passed to it. 

XExtensionItem [defines this generic contract](#generic-metadata-parameters), allowing application to pass metadata that extensions can easily read, each without worrying about the implementation details on the other end of the handshake. It even provides hooks for extension developers at add support for [custom metadata parameters](#custom-metadata-parameters).

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

This repository includes a [sample project](Example) which should help explain how the library is used. It has targets for both a share extension and an application; you can run the former using the latter as the host application and see [the data from the application](Example/App/ViewController.m#L31) get [passed through to the extension](Example/Extension/ShareViewController.m#L16).

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
* A placeholder item and a block to lazily provide the actual item (once an activity has been chosen)

#### Advanced attachments

An included `XExtensionItemSource` category provides additional convenience identifiers for lazily supplying URLs, strings, images, or data:

```objc
XExtensionItemSource *itemSource = 
     [[XExtensionItemSource alloc] initWithImageProvider:^UIImage *(NSString *activityType) {
        if (activityType == UIActivityTypePostToTwitter) {
            return twitterImage;
        }
        else {
            return defaultImage;
        }
     }];
```

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

#### Generic metadata parameters

In addition to multiple attachments, XExtensionItem also allows applications to pass generic metadata parameters to extensions.

The following parameters are currently supported (more information on each can be found in the `XExtensionItemSource` [header documentation](XExtensionItem/XExtensionItem.h)):

* A title (also used as the subject for system activities such as Mail and Messages)
* Attributed content text (can also be specified on a per-activity type basis)
* A thumbnail image
* Tags
* A source URL
* Referrer information
    * App Name
    * App store IDs (iTunes and Google Play)
    * URLs where the content being shared can be linked to on the web, or natively deep-linked on iOS and Android

Some built-in activities (e.g. `UIActivityTypePostToTwitter`) will consume the attributed content text field (if populated), while others (e.g. “Copy” or “Add to Reading List”) only know how to accept a single attachment. XExtensionItem is smart enough to handle this for you.

If you have an idea for a parameter that would be broadly useful (i.e. not specific to any particular share extension or service), please [create an issue](https://github.com/tumblr/XExtensionItem/issues/new) or open a [pull request](https://github.com/tumblr/XExtensionItem/pulls).

#### Custom metadata parameters

Generic parameters are great, as they allow applications and share extensions to interoperate without knowing the specifics about how the other is implemented. But XExtensionItem also makes it trivial for extension developers to add support for custom parameters as well.

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

By default, all custom parameter classes will be included when you pull XExtensionItem into your application. If you want more granular control over what is included, we’ve added support for this in the form of subspecs (CocoaPods) and submodules (Carthage).

If you’re an extension developer and would like to add custom parameters for your extension to XExtensionItem, please see the [Custom Parameters Guide](https://github.com/tumblr/XExtensionItem/wiki/Custom-parameters-guide).

Have a look at the [Apps that use XExtensionItem](#apps-that-use-xextensionitem) section for additional documentation on how to integrate with specific extensions.

### Extensions

Convert incoming `NSExtensionItem` instances retrieved from an extension context into `XExtensionItem` 
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

## Apps that use XExtensionItem

If you're using XExtensionItem in either your application or extension, create a [pull request](https://github.com/tumblr/XExtensionItem/pulls) to add yourself here.

### Apps

The following apps use XExtensionItem to pass flexible data to share extensions:

* [Tumblr](http://appstore.com/tumblr)
* [Unread](http://supertop.co/download/unread)

### Extensions

The following share extensions use XExtensionItem to parse incoming data:

* [Tumblr](http://appstore.com/tumblr) ([integration guide](https://github.com/tumblr/XExtensionItem/wiki/Integration-guide:-Tumblr))

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
