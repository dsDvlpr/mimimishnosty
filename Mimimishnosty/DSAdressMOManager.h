//
//  DSAdressMOManager.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 13.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSAdress_MO+CoreDataClass.h"

@interface DSAdressMOManager : NSObject

@property (strong, nonatomic) NSString *currentCity;
@property (strong, nonatomic) NSString *currentHouse;
@property (strong, nonatomic) NSString *currentFlat;
@property (strong, nonatomic) NSString *currentStreet;
@property (strong, nonatomic) NSString *currentBuilding;

- (DSAdress_MO *) currentAdressMO;

@end
