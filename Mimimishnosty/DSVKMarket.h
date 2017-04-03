//
//  DSVKMarket.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 21.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DSMarketManagerShopArrayDidChangeNotification;

extern NSString *const DSVKMarketItemTitleKey;
extern NSString *const DSVKMarketItemDescriptionKey;
extern NSString *const DSVKMarketItemPhotosKey;
extern NSString *const DSVKMarketItemPriceKey;
extern NSString *const DSVKMarketItemMainImageURLKey;
extern NSString *const DSVKMarketItemIdKey;


@interface DSVKMarket : NSObject

@property (strong, nonatomic) NSArray *items;

- (instancetype)initWithGroupId:(NSString*) groupId;
- (BOOL) loadMarketItems;
- (NSDictionary *) itemDictionaryForId:(int32_t) itemId;

@end
