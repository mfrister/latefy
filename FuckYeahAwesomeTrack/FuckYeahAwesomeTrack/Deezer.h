//
//  Deezer.h
//  FuckYeahAwesomeTrack
//
//  Created by mf on 07.07.12.
//
//

#import <Foundation/Foundation.h>
#import "libDeezer/DeezerConnect.h"

@interface Deezer : NSObject<DeezerSessionDelegate, DeezerRequestDelegate>

@property (nonatomic, retain) DeezerConnect *deezerConnect;

- (void)authorize;

- (void)retrieveTokenAndExpirationDate;
- (void)saveTokenAndExpirationDate;

- (void)deezerDidLogin;
- (void)deezerDidNotLogin:(BOOL) cancelled;
- (void)deezerDidLogout;
@end
