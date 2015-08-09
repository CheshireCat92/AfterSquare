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
@synthesize mapView = _mapView;
@synthesize samePlace;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setPinToMap];
//    [self setDictForBindings];
//    [self setMapViewConstraints];
//    [self.view updateConstraints];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPinToMap
{
    CLLocationDegrees lat = [samePlace.placeDetails.lat doubleValue];
    CLLocationDegrees lng = [samePlace.placeDetails.lng doubleValue];
    CLLocationCoordinate2D cords = CLLocationCoordinate2DMake(lat,lng);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(cords, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    [self setAnnotationForPointWithCords:cords];
}

-(void)setAnnotationForPointWithCords:(CLLocationCoordinate2D)cords{
    MKPointAnnotation *pointAnnotation = [MKPointAnnotation new];
    pointAnnotation.coordinate = cords;
    pointAnnotation.title = samePlace.name;
    pointAnnotation.subtitle = samePlace.category;
    [self.mapView addAnnotation:pointAnnotation];
}

//-(void)setDictForBindings
//{
//    viewDict=@{
//               @"view":self.view,
//               @"map":self.mapView
//               };
//}


-(void)setMapViewConstraints
{
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[map]|" options:0 metrics:nil views:viewDict]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[map]|" options:0 metrics:nil views:viewDict]];
}
@end
