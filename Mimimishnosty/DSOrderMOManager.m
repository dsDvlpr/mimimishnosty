//
//  DSOrderMOManager.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 02.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSOrderMOManager.h"
#import "DSShopingCart.h"
#import "DSMarket.h"
#import "DSItem_MO+CoreDataClass.h"
#import "DSCoreDataManager.h"
#import "DSAdressMOManager.h"
#import "DSOrder_MO+CoreDataClass.h"
#import "DSVKManager.h"

@implementation DSOrderMOManager

NSString *degustatoryId = @"-129235573";

- (void) createNewOrderWithDelivery:(BOOL)delivery {
    
    DSCoreDataManager *coreDataManager = [DSCoreDataManager sharedManager];
    NSManagedObjectContext *context = coreDataManager.persistentContainer.viewContext;
    
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    DSOrder_MO *newOrder = [[DSOrder_MO alloc] initWithContext:context];
    newOrder.date = nowDate;
    
    DSAdressMOManager *adressManager = [[DSAdressMOManager alloc]init];
    DSAdress_MO *adress = [[DSAdress_MO alloc] initWithContext:context];
    adress = [adressManager adressCopy];
    newOrder.adress = adress;
    
    NSMutableString *message = [NSMutableString stringWithFormat:@"Заказ"];
    
    DSShopingCart *shopingCart = [[DSShopingCart alloc] init];
    for (DSItem_MO *item in shopingCart.allItems) {
        
        DSItem_MO *newItem = item;
        [message appendString:[NSString stringWithFormat:@"\n%@, количество: %d", item.title, item.quantity]];
        [newOrder addItemsObject:newItem];
        
    }
    
    
    
    if (delivery) {
        
        NSString *adressString = [[DSMarket sharedManager] adressString];
        [message appendString:[NSString stringWithFormat:@"\nАдрес: %@", adressString]];
    } else {
        
        [message appendString:@"\nСамовывоз"];
        
    }
    
    
    [[DSVKManager sharedManager] sendMessage:[NSString stringWithString:message]
                                toUserWithId:degustatoryId
                                   onSuccess:^{
                                       ;
                                   }
                                    onFailor:^{
                                        ;
                                    }];
    
    [shopingCart clearShopingCart];
    [coreDataManager saveContext];
}

- (NSInteger) totalPriceOfOrder:(DSOrder_MO *)order {
    
    NSInteger totalPrice = 0;
    
    for (DSItem_MO *item in order.items) {
        totalPrice += item.price * item.quantity;
    }
    return totalPrice;
    
}

@end
