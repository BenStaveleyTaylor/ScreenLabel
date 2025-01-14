# ScreenLabel

This repository contains the source code code for the [Screen Label iOS app](https://apps.apple.com/us/app/screen-label/id1454415262?ls=1), which has been published on the App Store since 2019.

## Purpose and History

Screen Label allows a message to be placed on the iOS Lock Screen, to be readable without unlocking in case the device is lost. The project was called LockScreenText during development, which name still persists in the code.

Screen Label was designed in the days before iOS supported Widgets on the Lock Screen. The only way to get text onto the iOS Lock Screen back then was to create an image with the text already in place then set that image as the wallpaper. Annoyingly there was no programmatic way for an app to set the wallpaper image, it had to be done by the user. So Screen Label allows an image to be selected, text to be placed and sized on top of the image, then the resulting composition can be saved to the Photos library from where the user can set it as Wallpaper. The Help instructions are important to assist users in doing this.

When iOS 16 came along, it introduced Lock Screen Widgets. Screen Label was enhanced to act as a Widget, providing the text to be displayed on the Lock Screen. The image editor part of the app is mostly redundant if you use a Widget, but it was left in place for users on older versions of iOS, or who just want to do it the old-fashioned way.

## Licence

There is deliberately no license for this repository. It is private code which does not necessarily conform to any open source license. You are free to browse and use this code in any way you like, but I retain the copyright of this code and I ask that you credit me in any applications or derived projects that you create.

## Web Pages

GitHub Pages provides the content for the two links that the Screen Label application embeds:
- https://benstaveleytaylor.github.io/ScreenLabel/
- https://benstaveleytaylor.github.io/ScreenLabel/privacy

Copyright © Ben Staveley-Taylor, 2019-2025<br>
January 2025
