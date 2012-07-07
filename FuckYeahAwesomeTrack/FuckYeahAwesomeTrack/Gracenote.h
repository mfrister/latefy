//
//  Gracenote.h
//  FuckYeahAwesomeTrack
//
//  Created by johan on 07.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GracenoteMusicID/GNSearchResponse.h>
#import <GracenoteMusicID/GNOperationStatusChanged.h>
#import <GracenoteMusicID/GNSearchResultReady.h>
#import "ViewController.h"

@interface Gracenote : NSObject

@end

// Result-ready object implements GNSearchResultReady and
// GNOperationStatusChanged protocols
@interface SearchResultsStatusReady : NSObject <GNSearchResultReady, GNOperationStatusChanged>
{
}
@property (nonatomic, assign) ViewController *controller;
@end
