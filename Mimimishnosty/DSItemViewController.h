//
//  DSItemViewController.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 29.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const DSShopItemBuyNotification;

@interface DSItemViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *itemInfo;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *nameTextFieldCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *controlSwitchCell;
@property (weak, nonatomic) IBOutlet UISwitch *textFieldSwitch;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

- (IBAction)nameTextFieldChanged:(UITextField *)sender;
- (IBAction)actionTextFieldSwitch:(UISwitch *)sender;
- (IBAction)actionBuyShopItem:(UIButton *)sender;


@end
