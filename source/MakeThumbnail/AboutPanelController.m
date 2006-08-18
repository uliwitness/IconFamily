/*
    Copyright (c) 2001-2006 Troy N. Stephens

    Use and distribution of this source code is governed by the MIT License, whose terms are as follows.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import "AboutPanelController.h"
#import "IconFamily.h"

@implementation AboutPanelController

- (IBAction)orderFrontAboutPanel:(id)sender
{
    IconFamily* iconFamily;
    NSBitmapImageRep* bitmapImageRep;
    NSImage* image;
    
    // Load the panel's bundle if we haven't loaded it already.
    if (aboutPanel == nil) {
        if (![NSBundle loadNibNamed:@"AboutPanel.nib" owner:self])
            return;
    }
    
    // Demonstrate retrieving an NSBitmapImageRep from an IconFamily by
    // setting the about panel's image view's image from the thumbnail element
    // of the application's icon.  (Ordinarily we could just call [NSImage
    // imageNamed:NSApplicationIcon], but the point is to show off here...)
    iconFamily = [IconFamily iconFamilyWithContentsOfFile:
      [[NSBundle mainBundle] pathForResource:@"MacOSXPublicBeta" ofType:@"icns"]];
    bitmapImageRep = [iconFamily bitmapImageRepWithAlphaForIconFamilyElement:kThumbnail32BitData];
    if (bitmapImageRep) {
        image = [[[NSImage alloc] initWithSize:[bitmapImageRep size]] autorelease];
        [image addRepresentation:bitmapImageRep];
        [aboutPanelImageView setImage:image];
    } else {
        [aboutPanelImageView setImage:nil];
    }
    
    // Bring the panel to the front.
    [aboutPanel orderFront:self];
}

@end
