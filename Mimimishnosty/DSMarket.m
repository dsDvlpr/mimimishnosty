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
#import "DSAdressMOManager.h"
#import "SCLAlertView.h"

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
        
        [itemManager createItemMOWithDictionary:item];
    }
    
        NSString *greetings = @"Добавлено в корзину:";
        SCLAlertView *alertView = [[SCLAlertView alloc] initWithNewWindow];
        [alertView showSuccess:greetings
                      subTitle:[item objectForKey:DSVKMarketItemTitleKey]
              closeButtonTitle:@"OK"
                      duration:5];

    
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


- (NSString *) adressString {
    
    NSMutableString *result = [NSMutableString string];
    DSAdressMOManager *adressManager = [[DSAdressMOManager alloc] init];
    
    if ([adressManager.currentCity length] > 0) {
        [result appendString:adressManager.currentCity];
    }
    
    if ([adressManager.currentStreet length] > 0) {
        [result appendString:[NSString stringWithFormat:@" ул. %@", adressManager.currentStreet]];
    }
    
    if ([adressManager.currentHouse length] > 0) {
        [result appendString:[NSString stringWithFormat:@", д. %@", adressManager.currentHouse]];
    }
    
    if ([adressManager.currentBuilding length] > 0) {
        [result appendString:[NSString stringWithFormat:@" %@", adressManager.currentBuilding]];
    }
    
    if ([adressManager.currentFlat length] > 0) {
        [result appendString:[NSString stringWithFormat:@", кв. %@", adressManager.currentFlat]];
    }
    
    return [NSString stringWithFormat:@"%@.", result];
}

@end
