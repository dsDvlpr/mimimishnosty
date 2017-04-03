//
//  DSVKMarket.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 21.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSVKMarket.h"
#import <AFNetworking.h>
#import <VKSdk.h>
#import "NSArray+DSArray.h"

NSString *const DSMarketManagerShopArrayDidChangeNotification = @"DSMarketManagerShopArrayDidChangeNotification";

NSString *const DSVKMarketItemTitleKey          = @"title";
NSString *const DSVKMarketItemDescriptionKey    = @"description";
NSString *const DSVKMarketItemPhotosKey         = @"photos";
NSString *const DSVKMarketItemPriceKey          = @"price";
NSString *const DSVKMarketItemMainImageURLKey   = @"thumb_photo";
NSString *const DSVKMarketItemIdKey                = @"id";


@interface DSVKMarket ()

@property (strong, nonatomic) NSString *groupID;

@end

@implementation DSVKMarket

-(instancetype)initWithGroupId:(NSString *)groupId {
    
    self = [super init];
    if (self) {
        self.groupID = groupId;
    }
    
    return self;
}

#pragma mark - setters

-(void)setItems:(NSArray *)items {
    
    _items = items;

    [[NSNotificationCenter defaultCenter] postNotificationName:DSMarketManagerShopArrayDidChangeNotification object:nil];

    
}

#pragma mark - methods

- (NSDictionary *) itemDictionaryForId:(int32_t) itemId {
    
    // ПРОВЕРИТЬ!!!!
    NSDictionary *result = nil;
    if ([self.items count] > 0) {
        result = [self.items objectWithValue:@(itemId)
                                                    forKey:DSVKMarketItemIdKey];
    }
    
    if (result) {
        return result;
    }
    
    return nil;
}


-(BOOL)loadMarketItems {
    
    NSString *URLString = @"https://api.vk.com/method/";
    NSURL *URL =[NSURL URLWithString:URLString];
    __block BOOL result = NO;
    
    AFHTTPSessionManager *requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.groupID,                       @"owner_id",
                            @(20),                              @"count",
                            @(0),                               @"offset",
                            @(1),                               @"extended",
                            @"5.62",                            @"v",
                            [[VKSdk accessToken] accessToken],  @"access_token",
                            nil];
    
    if ([VKSdk isLoggedIn]) {
        
        [requestManager GET:@"market.get"
                 parameters:params
                   progress:^(NSProgress * _Nonnull downloadProgress) {
                       ;
                   }
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        NSDictionary *response = [responseObject objectForKey:@"response"];
                        NSArray *items = [response objectForKey:@"items"];
                        self.items = [NSArray arrayWithArray:items];
                        
                        NSLog(@"\n%@", self.items);
                        NSLog(@"\n\nItems loaded");
                        result = YES;
                        
                    }
         
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"Request error:%@", error);
                        result = NO;
                    }];
        
    }

    return result;
}

@end
