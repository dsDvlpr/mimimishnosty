//
//  DSStartViewController.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 20.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSStartViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *logInButton;


- (IBAction)actionVKLogIn:(UIButton *)sender;
- (IBAction)actionLogOut:(UIButton *)sender;

@end
