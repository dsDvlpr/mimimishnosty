//
//  DSShopingCart.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 02.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSShopingCart_MO+CoreDataClass.h"
#import "DSAdress_MO+CoreDataClass.h"

@interface DSShopingCart : NSObject

- (BOOL) itemMOWithIdIsInShopingCart:(int32_t) itemId;
- (NSArray *) allItems;
- (void) addItemMOWithId: (int32_t)itemId;
- (DSShopingCart_MO *) defaultShopingCart;
//- (DSAdress_MO *) adressCopy;
- (void) clearShopingCart;

@end
