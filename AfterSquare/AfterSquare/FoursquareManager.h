//
//  TwitterManager.h
//
//  Created by Cheshire on 21.07.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//

//#import "Constants.h"
#import <Foundation/Foundation.h>

@interface FoursquareManager : NSObject

+(id)sharedManager;
-(void)searchNearLocations;
-(void)fsAuthorize;

@end
