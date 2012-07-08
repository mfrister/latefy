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
    NSString *message = status.message;;
	
    switch (status.status)
	{
        case GENERATING:
        case FINGERPRINTING:
        case WEBSERVICES:
            [controller setPercent:100.0];
            [controller startAnimation ];
            controller.navBar.topItem.title = @"Analyzing";
            break;
			
		case RECORDING:
            message = [NSString stringWithFormat: @"%@ %d@", status.message, status.percentDone];
            [controller setPercent:status.percentDone];
            [controller stopAnimation ];
            controller.navBar.topItem.title = @"Recording";
            break;
			
		default:
			// do nothing
			break;
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
            [controller failed: nil];
            
            //controller.trackName.text = @"Not Found :("; 
            
//            [ controller 
//             sendTrackToDeezerWithArtist: @"Absolute Beginner"
//             withTitle: @"Liebes Lied"
//            ];
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

            [controller findTrackInDeezerWithArtist: best.artist withTitle: best.trackTitle withCover: coverArt];
            
//            controller.trackName.text = best.artist;
//            [controller loadImagefromURL:coverArt.data];
//			
//            controller.trackName.text = best.trackTitle;
//            controller.artistName.text = best.artist;
//            
//            [ controller 
//                sendTrackToDeezerWithArtist: best.artist
//                withTitle: best.trackTitle
//            ];
        }
    }
	
    NSLog(@"%@", result);
}

@end

@implementation Gracenote

+ (GNConfig *)makeConfig
{
	GNConfig *config = [GNConfig init:GRACENOTE_CLIENT_ID];
	
	[config setProperty: @"debugEnabled" value:@"1"];
	[config setProperty: @"content.musicId.queryPreference.singleBestMatch" value:@"true"];
	[config setProperty: @"content.coverArt" value:@"true"];
	[config setProperty: @"content.coverArt.sizePreference" value:@"MEDIUM"];
	
	return config;
}

+ (void) fingerprint: (RecordingController *)controller
{
	// Create result-ready object to receive recognition result
	SearchResultsStatusReady *searchResultReady = [SearchResultsStatusReady alloc];
	searchResultReady.controller = controller;
	// Invoke recognition operation
	[GNOperations recognizeMIDStreamFromMic: searchResultReady config:controller.gracenoteConfig];
}

@end
