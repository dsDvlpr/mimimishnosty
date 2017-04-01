//
//  DSCoreDataManager.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 01.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DSCoreDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (DSCoreDataManager*) sharedManager;
- (void)saveContext;

@end
