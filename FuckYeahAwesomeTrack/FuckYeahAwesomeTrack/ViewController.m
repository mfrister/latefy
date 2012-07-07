//
//  ViewController.m
//  FuckYeahAwesomeTrack
//
//  Created by johan on 07.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import <GracenoteMusicID/GNConfig.h>
#import <GracenoteMusicID/GNUtil.h>
#import <GracenoteMusicID/GNOperations.h>

#import "Gracenote.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize config = m_config;
@synthesize button;
@synthesize trackName;
@synthesize deezer;
@synthesize listeningView;
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	self.config = [GNConfig init:@"3675392-79DAB14D8D37690935E637F6B45BCCB8"];

    [self.config setProperty: @"debugEnabled" value: @"1"];
    
	//RecognizeFromMicOperation *op = [RecognizeFromMicOperation recognizeFromMicOperation:self.config];
	//[GNOperations recognizeMIDStreamFromMic:op config:self.config];    
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

    // Create result-ready object to receive recognition result
    SearchResultsStatusReady *searchResultReady = [SearchResultsStatusReady alloc];
    searchResultReady.controller = self;
    // Invoke recognition operation
    [GNOperations recognizeMIDStreamFromMic: searchResultReady config: self.config];

//    deezer = [[Deezer alloc] init];
//    [deezer authorize];
}

- (void) setPercent:(CGFloat) percent
{
	listeningView.percent = percent;
}

- (void) loadImagefromURL:(NSString *)imageURL
{
	NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageURL]];

	UIImage *image = [[UIImage alloc] initWithData:imageData];
	[imageView setImage:image];
}

@end
