//
//  ResultController.m
//  FuckYeahAwesomeTrack
//
//  Created by Stefan Hintz on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResultController.h"
#import "RecordingController.h"
#import <GracenoteMusicID/GNCoverArt.h>

@interface ResultController ()

@end

@implementation ResultController

@synthesize trackName;
@synthesize artistName;
@synthesize imageView;
@synthesize addToDeezerButton;
@synthesize deezerStatus;

- (id)init
{
    self = [super initWithNibName:@"ResultController" bundle:nil];

    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    RecordingController* recordingController = (RecordingController *)[ self presentingViewController ];
    
    artistName.text = recordingController.gracenoteArtist;
    trackName.text = recordingController.gracenoteTrack;
    [self loadImagefromURL:recordingController.gracenoteCoverArt.data];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (IBAction)goBack:(id)sender
{
	NSLog(@"Back Button touched");
	
	NSNotification *notification = [NSNotification notificationWithName:@"BACKTOSTART" object:nil];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
	
//	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadImagefromURL:(NSData *)imageData
{
	[imageView setImage:[[UIImage alloc] initWithData:imageData]];
	imageView.hidden = NO;
}

- (IBAction)addToDeezer: (id)sender
{
    RecordingController* recordingController = (RecordingController *)[ self presentingViewController ];
    addToDeezerButton.hidden = YES;
    [recordingController.deezer addTrackWithController: self];
}

@end
