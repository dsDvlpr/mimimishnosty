//
//  DSShopingCartCell.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 03.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSShopingCartCell.h"
#import "DSVKManager.h"
#import "DSShopingCart.h"
#import "DSCoreDataManager.h"

@interface DSShopingCartCell ()

@property (weak, nonatomic) NSDictionary *itemInfo;


@end

@implementation DSShopingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionIncrementQuantity:(UIButton *)sender {
    
    self.itemMO.quantity++;
    [[DSCoreDataManager sharedManager] saveContext];
    
}

- (IBAction)actionDecrementQuantity:(UIButton *)sender {
    
    if (self.itemMO.quantity > 1) {
    
        self.itemMO.quantity --;
    
    } else {
    
        DSShopingCart *shopingCartManager = [[DSShopingCart alloc] init];
        DSShopingCart_MO *defaultSC = [shopingCartManager defaultShopingCart];
        [defaultSC removeItemsObject:self.itemMO];
        
    }

    [[DSCoreDataManager sharedManager] saveContext];

}
@end
