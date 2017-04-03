//
//  DSItemMOManager.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 02.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSItem_MO+CoreDataClass.h"

@interface DSItemMOManager : NSObject

- (void) createItemMOWithDictionary:(NSDictionary *)item;
- (BOOL) itemMOWithIdDoesExist:(int32_t) itemId;
- (DSItem_MO *) itemMOByItemId:(int32_t) itemId;
- (void) incrementItemWithIdQuantity: (int32_t) itemId;
- (void) decrementItemWithIdQuantity: (int32_t) itemId;

@end
