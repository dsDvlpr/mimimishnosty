//
//  DSShopViewController.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 26.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSShopViewController.h"
#import "DSShopCell.h"
#import "DSVKManager.h"
#import "UIImageView+AFNetworking.h"
#import "DSItemViewController.h"

@interface DSShopViewController ()

@property (strong, nonatomic) NSArray *items;


@end

@implementation DSShopViewController

static NSString *identifier = @"shopCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DSVKManager *vkManager = [DSVKManager sharedManager];
    self.items = vkManager.vkMarket.items;
    
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([DSShopCell class])
                                bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:identifier];
    
    UIColor *color = [UIColor colorWithRed:223.f/256.f
                                     green:81.f/256.f
                                      blue:88.f/256.f
                                     alpha:1.f];
    
    self.tableView.backgroundColor = color;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"\n\nNumber of rows:%ld",[self.items count]);
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"shopCell";
    
    DSShopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[DSShopCell alloc] init];
    }
    
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [item valueForKey:DSVKMarketItemTitleKey];
    
    NSDictionary *priceDictionary = [item valueForKey:DSVKMarketItemPriceKey];
    cell.priceLabel.text = [priceDictionary valueForKey:@"text"];
    
    NSURL *mainImageURL = [NSURL URLWithString:[item valueForKey:DSVKMarketItemMainImageURLKey]];
    NSURLRequest *request = [NSURLRequest requestWithURL:mainImageURL];
    __weak DSShopCell *weakCell = cell;
    [cell.itemImageView setImageWithURLRequest:request
                              placeholderImage:[UIImage imageNamed:@"defaultPic.png"]
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           weakCell.itemImageView.image = image;
                                           [weakCell layoutSubviews];
                                           
                                       }
                                       failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           
                                           NSLog(@"Image not loaded");
                                           
                                       }];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIStoryboard *storyboard =
    [UIStoryboard storyboardWithName:@"Main"
                              bundle:[NSBundle mainBundle]];

    DSItemViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DSItemViewController"];

    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    vc.item = item;
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
}
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        
}


@end
