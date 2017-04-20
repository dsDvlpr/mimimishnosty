//
//  DSItemViewController.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 29.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSItemViewController.h"
#import "DSPhoto.h"
#import "NYTPhotosViewController.h"
#import "DSPhotoViewerController.h"
#import "DSVKManager.h"
#import "DSMarket.h"

NSString *const DSShopItemBuyNotification = @"DSShopItemBuyNotification";

@interface DSItemViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSIndexPath *nameTextFieldIndexPath;
@property (strong, nonatomic) DSPhotoViewerController *photoViewerController;

@end


BOOL nameTextFieldIsShown = NO;
NSInteger imageRow = 0;


@implementation DSItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.itemInfo) {
        
        self.titleLabel.text = [self.itemInfo objectForKey:DSVKMarketItemTitleKey];
        self.priceLabel.text = [[self.itemInfo objectForKey:DSVKMarketItemPriceKey] objectForKey:@"text"];
        self.descriptionLabel.text = [self.itemInfo objectForKey:DSVKMarketItemDescriptionKey];
        
        NSArray *photoURLStrings = [self photoURLStringsFromItem:self.itemInfo];
        self.photoViewerController =
        [[DSPhotoViewerController alloc] initWithPhotosURLs:photoURLStrings
                                           inViewController:self
                                               andImageView:self.mainImageView];

        self.nameTextField.delegate = self;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.nameTextFieldCell]) {
        self.nameTextFieldIndexPath = indexPath;
    } else if([cell isEqual:self.controlSwitchCell]) {
        [self.textFieldSwitch setOn:nameTextFieldIsShown];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!nameTextFieldIsShown && [indexPath isEqual:self.nameTextFieldIndexPath]) {
        return 0;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.nameTextField resignFirstResponder];
}

#pragma mark - Methods

- (NSArray *) photoURLStringsFromItem:(NSDictionary *) item {
    
    NSMutableArray *photoURLStrings = [NSMutableArray array];
    
    static NSString *photosKey = @"photos";
    static NSString *URLStringKey = @"photo_1280";
    NSArray *photoDictionaries = [item objectForKey:photosKey];
    
    for (NSDictionary *photoDictionary in photoDictionaries) {
        
        NSString *URLString = [photoDictionary objectForKey:URLStringKey];
        if (URLString) {
            [photoURLStrings addObject:URLString];
        }
    }
    
    return [NSArray arrayWithArray:photoURLStrings];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions

- (IBAction)actionTextFieldSwitch:(UISwitch *)sender {
    
    nameTextFieldIsShown = sender.isOn;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}

- (IBAction)actionBuyShopItem:(UIButton *)sender {
    
    DSMarket *market = [[DSMarket alloc]init];
    [market addItemToShopingCart:self.itemInfo];
    
}
@end
