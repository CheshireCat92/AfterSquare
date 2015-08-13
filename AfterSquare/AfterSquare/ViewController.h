//
//  ViewController.h
//  AfterSquare
//
//  Created by Cheshire on 04.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *placeTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *showAllPlaces;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

