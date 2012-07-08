//
//  RecordingController.h
//  FuckYeahAwesomeTrack
//
//  Created by Stefan Hintz on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListeningView.h"
#import "Gracenote.h"
#import "Deezer.h"

@class GNConfig;
@class Deezer;

@interface RecordingController : UIViewController
{
}

- (IBAction)success:(id)sender;
- (IBAction)failed:(id)sender;
- (void) setPercent:(CGFloat) percent;
- (void) findTrackInDeezerWithArtist:(NSString *)artist withTitle:(NSString *)title;

@property (nonatomic, retain) GNConfig *gracenoteConfig;
@property (nonatomic, retain) Deezer *deezer;
@property (nonatomic, retain) IBOutlet ListeningView *listeningView;
@property (nonatomic, retain) NSTimer *timer;

@end
