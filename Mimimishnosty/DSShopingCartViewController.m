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
#import "DSItem_MO+CoreDataClass.h"

@interface DSShopingCartViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

static NSString *identifier = @"shopingCartCell";

@implementation DSShopingCartViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([DSShopingCartCell class])
                                bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:identifier];
    

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

    return [[self.fetchedResultsController sections] count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DSShopingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[DSShopingCartCell alloc] init];
    }
    
    DSItem_MO *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = item.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 160.f;
    
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
