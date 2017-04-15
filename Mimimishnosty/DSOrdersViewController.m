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

@interface DSOrdersViewController ()<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

static NSString *ordersIdentifier = @"ordersCell";

@implementation DSOrdersViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *ordersNib = [UINib nibWithNibName:NSStringFromClass([DSOrdersCell class]) bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:ordersNib
         forCellReuseIdentifier:ordersIdentifier];
    
    // Uncomment the following line to preserve selection between presentations.
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
    
    NSSortDescriptor *sortTitleDescriptor = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    
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
        
        NSLog(@"deleteRowsAtIndexPaths");
        
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
    return [sectionInfo numberOfObjects];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    return cell;
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200.f;
    
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
