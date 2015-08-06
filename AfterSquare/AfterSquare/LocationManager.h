//
//  LocationManager.h
//  AfterSquare
//
//  Created by Cheshire on 06.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

+(id)sharedManager;
-(void)startLocationUpdate;
-(CLLocation *)getUserLocation;
@end
