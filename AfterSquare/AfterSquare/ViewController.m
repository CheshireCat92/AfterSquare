//
//  ViewController.m
//  AfterSquare
//
//  Created by Cheshire on 04.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//
#import "NSObject+PerformSelectorWithCallback.h"
#import "LocationManager.h"
#import "FoursquareManager.h"
#import "ViewController.h"

@interface ViewController ()
{
    LocationManager *lManager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lManager = [LocationManager sharedManager];
    [lManager startLocationUpdate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchNearLocation:) name:CL_CURENT_LOC object:nil];
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
@end
