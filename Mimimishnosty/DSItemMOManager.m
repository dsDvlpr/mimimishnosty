//
//  DSItemMOManager.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 02.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSItemMOManager.h"
#import "DSVKManager.h"
#import "DSCoreDataManager.h"
#import "DSItem_MO+CoreDataClass.h"

@implementation DSItemMOManager

- (void) createItemMOWithDictionary:(NSDictionary *)item {
    
    int itemId = [[item valueForKey:DSVKMarketItemIdKey]intValue];
    if (![self itemMOWithIdDoesExist:itemId]) {
        
        DSCoreDataManager *coreDataManager = [DSCoreDataManager sharedManager];
        NSManagedObjectContext *context = coreDataManager.persistentContainer.viewContext;

        DSItem_MO *resultItem = [[DSItem_MO alloc] initWithContext:context];
        resultItem.title = [item objectForKey:DSVKMarketItemTitleKey];
        NSDictionary *priceDictionary = [item objectForKey:DSVKMarketItemPriceKey];
        resultItem.price = [[priceDictionary objectForKey:@"amount"] intValue] / 100;
        resultItem.quantity = 1;
        resultItem.itemDescription = [item objectForKey:DSVKMarketItemDescriptionKey];
        resultItem.itemId = itemId;
        
        [coreDataManager saveContext];
    }
    
}

- (void) incrementItemWithIdQuantity: (int32_t) itemId {
    
    DSItem_MO *item = [self itemMOByItemId:itemId];
    if (item) {
        
        item.quantity ++;
        [[DSCoreDataManager sharedManager] saveContext];
        
    }
    
}

- (void) decrementItemWithIdQuantity: (int32_t) itemId {
    
    DSItem_MO *item = [self itemMOByItemId:itemId];
    if (item) {
        
        int32_t currentQuantity = item.quantity;
        
        if (currentQuantity > 1) {
            item.quantity --;
        } else {
            NSLog(@"\n\ndecrementItemWithIdQuantity:\nНеобходимо реализовать удаление Item");
        }
        
        [[DSCoreDataManager sharedManager] saveContext];
        
    }
}


- (BOOL) itemMOWithIdDoesExist:(int32_t) itemId {
    
    BOOL result = [self itemMOByItemId:itemId] != nil;
    return result;
    
}

- (DSItem_MO *) itemMOByItemId:(int32_t) itemId {
    
    NSFetchRequest *fetchRequest = [DSItem_MO fetchRequest];
    NSPredicate *idPredicate =
    [NSPredicate predicateWithFormat:@"itemId == %@",@(itemId)];
    fetchRequest.predicate = idPredicate;
    
    NSManagedObjectContext *context = [[[DSCoreDataManager sharedManager] persistentContainer]viewContext];
    
    NSArray *items = [context executeFetchRequest:fetchRequest
                                            error:nil];
    if ([items count] > 0) {
        return [items firstObject];
    }
    
    return nil;
    
}

@end
