//
//  ViewController.h
//  FuckYeahAwesomeTrack
//
//  Created by johan on 07.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GNConfig;

@interface ViewController : UIViewController {

  GNConfig *m_config;
}

@property (nonatomic, retain) GNConfig *config;

@end
