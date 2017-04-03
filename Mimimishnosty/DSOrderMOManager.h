//
//  DSOrderMOManager.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 02.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSOrderMOManager : NSObject

- (void) createNewOrderWithItems:(NSArray *) items;
- (NSInteger) totalPrice;

@end
