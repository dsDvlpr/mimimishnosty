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
    
    self.adressMOManager = [[DSAdressMOManager alloc] init];
    
    for (UITextField *textField in self.textFields) {
        textField.delegate = self;
    }

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Tap to hide keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTap:)];
    
    [self.view addGestureRecognizer:tapGesture];

    [self loadData];

    
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

#pragma mark - Gestures
- (void) handleTap:(UITapGestureRecognizer *) tapGestureRecognizer {
    
    for (UITextField *textField in self.textFields) {
        [textField resignFirstResponder];
    }
    
}

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
