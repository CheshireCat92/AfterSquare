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
    [self clearPlaceMap];
    NSDictionary* places = json[@"response"][@"venues"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (NSDictionary *place in places) {
            Place * newPlace = [Place MR_createEntityInContext:localContext];
            if (newPlace.placeDetails == nil) {
                newPlace.placeDetails = [PlaceDetails MR_createEntityInContext:localContext];
            }
            newPlace.name = place[@"name"];
            newPlace.distance = [place[@"location"][@"distance"] stringValue];
            newPlace.category = [place[@"categories"] lastObject][@"name"];
            newPlace.placeDetails.city = place[@"location"][@"city"];
            newPlace.placeDetails.street = place[@"location"][@"address"];
        }
    }completion:^(BOOL contextDidSave, NSError *error) {
            [self setPlaceMap];
    }];
}
-(NSMutableArray* )getPlaceMap
{
    return placeMap;
}

-(void)setPlaceMap
{
    placeMap = [[Place MR_findAllSortedBy:@"distance" ascending:NO]copy];
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    [[NSNotificationCenter defaultCenter]postNotificationName:CL_MAP_CREATED object:nil];
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

-(Place*)getPlaceByIndexPath:(NSIndexPath *)path
{
    return placeMap[path.row];
}

@end
