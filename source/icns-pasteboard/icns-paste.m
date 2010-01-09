/*
 *  icns-cli.m
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
            "Pastes .icns data from the clipboard into the named .icns file. If the file doesn't exist, creates it; if it does exist, overwrites it.\n",
            argv[0]);
        status = EX_USAGE;
        goto exit;
    }

    if( ! [IconFamily canInitWithScrap] )
    {
        fprintf(stderr,
            "%s: Clipboard does not contain IconFamily data; exiting\n",
            argv[0]);
        status = EX_NOINPUT;
        goto exit;
    }

    IconFamily *family = [IconFamily iconFamilyWithScrap];
    BOOL success = [family writeToFile:[[[NSProcessInfo processInfo] arguments] objectAtIndex:1U]];
    if( ! success )
    {
        fprintf(stderr,
            "%s: Could not write file: %s\n",
            argv[0], strerror(errno));
        status = EX_IOERR;
        goto exit;
    }
    
exit:
	[pool drain];
    return status;
}
