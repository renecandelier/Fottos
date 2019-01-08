# Fottos
This app is a fun way to explore photos using the flickr search API.

## Development
This project uses [gitflow](http://nvie.com/posts/a-successful-git-branching-model/) and requires code reviews for every pull request.

## Features

- Use predefined search terms to load photos from the Explore tab.
- Search photos from the Search tab using the search bar. 
- Saves prior search terms and presented them as quick search options in the search tab.
- Share/ save photos when performing a long when on the photo under the slide show. 
- Double tap a photo in the slideshow in order to save to your favorites. 
- Clear cache under the settings screen. 
- Remove all saved search terms from the settings screen. 
- Delete all photos saved to your favorites. 
- Change the amount of photos you would like to load per page under the settings screen.
- Infinite scrolling. 

# Project requirements

Fottos project requires:

- Xcode Version 9.4 or newer

- [CocoaPods](https://cocoapods.org/) Version 1.0.1 or newer - A  dependency manager for Swift and Objective-C Cocoa projects.

- Because we use CocoaPods when opening the application for the first time select `Fottos.xcworkspace` and not `Fottos.xcodeproj`.

# Contribution guidelines

Here we will outline standards for contributing to the Fottos project.

## Quick Do's and Don't's

If you’re familiar with git and GitHub, here’s the short version of what you need to know. Once you clone the Fottos code:

- First rule of contributing: **YOU DO NOT WORK OFF A _master_ BRANCH!**
- Second rule of contributing: **YOU DO NOT WORK OFF A _master_ BRANCH!**
- Third rule of contributing: **YOU DO NOT WORK OFF A _master_ BRANCH!**

- **Don’t develop directly on the _develop_ branch.** Always create a development branch specific to the issue you’re working on.Your development branch should be called feature/ABC-1234_fb_connect. Your branch should be based off of the *develop* branch.
 
- **Don't merge the upstream *develop* with your development branch**; rebase your branch on top of the upstream develop.

- **A single development branch should represent changes related to a single issue.** If you decide to work on another issue, create another branch. Your branch should be based off of the *develop* branch.

- **Git Flow** Creating branches should try to follow Git Flow which is a way of separating branches out based on the tickets. The main flows are: 
    - featured (feature/user stories) - ex: featured/ABC-1234   
    - fix (bug fixes) - ex: fix/ABC-1234
    - release (release branches) - ex: release/2.1
    - improvements (technical debt tickets) - ex: improvement/ABC-1234
    - hotfix (branches made for a hotfix release) - ex: hotfix/2.1.1

For more information regarding our Git branching model please see Vincent Driessen's post: [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/).


## Write awesome code

We strongly advise anyone to write unit tests for all features and bug fixes. No matter how small they are. 

There countless resources online about unit testing. 

## Code style and API design

* All code must be written in Swift 4.0+
* Follow Swift's [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
* Generally-followed style guide [Swift Style Guide](https://github.com/github/swift-style-guide)
* All warnings are treated as error and should be resolved immediately (including Interface Builder warnings)
