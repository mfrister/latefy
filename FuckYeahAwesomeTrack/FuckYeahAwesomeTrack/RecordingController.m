//
//  RecordingController.m
//  FuckYeahAwesomeTrack
//
//  Created by Stefan Hintz on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecordingController.h"

@interface RecordingController ()

@end

@implementation RecordingController

@synthesize gracenoteConfig;
@synthesize listeningView;

- (id)init
{
    self = [super initWithNibName:@"RecordingController" bundle:nil];
   
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
	self.gracenoteConfig = Gracenote.makeConfig;        

    NSLog(@"Fingerprint start");
    [Gracenote fingerprint: self];
}

- (void) setPercent:(CGFloat) percent
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	listeningView.percent = percent;
	[UIView commitAnimations];
}

@end
