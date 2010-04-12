//
//  ThumbView.m
//
//  Essentially, to use Touch Events in a UIImageView encompassed in a UIScrollView you have
//  to make a subclass of the UIImageView class. If anyone has a tidier solution; feel free to
//  let me know - alas the apple documents pointed me this way!
//
//  vodCastIMG
//
//  Created by Fergus Morrow on 11/04/2010.
//  Copyright 2010 - GNU General Public License; see "LICENSE.txt"
//

#import <MediaPlayer/MediaPlayer.h>
#import "ThumbView.h"
#import "Video.h"


@implementation ThumbView
@synthesize currentVideo;

/* Catches interaction on the ThumbView, displays a prompt to the user about watching the video */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: currentVideo.title 
													message: @"Do you want to play this movie?" 
												   delegate: self
										  cancelButtonTitle: @"Yes" 
										  otherButtonTitles: @"No", nil 						  ];
		
	[alert show];
	[alert release];
}

/* Called by alerView() (UIAlertViewDelegate) if the user opts to watch the video */
-(void) playVideo {
	MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc]
											initWithContentURL:[NSURL URLWithString:currentVideo.vurl]];
	[moviePlayer play];
}


/* UIAlertViewDelegate Method */

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if( buttonIndex == 0 ){		//check user said Yes
		[self playVideo];
	}// if they said no, do nothing.
}


@end
