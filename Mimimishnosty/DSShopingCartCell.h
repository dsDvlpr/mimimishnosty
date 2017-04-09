//
//  DSShopingCartCell.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 03.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSItem_MO+CoreDataClass.h"

@interface DSShopingCartCell : UITableViewCell

@property (weak, nonatomic) DSItem_MO *itemMO;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

- (IBAction)actionIncrementQuantity:(UIButton *)sender;
- (IBAction)actionDecrementQuantity:(UIButton *)sender;

@end
