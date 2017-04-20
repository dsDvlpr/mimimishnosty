//
//  DSPlaceOrderCell.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 12.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSPlaceOrderCell.h"
#import "DSOrderMOManager.h"
#import "SCLAlertView.h"

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

    NSString *greetings = @"Заказ оформлен!";
    SCLAlertView *alertView = [[SCLAlertView alloc] initWithNewWindow];
    [alertView showSuccess:greetings
                  subTitle:nil
          closeButtonTitle:@"OK"
                  duration:5];

    
    [orderManager createNewOrderWithDelivery:self.isDeliveryChosen];
    
}
@end
