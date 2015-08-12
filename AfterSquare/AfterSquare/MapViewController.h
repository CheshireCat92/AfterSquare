//
//  MapViewController.h
//  AfterSquare
//
//  Created by Cheshire on 09.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//

#import "Place.h"
#import "PlaceDetails.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) Place *samePlace;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) NSMutableArray *placeMap;
@property (weak, nonatomic) IBOutlet MKMapView *allPlaceMapView;

@end
