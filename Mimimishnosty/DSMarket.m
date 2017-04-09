//
//  DSMarket.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 02.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSMarket.h"
#import "DSItemMOManager.h"
#import "DSVKManager.h"
#import "DSShopingCart.h"

@implementation DSMarket

+ (DSMarket *) sharedManager {
    
    static DSMarket *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DSMarket alloc] init];
    });
    
    return manager;
}

- (void)addItemToShopingCart:(NSDictionary *)item {
    
    DSItemMOManager *itemManager = [[DSItemMOManager alloc] init];
    DSShopingCart *shopingCart = [[DSShopingCart alloc] init];
    
    int32_t itemId = [[item valueForKey:DSVKMarketItemIdKey]intValue];
    
    if (![itemManager itemMOWithIdDoesExist:itemId]) {
        NSLog(@"\n- (void) addItemToShopingCart:\n No such item in core data");
        [itemManager createItemMOWithDictionary:item];
    }
    
    [shopingCart addItemMOWithId:itemId];
}

- (DSItem_MO *) itemMOById:(int32_t)itemId {
    
    DSItemMOManager *itemManager = [[DSItemMOManager alloc] init];
    return [itemManager itemMOByItemId:itemId];
    
}

- (void) clearShopingCart {
    
    DSShopingCart *shopingCart = [[DSShopingCart alloc] init];
    [shopingCart clearShopingCart];
    
}

@end
