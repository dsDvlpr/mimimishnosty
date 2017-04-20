//
//  DSOrdersCell.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 15.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSOrdersCell.h"
#import "DSCollectionViewItemCell.h"

@implementation DSOrdersCell


- (void)awakeFromNib {
    [super awakeFromNib];
    UINib *collectionCellNib = [UINib nibWithNibName:NSStringFromClass([DSCollectionViewItemCell class]) bundle:[NSBundle mainBundle]];
    
    [self.itemsCollectionView registerNib:collectionCellNib
               forCellWithReuseIdentifier:itemCollectionCellIdentifier];
    
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath {
    
    self.itemsCollectionView.dataSource = dataSourceDelegate;
    self.itemsCollectionView.delegate = dataSourceDelegate;
    self.itemsCollectionView.indexPath = indexPath;
    [self.itemsCollectionView setContentOffset:self.itemsCollectionView.contentOffset animated:NO];
    
    [self.itemsCollectionView reloadData];

    
}

@end
