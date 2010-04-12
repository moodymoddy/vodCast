//
//  vodCastIMGAppDelegate.m
//  vodCastIMG
//
//  XCode Generated - no changes.
//
//  Created by Fergus Morrow on 11/04/2010.
//  Copyright 2010 - GNU General Public License; see "LICENSE.txt"
//

#import "vodCastIMGAppDelegate.h"
#import "vodCastIMGViewController.h"

@implementation vodCastIMGAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
