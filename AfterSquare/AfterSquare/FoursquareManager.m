//
//  TwitterManager.m
//  Copyright (c) 2015 Cheshire. All rights reserved.
//
//#import "ParseHelper.h"
//#import "NSString+StringUrlEncode.h"
#import "Constant.h"
#import <AFNetworking.h>
#import "FoursquareManager.h"

@implementation FoursquareManager
{
    AFHTTPRequestOperationManager *manager;
    NSString *bearerToken;
    NSMutableDictionary *tweetsDict;
}

+(id)sharedManager
{
    static FoursquareManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

-(id)init
{
    if (self = [super init]) {
        
        manager = [[AFHTTPRequestOperationManager manager]initWithBaseURL:[NSURL URLWithString:@"https://api.foursquare.com/v2/"]];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:0];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        bearerToken = [NSString new];
//        tweetsDict = [NSMutableDictionary new];
    }
    return self;
}

-(void)fsAuthorize
{

//    NSString *bearerKey = [NSString stringWithFormat:@"%@:%@",TW_CONS_KEY,TW_CONS_SECRET];
//    NSData *authData = [bearerKey dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *authString = [NSString stringWithFormat:@"Basic %@",[authData base64EncodedStringWithOptions:0]];
//    NSMutableDictionary *params = [NSMutableDictionary new];
//        params[@"grant_type"] = @"client_credentials";
//
//    [manager.requestSerializer setValue:authString forHTTPHeaderField:@"Authorization"];
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [manager POST:@"oauth2/token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Login complete wit object -> %@", responseObject);
//        bearerToken = [NSString stringWithFormat:@"Bearer %@",[responseObject objectForKey:@"access_token"]];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Login failure with error -> %@", error);
//    }];

    
    
}

-(void)searchNearLocations
{
//    NSString *urlString = @"1.1/search/tweets.json?";
//    NSString *requstURLString = [NSString new];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"ll"] = @"44.3,37.2";
    params[@"near"] = @"Chicago, IL";
    params[@"limit"] = @"10";
    params[@"intent"] = @"browse";
    params[@"radisu"] = @"800";
    params[@"client_id"] = FS_CLIENT_ID;
    params[@"client_secret"] = FS_CLIENT_SECRET;
    params[@"v"] = [self getCurrentDate];

//    for (NSString *key in params) {
//        NSString *param = [params[key] urlencode];
//        requstURLString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,param ] ];
//        urlString = [NSString stringWithFormat:@"%@&",requstURLString];
//    }
//    
//    [manager.requestSerializer setValue:bearerToken forHTTPHeaderField:@"Authorization"];
    [manager GET:@"venues/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Operation complete");
//        [[NSNotificationCenter defaultCenter]postNotificationName:TW_MAP_GETTING object:[NSArray arrayWithObjects:responseObject[@"statuses"],tag, nil]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failure");
    }];
}

-(NSString*)getCurrentDate
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYYMMDD"];
    return [formatter stringFromDate:[NSDate date]];
}

@end
