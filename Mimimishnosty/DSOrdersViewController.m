//
//  DSOrdersViewController.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 15.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSOrdersViewController.h"
#import "DSCoreDataManager.h"
#import "DSOrdersCell.h"
#import "DSOrderMOManager.h"
#import "DSCollectionViewItemCell.h"
#import "DSItem_MO+CoreDataClass.h"
#import "DSVKManager.h"
#import "DSMarket.h"
#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "DSAdressMOManager.h"

@interface DSOrdersViewController ()<NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) DSAdressMOManager *adressManager;

@end

static NSString *ordersIdentifier = @"ordersCell";
static NSString *emptyCellIdentifier = @"emptyCell";

@implementation DSOrdersViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.adressManager = [[DSAdressMOManager alloc] init];
    UINib *orderCellNib = [UINib nibWithNibName:NSStringFromClass([DSOrdersCell class]) bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:orderCellNib
         forCellReuseIdentifier:ordersIdentifier];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:emptyCellIdentifier];
    
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    NSFetchRequest *fetchRequest = [DSOrder_MO fetchRequest];
    
    NSSortDescriptor *sortTitleDescriptor = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
    
    fetchRequest.sortDescriptors = @[sortTitleDescriptor];
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
        
        
    } else if (type == NSFetchedResultsChangeInsert) {
        
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                              withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView reloadData];
        
    } else {
        
        [self.tableView reloadData];
        
    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView endUpdates];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects] + 1;

}

- (NSUInteger) ordersCount {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    NSUInteger result = [sectionInfo numberOfObjects];

    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self ordersCount]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyCellIdentifier];
        }
        
        return cell;
        
    } else {
        
        DSOrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:ordersIdentifier forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[DSOrdersCell alloc] init];
        }
        
        DSOrder_MO *order = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSDate *orderDate = order.date;
        NSCalendarUnit units = kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay;
        
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:units fromDate: orderDate];
        
        NSString *month = [[NSCalendar currentCalendar].shortMonthSymbols objectAtIndex:[dateComponents month] - 1];
        
        cell.orderDateLabel.text = [NSString stringWithFormat:@"Заказ %ld %@ %ld", (long)dateComponents.day, month, (long)dateComponents.year];
        
        DSOrderMOManager *orderManager = [[DSOrderMOManager alloc] init];
        NSInteger totalPrice = [orderManager totalPriceOfOrder:order];
        cell.priceLabel.text = [NSString stringWithFormat:@"%ld руб.", (long)totalPrice];
        
        cell.adressLabel.text = order.delivery ? [self.adressManager adressStringForAdressMO:order.adress] : @"Самовывоз";
        
        return cell;
        
    }
    
    return nil;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(DSOrdersCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self ordersCount]) {

        [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];

    }
    
/*    CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
    [cell.itemsCollectionView setContentOffset:CGPointMake(horizontalOffset, 0)];*/
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self ordersCount]) {
        return 44.f;
    }
    
    return 200.f;
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(DSItemsCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    DSOrder_MO *order = [self.fetchedResultsController objectAtIndexPath:collectionView.indexPath];
    

    return [order.items count];
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(DSItemsCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DSCollectionViewItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCollectionCellIdentifier
                                                                               forIndexPath:indexPath];
    if (!cell) {
        cell = [[DSCollectionViewItemCell alloc] init];
    }
    DSOrder_MO *order = [self.fetchedResultsController objectAtIndexPath:collectionView.indexPath];
    
    NSArray<DSItem_MO *> *items = [order.items allObjects];
    DSItem_MO *itemForCell = [items objectAtIndex:indexPath.row];
    NSString *title = itemForCell.title;
    cell.titleLabel.text = [title stringByReplacingOccurrencesOfString:@"для соски и прорезывателя" withString:@""];
    
    NSURL *imageURL = [NSURL URLWithString:itemForCell.iconURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    __weak DSCollectionViewItemCell *weakCell = cell;
    [cell.itemImageView setImageWithURLRequest:request
                              placeholderImage:[UIImage imageNamed:@"defaultPic.png"]
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           weakCell.itemImageView.image = image;
                                           
                                           [weakCell layoutSubviews];
                                           
                                       } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           
                                       }];

    
    return cell;
    
}


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
