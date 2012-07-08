//
//  Deezer.h
//  FuckYeahAwesomeTrack
//
//  Created by mf on 07.07.12.
//
//

#import <Foundation/Foundation.h>
#import "libDeezer/DeezerConnect.h"
#import "RecordingController.h"

@class RecordingController;

// values for requestType
#define DEEZER_FIND_TRACK 1
#define DEEZER_FIND_PLAYLIST 2
#define DEEZER_ADD_TRACK_TO_PLAYLIST 3

@interface Deezer : NSObject<DeezerSessionDelegate, DeezerRequestDelegate>

@property (nonatomic, retain) DeezerConnect *deezerConnect;

@property (nonatomic, retain) NSString *query;
@property (nonatomic, retain) NSString *trackId;
@property (nonatomic) int requestType;
@property (nonatomic, assign) RecordingController *recordingController;

- (id)initWithRecordingController: (RecordingController *) controller;
- (void)addTrackWithArtist: (NSString*) artist andTitle: (NSString*) title;
- (void)authorize;
- (void)findTrack:(NSString *)title withArtist: (NSString *)artist;
- (void)handleFindTrackResponse: (NSData*)data;
- (void)findPlaylist;
- (void)handleFindPlaylistResponse: (NSData*) data;
- (void)addTrackToPlaylistWithId: (NSString*) playlistId;
- (void)handleAddTrackToPlaylistResponse: (NSData*) data;

- (void)retrieveTokenAndExpirationDate;
- (void)saveTokenAndExpirationDate;

- (void)deezerDidLogin;
- (void)deezerDidNotLogin:(BOOL) cancelled;
- (void)deezerDidLogout;
@end
