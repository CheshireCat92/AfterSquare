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
@synthesize mapView,allPlaceMapView  ;
@synthesize samePlace;
@synthesize placeMap ;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setPinToMap];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPinToMap
{
    if (samePlace != nil ) {
        [self prepareForClippingPinForPlace:samePlace];
    }
    else if (placeMap.count >= 1 ){
        for (Place* place in placeMap) {
            [self prepareForClippingPinForPlace:place];
        }
    }
    
}

-(void)prepareForClippingPinForPlace:(Place*)place
{
    CLLocationDegrees lat = [place.placeDetails.lat doubleValue];
    CLLocationDegrees lng = [place.placeDetails.lng doubleValue];
    CLLocationCoordinate2D cords = CLLocationCoordinate2DMake(lat,lng);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(cords, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    [self setAnnotationForPointWithCords:cords Name:place.name andCategory:place.category forMap:allPlaceMapView];
}

-(void)setAnnotationForPointWithCords:(CLLocationCoordinate2D)cords Name:(NSString *)name andCategory:(NSString *)category forMap:(MKMapView *)map {
    MKPointAnnotation *pointAnnotation = [MKPointAnnotation new];
    pointAnnotation.coordinate = cords;
    pointAnnotation.title = name;
    pointAnnotation.subtitle = category;
    [map addAnnotation:pointAnnotation];
}

-(void)clearPlaceData
{
    samePlace = nil;
    placeMap = nil;
}



@end
