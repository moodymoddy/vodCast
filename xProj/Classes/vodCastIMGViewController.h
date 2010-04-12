//
//  vodCastIMGViewController.h
//
//  Standard class header file - references our Video and ThumbView clases. See individual comments for more details!
//
//  vodCastIMG
//
//  Created by Fergus Morrow on 11/04/2010.
//  Copyright 2010 - GNU General Public License; see "LICENSE.txt"
//

#import <UIKit/UIKit.h>

@class Video;																	// Stores the details of our video objects - see Video.h 
@class ThumbView;																// Required to use UIImageView in a UIScrollView whilst maintaining Touch Events - see ThumbView.h

@interface vodCastIMGViewController : UIViewController
<UIScrollViewDelegate> {
	IBOutlet UIScrollView *scroller;											// Scroll View to house all our images
	
	Video *aVideo;																// Instance of Video - only really used during XML Parsing to store data temp
	NSMutableString *currentProperty;											// This is used to hold the current property of an element during XML Parsing
	
	NSMutableArray *vod;														// Holds all of our Video instances
	NSMutableArray *uiImageList;												// Holds all of our UIImages
	int currentImage;															// This is set when the UIScrollView stops loading, and it stores which image the UIScrollView has stopped on
}

/* Standard property statements to set up correct properties for each object */
@property (retain, nonatomic) UIScrollView *scroller;
@property (retain, nonatomic) Video *aVideo;
@property (retain, nonatomic) NSMutableArray *vod;
@property (retain, nonatomic) NSMutableString *currentProperty;
@property (retain, nonatomic) NSMutableArray *uiImageList;
@property int currentImage;

-(void) layoutScrollImages;				// This organises our ThumbView items in the UIScrollView correctly
-(IBAction) showAbout;					// Just pops up an Alert with a little about statement

@end

