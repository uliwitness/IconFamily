#IconFamily class
with “MakeThumbnail” example for Mac OS X

by Troy Stephens, Thomas Schnitzer, David Remahl, Nathan Day, Ben Haller, Sven Janssen, Peter Hosey, Conor Dearden, Elliot Glaysher, and Dave MacLachlan

##Purpose

“IconFamily” is a Cocoa/Objective-C wrapper for Mac OS X Icon Services’ “IconFamily” data type. Its main purpose is to enable Cocoa applications to easily assign custom file icons from NSImage instances. Using the IconFamily class you can:

* create a multi-representation icon family from any arbitrary NSImage
* assign an icon family as a file's custom icon resource, so it will appear in Finder views
* read and write .icns files
* copy icon data to and from the scrap (pasteboard)
* get and set the elements of an icon family in convenient, Cocoa-compatible NSBitmapImageRep form

The IconFamily code started out as a small experiment that yielded a modest bit of code that has since found its way into a gratifying number of applications. It's extensively commented, so extending it further and fixing problems should be pretty easy. I welcome contributions, suggestions, and feedback that will help to improve it further.

##License

The IconFamily source code is released under The MIT License, which permits commercial as well as non-commercial use.

##Download

Get the latest complete source code at sourceforge.

There is reference documentation for the IconFamily class on the sourceforge project page.

##Credits/Contributors

I'm grateful to a number of talented and generous people for enhancements, bug fixes, and feedback that have helped improve the IconFamily code over the years. Thanks, guys!

Thomas Schnitzer provided contributions to the icon family element extraction code, and valuable help in understanding the related Carbon APIs, that made the initial releases possible.

David Remahl, author of Can Combine Icons, generously donated his own extensions to the IconFamily class for the 0.3 and 0.4.x releases. Nathan Day has likewise helped fix bugs and has contributed useful extensions, in the course of using the IconFamily code to build Popup Dock. Ben Haller, proprietor of Stick Software, pitched in his own contributions and dedication to get the 0.4 release of IconFamily out the door.

Sven Janssen, Peter Hosey, Conor Dearden, and Elliot Glaysher reported bugs and contributed patches to modernize the IconFamily code and keep the project going in the 0.9.x releases.

Dave MacLachlan of Google has contributed support for 256x256 and 512x512 icon family elements that I've rolled into a 0.9.3 release.

Mike Margolis, author of Sugar Cube Software's Pic2Icon tool, has contributed support for creating shadowed, dog-eared document-like thumbnail icons that I've been meaning for a good long while now to fold into a future release. (Sorry, Mike!)

Applications that use IconFamily

OmniGraffle saves each document with a thumbnail snapshot as its custom file icon. Omni has folded the IconFamily source into its freely available OmniAppKit framework.

Stone Design's Create also uses the IconFamily code to provide thumbnail snapshots for saved documents.

David Remahl built on the IconFamily class to create Can Combine Icons, an elegant Cocoa-based Mac OS X application that makes short work of compositing icons to create new ones.

Martin Wengenmayer's Cheetah3D uses IconFamily to save thumbnail icons for rendered images (specify an explicit extension, such as “.tiff”, when saving), and can be used as a tool for creating custom icons from 3D models (see “Making Mac OS X Icons” in the accompanying documentation).

EazyDraw uses IconFamily to save documents with thumbnail icons, and to support creating .icns files.

Marc Moini's 3D-Finder and Smart Scroll X use IconFamily for their custom icon manipulation needs.

The bitmap manipulation code in Trollin's iconCompo, another versatile icon compositing tool, was influenced by the IconFamily source.

Thomas Schnitzer's Iconizer lets you zoom and drag-select to choose specific regions of your images from which to create thumbnail icons.

Sugar Cube Software's free Pic2Icon leverages the IconFamily class, enabling you to create thumbnails for image files with drag-and-drop simplicity.

Stick Software's Constrictor screen grab utility and Fracture screen saver use the IconFamily class to provide thumbnail icons for saved screen snapshots and fractal images.

Gideon Softworks' FileXaminer (a Finder "Get Info" enhancement) uses IconFamily to support custom icon assignments.

Extraneous Software's LameSecure, a lightweight security tool, reportedly uses IconFamily somewhere, for something or other. :-)

##Version History

###Version 0.9.4 - 2010-01-12

64-bit support and various fixes (big thanks to Peter Hosey and Jens Ayton for making the much-needed improvements in this release!)

Moved off 32-bit-only Carbon Scrap Manager APIs. IconFamily's "Scrap" API methods (+canInitWithScrap, etc.) now use NSPasteboard under the hood.
Project now builds for Intel 64-bit (x86_64).
New "icns-pasteboard" project adds command-line tools for testing copy/paste of .icns data.
Fixed setting the Invisible bit on the "Icon\r" file inside a directory when setting a custom icon on that directory. Patch submitted by Timothy McIntosh in SF #2794260; thanks!
Added a menu item to the "MakeThumbnail" example project for applying custom icons to files and folders.
Added a -finalize method, to allow use by garbage-collected client apps.
Enabled more warnings when building.
Fixed build warnings, and some potential leaks.
See the svn commit log for a complete list of changes since 0.9.3 (which was r27).

With Mac OS X up to release 10.6.2, it's about time we modernized the IconFamily code base for the greater convenience of most developers, who are probably developing on 10.6.x and targeting a baseline OS of 10.4 at the earliest. As such, 0.9.4 will be the last release of IconFamily to specifically maintain build compatibility with pre-10.4 versions of Mac OS X. We won't be going out of our way to break things badly for anyone who might need to work with very old versions of Mac OS X ("Bueller? Bueller? ..."), but there's no reason to penalize the majority of clients to accommodate those rare cases. It's time to update the project file to Xcode 3.x, and adopt 10.4-and-later API conventions such as the NSUInteger and CGFloat types.

###Version 0.9.3 - 2008-05-03

Incorporated enhancements contributed by Dave MacLachlan @ Google into a new, "0.9.3" release (these changes have been in svn since 2007-11-09):

Creation and retrieval of 256x256 (Tiger and later) and 512x512 (Leopard and later) ARGB icon family elements.
Removed unnecessary HLock()/HUnlock() calls. (Handle-based memory isn't really compacted anymore, so blocks can't move.)
Added guard against NULL "scrapInfos" pointer in +canInitWithScrap.
Moving Day - 2006-08-19

Project moved from its previous location to its new home on sourceforge!
###Version 0.9.2 - March 29, 2006

Fixed a regression in -setAsCustomIconForDirectory:... that appeared in 0.9
-setAsCustomIconForFile:... now preserves the target file's previous modification time, thanks to an enhancement contributed by Elliot Glaysher
###Version 0.9.1 - March 12, 2006

Fixed a regression in 0.9 that prevented a file's custom icon from being set after it had already been set and cleared. (Thanks to Sven Janssen for noticing this and providing a test case!)
###Version 0.9 - March 9, 2006

Fixed byte order handling in -bitmapImageRepWithAlphaForIconFamilyElement: to work correctly on Intel
Replaced all usage of the deprecated FSSpec type with appropriate calls and use of FSRef (thanks to patches contributed by Peter Hosey and Conor Dearden!)
Fixed build warnings that appeared on Tiger, and removed some old cruft
Updated project file to Xcode 2.2
Tested under Mac OS X 10.4.5, on both Intel and PPC hardware
###Version 0.5.1 - March 5, 2004
Minor changes to fix two warnings that appeared when compiling IconFamily 0.5 on Mac OS X 10.3 (Panther):

Replaced occurrences of '????' with kUnknownType
Disambiguated order of operations in expressions involving *pRawBitmapData++
###Version 0.5 - August 6, 2002
Updated for compatibility with Mac OS X 10.2:

Fixed -init method so it works on both 10.1.x and 10.2
Added calls to FNNotify() to improve Finder synchronization
Applications that rely on the -init method that was added in Version 0.4 should be recompiled with this new version of the IconFamily class for compatibility with Mac OS X 10.2.

###Version 0.4.1 - May 2, 2002
Released within hours of 0.4, this version fixed the omission of two new methods submitted by David Remahl:

-setAsCustomIconForDirectory:
-setAsCustomIconForDirectory:withCompatibility:
There is also a new method in the "CarbonFSSpecCreation" category on NSString, which permits getting an FSRef for a given path. The prior method to get an FSSpec is now implemented in terms of this method.

###Version 0.4 - May 2, 2002
Nathan Day, Ben Haller, and David Remahl contributed new features and bug fixes for the 0.4 release, including:

fixes for the -init and -setAsCustomIconOfFile: methods
a new +removeCustomIconFromFile: class method
support for creating 8-bit indexed-color icon family elements
respect for exiting type/creator codes in -setAsCustomIconForFile:... A new "compatibility" parameter to this method causes "large" and "small" 8-bit images and their 1-bit masks to be stored as independent resources in addition to being stored as members of the icon family resource
a fix for -writeToFile: (previously there was a problem with certain kinds of paths)
a probably more efficient alternative to going through -tiffData to get bitmap image representations in -initWithThumbnailsOfImage:usingImageInterpolation:
Special thanks to Ben for folding his and David's changes into a ready-to-go 0.4 release!

I've also fixed a potential divide-by-zero error in +get32BitdataFromBitmapImageRep:.

###Version 0.3 - January 26, 2002
David Remahl contributed a number of useful extensions and fixes for this release, including:

new init methods for creating an IconFamily from a standard system icon, from the Finder icon of a specified file, or from the Carbon Scrap Manager (Cocoa Pasteboard)
a -putOnScrap method for placing a copy of an IconFamily on the Scrap (Pasteboard)
code to undo the effects of premultiplied alpha in get32BitDataFromBitmapImageRep:
a fix for 1-bit mask generation
Mike Margolis and David Remahl jointly suggested the use of NSGraphicsContext's -setImageInterpolation: method to specify the resampling algorithm to use. By default, the IconFamily class now uses NSImageInterpolationHigh, which produces higher-quality thumbnails than previous versions of the code, but you can easily choose from among Default/None/Low/High.

I added an accessory view to MakeThumbnail's "Save" panel to facilitate experimenting with the various NSImageInterpolation... settings that are now available. I've also added generation of "small" (16x16) icons, fixed memory leaks, and fixed a bug that affected the display size of the loaded image in the MakeThumbnail example under Mac OS X 10.0 and later versions.

IconFamily 0.3 has been tested on Mac OS X 10.1.2, using the December 2001 Developer Tools.

###Version 0.2 - April 25, 2001
This release fixed a bug in the -bitmapImageRepWithAlphaForIconFamilyElement: method, where the NSBitmapImageRep's data was being referenced instead of copied and retained (sometimes resulting in a damaged bitmap or one containing random garbage).

I also added an init method for creating an IconFamily from an existing IconFamilyHandle, and removed the warnings about post-Public Beta Mac OS X compatibility, since the code appeared to work just fine on Mac OS X 10.0.

###Version 0.1 alpha - February 28, 2001
First public release.