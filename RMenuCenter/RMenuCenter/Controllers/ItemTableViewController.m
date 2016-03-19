//
//  ItemTableViewController.m
//  RMenuCenter
//
//  Created by sandeep.v on 9/3/15.
//  Copyright (c) 2015 GlobalSoftwareSolutions. All rights reserved.
//

#import "ItemTableViewController.h"
#import "CategoryTableViewController.h"
#import "CustomCell.h"

@interface ItemTableViewController (){
    NSInteger mSelectedSection;
}
@property (strong,nonatomic) NSMutableArray *mCategoryArray;
@property (strong,nonatomic) NSMutableArray *mOrderArray;
@property (strong,nonatomic) CategoryTableViewController *mCategoryObject;
@end

@implementation ItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSectionSelectionHandler:) name:kSectionSelectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateItemHandler:) name:kUpdateItemNotification object:nil];
    
    mSelectedSection=-1;
    self.mCategoryArray = [[NSMutableArray alloc] init];
    self.mOrderArray = [[NSMutableArray alloc] init];
    self.mCategoryObject = [[CategoryTableViewController alloc] init];
    
    if ([USER_DEFAULTS objectForKey:kCATEGORY_RESPONSE]!=nil) {
        NSDictionary *categoryResponse = [USER_DEFAULTS objectForKey:kCATEGORY_RESPONSE];
        self.mCategoryArray = [NSMutableArray arrayWithArray:[categoryResponse objectForKey:kResult]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger sections = 1;
    
    if ([self.mCategoryArray count]>0) {
        sections = [self.mCategoryArray count];
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSUInteger row = 0;
    if ([self.mCategoryArray count]>0) {
        row = [[[self.mCategoryArray objectAtIndex:section] objectForKey:kItemList] count];
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"itemCell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.layer setCornerRadius:15.0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.mItemName.text = [[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemName];
    cell.mItemDescription.text = [[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemDescription];
    cell.mItemPrice.text = [[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemPrice];
    [cell.mAddButton addTarget:self action:@selector(onAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mMinusButton addTarget:self action:@selector(onMinusButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([kPriceSymbol isEqualToString:kRupees]) {
        [cell.mPriceSymbol setImage:[UIImage imageNamed:kRupeeIcon]];
    }else if ([kPriceSymbol isEqualToString:kDollar]) {
        [cell.mPriceSymbol setImage:[UIImage imageNamed:kDollarIcon]];
    }else if ([kPriceSymbol isEqualToString:kPounds]) {
        [cell.mPriceSymbol setImage:[UIImage imageNamed:kPoundsIcon]];
    }
    
    if ([[self.mOrderArray valueForKey:kItemId] containsObject:[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemId]]) {
        NSInteger index = [[self.mOrderArray valueForKey:kItemId] indexOfObject:[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemId]];
        cell.mItemQuantity.text = [NSString stringWithFormat:@"%@",[[self.mOrderArray objectAtIndex:index] objectForKey:kQuantity]];
    }
    else{
        cell.mItemQuantity.text = @"0";
    }
    
    if ([[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemType] isEqualToString:@"1"]) {
        if ([[self.mOrderArray valueForKey:kItemId] containsObject:[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemId]]) {
            [cell setBackgroundColor:kVegSelectedColor];
        }else{
            [cell setBackgroundColor:kVegColor];
        }
    }
    else{
        if ([[self.mOrderArray valueForKey:kItemId] containsObject:[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemId]]) {
            [cell setBackgroundColor:kNonVegSelectedColor];
        }else{
            [cell setBackgroundColor:kNonVegColor];
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName = @"";
    if ([[[self.mCategoryArray objectAtIndex:section] objectForKey:kItemList] count]>0) {
        sectionName = [[self.mCategoryArray objectAtIndex:section] objectForKey:kCategoryName];
    }
    
    return sectionName;
}

#pragma mark - Table view delegate
#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = 132.0f;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 44.0f;
    return headerHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    NSIndexPath *firstVisibleIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
    if (mSelectedSection != firstVisibleIndexPath.section) {
        mSelectedSection = firstVisibleIndexPath.section;
        [[NSNotificationCenter defaultCenter] postNotificationName:kSectionChangedNotification object:[NSString stringWithFormat:@"%ld",(long)firstVisibleIndexPath.section]];
    }
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

#pragma mark - Button events
#pragma mark -

-(void)onAddButton:(id)sender{
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    NSMutableDictionary *orderDictionary;
    NSString *operation = @"";
    NSInteger operationIndex;
    
    if ([[self.mOrderArray valueForKey:kItemId] containsObject:[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemId]]) {
        operationIndex = [[self.mOrderArray valueForKey:kItemId] indexOfObject:[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemId]];
        orderDictionary = [NSMutableDictionary dictionaryWithDictionary:[self.mOrderArray objectAtIndex:operationIndex]];
        NSInteger quantity = [[[self.mOrderArray objectAtIndex:operationIndex] objectForKey:kQuantity] integerValue];
        [orderDictionary setObject:[NSNumber numberWithInteger:quantity+1] forKey:kQuantity];
        [self.mOrderArray replaceObjectAtIndex:operationIndex withObject:orderDictionary];
        operation = kEdit;
    }
    else{
        orderDictionary = [[NSMutableDictionary alloc] init];
        [orderDictionary setObject:@"" forKey:@"tableNo"];
        [orderDictionary setObject:[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kCategoryId] forKey:kCategoryId];
        [orderDictionary setObject:[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemId] forKey:kItemId];
        [orderDictionary setObject:[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemName] forKey:kItemName];
        [orderDictionary setObject:[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemPrice] forKey:kItemPrice];
        [orderDictionary setObject:[NSNumber numberWithInteger:1] forKey:kQuantity];
        [self.mOrderArray addObject:orderDictionary];
        operation = kInsert;
        operationIndex = [self.mOrderArray count]-1;
    }
//    [USER_DEFAULTS setObject:self.mOrderArray forKey:kOrderArray];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    NSMutableDictionary *notificationDictionary = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:operation,[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemId],[NSNumber numberWithInteger:operationIndex],self.mOrderArray, nil] forKeys:[NSArray arrayWithObjects:kOperation,kItemId,kOperationIndex,kOrderArray, nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kOrderChangeNotification object:notificationDictionary];

    NSLog(@"\n%@\n",self.mOrderArray);
}

-(void)onMinusButton:(id)sender{
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    NSMutableDictionary *orderDictionary;
    NSString *operation = @"";
    NSInteger operationIndex;
    
    if ([[self.mOrderArray valueForKey:kItemId] containsObject:[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemId]]) {
        operationIndex = [[self.mOrderArray valueForKey:kItemId] indexOfObject:[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemId]];
        orderDictionary = [NSMutableDictionary dictionaryWithDictionary:[self.mOrderArray objectAtIndex:operationIndex]];
        NSInteger quantity = [[[self.mOrderArray objectAtIndex:operationIndex] objectForKey:kQuantity] integerValue];
        if (quantity>1) {
            [orderDictionary setObject:[NSNumber numberWithInteger:quantity-1] forKey:kQuantity];
            [self.mOrderArray replaceObjectAtIndex:operationIndex withObject:orderDictionary];
            operation = kEdit;
        }
        else{
            [self.mOrderArray removeObjectAtIndex:operationIndex];
            operation = kDelete;
        }
//        [USER_DEFAULTS setObject:self.mOrderArray forKey:kOrderArray];
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        NSMutableDictionary *notificationDictionary = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:operation,[[[[self.mCategoryArray objectAtIndex:indexPath.section] objectForKey:kItemList] objectAtIndex:indexPath.row] objectForKey:kItemId],[NSNumber numberWithInteger:operationIndex],self.mOrderArray, nil] forKeys:[NSArray arrayWithObjects:kOperation,kItemId,kOperationIndex,kOrderArray, nil]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kOrderChangeNotification object:notificationDictionary];
    }
    NSLog(@"\n%@\n",self.mOrderArray);
}

#pragma mark - Scroll view delegate
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSIndexPath *firstVisibleIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
    if (mSelectedSection != firstVisibleIndexPath.section) {
        mSelectedSection = firstVisibleIndexPath.section;
        [[NSNotificationCenter defaultCenter] postNotificationName:kSectionChangedNotification object:[NSString stringWithFormat:@"%ld",firstVisibleIndexPath.section]];
    }
}

#pragma mark - Section selection notification handler
#pragma mark -

-(void) onSectionSelectionHandler:(NSNotification*)notification{
    NSInteger section = [[notification object] integerValue];
    if ([[[self.mCategoryArray objectAtIndex:section] objectForKey:kItemList] count]>0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


-(void) onUpdateItemHandler:(NSNotification*)notification{
    NSDictionary *notificationDictionary = [notification object];
    NSString *categoryId = [notificationDictionary objectForKey:kCategoryId];
    NSString *itemId = [notificationDictionary objectForKey:kItemId];
    self.mOrderArray = [NSMutableArray arrayWithArray:[notificationDictionary objectForKey:kOrderArray]];
    
    NSInteger sectionIndex = [[self.mCategoryArray valueForKey:kCategoryId] indexOfObject:categoryId];
    NSInteger rowIndex;
    NSArray *itemList = [[self.mCategoryArray objectAtIndex:sectionIndex] objectForKey:kItemList];
    
    if ([itemList count]>0) {
        rowIndex = [[itemList valueForKey:kItemId] indexOfObject:itemId];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

@end
