//
//  ListeningView.h
//  FuckYeahAwesomeTrack
//
//  Created by Stefan Hintz on 07.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListeningView : UIView

// 0 .. 100
@property (nonatomic, assign) CGFloat percent;

// 0 .. 1
@property (nonatomic, assign) CGFloat sizeFactor;

@end
