//
//  NSArray+DSArray.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 27.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "NSArray+DSArray.h"

@implementation NSArray (DSArray)

- (id) objectWithValue:(id) valueObject forKey:(NSString*) keyString {
    
    for (id object in self) {
        
        NSError *error;
        if (![object validateValue:&valueObject
                            forKey:keyString
                             error:&error]) {
            
            NSLog(@"\nobjectWithValue: no such Key.\nReason: %@",error);
            return nil;
            
        }
        
        if ([[object valueForKey:keyString] isEqual:valueObject]) {
            return object;
        }
    }
    
    return nil;
    
}

@end
