//
//  DSPlaceOrderCell.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 12.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSPlaceOrderCell.h"
#import "DSOrderMOManager.h"

@implementation DSPlaceOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionPlaceOrder:(UIButton *)sender {
    
    DSOrderMOManager *orderManager = [[DSOrderMOManager alloc] init];
    [orderManager createNewOrderWithDelivery:self.isDeliveryChosen];
    
}
@end
