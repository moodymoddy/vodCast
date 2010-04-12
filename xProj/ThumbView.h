//
//  ThumbView.h - This is required to use Touch Events with UIImageView in a UIScrollView.
//  (See ThumbView.m for more details)
//
//  vodCastIMG
//
//  Created by Fergus Morrow on 11/04/2010.
//  Copyright 2010 - GNU General Public License; see "LICENSE.txt"
//

#import <Foundation/Foundation.h>

@class Video;

@interface ThumbView : UIImageView
<UIAlertViewDelegate>{
	Video *currentVideo;	//Stores the current "Video" instance
}

@property (nonatomic, retain) Video *currentVideo;

@end
