//
//  FoursquareManager.h
//
//  Created by Cheshire on 21.07.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface FoursquareManager : NSObject

+(id)sharedManager;
-(void)searchLocationsNearLocation:(CLPlacemark *)location;
-(void)fsAuthorize;
//-(void)startCheckConnection;
//-(BOOL)isConnected;

@end
