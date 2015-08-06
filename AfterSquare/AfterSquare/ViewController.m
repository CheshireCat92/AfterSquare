//
//  ViewController.m
//  AfterSquare
//
//  Created by Cheshire on 04.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//
#import "FoursquareManager.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FoursquareManager* fManager = [FoursquareManager new];
    [fManager searchNearLocations];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
