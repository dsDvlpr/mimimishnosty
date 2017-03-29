//
//  DSMarketItem.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 26.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DSMarketItem : NSObject

@property (strong, nonatomic) NSString *itemDescription;

@property (strong, nonatomic) UIImage *mainImage;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSArray *imagesURLStrings;
@property (strong, nonatomic) NSString *mainImageUrlString;

@property (nonatomic, assign) int32_t theGoodsId;
@property (nonatomic, assign) int32_t price;
@property (strong, nonatomic) NSString *name;

- (instancetype) initWithName:(NSString*)name price:(int32_t)price mainImageIcon:(UIImage*)icon;
- (instancetype)initWithDictionary:(NSDictionary*) dictionary;
- (BOOL) loadImages;

@end
