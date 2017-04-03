//
//  DSShopingCart.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 02.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSShopingCart.h"
#import "DSItemMOManager.h"
#import "DSCoreDataManager.h"
#import "NSArray+DSArray.h"

@implementation DSShopingCart

- (BOOL) itemMOWithIdIsInShopingCart:(int32_t) itemId {
    
    NSArray *itemsInShopingCart = [self allItems];
    DSItem_MO *resultItem = [itemsInShopingCart objectWithValue:@(itemId)
                                                         forKey:@"itemId"];
    BOOL result = (resultItem != nil);
    
    return result;
    
}

- (void) addItemMOWithId: (int32_t)itemId {
    
    NSLog(@"\n\n- (void) addItemMOWithId");
    DSItemMOManager *itemMOManager = [[DSItemMOManager alloc] init];
    
    if ([self itemMOWithIdIsInShopingCart:itemId]) {
        
        [itemMOManager incrementItemWithIdQuantity:itemId];
    
    } else {
        
        DSItem_MO *itemMO = [itemMOManager itemMOByItemId:itemId];
        DSShopingCart_MO *shopingCart = [self defaultShopingCart];
        [shopingCart addItemsObject:itemMO];

    }

    [[DSCoreDataManager sharedManager] saveContext];
    [self showItemsInShopingCart];
    
}

- (NSArray *)allItems {
    
    DSShopingCart_MO *shopingCart = [self defaultShopingCart];
    NSSet *items = [shopingCart items];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    
    NSArray *allItems = [items allObjects];
    NSArray *sortedArray = [allItems sortedArrayUsingDescriptors:@[descriptor]];
    
    return sortedArray;
    
}

- (void) showItemsInShopingCart {
    NSArray *itemsInShopingCart = [self allItems];
    NSLog(@"\n\nItems in shoping cart:");
    for (DSItem_MO *item in itemsInShopingCart) {
        NSLog(@"\n%@", item.title);
    }
}

- (DSShopingCart_MO *)defaultShopingCart {
    
    NSFetchRequest *request = [DSShopingCart_MO fetchRequest];
    DSCoreDataManager *coreDataManager = [DSCoreDataManager sharedManager];
    NSManagedObjectContext *context = coreDataManager.persistentContainer.viewContext;
    
    NSArray *shopingCarts = [context executeFetchRequest:request
                                                    error:nil];
    if ([shopingCarts count] > 0) {
        
        return [shopingCarts firstObject];
    
    } else {
        
        DSShopingCart_MO *shopingCart = [[DSShopingCart_MO alloc] initWithContext:context];
        [coreDataManager saveContext];
        
        return shopingCart;
        
    }
}


@end
