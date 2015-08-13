//
//  MapViewController.m
//  AfterSquare
//
//  Created by Cheshire on 09.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
{
    NSDictionary *viewDict;
}
@end

@implementation MapViewController
@synthesize mapView,allPlaceMapView;
@synthesize samePlace;
@synthesize placeMap ;
@synthesize placeCategoryLabel,placeCityLabel,placeDistanceLabel,placeNameLabel,placeStreetLabel;
@synthesize currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad ];
    mapView.delegate = self;
    [mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setPinToMap ];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    [self clearPlaceData ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPinToMap
{
    if (samePlace != nil ) {
        [placeNameLabel     setText:samePlace.name ];
        [placeCategoryLabel setText:samePlace.category ];
        [placeDistanceLabel setText:[self getDistanceFromCurrentLocationToPlace:samePlace]];
        [placeCityLabel     setText:samePlace.placeDetails.city ];
        [placeStreetLabel   setText:samePlace.placeDetails.street ];
        
        [self prepareForClippingPinForPlace:samePlace forView:mapView];
    }
    else if (placeMap.count >= 1 ){
        for (Place* place in placeMap) {
            [self prepareForClippingPinForPlace:place forView:allPlaceMapView];
        }
    }
    
}

-(NSString* )getDistanceFromCurrentLocationToPlace:(Place*)place{
    CLLocationDegrees lat        = [place.placeDetails.lat doubleValue ];
    CLLocationDegrees lng        = [place.placeDetails.lng doubleValue ];
    CLLocation *placeLoc = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    return [NSString stringWithFormat:@"%f",[currentLocation distanceFromLocation:placeLoc]/1000]; //km
}

-(void)prepareForClippingPinForPlace:(Place*)place forView:(MKMapView *)neededMapView
{
    CLLocationDegrees lat        = [place.placeDetails.lat doubleValue ];
    CLLocationDegrees lng        = [place.placeDetails.lng doubleValue ];
    CLLocationCoordinate2D cords = CLLocationCoordinate2DMake(lat,lng);
    MKCoordinateRegion region    = MKCoordinateRegionMakeWithDistance(cords, 800, 800);
    [neededMapView setRegion:[neededMapView regionThatFits:region ] animated:YES ];
    [self setAnnotationForPointWithCords:cords Name:place.name andCategory:place.category forMap:neededMapView ];
}

-(void)setAnnotationForPointWithCords:(CLLocationCoordinate2D)cords Name:(NSString *)name andCategory:(NSString *)category forMap:(MKMapView *)map {
    MKPointAnnotation *pointAnnotation = [MKPointAnnotation new];
    pointAnnotation.coordinate         = cords;
    pointAnnotation.title              = name;
    pointAnnotation.subtitle           = category;
    [map addAnnotation:pointAnnotation];
}

-(void)clearPlaceData
{
    samePlace = nil;
    placeMap = nil;
}



@end
