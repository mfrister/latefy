//
//  ViewController.m
//  FuckYeahAwesomeTrack
//
//  Created by johan on 07.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Gracenote.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize config;
@synthesize button;
@synthesize deezerButton;
@synthesize trackName;
@synthesize artistName;
@synthesize deezer;
@synthesize listeningView;
@synthesize imageView;
@synthesize message;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	self.config = Gracenote.initConfig;        
	
	trackName.text = @"";
	artistName.text = @"";
	message.text = @"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (IBAction)listenToTheMusic:(id)sender 
{
	button.hidden = YES;
	imageView.hidden = YES;
	trackName.text = @"";
	artistName.text = @"";
	message.text = @"";
	[self setPercent:0];
	
	NSLog(@"Button touched");
    NSLog(@"Fingerprint start");

    [Gracenote fingerprint: self];

    //deezer = [[Deezer alloc] init];
    //[deezer addTrackWithArtist:@"Eminem" andTitle:@"My name is"];
}

- (IBAction)addToDeezer:(id)sender
{
	NSLog(@"Add to DEEZER Button touched");
}

- (void) setPercent:(CGFloat) percent
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	listeningView.percent = percent;
	[UIView commitAnimations];
}

- (void) loadImagefromURL:(NSData *)imageData
{
	[imageView setImage:[[UIImage alloc] initWithData:imageData]];
	imageView.hidden = NO;
}

@end
