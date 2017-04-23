//
//  DSInscriptionMOManager.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 22.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSInscriptionMOManager.h"
#import "DSCoreDataManager.h"
#import "NSArray+DSArray.h"

@implementation DSInscriptionMOManager

- (DSInscription_MO *)newInscriptionMOForItemWithId:(int32_t)itemId {
    
    DSCoreDataManager *coreDataManager = [DSCoreDataManager sharedManager];
    NSManagedObjectContext *context = coreDataManager.persistentContainer.viewContext;
    DSInscription_MO *insperationMO = [[DSInscription_MO alloc] initWithContext:context];
    insperationMO.itemId = itemId;
    [coreDataManager saveContext];
    
    return insperationMO;
    
}

- (DSInscription_MO *) inscriptionMOWithoutOrderForItemWithId:(int32_t)itemId {
    
    NSFetchRequest *fetchRequest = [DSInscription_MO fetchRequest];
    NSPredicate *itemIdPredicate = [NSPredicate predicateWithFormat:@"itemId == %d", itemId];
    fetchRequest.predicate = itemIdPredicate;
    DSCoreDataManager *coreDataManager = [DSCoreDataManager sharedManager];
    NSManagedObjectContext *context = coreDataManager.persistentContainer.viewContext;
    NSArray *inscriptions = [context executeFetchRequest:fetchRequest error:nil];
    
    for (DSInscription_MO *inscriptionMO in inscriptions) {
        if (inscriptionMO.order.date == nil) {
            
            return inscriptionMO;
        
        }
    }
    
    return [self newInscriptionMOForItemWithId:itemId];
    
}

- (void) setInscriptionString:(NSString *)string forItemWithId:(int32_t)itemId {
    
    DSInscription_MO *inscriptionMO = [self inscriptionMOWithoutOrderForItemWithId:itemId];
    inscriptionMO.inscriptionString = string;
    [[DSCoreDataManager sharedManager] saveContext];
    
}

- (NSString *) inscriptionStringForItemWithId:(int32_t)itemId inOrder:(DSOrder_MO *)order {
    
    NSFetchRequest *fetchRequest = [DSInscription_MO fetchRequest];
    
    if (order != nil) {

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(itemId == %d) AND (order.orderId == %d)", itemId, order.orderId];
        fetchRequest.predicate = predicate;

    } else {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemId == %d", itemId];
        fetchRequest.predicate = predicate;
    }
    DSCoreDataManager *coreDataManager = [DSCoreDataManager sharedManager];
    NSManagedObjectContext *context = coreDataManager.persistentContainer.viewContext;
    NSArray *inscriptions = [context executeFetchRequest:fetchRequest error:nil];
    if ([inscriptions count] > 0) {
        
        DSInscription_MO *inscription = [inscriptions firstObject];
        return inscription.inscriptionString;
    
    }
    
    return nil;
}

@end
