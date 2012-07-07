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
#import <GracenoteMusicID/GNOperationStatusChanged.h>
#import <GracenoteMusicID/GNStatus.h>

@interface ViewController ()

@end

// Result-ready object implements GNSearchResultReady and
// GNOperationStatusChanged protocols
@ interface SearchResultsStatusReady : NSObject <GNSearchResultReady, GNOperationStatusChanged>
{
}
@ end

// Provide implementation for GNOperationStatusChanged method
@ implementation SearchResultsStatusReady
// Method to handle the status changed updates from the operation
- (void) GNStatusChanged: (GNStatus*) status
{
    NSString* msg;
    
    if (status.status == RECORDING)
    {
        msg = [NSString stringWithFormat: @"%@ %d@", status.message, status.percentDone, @"%"];
    }
    else {
        msg = status.message;
    }
    NSLog(@"%@", msg);
}

// Method to handle result returned from operation
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
@synthesize button;
@synthesize trackName;

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
    SearchResultsStatusReady *searchResultReady = [SearchResultsStatusReady alloc];
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

- (IBAction)listenToTheMusic:(id)sender 
{
	NSLog(@"Button touched");
}

@end
