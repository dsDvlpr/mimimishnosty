//
//  DSMarket.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 02.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSMarket : NSObject

+ (DSMarket *) sharedManager;
- (void) addItemToShopingCart:(NSDictionary *)item;

@end
