//
//  DSVKMarket.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 21.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DSMarketManagerShopArrayDidChangeNotification;

@interface DSVKMarket : NSObject


- (instancetype)initWithGroupId:(NSString*) groupId;
- (BOOL) loadMarketItems;

@end
