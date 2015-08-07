//
//  DataHelper.m
//  AfterSquare
//
//  Created by Cheshire on 07.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//

#import "Place.h"
#import "PlaceDetails.h"
#import "DataHelper.h"

@implementation DataHelper
{
    NSMutableArray* placeMap;
}

+(id)sharedManager
{
    static DataHelper *shared;
    static dispatch_once_t dataHelperToken;
    dispatch_once(&dataHelperToken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

-(void)saveFsPlacesData:(NSDictionary *)json{
    NSDictionary* places = json[@"response"][@"venues"];
    for (NSDictionary *place in places) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Place * newPlace = [Place MR_createEntityInContext:localContext];
            if (newPlace.placeDetails == nil) {
                newPlace.placeDetails = [PlaceDetails MR_createEntityInContext:localContext];
            }
            newPlace.name = place[@"name"];
            newPlace.distance = place[@"location"][@"distance"];
            newPlace.category = place[@"categories"][@"name"];
            newPlace.placeDetails.city = place[@"location"][@"city"];
            newPlace.placeDetails.street = place[@"location"][@"address"];
        }];
    }
    [self setPlaceMap];
}

-(NSMutableArray* )getPlaceMap
{
    return placeMap;
}

-(void)setPlaceMap
{
    placeMap = [[Place MR_findAllSortedBy:@"distance" ascending:NO]copy];
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
}


-(void)clearPlaceMap
{
    if (!placeMap) {
        return;
    }
    
    [placeMap enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [Place MR_truncateAll];
        [PlaceDetails MR_truncateAll];
    }];
}

@end
