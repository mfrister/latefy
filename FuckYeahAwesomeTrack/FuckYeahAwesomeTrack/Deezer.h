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
// 
@property (nonatomic, retain) NSString *query;

- (void)addTrackWithArtist: (NSString*) artist andTitle: (NSString*) title;
- (void)authorize;
- (void)handleSearchResponse: (NSData*)data;
//- (void)findPlaylist;
//- (void)handleFindResponse
//- (void)addTrackWithId: (NSString*) trackId;

- (void)retrieveTokenAndExpirationDate;
- (void)saveTokenAndExpirationDate;

- (void)deezerDidLogin;
- (void)deezerDidNotLogin:(BOOL) cancelled;
- (void)deezerDidLogout;
@end
