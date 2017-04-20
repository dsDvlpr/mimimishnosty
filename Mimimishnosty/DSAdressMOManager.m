//
//  DSAdressMOManager.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 13.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSAdressMOManager.h"
#import "DSCoreDataManager.h"

@interface DSAdressMOManager ()

@property (assign, nonatomic) NSInteger adressesNumber;

@end

@implementation DSAdressMOManager

- (DSAdress_MO *) currentAdressMO {
    
    NSFetchRequest *fetchRequest = [DSAdress_MO fetchRequest];
    DSCoreDataManager *coreDataManager = [DSCoreDataManager sharedManager];
    NSManagedObjectContext *context = coreDataManager.persistentContainer.viewContext;
    NSPredicate *ordersPredicate = [NSPredicate predicateWithFormat:@"adressId == %d", 1];
    
    fetchRequest.predicate = ordersPredicate;
    NSArray *adressesMO = [context executeFetchRequest:fetchRequest error:nil];
    
    self.adressesNumber = [adressesMO count];
    NSLog(@"\n\nall adresses: %ld", (long)self.adressesNumber);
    
    if ([adressesMO count] > 0) {
        
        DSAdress_MO *adressMO = [adressesMO firstObject];
        
        //[coreDataManager saveContext];
        return adressMO;
    
    } else {
        
        DSAdress_MO *adressMO = [[DSAdress_MO alloc] initWithContext:context];
        adressMO.adressId = 1;
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
    
    newAdress.adressId = (int)self.adressesNumber;
    
    [coreDataManager saveContext];
    
    return newAdress;
}

- (NSString *) adressStringForAdressMO:(DSAdress_MO *) adress {
    
    NSMutableString *result = [NSMutableString string];
    
    if ([adress.city length] > 0) {
        [result appendString:adress.city];
    }
    
    if ([adress.street length] > 0) {
        [result appendString:[NSString stringWithFormat:@" ул. %@", adress.street]];
    }
    
    if ([adress.house length] > 0) {
        [result appendString:[NSString stringWithFormat:@", д. %@", adress.house]];
    }
    
    if ([adress.building length] > 0) {
        [result appendString:[NSString stringWithFormat:@" %@", adress.building]];
    }
    
    if ([adress.flat length] > 0) {
        [result appendString:[NSString stringWithFormat:@", кв. %@", adress.flat]];
    }
    
    return [NSString stringWithFormat:@"%@", result];
    
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
