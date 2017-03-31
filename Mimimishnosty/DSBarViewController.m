//
//  DSBarViewController.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 26.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSBarViewController.h"
#import "BATabBarController.h"
#import "BATabBarItem.h"
#import "BATabBarBadge.h"
#import "DSShopViewController.h"

@interface DSBarViewController () <BATabBarControllerDelegate>

@property (strong, nonatomic) BATabBarController *tabBarController;

@end

@implementation DSBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    DSShopViewController *shopVC = [[DSShopViewController alloc] init];
    UINavigationController *shopNavVC = [[UINavigationController alloc]initWithRootViewController:shopVC];
    
    UIImage *shopActiveImage = [UIImage imageNamed:@"Shop_Active.png"];
    UIImage *shopPassiveImage = [UIImage imageNamed:@"Shop_Passive.png"];
    NSAttributedString *shopTitle = [[NSAttributedString alloc] initWithString:@"Магазин"];
    
    [self createTabBarItemWithDeselectedImage:shopPassiveImage
                                selectedImage:shopActiveImage
                                    itemTitle:shopTitle
                            forViewController:shopNavVC];
    
    //__________________________________________________________________
    //TabBarController
    //__________________________________________________________________
    
    if (!self.tabBarController) {
        self.tabBarController = [[BATabBarController alloc] init];
    }
    
    [self.tabBarController setSelectedViewController:shopNavVC animated:YES];
    self.tabBarController.delegate = self;
    self.tabBarController.tabBarItemStrokeColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tabBarController.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (BATabBarItem *) createTabBarItemWithDeselectedImage:(UIImage*)deselImage
                                         selectedImage:(UIImage*)selImage
                                             itemTitle:(NSAttributedString*)titleString
                                     forViewController:(UIViewController*)vc {
    
    BATabBarItem *tabBarItem = [[BATabBarItem alloc]
                                initWithImage:deselImage
                                selectedImage:selImage
                                title:titleString];
    
    if (!self.tabBarController) {
        self.tabBarController = [[BATabBarController alloc] init];
    }
    
    self.tabBarController.tabBarBackgroundColor = [UIColor darkGrayColor];
    
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
    [tempArray addObject:vc];
    self.tabBarController.viewControllers = tempArray;
    
    tempArray = [NSMutableArray arrayWithArray:self.tabBarController.tabBarItems];
    [tempArray addObject:tabBarItem];
    self.tabBarController.tabBarItems = tempArray;
    
    return tabBarItem;
}


#pragma mark - BATabBarControllerDelegate
- (void)tabBarController:(BATabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
