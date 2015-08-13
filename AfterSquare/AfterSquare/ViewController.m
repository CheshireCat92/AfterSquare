//
//  ViewController.m
//  AfterSquare
//
//  Created by Cheshire on 04.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//
#import <Reachability.h>
#import "MapViewController.h"
#import "Place.h"
#import "PlaceDetails.h"
#import "LocationCell.h"
#import "NSObject+PerformSelectorWithCallback.h"
#import "DataHelper.h"
#import "FoursquareManager.h"
#import "ViewController.h"
@interface ViewController ()
{
    NSMutableArray *placeMap;
    UIRefreshControl *refresher;
    
    CLLocationManager *localManager;
    CLGeocoder *geocoder;
    Reachability *networkReachable;
}
@end

@implementation ViewController
@synthesize placeTableView;
@synthesize activityIndicator;
@synthesize showAllPlaces;
@synthesize currentLocation;

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkNetworkAvailable];
    showAllPlaces.enabled = NO;
    refresher = [[UIRefreshControl alloc]init];
    [refresher addTarget:self action:@selector(updatePlaceData:) forControlEvents:UIControlEventValueChanged];
    [placeTableView addSubview:refresher];
    [self startLocationUpdate];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlaceMap) name:CL_MAP_CREATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)setPlaceMap
{
    placeMap = [[DataHelper sharedManager ]getPlaceMap];
    if (placeMap) {
        showAllPlaces.enabled = YES;
        [placeTableView reloadData];
    }
    [self stopLocationUpdate];
}

-(void)stopLocationUpdate{
    [activityIndicator stopAnimating];
    [refresher endRefreshing];
    [localManager stopUpdatingLocation];
}

#pragma mark - TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return placeMap.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_ID];
    if (!cell) {
        cell = [[LocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSE_ID];
    }
    Place *samePlace = placeMap[indexPath.row];
    [cell.placeName setText:samePlace.name ];
    [cell.placeCategory setText:samePlace.category];
    [cell.placeDistance setText:samePlace.distance];
    
    return cell;
}

#pragma mark - Refresh Controller

-(void)updatePlaceData:(UIRefreshControl *)refreshControl
{
    if  ([networkReachable currentReachabilityStatus] == ReachableViaWWAN || [networkReachable currentReachabilityStatus] == ReachableViaWiFi){
        [self startLocationUpdate];
    }else{
        [self stopLocationUpdate];
    }
}

#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Seg started");
    MapViewController *upcomingMapView = segue.destinationViewController;
    if ([sender isKindOfClass:[UIButton class]]) {
        NSLog(@"show all places");
        upcomingMapView.placeMap = placeMap;
    }else{
        NSIndexPath *indexPath = [self.placeTableView indexPathForSelectedRow];
        Place *samePlace = placeMap[indexPath.row];
        upcomingMapView.samePlace = samePlace;
    }
}

#pragma mark - Location


-(void)setupLocationUpdates
{
    if (!localManager){
        localManager = [[CLLocationManager alloc]init];
        localManager.delegate = self;
        localManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        localManager.distanceFilter = 300;//300 meters
    }
    if (!geocoder)
    {
        geocoder = [CLGeocoder new];
    }
    if  (!currentLocation) {
        currentLocation = [CLLocation new];
    }
    [localManager startUpdatingLocation];
}

-(void)startLocationUpdate
{
    [refresher beginRefreshing];
    [self setupLocationUpdates];
}

-(void)getGeolocationPermissions
{
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            [localManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusDenied:
            [localManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
            [localManager requestWhenInUseAuthorization];
        default:
            break;
    }
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
    [self stopLocationUpdate];
    [localManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    currentLocation = [locations lastObject ];
    [manager stopUpdatingLocation];
    CLLocationAccuracy accuracy = [currentLocation horizontalAccuracy ];
    NSLog(@"last locations is -> %@ accuracy is -> %f", currentLocation,accuracy);
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count ==1) {
             [[FoursquareManager sharedManager]searchLocationsNearLocation:[placemarks lastObject]];
        };
    }];
}

#pragma mark - Network

-(void)checkNetworkAvailable{
    networkReachable = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    networkReachable.reachableBlock = ^(Reachability *reach){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Internet connection are stable");
        });
    };
    networkReachable.unreachableBlock = ^(Reachability *reach){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *errorAlertView = [[UIAlertView alloc]initWithTitle:@"Internet connection is lost" message:@"Please turn on internet connection for proper application" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [errorAlertView show];
            NSLog(@"Internet connection are closed");
        });
    };
    
    [networkReachable startNotifier];
}

-(void)networkReachabilityChanged:(NSNotification *)notify{
    Reachability* networkStatus = notify.object;
    NSLog(@"state changed");
    switch ([networkStatus currentReachabilityStatus]) {
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            [activityIndicator startAnimating];
            [self startLocationUpdate];
            break;
            
        default:
            [self stopLocationUpdate];
            break;
    }
}


@end
