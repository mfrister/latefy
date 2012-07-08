//
//  ResultController.m
//  FuckYeahAwesomeTrack
//
//  Created by Stefan Hintz on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResultController.h"

@interface ResultController ()

@end

@implementation ResultController

- (id)init
{
    self = [super initWithNibName:@"ResultController" bundle:nil];

    return self;
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

@end
