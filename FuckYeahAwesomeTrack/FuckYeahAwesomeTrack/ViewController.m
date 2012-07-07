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
#import <GracenoteMusicID/GNSearchResult.h>
#import <GracenoteMusicID/GNSearchResultReady.h>
#import <GracenoteMusicID/GNSearchResponse.h>
#import <GracenoteMusicID/GNOperations.h>

@interface ViewController ()

@end

// Result-ready object implements GNSearchResultReady protocol
@ interface ApplicationSearchResultReady : NSObject <GNSearchResultReady>
{
}
@end

// Provide implementation for GNResultReady method
@ implementation ApplicationSearchResultReady
- (void) GNResultReady: (GNSearchResult*) result
{
    if ([result isFailure]) {
        NSLog(@"Error %d %@", result.errCode, result.errMessage); 
    } else {
        if ([result isAnySearchNoMatchStatus]) {
            NSLog(@"NO_MATCH\n");
        } else {
            GNSearchResponse *best = [result bestResponse];
            
            NSLog(@"Artist: %@", best.artist);
            if (best.artistYomi != nil) {
                NSLog(@"%@", best.artistYomi);
            }
            NSLog(@"1");
        }
    }

    NSLog(@"%@", result);
}
@end

@implementation ViewController

@synthesize config = m_config;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	self.config = [GNConfig init:@"3675392-79DAB14D8D37690935E637F6B45BCCB8"];

    [self.config setProperty: @"debugEnabled" value: @"1"];
    
	//RecognizeFromMicOperation *op = [RecognizeFromMicOperation recognizeFromMicOperation:self.config];
	//[GNOperations recognizeMIDStreamFromMic:op config:self.config];    
    
    NSLog(@"Fingerprint start");
    
    // Create result-ready object to receive recognition result
    ApplicationSearchResultReady *searchResultReady = [ApplicationSearchResultReady alloc];
    // Invoke recognition operation
    [GNOperations recognizeMIDStreamFromMic: searchResultReady config: self.config];
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

@end
