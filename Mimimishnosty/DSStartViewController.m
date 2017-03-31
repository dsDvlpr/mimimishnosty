//
//  DSStartViewController.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 20.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSStartViewController.h"
#import "SCLAlertView.h"
#import "DSVKManager.h"
#import "DSBarViewController.h"

@interface DSStartViewController ()

@end

@implementation DSStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logInButton.alpha = 0.f;
    
    DSVKManager *vkManager = [DSVKManager sharedManager];
    
    [vkManager checkAuthorisationOnSuccess:^{
        [vkManager loadUser];
        
    }
                                  onFailor:^{
                                      
                                      self.logInButton.alpha = 1.f;

                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLogInNotification:)
                                                 name:DSVKManagerLogInNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleItemsLoadedNotification:)
                                                 name:DSMarketManagerShopArrayDidChangeNotification
                                               object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Handle notification
- (void) handleLogInNotification:(NSNotification*) notification {
    
    self.logInButton.alpha = 0.f;
    NSLog(@"handleLogInNotification");
    
}
- (void) handleItemsLoadedNotification:(NSNotification*) notification {
    
    
    DSBarViewController *barVC = [[DSBarViewController alloc] init];
    
    [self presentViewController:barVC animated:YES completion:^{
        ;
    }];
    
}

#pragma mark - Actions

- (IBAction)actionVKLogIn:(UIButton *)sender {
    
    DSVKManager *vkManager = [DSVKManager sharedManager];
    [vkManager logIn];
    
}

- (IBAction)actionLogOut:(UIButton *)sender {
    
    DSVKManager *vkManager = [DSVKManager sharedManager];
    [vkManager logOut];
    self.logInButton.alpha = 1.f;
    
}
@end
