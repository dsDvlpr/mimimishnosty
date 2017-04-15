//
//  DSAdressMOManager.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 13.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSAdressMOManager.h"
#import "DSCoreDataManager.h"


@implementation DSAdressMOManager

- (DSAdress_MO *) currentAdressMO {
    
    NSFetchRequest *fetchRequest = [DSAdress_MO fetchRequest];
    DSCoreDataManager *coreDataManager = [DSCoreDataManager sharedManager];
    NSManagedObjectContext *context = coreDataManager.persistentContainer.viewContext;
    NSPredicate *ordersPredicate = [NSPredicate predicateWithFormat:@"order == %@", nil];
    
    fetchRequest.predicate = ordersPredicate;
    NSArray *adressesMO = [context executeFetchRequest:fetchRequest error:nil];
    
    if ([adressesMO count] > 0) {
        
        DSAdress_MO *adressMO = [adressesMO firstObject];
        [coreDataManager saveContext];
        return adressMO;
    
    } else {
        
        DSAdress_MO *adressMO = [[DSAdress_MO alloc] initWithContext:context];
        [coreDataManager saveContext];
        return adressMO;
        
    }
    
    return nil;
}

- (DSAdress_MO *)adressCopy {
    
    DSCoreDataManager *coreDataManager = [DSCoreDataManager sharedManager];
    NSManagedObjectContext *context = coreDataManager.persistentContainer.viewContext;
    DSAdress_MO *newAdress = [[DSAdress_MO alloc] initWithContext:context];
    
    DSAdress_MO *oldAdress = [self currentAdressMO];
    newAdress.city = oldAdress.city;
    newAdress.building = oldAdress.building;
    newAdress.house = oldAdress.house;
    newAdress.street = oldAdress.street;
    newAdress.flat = oldAdress.flat;
    
    [coreDataManager saveContext];
    
    return newAdress;
}

#pragma mark - Setters

- (void) setCurrentCity:(NSString *)city{
    
    DSAdress_MO *adressMO = [self currentAdressMO];
    adressMO.city = city;
    [[DSCoreDataManager sharedManager] saveContext];
    
}

- (void) setCurrentHouse:(NSString *)house{

    DSAdress_MO *adressMO = [self currentAdressMO];
    adressMO.house = house;
    [[DSCoreDataManager sharedManager] saveContext];

}

- (void) setCurrentBuilding:(NSString *)building{
    
    DSAdress_MO *adressMO = [self currentAdressMO];
    adressMO.building = building;
    [[DSCoreDataManager sharedManager] saveContext];

}

- (void) setCurrentStreet:(NSString *)street{
    
    DSAdress_MO *adressMO = [self currentAdressMO];
    adressMO.street = street;
    [[DSCoreDataManager sharedManager] saveContext];

}

- (void) setCurrentFlat:(NSString *)flat{
    
    DSAdress_MO *adressMO = [self currentAdressMO];
    adressMO.flat = flat;
    [[DSCoreDataManager sharedManager] saveContext];

}

#pragma mark - Getters

-(NSString *)currentCity {
    DSAdress_MO *adressMO = [self currentAdressMO];
    return adressMO.city;
}


-(NSString *)currentBuilding {
    DSAdress_MO *adressMO = [self currentAdressMO];
    return adressMO.building;
}


-(NSString *)currentFlat {
    DSAdress_MO *adressMO = [self currentAdressMO];
    return adressMO.flat;
}


-(NSString *)currentStreet {
    DSAdress_MO *adressMO = [self currentAdressMO];
    return adressMO.street;
}


-(NSString *)currentHouse {
    DSAdress_MO *adressMO = [self currentAdressMO];
    return adressMO.house;
}

@end
