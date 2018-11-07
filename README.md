# GoHelpFund - iOS

[![Swift Version][swift-image]][swift-url]
[![GitHub last commit](https://img.shields.io/github/last-commit/gohelpfund/gohelpfund-api.svg?style=for-the-badge)][github-last-commit]

[![GitHub issues](https://img.shields.io/github/issues/gohelpfund/gohelpfund-api.svg?style=flat-square&longCache=true)][github-issues]
[![GitHub closed issues](https://img.shields.io/github/issues-closed/gohelpfund/gohelpfund-api.svg?style=flat-square&longCache=true)][github-issues-closed]
[![GitHub pull requests](https://img.shields.io/github/issues-pr/gohelpfund/gohelpfund-api.svg?style=flat-square&longCache=true)][github-pulls]
[![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed/gohelpfund/gohelpfund-api.svg?style=flat-square&longCache=true)][github-pulls-closed]

GoHelpFund is crowdfunding platform where people can donate and support campaigns like charity, medical, education, emergency and more. You can visit us at https://gohelpfund.com.

GoHelpFund is still in beta, so please submit any issues ([bug reports][github-bug-report] and [feature requests][github-feature-request]).

The GoHelpFund platform enables people to:

- Create and view campaigns
- Donate to campaigns using the [HELP][helptoken] token
- Filter and sort based on preferences
- See trending campaigns
- View nearby campaigns based on your location
- Share campaigns to social media platforms
- Invite other people to the platform

To learn more about the GoHelpFund platform check out [this presentation video][explainer video] created by us.

# Table of Contents

   * [Features](#features)
   * [Components &amp; Architecture](#components--architecture)
      * [Technologies](#technologies)
      * [Directory Structure](#directory-structure)
      * [Third Parties](#third-parties)
      * [Design Patterns](#design-patterns)
   * [Examples](#examples)
   * [Contributing](#contributing)
   * [Changelog](#changelog)
   * [Questions &amp; Improvements](#questions--improvements)

# Features

- [x] Campaign list
- [x] Campaign details
- [x] Categories
- [x] Create campaign
- [ ]  Donate
- [ ]  Track 

# Components & Architecture

We have a multy-layer structure: 
- the *Data Layer* is formed by "dumb" models which confort to the Codable protocol for automatic mapping from and to JSON. 

- the *Networking Layer* is formed by an API Service which contains an API enum that conforms to Target Type protocol. The "micro-services" (AWSUploadService and CampaignService) use the MoyaProvider in order to make API requests, then they send the mapped responses to the view models using closures.

- for the presentation layer, we use a combination between MVC and MVVM architecture. For the simpler views, like the campaign list screen, we use a flat MVC. On the other screens, like Categories, Campaign Details or Create Campaign Flow we use a Model-View-ViewModel architecture, with the posibility to add ViewModelDesigner components. The communication between the view (which represents the view controller and the smaller view classes) and the ViewModel is made using update methods, kvo and closures.

- the navigation layer is made using a coordinator called NavigationFactory, which provides the next view controller that needs to be presented.

- the user interface is implemented using autolayout and storyboards for small flows.

- our dependency management system is made using Pods

- tests will be implemented using XCTest.

## Technologies

Xcode 10.1, Swift 4.2.1, SDK iOS 12.1, macOS Mojave

## Directory Structure

    github.com/gohelpfund/gohelpfund-ios
    ├── GoHelpFund-Plaform/         # Main source code
        ├── Assets                    # Images, icons
        ├── BaseClasses               # Generic parent classes, Utils, Helpers, Extensions for Strings, Colors etc
        ├── Tests                     # Unit Testing
        ├── Models                    # Data structures and Encoding/Decoding
        ├── Networking                # API communication
        ├── Screens                   # Tab structure & visual componenets
        ├── Storyboards               # Layout construction
    ├── Pods/                       # Dependencies
  
  
## Third Parties

- Moya - Networking Layer Abstraction
- SDWebImage - Image downloading & caching
- Fabric - Base framework for distribution & Analytics
- Crashlytics - Crash reports framework
- LinearProgressBar - Layout for campaign raised percentage
- SkyFloatingLabelTextField - Elegant and minimalistic layout for text fields, create by SkyScanner
- UITextView+Placeholder - Customizable placeholder for UITextView
- DateTimePicker - Cool layout for date picker
- YPImagePicker - Image picking component, very similar to instagram upload image flow
- GooglePlaces - Selecting a location from a google (city, country)
- IQKeyboardManagerSwift - Manages keyboard appearence
- JSONDecoder-Keypath - Custom decoding helper
- AWSMobileClient - iOS SDK for AWS
- AWSS3 - File transfers, file upload in Amazon S3
- SwiftSpinner - Custom cool spinner

## Design Patterns  

- Arhitectural: MVC, MVVM 
- Structural: Facade, Adapter, Decorator
- Creational: Factory Method, Singleton, Builder
- Behavioral: KVO, Delegate, Observer, Decorator

# Examples


# Contributing

To be added

# Changelog

To be added


# Questions & Improvements

Ask us anything on telegram: https://t.me/gohelpfund

- [Submit a Bug Report][github-bug-report]
- [Submit a Feature Request][github-feature-request]
- [Raise an issue][github-new-issue] that is not a bug report or a feature request
- [Contribute a PR][github-pulls]

[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/

[github-last-commit]: https://github.com/gohelpfund/gohelpfund-api/commit/HEAD
[github-releases]: https://github.com/gohelpfund/gohelpfund-api/releases
[github-issues]: https://github.com/gohelpfund/gohelpfund-api/issues
[github-issues-closed]: https://github.com/gohelpfund/gohelpfund-api/issues?q=is%3Aissue+is%3Aclosed
[github-pulls]: https://github.com/gohelpfund/gohelpfund-api/pulls
[github-pulls-closed]: https://github.com/gohelpfund/gohelpfund-api/pulls?q=is%3Apr+is%3Aclosed
[helptoken]: https://coinmarketcap.com/currencies/gohelpfund/

[explainer video]: https://www.youtube.com/watch?v=mGXZzwEqLLc
[github-bug-report]: https://github.com/gohelpfund/gohelpfund-api/issues/new
[github-feature-request]: https://github.com/gohelpfund/gohelpfund-api/issues/new
[github-new-issue]: https://github.com/gohelpfund/gohelpfund-api/issues/new
