//
//  Deezer.m
//  FuckYeahAwesomeTrack
//
//  Created by mf on 07.07.12.
//
//

#import "JSONKit.h"
#import "libDeezer/DeezerConnect.h"
#import "Deezer.h"
#import "Secrets.h"

#define DEEZER_TOKEN_KEY @"DeezerTokenKey"
#define DEEZER_EXPIRATION_DATE_KEY @"DeezerExpirationDateKey"
#define DEEZER_USER_ID_KEY @"DeezerUserId"

@implementation Deezer

@synthesize deezerConnect;
@synthesize query;
@synthesize trackId;
@synthesize requestType;

- (void)addTrackWithArtist: (NSString*) artist andTitle: (NSString*) title {
    query = [[NSString alloc] initWithFormat:@"%@ %@", artist, title];
    [self authorize];
}

-(void) authorize {
    if(!deezerConnect) {
        deezerConnect = [[DeezerConnect alloc] initWithAppId:DEEZER_APP_ID andDelegate: self];
        [self retrieveTokenAndExpirationDate];
    }
    if([deezerConnect isSessionValid]) {
        [self deezerDidLogin];
        return;
    }
    NSLog(@"Deezer authorize");
    NSMutableArray* permissionsArray = [NSMutableArray arrayWithObjects:@"basic_access", @"manage_library", nil];
    [deezerConnect authorize:permissionsArray];
}

- (void)findTrack {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: query, @"q", nil];
    requestType = DEEZER_FIND_TRACK;
    [self request: @"search" params: params];
}

- (void) handleFindTrackResponse:(NSData *)data {
    query = nil;
    NSDictionary *response = [data objectFromJSONData];
    NSNumber *resultCount = [response objectForKey:@"total"];
    NSLog(@"Track count: %@", resultCount);
    if([resultCount intValue] == 0) {
        NSLog(@"Warning: No tracks found.");
        // TODO display some message
        return;
    }
    NSDictionary *track = [[response objectForKey:@"data"] objectAtIndex:0];
    trackId = [track objectForKey:@"id"];
    NSLog(@"Found track with ID: %@", trackId);
    [self findPlaylist];
}

- (void) findPlaylist {
    requestType = DEEZER_FIND_PLAYLIST;
    [self request:@"/user/me/playlists" params: nil];
}

- (void) handleFindPlaylistResponse: (NSData*) data {
    NSDictionary *response = [data objectFromJSONData];
    if([[response objectForKey:@"total"] intValue] == 0) {
        NSLog(@"Warning: no playlist found");
        return;
    }
    NSString *playlistId = [[[response objectForKey:@"data"]
                                objectAtIndex:0]
                                    objectForKey: @"id"];
    NSLog(@"Got playlist with ID %@", playlistId);
    [self addTrackToPlaylistWithId: playlistId];
}

- (void) addTrackToPlaylistWithId:(NSString *)playlistId {
    requestType = DEEZER_ADD_TRACK_TO_PLAYLIST;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: trackId, @"songs", nil];
    
    NSString *path = [[NSString alloc] initWithFormat:@"playlist/%@/tracks", playlistId];
    DeezerRequest* request = [deezerConnect createRequestWithServicePath:path params:params httpMethod:HttpMethod_POST delegate:self];
    [deezerConnect launchAsyncRequest:request];
}

- (void) handleAddTrackToPlaylistResponse: (NSData*)data {
    NSLog(@"Yay! Track was probably added to a playlist.");
    // TODO
}

- (void)request: (NSString *)path params: (NSDictionary*) params {
    DeezerRequest* request = [deezerConnect createRequestWithServicePath:path params: params delegate:self];
    [deezerConnect launchAsyncRequest:request];
}

- (void)retrieveTokenAndExpirationDate {
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [deezerConnect setAccessToken:[standardUserDefaults objectForKey:DEEZER_TOKEN_KEY]];
    [deezerConnect setExpirationDate:[standardUserDefaults objectForKey:DEEZER_EXPIRATION_DATE_KEY]];
    [deezerConnect setUserId:[standardUserDefaults objectForKey:DEEZER_USER_ID_KEY]];
}

- (void)saveTokenAndExpirationDate {
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:[deezerConnect accessToken] forKey:DEEZER_TOKEN_KEY];
    [standardUserDefaults setObject:[deezerConnect expirationDate] forKey:DEEZER_EXPIRATION_DATE_KEY];
    [standardUserDefaults setObject:[deezerConnect userId] forKey:DEEZER_USER_ID_KEY];
    [standardUserDefaults synchronize];
}

- (void)deezerDidLogin {
    NSLog(@"Deezer did login");
    [self saveTokenAndExpirationDate];
    [self findTrack];
}

- (void)deezerDidNotLogin:(BOOL)cancelled {
    NSLog(@"Deezer Did not login %@", cancelled ? @"Cancelled" : @"Not Cancelled");
}

- (void)deezerDidLogout {
    NSLog(@"Deezer Did logout");
}

- (void)request:(DeezerRequest *)request didReceiveResponse:(NSData *)data {
    NSLog(@"Deezer response");
    switch(requestType) {
        case DEEZER_FIND_TRACK:
            [self handleFindTrackResponse: data];
            break;
        case DEEZER_FIND_PLAYLIST:
            [self handleFindPlaylistResponse: data];
            break;
        case DEEZER_ADD_TRACK_TO_PLAYLIST:
            [self handleAddTrackToPlaylistResponse: data];
            break;
        default:
            NSLog(@"request:didReceiveResponse: Error: unknown requestType");
    }
}

- (void)request:(DeezerRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Deezer fail");
}

@end
