//
//  RecordingController.m
//  FuckYeahAwesomeTrack
//
//  Created by Stefan Hintz on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecordingController.h"
#import "ResultController.h"

@interface RecordingController ()

@end

@implementation RecordingController

- (id)init
{
    self = [super initWithNibName:@"RecordingController" bundle:nil];

    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (IBAction)recordingFinished:(id)sender
{
	NSLog(@"Recording finished");
	
	UIViewController *controller = [[ResultController alloc] init];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	[self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)recordingFailed:(id)sender
{
	NSLog(@"Recording failed");
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
