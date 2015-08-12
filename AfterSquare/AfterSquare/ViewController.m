//
//  ViewController.m
//  AfterSquare
//
//  Created by Cheshire on 04.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//
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
    CLLocation *currentLocation;
    CLGeocoder *geocoder;
}
@end

@implementation ViewController
@synthesize placeTableView;
@synthesize activityIndicator;
@synthesize showAllPlaces;
@synthesize currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    showAllPlaces.enabled = NO;
    refresher = [[UIRefreshControl alloc]init];
    [refresher addTarget:self action:@selector(updatePlaceData:) forControlEvents:UIControlEventValueChanged];
    [placeTableView addSubview:refresher];
    [activityIndicator startAnimating];
    [refresher beginRefreshing];
    [self startLocationUpdate];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlaceMap) name:CL_MAP_CREATED object:nil];
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
        [activityIndicator stopAnimating];
        [refresher endRefreshing];
    }

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

-(void)setRefresher
{
    
}

-(void)updatePlaceData:(UIRefreshControl *)refreshControl
{
    [self startLocationUpdate];
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


@end
