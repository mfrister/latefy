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
#import "RecordingController.h"

#define DEEZER_TOKEN_KEY @"DeezerTokenKey"
#define DEEZER_EXPIRATION_DATE_KEY @"DeezerExpirationDateKey"
#define DEEZER_USER_ID_KEY @"DeezerUserId"
#define PLAYLIST_TITLE @"Latefy"

@implementation Deezer

@synthesize deezerConnect;
@synthesize trackId;
@synthesize requestType;
@synthesize recordingController;

- (id)initWithRecordingController: (RecordingController *) controller
{
    self = [super init];
    if (self) {
        self.recordingController = controller;
    }
    return self;
}
- (void)addTrackWithArtist: (NSString*) artist andTitle: (NSString*) title {
//    query = [[NSString alloc] initWithFormat:@"%@ %@", artist, title];
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
    NSMutableArray* permissionsArray = [NSMutableArray arrayWithObjects:@"basic_access", @"manage_library", @"offline_access", nil];
    [deezerConnect authorize:permissionsArray];
}

- (void)findTrack:(NSString *)title withArtist: (NSString *)artist
{
    NSLog(@"Finding Track in deezer");
    NSString *query = [[NSString alloc] initWithFormat:@"%@ %@", artist, title];

    NSString *escapedQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat: @"http://api.deezer.com/2.0/search?output=json&request_method=GET&q=%@", escapedQuery];
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    [self handleFindTrackResponse:data];
}

- (void) handleFindTrackResponse:(NSData *)data {
    NSDictionary *response = [data objectFromJSONData];
    NSNumber *resultCount = [response objectForKey:@"total"];
    NSLog(@"Track count: %@", resultCount);
    if([resultCount intValue] == 0) {
        NSLog(@"Warning: No tracks found.");
        [recordingController failed:nil];
        return;
    }
    NSDictionary *track = [[response objectForKey:@"data"] objectAtIndex:0];
    trackId = [track objectForKey:@"id"];
    NSLog(@"Found track with ID: %@", trackId);
    [recordingController success:nil];
}

- (void) findPlaylist {
    requestType = DEEZER_FIND_PLAYLIST;
    [self request:@"/user/me/playlists" params: nil];
}

- (void) handleFindPlaylistResponse: (NSData*) data {
    NSDictionary *response = [data objectFromJSONData];
    NSArray *playlists = [response objectForKey:@"data"];

    NSUInteger ourPlaylistIndex = [playlists indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[(NSDictionary*)obj objectForKey:@"title"] isEqual: PLAYLIST_TITLE];
    }];

    if(ourPlaylistIndex == NSNotFound) {
        NSLog(@"Warning: playlist %@ not found", PLAYLIST_TITLE);
        [self createPlaylist];
        return;
    }
    NSString *playlistId = [[playlists objectAtIndex:ourPlaylistIndex] objectForKey:@"id"];

    NSLog(@"Got playlist with ID %@", playlistId);
    [self addTrackToPlaylistWithId:playlistId];
}

- (void)createPlaylist
{
    requestType = DEEZER_CREATE_PLAYLIST;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:PLAYLIST_TITLE, @"title", nil];
    [self postRequest:@"/user/me/playlists" params: params];
}

- (void)handleCreatePlaylistResponse:(NSData *)data
{
    NSDictionary *response = [data objectFromJSONData];
    NSString *playlistId = [response objectForKey:@"id"];
    NSLog(@"Added playlist with ID %@", playlistId);
    [self addTrackToPlaylistWithId:playlistId];
}

- (void) addTrackToPlaylistWithId:(NSString *)playlistId
{
    requestType = DEEZER_ADD_TRACK_TO_PLAYLIST;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: trackId, @"songs", nil];
    
    NSString *path = [[NSString alloc] initWithFormat:@"playlist/%@/tracks", playlistId];
    [self postRequest:path params:params];
}

- (void) handleAddTrackToPlaylistResponse:(NSData*)data
{
    NSLog(@"Yay! Track was probably added to a playlist.");
    // TODO
}

- (void)request: (NSString *)path params: (NSDictionary *) params {
    DeezerRequest* request = [deezerConnect createRequestWithServicePath:path params: params delegate:self];
    [deezerConnect launchAsyncRequest:request];
}

- (void)postRequest: (NSString *)path params: (NSDictionary *) params {
    DeezerRequest* request = [deezerConnect createRequestWithServicePath:path params:params httpMethod:HttpMethod_POST delegate:self];
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
    //[self findTrack];
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
        case DEEZER_FIND_PLAYLIST:
            [self handleFindPlaylistResponse:data];
            break;
        case DEEZER_CREATE_PLAYLIST:
            [self handleCreatePlaylistResponse:data];
            break;
        case DEEZER_ADD_TRACK_TO_PLAYLIST:
            [self handleAddTrackToPlaylistResponse:data];
            break;
        default:
            NSLog(@"request:didReceiveResponse: Error: unknown requestType");
    }
}

- (void)request:(DeezerRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Deezer fail");
}

@end
