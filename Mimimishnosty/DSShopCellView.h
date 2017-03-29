//
//  DSShopCellView.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 27.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSShopCellView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (UIView *) loadFromNib;

- (void) setup;

@end
