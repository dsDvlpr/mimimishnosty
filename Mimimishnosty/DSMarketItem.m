//
//  DSMarketItem.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 26.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSMarketItem.h"
#import <AFNetworking.h>
#import <AFImageDownloader.h>
#import "UIImageView+AFNetworking.h"
#import "DSPhoto.h"

NSString *const DSShopItemTitleKey          = @"title";
NSString *const DSShopItemDescriptionKey    = @"description";
NSString *const DSShopItemPhotosKey         = @"photos";
NSString *const DSShopItemPriceKey          = @"price";
NSString *const DSShopItemMainImageURLKey   = @"thumb_photo";
NSString *const DSShopItemId                = @"id";

@implementation DSMarketItem

- (instancetype) initWithName:(NSString*)name price:(int32_t)price mainImageIcon:(UIImage*)icon {
    
    self = [super init];
    if (self) {
        
        self.name = name;
        self.price = price;
        self.mainImage = icon;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        
        NSArray *dictionaryKeys = [dictionary allKeys];
        
        if ([dictionaryKeys containsObject:DSShopItemTitleKey]) {
            self.name = [dictionary objectForKey:DSShopItemTitleKey];
        }
        
        if ([dictionaryKeys containsObject:DSShopItemDescriptionKey]) {
            self.itemDescription = [dictionary objectForKey:DSShopItemDescriptionKey];
        }
        
        if ([dictionaryKeys containsObject:DSShopItemId]) {
            self.theGoodsId = [[dictionary objectForKey:DSShopItemId] intValue];
        }
        
        if ([dictionaryKeys containsObject:DSShopItemPhotosKey]) {
            
            NSArray *photoDictionaries = [dictionary objectForKey:DSShopItemPhotosKey];
            NSMutableArray *tempArray = [NSMutableArray array];
            NSMutableArray *tempPhotoArray = [NSMutableArray array];
            
            if ([photoDictionaries isKindOfClass:[NSArray class]]) {
                for (NSDictionary *photoDictinary in photoDictionaries) {
                    if ([[photoDictinary allKeys] containsObject:@"photo_1280"]) {
                        
                        NSString *imageURLString = [photoDictinary objectForKey:@"photo_1280"];
                        [tempArray addObject:imageURLString];
                        
                        DSPhoto *photo = [[DSPhoto alloc] init];
                        [tempPhotoArray addObject:photo];
                    }
                }
            }
            self.imagesURLStrings = [NSArray arrayWithArray:tempArray];
            self.photos = tempPhotoArray;
            
        }
        
        if ([dictionaryKeys containsObject:DSShopItemMainImageURLKey]) {
            self.mainImageUrlString = [dictionary objectForKey:DSShopItemMainImageURLKey];
        }
        
        if ([dictionaryKeys containsObject:DSShopItemPriceKey]) {
            NSDictionary *priceDictionary = [dictionary objectForKey:DSShopItemPriceKey];
            self.price = [[priceDictionary objectForKey:@"amount"] intValue] / 100;
        }
        
    }
    
    return self;
}

- (BOOL) loadImages {
    
    __weak DSMarketItem *weakSelf = self;
    __block NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSString *imageURLString in self.imagesURLStrings) {
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
        
        [[AFImageDownloader defaultInstance] downloadImageForURLRequest:request success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
            
            DSPhoto *photo = [[DSPhoto alloc] init];
            photo.image = responseObject;
            [tempArray addObject:photo];
            weakSelf.photos = tempArray;
            
            NSLog(@"\nOne more image loaded!!!");
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"Image not loaded");
        }];
        
    }
    
    return YES;
}

@end
