# ScreenLabel

This repository contains the source code code for the Screen Label iOS app, which has been published on the App Store since 2019.

## History and Purpose

Screen Label allows a message to be placed on the iOS Lock Screen, to be readable without unlocking in case the device is lost. The project was called LockScreenText during development, which name still persists in the code.

Screen Label was designed in the days before iOS supported Widgets on the Lock Screen. The only way to get text onto the iOS Lock Screen back then was to create an image with the text already in place then set that image as the wallpaper. Annoyingly there was no programmatic way for an app to set the wallpaper image, it had to be done by the user. So Screen Label allows an image to be selected, text to be placed and sized on top of the image, then the resulting composition can be saved to the Photos library from where the user can set it as Wallpaper.

When iOS 16 came along, it introduced Lock Screen Widgets. Screen Label was enhanced to act as a Widget, providing the text to be displayed on the Lock Screen. The image editor part of the app is mostly redundant if you use a Widget, but it was left in place for users on older versions of iOS, or who just want to do it the old-fashioned way.

## License

There is deliberately no license for this repository. It was not originally intended to be forked or otherwise shared. However, in view of the age of the code and the low likelihood of a new version being released I am making the code available in the public domain for archival purposes and general interest. Some fragments of code in the product may have been inspired by or copied from other projects. I offer no guarantee that the entire codebase conforms to any particular open source licence.

No copyright, Ben Staveley-Taylor<br>
January 2025
