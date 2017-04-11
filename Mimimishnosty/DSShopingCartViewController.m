//
//  DSShopingCartViewController.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 03.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSShopingCartViewController.h"
#import "DSCoreDataManager.h"
#import "DSShopingCartCell.h"
#import "DSCoreDataManager.h"
#import "DSVKManager.h"
#import "DSItemViewController.h"
#import "NSArray+DSArray.h"
#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "DSItem_MO+CoreDataClass.h"
#import "DSMarket.h"
#import "DSDeliveryChooseCell.h"
#import "DSAdressCell.h"
#import "DSPlaceOrderCell.h"

@interface DSShopingCartViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

static NSString *itemIdentifier = @"shopingCartCell";
static NSString *deliveryChooseIdentifier = @"deliveryChooseCell";
static NSString *adressIdentifier = @"adressCell";
static NSString *placeOrderIdentifier = @"placeOrderCell";

@implementation DSShopingCartViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *clearBarButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Очистить корзину"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(actionClearShopingCart:)];
    
    clearBarButton.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = clearBarButton;
    
    UINib *itemNib = [UINib nibWithNibName:NSStringFromClass([DSShopingCartCell class])
                                bundle:[NSBundle mainBundle]];
    UINib *deliveryChooseNib = [UINib nibWithNibName:NSStringFromClass([DSDeliveryChooseCell class]) bundle:[NSBundle mainBundle]];
    UINib *adressNib = [UINib nibWithNibName:NSStringFromClass([DSAdressCell class]) bundle:[NSBundle mainBundle]];
    UINib *placeOrderNib = [UINib nibWithNibName:NSStringFromClass([DSPlaceOrderCell class]) bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:itemNib
         forCellReuseIdentifier:itemIdentifier];
    [self.tableView registerNib:deliveryChooseNib
         forCellReuseIdentifier:deliveryChooseIdentifier];
    [self.tableView registerNib:adressNib
         forCellReuseIdentifier:adressIdentifier];
    [self.tableView registerNib:placeOrderNib
         forCellReuseIdentifier:placeOrderIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *context = [[[DSCoreDataManager sharedManager] persistentContainer] viewContext];
    
    NSFetchRequest *fetchRequest = [DSItem_MO fetchRequest];
    
    NSSortDescriptor *sortTitleDescriptor = [[NSSortDescriptor alloc]initWithKey:@"title" ascending:YES];
    NSPredicate *activeOrderPredicate = [NSPredicate predicateWithFormat:@"shopingCart.shopingCartId == 1"];
    
    fetchRequest.sortDescriptors = @[sortTitleDescriptor];
    fetchRequest.predicate = activeOrderPredicate;
    NSFetchedResultsController *frc =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:context
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    frc.delegate = self;

    self.fetchedResultsController = frc;
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;

}

#pragma mark -  NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(nullable NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(nullable NSIndexPath *)newIndexPath {
    
    if (type == NSFetchedResultsChangeDelete) {
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationBottom];
        
        NSLog(@"deleteRowsAtIndexPaths");
        
    } else if (type == NSFetchedResultsChangeInsert) {
        
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                              withRowAnimation:UITableViewRowAnimationRight];
    } else {
        
        [self.tableView reloadData];
        
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView endUpdates];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [[self.fetchedResultsController sections] count] + 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return [self numberOfItems];
            break;
            
        case 1:
            return 3;
            break;
            
        default:
            return 0;
            break;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        DSShopingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:itemIdentifier forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[DSShopingCartCell alloc] init];
        }
        
        DSItem_MO *itemMO = [self.fetchedResultsController objectAtIndexPath:indexPath];
        int32_t itemId = itemMO.itemId;
        
        cell.itemMO = itemMO;
        DSVKManager *vkManager = [DSVKManager sharedManager];
        NSDictionary *itemInfo = [[vkManager vkMarket] itemInfoDictionaryForId:itemId];
        NSString *photoURLString = [itemInfo objectForKey:DSVKMarketItemMainImageURLKey];
        NSURL *imageURL = [NSURL URLWithString:photoURLString];
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
        __weak DSShopingCartCell *weakCell = cell;
        [cell.mainImageView setImageWithURLRequest:request
                                  placeholderImage:[UIImage imageNamed:@"defaultPic.png"]
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                               
                                               weakCell.mainImageView.image = image;
                                               [weakCell layoutSubviews];
                                               
                                           } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                               ;
                                           }];
        
        cell.titleLabel.text = itemMO.title;
        cell.quantityLabel.text = [NSString stringWithFormat:@"%d", itemMO.quantity];
        cell.priceLabel.text = [[itemInfo objectForKey:DSVKMarketItemPriceKey]
                                objectForKey:@"text"];
        int totalPrice = itemMO.quantity * itemMO.price;
        cell.totalPriceLabel.text = [NSString stringWithFormat:@"%d руб.", totalPrice];
        
        return cell;
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        
        DSDeliveryChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:deliveryChooseIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [[DSDeliveryChooseCell alloc] init];
        }
        
        return cell;
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        DSAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:adressIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [[DSAdressCell alloc] init];
        }
        
        return cell;
        
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        
        DSPlaceOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:placeOrderIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [[DSPlaceOrderCell alloc] init];
        }
        
        return cell;
        
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        [self.tableView reloadData];
        NSError *error = nil;
        if (![context save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Товары";
            break;
            
        case 1:
            return @"Доставка";
            break;
            
        default:
            break;
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 160.f;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        return 44.f;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        return 77.f;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        return 100.f;
    }
    return 44.f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:@"Main"
                                  bundle:[NSBundle mainBundle]];
        
        DSItemViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DSItemViewController"];
        DSItem_MO *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
        int32_t itemId = item.itemId;
        
        NSDictionary *itemInfo = [[[DSVKManager sharedManager]vkMarket] itemInfoDictionaryForId:itemId];
        
        vc.itemInfo = itemInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Actions

- (void) actionClearShopingCart:(UIBarButtonItem *)sender {
    
    [[DSMarket sharedManager] clearShopingCart];
    
}

#pragma mark - Methods

- (NSUInteger) numberOfItems {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    return [sectionInfo numberOfObjects];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
