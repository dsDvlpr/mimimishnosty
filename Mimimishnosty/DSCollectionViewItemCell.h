//
//  DSCollectionViewItemCell.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 17.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSCollectionViewItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
