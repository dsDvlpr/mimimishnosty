//
//  DSOrderMOManager.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 02.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSOrderMOManager.h"
#import "DSItem_MO+CoreDataClass.h"
#import "DSCoreDataManager.h"

@implementation DSOrderMOManager

-(void)createNewOrderWithItems:(NSArray *)items {
    
    
    
}

-(NSInteger) totalPriceOfOrder:(DSOrder_MO *)order {
    
    NSInteger totalPrice = 0;
    
    for (DSItem_MO *item in order.items) {
        totalPrice += item.price * item.quantity;
    }
    return totalPrice;
    
}

@end
