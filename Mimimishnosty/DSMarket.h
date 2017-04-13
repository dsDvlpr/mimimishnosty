//
//  DSMarket.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 02.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSShopingCart_MO+CoreDataProperties.h"
#import "DSItem_MO+CoreDataClass.h"

@interface DSMarket : NSObject

+ (DSMarket *) sharedManager;
- (void) addItemToShopingCart:(NSDictionary *)item;
- (DSItem_MO*) itemMOById:(int32_t) itemId;
- (void) clearShopingCart;
- (NSString *) adressString;

@end
