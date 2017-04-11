//
//  DSDeliveryChooseCell.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 09.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DSDeliveryChooseCellDelegate;

@interface DSDeliveryChooseCell : UITableViewCell

@property (weak, nonatomic) id<DSDeliveryChooseCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *deliveryChoseSegmentControl;

- (IBAction)actionDeliveryChanged:(UISegmentedControl *)sender;

@end

@protocol DSDeliveryChooseCellDelegate <NSObject>

-(void) deliveryTypeDidChangeInDeliveryChooseCell:(DSDeliveryChooseCell *) cell;

@end
