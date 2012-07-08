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

- (IBAction)success:(id)sender
{
	NSLog(@"Successfull found track");
	
	UIViewController *controller = [[ResultController alloc] init];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	[self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)failed:(id)sender
{
	NSLog(@"Failed track finding");
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
