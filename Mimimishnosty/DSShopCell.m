//
//  DSShopCell.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 27.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSShopCell.h"
#import "DSMarket.h"


@implementation DSShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionBuyItem:(UIButton *)sender {

    DSMarket *market = [[DSMarket alloc]init];
    [market addItemToShopingCart:self.itemInfo];

}
@end
