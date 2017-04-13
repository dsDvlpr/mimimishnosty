//
//  DSAdressViewController.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 12.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const DSAdressChangedNotification;

@interface DSAdressViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetTextField;
@property (weak, nonatomic) IBOutlet UITextField *houseNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *buildingTextField;
@property (weak, nonatomic) IBOutlet UITextField *flatNumberTextField;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

- (IBAction)actionReadyButton:(UIButton *)sender;
- (IBAction)actionTextFieldEditingDidEnd:(UITextField *)sender;
- (IBAction)actionTextFieldEditingChanged:(UITextField *)sender;



@end
