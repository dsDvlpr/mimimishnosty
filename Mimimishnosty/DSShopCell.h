//
//  DSShopCell.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 27.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSShopCellView.h"

@interface DSShopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

- (IBAction)actionBuyItem:(UIButton *)sender;

@end
