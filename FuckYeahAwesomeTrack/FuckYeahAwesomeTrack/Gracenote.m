//
//  Gracenote.m
//  FuckYeahAwesomeTrack
//
//  Created by johan on 07.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Gracenote.h"
#import "Secrets.h"

#import <GracenoteMusicID/GNConfig.h>
#import <GracenoteMusicID/GNStatus.h>
#import <GracenoteMusicID/GNSearchResult.h>
#import <GracenoteMusicID/GNCoverArt.h>
#import <GracenoteMusicID/GNUtil.h>
#import <GracenoteMusicID/GNOperations.h>

// Provide implementation for GNOperationStatusChanged method
@implementation SearchResultsStatusReady

@synthesize controller;

// Method to handle the status changed updates from the operation
- (void) GNStatusChanged:(GNStatus *)status
{
    NSString *message;
	
    if (status.status == RECORDING)
    {
        message = [NSString stringWithFormat: @"%@ %d@", status.message, status.percentDone, @"%"];
        [controller setPercent:status.percentDone];
    }
    else 
	{
        message = status.message;
    }
    
	NSLog(@"%@", message);
}

// Method to handle result returned from operation
- (void) GNResultReady: (GNSearchResult *)result
{
    if ([result isFailure]) 
	{
        NSLog(@"Error %d %@", result.errCode, result.errMessage); 
    }
	else
	{
        if ([result isAnySearchNoMatchStatus]) 
		{
            NSLog(@"NO_MATCH\n");
            controller.trackName.text = @"Not Found :(";            
        }
		else 
		{
            GNSearchResponse *best = [result bestResponse];
            
            NSLog(@"Artist: %@", best.artist);
            NSLog(@"Track: %@", best.trackTitle);
            NSLog(@"Album: %@", best.albumTitle);
            NSLog(@"AlbumReleaseYear: %@", best.albumReleaseYear);
            NSLog(@"Art: %@", best.coverArt);
            
            GNCoverArt *coverArt = best.coverArt;
            NSLog(@"ArtURL: %@", coverArt.url);
            
            controller.trackName.text = best.artist;
            [controller loadImagefromURL:coverArt.data];
			
            controller.trackName.text = best.trackTitle;
            controller.artistName.text = best.artist;
            controller.albumName.text = [NSString stringWithFormat:@"%@ (%@)",
										 best.albumTitle,
										 best.albumReleaseYear];
        }
    }
	
    NSLog(@"%@", result);
	
	controller.button.hidden = NO;
}

@end

@implementation Gracenote

+ (GNConfig *)initConfig
{
	GNConfig *config = [GNConfig init:GRACENOTE_CLIENT_ID];
	
	[config setProperty: @"debugEnabled" value:@"1"];
	[config setProperty: @"content.musicId.queryPreference.singleBestMatch" value:@"true"];
	[config setProperty: @"content.coverArt" value:@"true"];
	[config setProperty: @"content.coverArt.sizePreference" value:@"medium, small"];            
	
	return config;
}

+ (void) fingerprint: (ViewController *)controller
{
	// Create result-ready object to receive recognition result
	SearchResultsStatusReady *searchResultReady = [SearchResultsStatusReady alloc];
	searchResultReady.controller = controller;
	// Invoke recognition operation
	[GNOperations recognizeMIDStreamFromMic: searchResultReady config:controller.config];
}

@end
