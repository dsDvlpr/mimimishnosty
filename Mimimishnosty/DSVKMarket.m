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

NSString *const DSMarketManagerShopArrayDidChangeNotification = @"DSMarketManagerShopArrayDidChangeNotification";

@interface DSVKMarket ()

@property (strong, nonatomic) NSArray *items;

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
/*
#pragma mark - getter

- (NSArray *) items {
    
    if ([_items count] == 0) {
        [self loadMarketItems];
        
    }
    
    return _items;
}
*/
#pragma mark - setters

-(void)setItems:(NSArray *)items {
    
    _items = items;

    [[NSNotificationCenter defaultCenter] postNotificationName:DSMarketManagerShopArrayDidChangeNotification object:nil];

    
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
                        
                        NSLog(@"\n%@", response);
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
