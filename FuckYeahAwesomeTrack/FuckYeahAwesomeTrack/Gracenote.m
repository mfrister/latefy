//
//  Gracenote.m
//  FuckYeahAwesomeTrack
//
//  Created by johan on 07.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Gracenote.h"
#import <GracenoteMusicID/GNStatus.h>
#import <GracenoteMusicID/GNSearchResult.h>

// Provide implementation for GNOperationStatusChanged method
@implementation SearchResultsStatusReady

@synthesize controller;

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
            
            controller.trackName.text = best.artist;
        }
    }

    NSLog(@"%@", result);
}
@end

@implementation Gracenote

@end
