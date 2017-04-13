//
//  DSAdressViewController.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 12.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSAdressViewController.h"
#import "DSAdressMOManager.h"

NSString *const DSAdressChangedNotification = @"DSAdressChangedNotification";

@interface DSAdressViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) DSAdressMOManager *adressMOManager;

@end

@implementation DSAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    self.adressMOManager = [[DSAdressMOManager alloc] init];
    
    for (UITextField *textField in self.textFields) {
        textField.delegate = self;
    }

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadData];

    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (![textField isEqual:[self.textFields lastObject]]) {
        NSInteger index = [self.textFields indexOfObject:textField];
        [[self.textFields objectAtIndex:index + 1] becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions

- (IBAction)actionReadyButton:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DSAdressChangedNotification object:nil];
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 ;
                             }];
    
}

- (IBAction)actionTextFieldEditingDidEnd:(UITextField *)sender {
    [self saveDataBy:sender];

}

- (IBAction)actionTextFieldEditingChanged:(UITextField *)sender {
    [self saveDataBy:sender];

}

#pragma mark - Methods

- (void) saveDataBy:(UITextField *)sender {
    
    if ([sender isEqual:self.cityTextField]) {
        
        self.adressMOManager.currentCity = self.cityTextField.text;
        
    }
    
    if ([sender isEqual:self.streetTextField]) {
        
        self.adressMOManager.currentStreet = self.streetTextField.text;
        
    }
    
    if ([sender isEqual:self.flatNumberTextField]) {
        
        self.adressMOManager.currentFlat = self.flatNumberTextField.text;
        
    }
    
    if ([sender isEqual:self.buildingTextField]) {
        
        self.adressMOManager.currentBuilding = self.buildingTextField.text;
        
    }
    
    if ([sender isEqual:self.houseNumberTextField]) {
        
        self.adressMOManager.currentHouse = self.houseNumberTextField.text;
        
    }
}

- (void) loadData {
    
    self.cityTextField.text = self.adressMOManager.currentCity;
    self.streetTextField.text = self.adressMOManager.currentStreet;
    self.flatNumberTextField.text = self.adressMOManager.currentFlat;
    self.buildingTextField.text = self.adressMOManager.currentBuilding;
    self.houseNumberTextField.text = self.adressMOManager.currentHouse;
    
}

@end
