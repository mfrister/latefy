//
//  StartControllerViewController.m
//  FuckYeahAwesomeTrack
//
//  Created by Stefan Hintz on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartController.h"

@interface StartController ()

@end

@implementation StartController

- (id)init
{
    self = [super initWithNibName:@"StartController" bundle:nil];

    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)start:(id)sender
{
	NSLog(@"Start Button touched");
}

@end
