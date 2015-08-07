//
//  DataHelper.h
//  AfterSquare
//
//  Created by Cheshire on 07.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//
#import "Place.h"
#import <Foundation/Foundation.h>

@interface DataHelper : NSObject

+(id)sharedManager;
-(void)saveFsPlacesData:(NSDictionary *)json;
-(NSMutableArray *)getPlaceMap;
-(void)clearPlaceMap;
-(Place *)getPlaceByIndexPath:(NSIndexPath *)path;

@end
