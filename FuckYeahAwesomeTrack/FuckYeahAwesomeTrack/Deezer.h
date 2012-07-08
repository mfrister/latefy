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
#define DEEZER_FIND_PLAYLIST 2
#define DEEZER_CREATE_PLAYLIST 3  // optional step if playlist doesn't exist
#define DEEZER_ADD_TRACK_TO_PLAYLIST 4

@interface Deezer : NSObject<DeezerSessionDelegate, DeezerRequestDelegate>

@property (nonatomic, retain) DeezerConnect *deezerConnect;

@property (nonatomic, retain) NSString *trackId;
@property (nonatomic) int requestType;
@property (nonatomic, assign) RecordingController *recordingController;

- (id)initWithRecordingController: (RecordingController *) controller;
- (void)addTrack;
- (void)authorize;
- (void)findTrack:(NSString *)title withArtist: (NSString *)artist;
- (void)handleFindTrackResponse: (NSData*)data;
- (void)findPlaylist;
- (void)handleFindPlaylistResponse: (NSData*) data;
- (void)createPlaylist;
- (void)handleCreatePlaylistResponse: (NSData*) data;
- (void)addTrackToPlaylistWithId: (NSString*) playlistId;
- (void)handleAddTrackToPlaylistResponse: (NSData*) data;

- (void)retrieveTokenAndExpirationDate;
- (void)saveTokenAndExpirationDate;

- (void)deezerDidLogin;
- (void)deezerDidNotLogin:(BOOL) cancelled;
- (void)deezerDidLogout;
@end
