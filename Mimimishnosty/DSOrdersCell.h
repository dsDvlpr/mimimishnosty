//
//  DSOrdersCell.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 15.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSItemsCollectionView.h"

static NSString *itemCollectionCellIdentifier = @"itemCollectionCell";

@interface DSOrdersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet DSItemsCollectionView *itemsCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end
