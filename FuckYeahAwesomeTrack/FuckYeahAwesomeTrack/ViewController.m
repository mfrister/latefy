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

@synthesize config = m_config;
@synthesize button;
@synthesize trackName;
@synthesize deezer;

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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)listenToTheMusic:(id)sender 
{
	NSLog(@"Button touched");
    NSLog(@"Fingerprint start");

    [Gracenote fingerprint: self];

    //    deezer = [[Deezer alloc] init];
    //    [deezer authorize];
}

@end
