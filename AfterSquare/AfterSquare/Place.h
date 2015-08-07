//
//  Place.h
//  AfterSquare
//
//  Created by Cheshire on 07.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlaceDetails;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * distance;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) PlaceDetails *placeDetails;

@end
