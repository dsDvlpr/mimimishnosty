//
//  DSVKManager.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 20.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSVKMarket.h"
#import <VKUser.h>

extern NSString* const DSVKManagerLogInNotification;

extern NSString* const DSVKManagerLogInUserInfoKey;

@interface DSVKManager : NSObject

//@property (strong, atomic) NSArray *marketItemsArray;
@property (assign, setter = setAuthorisationViewControllerHidden:, nonatomic) BOOL isAuthorisationViewControllerHidden;

@property (strong, nonatomic) VKUser *user;
@property (strong, nonatomic) DSVKMarket *vkMarket;

+ (DSVKManager *) sharedManager;
- (BOOL) logIn;
- (BOOL) isLoggedIn;
- (void) logOut;
- (void) loadUser;
- (void) checkAuthorisationOnSuccess:(void (^)(void))success onFailor:(void (^)(void))failor;

- (void) sendMessage:(NSString *)message toUserWithId:(NSString *) userId onSuccess:(void (^)(void))success onFailor:(void (^)(void))failor;

- (void) showGreetingsAlert;

@end
