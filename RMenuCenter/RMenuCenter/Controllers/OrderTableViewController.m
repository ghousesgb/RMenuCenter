//
//  OrderTableViewController.m
//  RMenuCenter
//
//  Created by sandeep.v on 9/7/15.
//  Copyright (c) 2015 GlobalSoftwareSolutions. All rights reserved.
//

#import "OrderTableViewController.h"
#import "CustomCell.h"

@interface OrderTableViewController (){
    NSMutableArray *mOrderArray;
    NSInteger mFooterCount;
}

@end

@implementation OrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    mFooterCount = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrderChangeHandler:) name:kOrderChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger row = 0;
    
    if ([mOrderArray count]>0) {
        row = [mOrderArray count]+mFooterCount;
    }
    return row;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"orderCell";
    static NSString *CellIdentifier2 = @"placeOrderCell";
    CustomCell *cell;
    
    if (indexPath.row<[mOrderArray count]) {
        cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...

        cell.mOrderItem.text = [[mOrderArray objectAtIndex:indexPath.row] objectForKey:kItemName];
        NSInteger quantity = [[[mOrderArray objectAtIndex:indexPath.row] objectForKey:kQuantity] integerValue];
        cell.mOrderItemQuantity.text = [NSString stringWithFormat:@"%ld",quantity];
    }
    else{
        cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        
    }
    [cell.layer setCornerRadius:15.0];
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSString *sectionName = @"Item                      Quantity";
//    return sectionName;
//}

#pragma mark - Table view delegate
#pragma mark -

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    float height = 65.0f;
//    return height;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [USER_DEFAULTS setObject:kYes forKey:kExpandedOrder];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowExpanadedOrderNotification object:mOrderArray];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 44.0f;
    return headerHeight;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, self.tableView.sectionHeaderHeight)];
    UILabel *itemLable = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, self.tableView.sectionHeaderHeight*0.3, 180.0f, 45.0f)];
    [itemLable setNumberOfLines:2];
    [itemLable setText:kItem];
    UILabel *quantityLable = [[UILabel alloc] initWithFrame:CGRectMake(itemLable.frame.size.width+30.0f, self.tableView.sectionHeaderHeight*0.4, 80.0f, 45.0f)];
    [quantityLable setText:kQuantity];
    [sectionView addSubview:itemLable];
    [sectionView addSubview:quantityLable];
    return sectionView;
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

#pragma mark - Order Change Notification Handler
#pragma mark -
-(void)onOrderChangeHandler:(NSNotification*)notification{
    NSDictionary *notifObject = [notification object];
    mOrderArray = [NSMutableArray arrayWithArray:[notifObject objectForKey:kOrderArray]];
    
    NSInteger index = [[notifObject objectForKey:kOperationIndex] integerValue];
    NSArray *indexPathArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil];
    NSInteger totalTableRows = [self.tableView numberOfRowsInSection:0];
    
    if ([[mOrderArray valueForKey:kItemId] containsObject:[notifObject objectForKey:kItemId]]) {
        mFooterCount = 1;
        [self.tableView beginUpdates];
        if ([[notifObject objectForKey:kOperation] isEqualToString:kInsert]) {
            if (totalTableRows>1) {
                [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationRight];
            }
            else{
                NSArray *indexPathWithFooterArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0],[NSIndexPath indexPathForRow:[mOrderArray count] inSection:0], nil];
                [self.tableView insertRowsAtIndexPaths:indexPathWithFooterArray withRowAnimation:UITableViewRowAnimationRight];
            }
        }else if ([[notifObject objectForKey:kOperation] isEqualToString:kEdit]){
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationRight];
        }
        [self.tableView endUpdates];
    }
    else{
        if ([[notifObject objectForKey:kOperation] isEqualToString:kDelete]){
            [self.tableView beginUpdates];
            if (totalTableRows>2) {
                mFooterCount = 1;
                [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationRight];
            }
            else{
                mFooterCount = 0;
                NSArray *indexPathForDeleteAllArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0],[NSIndexPath indexPathForRow:[mOrderArray count]+1 inSection:0], nil];
                [self.tableView deleteRowsAtIndexPaths:indexPathForDeleteAllArray withRowAnimation:UITableViewRowAnimationRight];
            }
            [self.tableView endUpdates];
        }
    }
}

@end
