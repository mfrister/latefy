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
@synthesize trackName;
@synthesize artistName;
@synthesize albumName;
@synthesize deezer;
@synthesize listeningView;
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	self.config = Gracenote.initConfig;        
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
	
	NSLog(@"Button touched");
    NSLog(@"Fingerprint start");

    [Gracenote fingerprint: self];

    //deezer = [[Deezer alloc] init];
    //[deezer addTrackWithArtist:@"Eminem" andTitle:@"My name is"];
}

- (void) setPercent:(CGFloat) percent
{
	listeningView.percent = percent;
}

- (void) loadImagefromURL:(NSData *) imageData
{
	UIImage *image = [[UIImage alloc] initWithData:imageData];
	[imageView setImage:image];

}

@end
