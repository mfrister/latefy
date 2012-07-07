//
//  Deezer.m
//  FuckYeahAwesomeTrack
//
//  Created by mf on 07.07.12.
//
//

#import "Deezer.h"
#import "libDeezer/DeezerConnect.h"
#import "Secrets.h"


#define DEEZER_TOKEN_KEY @"DeezerTokenKey"
#define DEEZER_EXPIRATION_DATE_KEY @"DeezerExpirationDateKey"
#define DEEZER_USER_ID_KEY @"DeezerUserId"

@implementation Deezer

@synthesize deezerConnect;
@synthesize query;

- (void)addTrackWithArtist: (NSString*) artist andTitle: (NSString*) title {
    [self authorize];
    query = [[NSString alloc] initWithFormat:@"%@ %@", artist, title];
}

- (void)findTrack {
    NSString* servicePath =@"search";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: query, @"q", nil];
    DeezerRequest* request = [deezerConnect createRequestWithServicePath:servicePath params: params delegate:self];
    [deezerConnect launchAsyncRequest:request];
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
    query = nil;
    NSLog(@"Deezer response");
}

- (void)request:(DeezerRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Deezer fail");
}

@end
