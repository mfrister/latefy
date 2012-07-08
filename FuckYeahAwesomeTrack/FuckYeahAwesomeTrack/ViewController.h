//
//  ViewController.h
//  FuckYeahAwesomeTrack
//
//  Created by johan on 07.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "deezer.h"
#import "ListeningView.h"

@class GNConfig;

@interface ViewController : UIViewController 
{
}

- (void) setPercent:(CGFloat) percent;
- (void) loadImagefromURL:(NSData *)imageData;
- (void) sendTrackToDeezerWithArtist:(NSString *)artist withTitle:(NSString *)title;

@property (nonatomic, retain) GNConfig *config;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UIButton *deezerButton;
@property (nonatomic, retain) IBOutlet UILabel *trackName;
@property (nonatomic, retain) IBOutlet UILabel *artistName;
@property (nonatomic, retain) IBOutlet UILabel *message;
@property (nonatomic, retain) Deezer *deezer;
@property (nonatomic, retain) IBOutlet ListeningView *listeningView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@end
