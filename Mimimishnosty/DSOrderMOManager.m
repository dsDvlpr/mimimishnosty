//
//  DSOrderMOManager.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 02.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSOrderMOManager.h"
#import "DSShopingCart.h"
#import "DSItem_MO+CoreDataClass.h"
#import "DSCoreDataManager.h"
#import "DSAdressMOManager.h"
#import "DSOrder_MO+CoreDataClass.h"

@implementation DSOrderMOManager

- (void) createNewOrder {
    
    DSCoreDataManager *coreDataManager = [DSCoreDataManager sharedManager];
    NSManagedObjectContext *context = coreDataManager.persistentContainer.viewContext;
    
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    DSOrder_MO *newOrder = [[DSOrder_MO alloc] initWithContext:context];
    newOrder.date = nowDate;
    
    DSAdressMOManager *adressManager = [[DSAdressMOManager alloc]init];
    DSAdress_MO *adress = [[DSAdress_MO alloc] initWithContext:context];
    adress = [adressManager adressCopy];
    newOrder.adress = adress;
    
    DSShopingCart *shopingCart = [[DSShopingCart alloc] init];
    for (DSItem_MO *item in shopingCart.allItems) {
        
        //DSItem_MO *newItem = [[DSItem_MO alloc] initWithContext:context];
        DSItem_MO *newItem = item;
        [newOrder addItemsObject:newItem];
        
    }
    
    [shopingCart clearShopingCart];
    [coreDataManager saveContext];
}

-(NSInteger) totalPriceOfOrder:(DSOrder_MO *)order {
    
    NSInteger totalPrice = 0;
    
    for (DSItem_MO *item in order.items) {
        totalPrice += item.price * item.quantity;
    }
    return totalPrice;
    
}

@end
