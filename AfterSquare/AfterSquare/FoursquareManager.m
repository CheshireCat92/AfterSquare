//
//  FoursquareManager.m
//  Copyright (c) 2015 Cheshire. All rights reserved.
//
//#import "ParseHelper.h"
//#import "NSString+StringUrlEncode.h"
#import "DataHelper.h"
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
    }
    return self;
}

-(void)fsAuthorize
{

}

-(void)searchLocationsNearLocation:(CLPlacemark *)place
{
    
    if (place == nil) {
        
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"ll"] = [NSString stringWithFormat:@"%f,%f",place.location.coordinate.latitude,place.location.coordinate.longitude];
    params[@"near"] = [NSString stringWithFormat:@"%@ %@",place.locality,place.administrativeArea];
    params[@"limit"] = @"50";
    params[@"intent"] = @"browse";
    params[@"radius"] = @"800";
    params[@"client_id"] = FS_CLIENT_ID;
    params[@"client_secret"] = FS_CLIENT_SECRET;
    params[@"v"] = [self getCurrentDateStampWithFormat:place.location.timestamp];

    [manager GET:@"venues/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Operation complete");
        [[DataHelper sharedManager] saveFsPlacesData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failure");
    }];
}

-(NSString*)getCurrentDateStampWithFormat:(NSDate*) dateStamp
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYYMMDD"];
    return [formatter stringFromDate:dateStamp];
}

//-(void)startCheckConnection{
////    BOOL result;
//    NSOperationQueue *operationQueue = manager.operationQueue;
//    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                [operationQueue setSuspended:NO];
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//            default:
//                [operationQueue setSuspended:YES];
//                break;
//        }
//    }];
//    [manager.reachabilityManager startMonitoring];
//}
//
//-(BOOL)isConnected{
//    return manager.reachabilityManager.reachable;
//};

@end
