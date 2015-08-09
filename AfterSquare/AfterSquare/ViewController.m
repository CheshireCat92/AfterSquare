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
#import "LocationManager.h"
#import "FoursquareManager.h"
#import "ViewController.h"
@interface ViewController ()
{
    LocationManager *lManager;
    NSMutableArray *placeMap;
    UIRefreshControl *refresher;
}
@end

@implementation ViewController
@synthesize placeTableView = _placeTableView;
@synthesize activityIndicator = _activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    refresher = [[UIRefreshControl alloc]init];
    [refresher addTarget:self action:@selector(updatePlaceData:) forControlEvents:UIControlEventValueChanged];
    [self.placeTableView addSubview:refresher];
    lManager = [LocationManager sharedManager];
    [self.activityIndicator startAnimating];
    [refresher beginRefreshing];
    [lManager startLocationUpdate];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchNearLocation:) name:CL_CURENT_LOC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlaceMap) name:CL_MAP_CREATED object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)searchNearLocation:(NSNotification *)notification
{
   [[FoursquareManager sharedManager]searchLocationsNearLocation:notification.object];
}

-(void)setPlaceMap
{
    placeMap = [[DataHelper sharedManager ]getPlaceMap];
    [self.placeTableView reloadData];
    [self.activityIndicator stopAnimating];
    [refresher endRefreshing];
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
    [lManager startLocationUpdate];
}

#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Seg started");
    MapViewController *upcomingMapView = segue.destinationViewController;
    NSIndexPath *indexPath = [self.placeTableView indexPathForSelectedRow];
    Place *samePlace = placeMap[indexPath.row];
    upcomingMapView.samePlace = samePlace;
}

@end
