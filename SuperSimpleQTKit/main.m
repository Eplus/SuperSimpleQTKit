//
//  main.m
//  SuperSimpleQTKit
//
//  Created by Iyad Assaf on 30/06/2013.
//  Copyright (c) 2013 Iyad Assaf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import <QuartzCore/QuartzCore.h>

int main(int argc, const char * argv[])
{
    //Variables & Objects
    NSWindow        *window;
    NSString        *moviePath;
    QTMovie         *movie;
    QTMovieLayer    *movieLayer;
    BOOL            doesLoop = TRUE;
    BOOL            fullscreen = FALSE;
    
    @autoreleasepool {
        NSApplication* application = [[NSApplication alloc] init];

        //Find movie URL through a CLI.
        NSLog(@":> Enter movie URL");
        printf(":>");
        char input[255];
        scanf("%s",input);

        //Set movie path
        moviePath = [NSString stringWithFormat:@"%s", input];
        
        //Load movie object,load movie from path, exit if invalid path or cannot otherwise be loaded.
        movie = [[QTMovie alloc] initWithFile:moviePath error:nil];
        if(movie == NULL) {
            NSLog(@"File %@ could not be loaded", moviePath);
            exit(1);
        } else {
            NSLog(@"Playing file - %@", moviePath);
        }
        
        //Set up movie proprties
        [movie setAttribute:QTMovieApertureModeClean forKey:QTMovieApertureModeAttribute];
        [movie setAttribute:[NSNumber numberWithBool:doesLoop] forKey:QTMovieLoopsAttribute];
        
        //Setup the window
        NSRect mainFrame = [[NSScreen mainScreen] frame];
        window = [[NSWindow alloc] initWithContentRect:mainFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreNonretained defer:NO];
        
        [window setBackgroundColor: [NSColor redColor]];
        [window setOpaque:YES];
        [window setFrame:[NSScreen mainScreen].frame display:YES];
        [[window contentView] setWantsLayer:YES];
        [[window contentView] setNeedsDisplay:YES];
        [window setBackgroundColor:[NSColor clearColor]];
        [window makeKeyAndOrderFront:nil];

        //Fullscreen or not.
        if (fullscreen) {
            if (([window level]/1000)) {
                [window setLevel:NSNormalWindowLevel];
                //Show cursor
                CGDisplayShowCursor(CGMainDisplayID());
            } else {
                [window setLevel:NSScreenSaverWindowLevel];
                //Hide cursor.
                CGDisplayHideCursor(CGMainDisplayID());
            }
        }
        
        //Set up the movie layer
        movieLayer = [[QTMovieLayer alloc] initWithMovie:movie];
        movieLayer.backgroundColor = [[NSColor clearColor] CGColor];
        movieLayer.frame = [[NSScreen mainScreen] frame];
        [movieLayer setContentsGravity:kCAGravityResizeAspect];
        
        //Add the movie layer to the window
        [[[window contentView] layer] addSublayer:movieLayer];
        
        //Play the movie
        [movie play];
        
        [application run];
    }
    return 0;
}

