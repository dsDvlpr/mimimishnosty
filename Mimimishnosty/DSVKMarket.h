//
//  DSVKMarket.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 21.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DSMarketManagerShopArrayDidChangeNotification;

extern NSString *const DSMarketItemTitleKey;
extern NSString *const DSMarketItemDescriptionKey;
extern NSString *const DSMarketItemPhotosKey;
extern NSString *const DSMarketItemPriceKey;
extern NSString *const DSMarketItemMainImageURLKey;
extern NSString *const DSMarketItemId;


@interface DSVKMarket : NSObject

@property (strong, nonatomic) NSArray *items;

- (instancetype)initWithGroupId:(NSString*) groupId;
- (BOOL) loadMarketItems;
- (NSDictionary *) itemDictionaryForId:(int32_t) itemId;

@end
