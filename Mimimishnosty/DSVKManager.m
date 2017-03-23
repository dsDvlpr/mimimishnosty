//
//  DSVKManager.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 20.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSVKManager.h"
#import <VKSdk.h>
#import <AFNetworking.h>
#import <UIKit/UIKit.h>
#import <VKUser.h>
#import "SCLAlertView.h"

NSString* const DSVKManagerAuthorisationViewControllerHiddenDidChangeNotification = @"DSVKManagerAuthorisationViewControllerHiddenDidChangeNotification";

NSString* const DSVKManagerAuthorisationViewControllerHiddenUserInfoKey = @"DSVKManagerAuthorisationViewControllerHiddenUserInfoKey";

NSString *appID = @"5937274";

@interface DSVKManager () <VKSdkUIDelegate, VKSdkDelegate>


@end

@implementation DSVKManager

static NSArray *scope = nil;

+ (DSVKManager *) sharedManager {
    
    static DSVKManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DSVKManager alloc] init];
    });
    
    return manager;
}

- (instancetype) init {
    
    self = [super init];
    if (self) {
        scope = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_EMAIL, VK_PER_MESSAGES, VK_PER_MARKET, VK_PER_STATUS];
        
        [[VKSdk initializeWithAppId:appID] registerDelegate:self];
        [[VKSdk instance] setUiDelegate:self];        

    }
    
    return self;
}

#pragma mark - setters

// post a notification about hidding authorisation VC

- (void) setAuthorisationViewControllerHidden:(BOOL)hidden {
    
    _isAuthorisationViewControllerHidden = hidden;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@(hidden) forKey:DSVKManagerAuthorisationViewControllerHiddenUserInfoKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DSVKManagerAuthorisationViewControllerHiddenDidChangeNotification
                                                        object:nil
                                                      userInfo:dictionary];
    
}

#pragma mark - getters 
- (BOOL) isLoggedIn {
    return [VKSdk isLoggedIn];
}

#pragma mark - methods


- (BOOL) logIn {
    
    [VKSdk wakeUpSession:scope completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            
            [self loadUser];
            NSLog(@"\nАвторизовались по старинке");
            self.isAuthorisationViewControllerHidden = YES;
            
        } else {
            
            if (error) {
                
                NSLog(@"\nWakeUpSession error %@", error);
            }
            
            [VKSdk authorize:scope];        }
    }];
    
    if ([VKSdk isLoggedIn]) {
        
        [self.vkMarket loadMarkteItems];
    }

    return [VKSdk isLoggedIn];
}

- (void) logOut {
    
    [VKSdk forceLogout];
         
}

- (void) checkAuthorisationOnSuccess:(void (^)(void))success onFailor:(void (^)(void))failor {
    
    [VKSdk wakeUpSession:scope completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            
            if (success) {
                success();
            }
            
        } else {
            if (failor) {
                failor();
            }
        }
    }];
    
}

- (void) sendMessage:(NSString *)message toUserWithId:(NSString *) userId onSuccess:(void (^)(void))success onFailor:(void (^)(void))failor {
    
    NSString *URLString = @"https://api.vk.com/method/";
    NSURL *URL =[NSURL URLWithString:URLString];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId                              , @"user_id",
                            message                             , @"message",
                            @(5.63)                             , @"version" ,
                            [[VKSdk accessToken] accessToken]   , @"access_token",
                            nil];
    
    [manager GET:@"messages.send"
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"\n\n\n\nSendMessage:\n%@", responseObject);
             NSDictionary *error = [responseObject objectForKey:@"error"];
             
             if (error != nil) {
                 
                 if (failor) {
                     failor();
                 }
                 
             } else {
                 
                 if (success) {
                     success ();
                 }
                 
             }
         }
     
         failure:
     
     nil];
    
}

- (void) loadUser {
    
    NSString *URLString = @"https://api.vk.com/method/";
    NSURL *URL =[NSURL URLWithString:URLString];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    
    NSString *methodName = @"account.getProfileInfo";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(5.63)                             , @"version" ,
                            [[VKSdk accessToken] accessToken]   , @"access_token",
                            nil];
    
    __block NSDictionary *result = [NSDictionary dictionary];
    
    __weak DSVKManager* weakSelf = self;
    [manager GET:methodName
      parameters:params
        progress:^(NSProgress * _Nonnull downloadProgress) {
            ;
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             result = [responseObject valueForKey:@"response"];
             weakSelf.user = [[VKUser alloc] initWithDictionary:result];
             
             [self showGreetingsAlert];
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"\nERROR");
             
             ;
         }];
}

#pragma mark - VKSdkUIDelegate

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    
    UIViewController *vc = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    [vc presentViewController:controller
                     animated:YES
                   completion:^{
                       ;
                   }];
    
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    
    VKCaptchaViewController *vcToPresent = [VKCaptchaViewController captchaControllerWithError:captchaError];
    UIViewController *vc = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [vcToPresent presentIn:vc];
    
}

- (void)vkSdkDidDismissViewController:(UIViewController *)controller{
    
    if ([VKSdk isLoggedIn]) {
        [self loadUser];
    }
    
}

- (void) showGreetingsAlert {
    
    NSString *greetings = [NSString stringWithFormat:@"%@ %@",self.user.first_name, self.user.last_name];
    SCLAlertView *alertView = [[SCLAlertView alloc] initWithNewWindow];
    [alertView showSuccess:greetings
                  subTitle:@"Добро пожаловать!"
          closeButtonTitle:@"OK"
                  duration:7];
    
}

#pragma mark - VKSdkDelegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    
    NSLog(@"\n\nПользователь: %@ %@", result.user.first_name, result.user.last_name);
 
}

- (void)vkSdkUserAuthorizationFailed {
    NSLog(@"Authorization failed");
}

@end
