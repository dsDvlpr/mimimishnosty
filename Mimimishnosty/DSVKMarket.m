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

@interface DSVKMarket ()

@property (strong, nonatomic) NSArray *marketItems;
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

- (NSArray *) marketItems {
    
    if ([self.marketItems count] == 0) {
        [self loadMarkteItems];
    }
    
    return self.marketItems;
}

-(BOOL)loadMarkteItems {
    
    NSString *URLString = @"https://api.vk.com/method/";
    NSURL *URL =[NSURL URLWithString:URLString];
    __block BOOL result = NO;
    
    AFHTTPSessionManager *requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.groupID,                       @"owner_id",
                            @(20),                              @"count",
                            @(0),                               @"offset",
                            @(1),                               @"extended",
                            @"5.63",                            @"v",
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
                        self.marketItems = [NSArray arrayWithArray:items];
                        
                        //[[DSMarketManager sharedManager] loadShopItemsFromArray:items];
                        
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
