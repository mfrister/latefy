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

@class GNConfig;

@interface RecordingController : UIViewController
{
}

- (void) setPercent:(CGFloat) percent;

@property (nonatomic, retain) GNConfig *gracenoteConfig;
@property (nonatomic, retain) IBOutlet ListeningView *listeningView;
@end
