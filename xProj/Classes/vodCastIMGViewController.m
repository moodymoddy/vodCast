//
//  vodCastIMGViewController.m
//  vodCastIMG
//
//  Created by Fergus Morrow on 11/04/2010.
//  Copyright 2010 - GNU General Public License; see "LICENSE.txt"
//

#import "vodCastIMGViewController.h"
#import "Video.h"
#import "ThumbView.h"
#import <MediaPlayer/MediaPlayer.h>

#define EXTXML "http://moodymoddy.isa-geek.org/vodcast/query.php"


@implementation vodCastIMGViewController
@synthesize vod, aVideo, currentProperty, uiImageList, scroller, currentImage;

/* Called when "About" is clicked */
-(IBAction) showAbout{
	UIAlertView *about = [[UIAlertView alloc] initWithTitle: @"About vodCast" 
													message: @"1 Idea. 3 Hours. * Possibilities" 
												   delegate: nil
										  cancelButtonTitle: @"Ok" 
										  otherButtonTitles: nil ];
	
	[about show];
	[about release];
}

/* UIScrollView Delegate Method */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_object {
	
	CGPoint scrollPosition;
	scrollPosition = scroller.contentOffset;
	
	currentImage = (int)scrollPosition.x / 320;	// Calculates which Image the ScrollView has stopped on
	
	ThumbView *tempThumb = [scroller.subviews objectAtIndex:currentImage];			//Gets the current ThumbView
	tempThumb.currentVideo = [vod objectAtIndex:currentImage];						//Passes it an instance of the current Video
}


/* NSXMLParser Delegate Methods */
- (void)parser:(NSXMLParser *)parser  didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict{
	
	//This is called when the Parser begins and we encounter <videos>
	if( [elementName isEqualToString:@"videos"] ){
		vod = [[NSMutableArray alloc] init];
	}
	
	//This is called when we begin a <video> element - uses aVideo as a temp storage place for all the properties
	if( [elementName isEqualToString:@"video"] ){
		aVideo = [[Video alloc] init];
		aVideo.ID = [[attributeDict objectForKey:@"id"] integerValue];		
	}
	
}

/* Parses the data inside an XML element */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if(!currentProperty)
		currentProperty = [[NSMutableString alloc] initWithString:string];
	else
		[currentProperty appendString:string];	//Just store the data in our NSMutableString "currentProperty"
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	// Its the end of the <videos> element, so we're done here. 
	if([elementName isEqualToString:@"videos"]) 
		return;
	
	// Its the end of a <video> so add the Video object to our NSMutableArray and then clear it ready for the next one
	if([elementName isEqualToString:@"video"]){ 
		NSLog(@"%s: URL - %s", aVideo.title, aVideo.vurl);
		[vod addObject:aVideo];
		[aVideo release];
		aVideo = nil;
	}
	
	// Set the output from parser() (currentProperty) into the corresponding part of our class
	// NOTE - THIS IS WHY OBJECT PROPERTIES MUST BE NAMED THE SAME AS THE RESPECTIVE ELEMENT NAMES
	else
		[aVideo setValue:currentProperty forKey:elementName];
	
	// Clear currentProperty ready for its next use
	[currentProperty release];
	currentProperty = nil;
}



/* Just means an error has occured parsing the XML file - so we just dump out an alert with the error */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	NSString *error = [NSString stringWithFormat:@"ERROR: %i", parseError.code];
	NSLog(error);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error 
													message:@"An error has occured with the XML Parser."
												   delegate:nil 
										  cancelButtonTitle:@"Ok" 
										  otherButtonTitles:nil
						  ];
	[alert show];
	[alert release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	//Check for net connectivity
	NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]];
	wait(20000);
	if(connected == NULL){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error!"
														message: @"Application requires internet connectivity!" 
													   delegate: nil
											  cancelButtonTitle: @"Ok" 
											  otherButtonTitles:nil
							  ];
		[alert show];
		[alert release];
		[connected release];
		exit(0);
		
	}	
	[connected release];
	
	// Call our XML Parser
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@EXTXML]];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser parse];
	
	//Get the images from the Video classes..
	uiImageList = [[NSMutableArray alloc] init];
	for(int i = 0; i<vod.count; i++){
		Video *vid = [vod objectAtIndex:i];
		[uiImageList addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:vid.image]]]];		
	}
	
	//Configure our UIScrollView
	[scroller setBackgroundColor:[UIColor blackColor]];
	scroller.pagingEnabled = YES;							//Stops the UIScrollView stopping between two images
	scroller.userInteractionEnabled = YES;					//Required for its subviews (ThumbView) to be able to take user interaction
	scroller.scrollsToTop = NO;								//Clever feature where the user can tap the status bar to go to top; alas - not needed
	scroller.showsVerticalScrollIndicator = NO;				//We don't want the scroll bar indicator
	scroller.showsHorizontalScrollIndicator = NO;			//No scroll bar indicator here either
	scroller.contentSize = CGSizeMake(scroller.frame.size.width * uiImageList.count, 480);	//Set the content size

	
	//Loop through each image and create a UIImageView, then add it as a subView to the UIScrollView
	for(int i = 0; i < uiImageList.count; i++)
	{
		UIImage *img = [uiImageList objectAtIndex:i];
		
		ThumbView *imgView = [[ThumbView alloc] initWithImage:img];
		imgView.userInteractionEnabled = YES;
		
		CGRect rect = imgView.frame;
		rect.size.height = 480;
		rect.size.width = 320;
		imgView.frame = rect;
		imgView.tag = i;
		
		[scroller addSubview:imgView];
		[img release];
		
		[imgView release];
		NSLog(@"Image %d added!", i);
				
	}
	
	// Set the default video to be 0
	ThumbView *tempThumb = [scroller.subviews objectAtIndex:0];
	tempThumb.currentVideo = [vod objectAtIndex:0];
	
	// Call layoutScrollImages to configure the positioning of the images
	[self layoutScrollImages];
	[super viewDidLoad];
}

// Configures the subviews for our UIScrollView
- (void)layoutScrollImages
{
	ThumbView *view = nil;
	NSArray *subviews = [scroller subviews];
	
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[ThumbView class]]) // && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
						
			curXLoc += (320);
		}
	}
	
	// set the content size so it can be scrollable
	[scroller setContentSize:CGSizeMake((uiImageList.count * 320), [scroller bounds].size.height)];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
