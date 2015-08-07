//
//  PlaceDetails.h
//  AfterSquare
//
//  Created by Cheshire on 07.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlaceDetails : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * street;

@end
