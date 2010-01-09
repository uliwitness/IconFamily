/*
 *  icns-copy.m
 *  MakeThumbnail
 *
 *  Created by Peter Hosey on 2008-08-04.
 *  Copyright 2008 Peter Hosey. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>
#import "IconFamily.h"

#include <stdio.h>
#include <string.h>
#include <libgen.h>
#include <sysexits.h>
#include <sys/errno.h>

int main(int argc, char **argv)
{
    int status = EXIT_SUCCESS;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    if( ! argv[1] )
    {
        fprintf(stderr,
            "Usage: %s <filename>\n"
            "Copies the contents of the named .icns file to the clipboard.\n",
            argv[0]);
        status = EX_USAGE;
        goto exit;
    }

    IconFamily *family = [IconFamily iconFamilyWithContentsOfFile:[[[NSProcessInfo processInfo] arguments] objectAtIndex:1U]];
    [family putOnScrap];

exit:
	[pool drain];
    return status;
}
