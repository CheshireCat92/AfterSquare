//
//  LocationManager.m
//  AfterSquare
//
//  Created by Cheshire on 06.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//


#import "LocationManager.h"

@implementation LocationManager
{
    CLLocationManager *manager;
    CLLocation *currentLocation;
    CLGeocoder *geocoder;
    
}

+(id)sharedManager
{
    static LocationManager *shared;
    static dispatch_once_t locationToken;
    dispatch_once(&locationToken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}


-(void)setupLocationUpdates
{
    if (!manager){
        manager = [[CLLocationManager alloc]init];
    }
    if (!geocoder)
    {
        geocoder = [CLGeocoder new];
    }
    currentLocation = [CLLocation new];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyKilometer;
    manager.distanceFilter = 300;//300 meters
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [manager requestWhenInUseAuthorization];
    }
    
    [manager startUpdatingLocation];
}

-(void)startLocationUpdate
{
    [self setupLocationUpdates];
}

-(void)getGeolocationPermissions
{
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            [manager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusDenied:
            [manager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
            [manager requestWhenInUseAuthorization];
        default:
            break;
    }
}



-(CLLocation *)getUserLocation
{
    return currentLocation;
}

-(void)setUserLocation:(CLLocation *)location
{
    currentLocation = location;
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if  (status != kCLAuthorizationStatusAuthorizedWhenInUse && status != kCLAuthorizationStatusAuthorizedAlways)
    {
        [self getGeolocationPermissions ];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlertView = [[UIAlertView alloc]initWithTitle:@"Same Error" message:@"Failed to get Location" delegate:nil cancelButtonTitle:@"OK =(" otherButtonTitles: nil];
    [errorAlertView show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self setUserLocation:[locations lastObject ] ];
    CLLocationAccuracy accuracy = [currentLocation horizontalAccuracy ];
    NSLog(@"last locations is -> %@ accuracy is -> %f", currentLocation,accuracy);
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count ==1) {
             [[NSNotificationCenter defaultCenter]postNotificationName:CL_CURENT_LOC object:[placemarks lastObject] ] ;
        };
    }];
}


@end
