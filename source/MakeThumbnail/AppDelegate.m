//
//  AppDelegate.m
//  MakeThumbnail
//
//  Created by Alex Zielenski on 4/7/12.
//  Copyright (c) 2012 Alex Zielenski. All rights reserved.
//

#import "AppDelegate.h"
#import "IconFamily.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	IconFamily *family = [IconFamily iconFamilyWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"appStore"]];
	NSLog(@"%@", [family bitmapImageRepWithAlphaForIconFamilyElement:kIconServices1024PixelDataARGB]);
}

@end
