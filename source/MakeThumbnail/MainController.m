/*
    Copyright (c) 2001-2006 Troy N. Stephens

    Use and distribution of this source code is governed by the MIT License, whose terms are as follows.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import "MainController.h"
#import "IconFamily.h"

#define TEST(expr) \
    if (!(expr)) { \
        [[NSAlert alertWithMessageText:@"Fail" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%s:%ld %s failed", (char *)__FILE__, (long)__LINE__, #expr] runModal]; \
        return; \
    }

@implementation MainController

- savePanelAccessoryView
{
    // Load the save panel accessory view that enables the user to choose the
    // degree of image interpolation to use.  We need to retain the view so
    // that NSSavePanel doesn't dispose of it after the first use.  This seems
    // a little bit strange, but is documented in the NSSavePanel documentation.
    if (savePanelAccessoryView == nil) {
        [NSBundle loadNibNamed:@"SavePanelAccessoryView.nib" owner:self];    
        [savePanelAccessoryView retain];
    }
    return savePanelAccessoryView;
}

- (void) setImage:(NSImage*)image
{
    NSImageRep* imageRep;
    NSSize size, pixelSize;
    
    imageRep = [image bestRepresentationForDevice:nil];
    if ([imageRep isKindOfClass:[NSBitmapImageRep class]]) {
        // Make image's size match its representation's pixel size, so it displays
        // at 1 pixel = 1 pixel in our thumbnailImageView.  (Non-72dpi images would
        // otherwise scale differently.)
        size = [image size];
        pixelSize.width  = [(NSBitmapImageRep*)imageRep pixelsWide];
        pixelSize.height = [(NSBitmapImageRep*)imageRep pixelsHigh];
        if (!NSEqualSizes( size, pixelSize )) {
            [image setSize:pixelSize];
            [imageRep setSize:pixelSize];
        }
    }
    
    [thumbnailImageView setImageScaling:NSScaleProportionally];
    [thumbnailImageView setImage:image];
}

// Call our -setImage: method so it can modify the image (if necessary) to
// display at 1 pixel = 1 pixel.
- (IBAction)newImageDraggedIntoImageView:(id)sender
{
    [self setImage:[thumbnailImageView image]];
}

- (IBAction)loadImage:(id)sender
{
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    NSArray* imageFileTypes = [NSImage imageFileTypes];
    long result;
    
    result = [openPanel runModalForDirectory:[NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"] file:nil types:imageFileTypes];
    if (result == NSOKButton) {
        NSString* path = [[openPanel filenames] objectAtIndex:0];
        NSImage* image = [[NSImage alloc] initWithContentsOfFile:path];
        [self setImage:image];
        [image release];
    }
}

- (IBAction)saveImageWithThumbnail:(id)sender
{
    NSSavePanel* savePanel = [NSSavePanel savePanel];
    long result;
    
    [savePanel setTitle:@"Save image with thumbnail to (JPEG) file"];
    [savePanel setAccessoryView:[self savePanelAccessoryView]];
    [savePanel setRequiredFileType:@"jpg"];
    result = [savePanel runModalForDirectory:[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"] file:@""];
    if (result == NSOKButton) {
        NSImageInterpolation imageInterpolation;
        NSImage* image;
        NSImageRep* imageRep;
        IconFamily* iconFamily;
        NSString* path;
        NSDictionary* jpegProperties;
        NSData* jpegData;
        
        // Create an IconFamily from the image.
        image = [thumbnailImageView image];
        imageInterpolation = [[imageInterpolationPopUpButton selectedItem] tag];
        iconFamily = [IconFamily iconFamilyWithThumbnailsOfImage:image
                                         usingImageInterpolation:imageInterpolation];
        
        // Save the image (in JPEG format).
        path = [savePanel filename];
        imageRep = [image bestRepresentationForDevice:nil];
        if (![imageRep isKindOfClass:[NSBitmapImageRep class]]) {
            NSRunAlertPanel( @"Non-bitmap image",
                             @"Image's representation isn't an NSBitmapImageRep",
                             @"Cancel", nil, nil );
            return;
        }
        jpegProperties = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithFloat:0.9f], NSImageCompressionFactor,
            nil];
        jpegData = [(NSBitmapImageRep*)imageRep
            representationUsingType:NSJPEGFileType
                         properties:jpegProperties];
        [jpegData writeToFile:path atomically:YES];
        
        // Now give the saved JPEG file a custom icon.
        [iconFamily setAsCustomIconForFile:path];
    }
}

- (IBAction)saveThumbnailToIcnsFile:(id)sender
{
    NSSavePanel* savePanel = [NSSavePanel savePanel];
    long result;
    
    [savePanel setTitle:@"Save thumbnail to .icns file"];
    [savePanel setAccessoryView:[self savePanelAccessoryView]];
    [savePanel setRequiredFileType:@"icns"];
    result = [savePanel runModalForDirectory:[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"] file:@""];
    if (result == NSOKButton) {
        NSImageInterpolation imageInterpolation;
        NSImage* image;
        IconFamily* iconFamily;
        NSString* path;
        
        // Create an IconFamily from the image.
        image = [thumbnailImageView image];
        imageInterpolation = [[imageInterpolationPopUpButton selectedItem] tag];
        iconFamily = [IconFamily iconFamilyWithThumbnailsOfImage:image
                                         usingImageInterpolation:imageInterpolation];
        
        // Save the icon family.
        path = [savePanel filename];
        [iconFamily writeToFile:path];
        
        // Give the .icns file a custom icon.
        [iconFamily setAsCustomIconForFile:path];
    }
}

- (IBAction)saveImageToCustomIcon:(id)sender
{
	NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:YES];
    long result;
    
    result = [openPanel runModalForDirectory:[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"] file:nil types:nil];
    if (result == NSOKButton) {
        NSImageInterpolation imageInterpolation;
        NSImage* image;
        IconFamily* iconFamily;

        image = [thumbnailImageView image];
        imageInterpolation = [[imageInterpolationPopUpButton selectedItem] tag];
        iconFamily = [IconFamily iconFamilyWithThumbnailsOfImage:image
                                         usingImageInterpolation:imageInterpolation];

        NSString* path = [[openPanel filenames] objectAtIndex:0];
        BOOL isDir = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];

        if ( isDir )
            [iconFamily setAsCustomIconForDirectory:path];
        else
            [iconFamily setAsCustomIconForFile:path];
    }
}

- (IBAction)removeCustomIcon:(id)sender
{
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:YES];
    long result;
    
    result = [openPanel runModalForDirectory:[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"] file:nil types:nil];
    if (result == NSOKButton) {
        NSString* path = [[openPanel filenames] objectAtIndex:0];
        [IconFamily removeCustomIconFromFile:path];
    }
}

// A quick stab at some automated testing.  Exercises some but not all of the IconFamily class' functionality.  Not yet very rigorous, but it's a start.
- (IBAction)runAutomatedTest:(id)sender
{
    // Create a folder to hold the result files the test generates.
    NSString *resultsPath = [NSString stringWithUTF8String:tmpnam(NULL)];
    NSLog(@"Creating results directory at path %@", resultsPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager createDirectoryAtPath:resultsPath attributes:nil]) {
        NSLog(@"** Failed to create results directory at path %@", resultsPath);
    }

    // Create an IconFamily.
    IconFamily *iconFamily = [IconFamily iconFamilyWithThumbnailsOfImage:[thumbnailImageView image] usingImageInterpolation:NSImageInterpolationHigh];

    // Test writing 'icns' files (and assigning custom icons to them).
    NSString *path;
    path = [resultsPath stringByAppendingPathComponent:@"File with Custom Icon.icns"];
    TEST([iconFamily writeToFile:path]);
    TEST([iconFamily setAsCustomIconForFile:path]);

    path = [resultsPath stringByAppendingPathComponent:@"File with Custom Icon Removed.icns"];
    TEST([iconFamily writeToFile:path]);
    TEST([iconFamily setAsCustomIconForFile:path]);
    TEST([IconFamily removeCustomIconFromFile:path]);

    path = [resultsPath stringByAppendingPathComponent:@"File with Custom Icon Removed, Set Again.icns"];
    TEST([iconFamily writeToFile:path]);
    TEST([iconFamily setAsCustomIconForFile:path]);
    TEST([IconFamily removeCustomIconFromFile:path]);
    TEST([iconFamily setAsCustomIconForFile:path]);

    // Test assigning custom icons to directories.
    path = [resultsPath stringByAppendingPathComponent:@"Folder with Custom Icon"];
    TEST([fileManager createDirectoryAtPath:path attributes:nil]);
    TEST([iconFamily setAsCustomIconForDirectory:path]);

    // Open the folder in Finder so we can inspect our handiwork.
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    [workspace openFile:resultsPath];

    [[NSAlert alertWithMessageText:@"Pass" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Automated tests succeeded"] runModal];
}

@end
