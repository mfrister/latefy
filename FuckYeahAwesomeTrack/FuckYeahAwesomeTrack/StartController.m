//
//  StartController.m
//  FuckYeahAwesomeTrack
//
//  Created by Stefan Hintz on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartController.h"
#import "RecordingController.h"

@interface StartController ()

@end

@implementation StartController

@synthesize errorLabel;

- (id)init
{
    self = [super initWithNibName:@"StartController" bundle:nil];
	if (self)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"BACKTOSTART" object:nil];

	}

    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (IBAction)start:(id)sender
{
	NSLog(@"Start Button touched");
	
	self.errorLabel.hidden = YES;
	
	UIViewController *controller = [[RecordingController alloc] init];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	[self presentViewController:controller animated:YES completion:nil];
}

-(void)dismiss
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
