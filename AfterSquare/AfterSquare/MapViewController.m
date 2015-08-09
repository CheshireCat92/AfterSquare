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
    
}
@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize samePlace;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self setPinToMap];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
@end
