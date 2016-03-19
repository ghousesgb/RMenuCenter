//
//  ExpandedOrderTableViewController.m
//  RMenuCenter
//
//  Created by sandeep.v on 9/11/15.
//  Copyright (c) 2015 GlobalSoftwareSolutions. All rights reserved.
//

#import "ExpandedOrderTableViewController.h"
#import "NSURLConnection+Blocks.h"
#import "CustomCell.h"

@interface ExpandedOrderTableViewController (){
    NSMutableArray *mOrderArray;
}

@end

@implementation ExpandedOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    mOrderArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showExpanadedOrderHandler:) name:kShowExpanadedOrderNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [mOrderArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"orderCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    [cell.mExpandedOrderItemName setText:[[mOrderArray objectAtIndex:indexPath.row] objectForKey:kItemName]];
    [cell.mExpandedOrderPrice setText:[[mOrderArray objectAtIndex:indexPath.row] objectForKey:kItemPrice]];
    NSInteger quantity = [[[mOrderArray objectAtIndex:indexPath.row] objectForKey:kQuantity] integerValue];
    cell.mOrderItemQuantity.text = [NSString stringWithFormat:@"%ld",quantity];
    [cell.mExpandedOrderQuantity setText:[NSString stringWithFormat:@"%ld",quantity]];
    [cell.mExpandedOrderMinusButton  addTarget:self action:@selector(onClickMinus:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mExpandedOrderPlusButton   addTarget:self action:@selector(onClickPlus:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mExpandedOrderDeleteButton addTarget:self action:@selector(onClickDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - Table view data delegate
#pragma mark -

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, self.tableView.sectionHeaderHeight)];
    UILabel *itemLable = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, self.tableView.sectionHeaderHeight*0.3, 260.0f, 45.0f)];
    [itemLable setNumberOfLines:2];
    [itemLable setText:kItem];
    UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(itemLable.frame.size.width+30.0f, self.tableView.sectionHeaderHeight*0.4, 49.0f, 45.0f)];
    [priceLable setText:kPrice];
    UILabel *quantityLable = [[UILabel alloc] initWithFrame:CGRectMake(itemLable.frame.size.width+priceLable.frame.size.width+60.0f, self.tableView.sectionHeaderHeight*0.4, 80.0f, 45.0f)];
    [quantityLable setText:kQuantity];
    [sectionView addSubview:itemLable];
    [sectionView addSubview:priceLable];
    [sectionView addSubview:quantityLable];
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 44.0f;
    return headerHeight;
}


#pragma mark - Show expanded order notification handler
#pragma mark -

-(void) showExpanadedOrderHandler:(NSNotification*)notification{
    mOrderArray = [NSMutableArray arrayWithArray:[notification object]];
    [self.tableView reloadData];
}

#pragma mark - makeAPICall
-(void)makeAPICall {
    NSString *categoryAPIURL = [NSString stringWithFormat:@"%s%s",BASE_URL,SAVE_ORDER_URL];
    NSURL *url = [NSURL URLWithString:categoryAPIURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:mOrderArray options:0 error:nil];;
    [NSURLConnection asyncRequest:request
                          success:^(NSData *data, NSURLResponse *response) {
                              NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                              [USER_DEFAULTS setObject:responseData forKey:kCATEGORY_RESPONSE];
                          }
                          failure:^(NSData *data, NSError *error) {
                              DLog(@"Error: %@", error);
                          }];
    
}

#pragma mark - Button Actions
#pragma mark - 
- (IBAction)closeButtonAction:(id)sender {
    [USER_DEFAULTS setObject:kNo forKey:kExpandedOrder];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHideExpanadedOrderNotification object:nil];

}
- (IBAction)placeOrderButtonAction:(id)sender {
    [self makeAPICall];
}

-(void)onClickPlus:(id)sender{
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    NSMutableDictionary *orderDictionary;
    NSString *operation = @"";
    NSInteger operationIndex;
    NSString *itemId = @"";
    NSString *categoryId = @"";
    
    operationIndex = indexPath.row;
    orderDictionary = [NSMutableDictionary dictionaryWithDictionary:[mOrderArray objectAtIndex:operationIndex]];
    NSInteger quantity = [[[mOrderArray objectAtIndex:operationIndex] objectForKey:kQuantity] integerValue];
    
    [orderDictionary setObject:[NSNumber numberWithInteger:quantity+1] forKey:kQuantity];
    itemId = [[mOrderArray objectAtIndex:operationIndex] objectForKey:kItemId];
    categoryId = [[mOrderArray objectAtIndex:operationIndex] objectForKey:kCategoryId];
    [mOrderArray replaceObjectAtIndex:operationIndex withObject:orderDictionary];
    operation = kEdit;
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    //Posting notification to order container to reflect the order change details
    NSMutableDictionary *orderChangeDictionary = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:operation,itemId,[NSNumber numberWithInteger:operationIndex],mOrderArray, nil] forKeys:[NSArray arrayWithObjects:kOperation,kItemId,kOperationIndex,kOrderArray, nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kOrderChangeNotification object:orderChangeDictionary];
    
    //Posting notification to item container to reflect the change details
    NSMutableDictionary *updateItemDictionary = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:categoryId,itemId,mOrderArray, nil] forKeys:[NSArray arrayWithObjects:kCategoryId,kItemId,kOrderArray, nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateItemNotification object:updateItemDictionary];
    
    //Hide the exapand view controller
    if ([mOrderArray count]<1) {
        [USER_DEFAULTS setObject:kNo forKey:kExpandedOrder];
        [[NSNotificationCenter defaultCenter] postNotificationName:kHideExpanadedOrderNotification object:nil];
    }
}

-(void)onClickMinus:(id)sender{
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    NSMutableDictionary *orderDictionary;
    NSString *operation = @"";
    NSInteger operationIndex;
    NSString *itemId = @"";
    NSString *categoryId = @"";
    
    operationIndex = indexPath.row;
    orderDictionary = [NSMutableDictionary dictionaryWithDictionary:[mOrderArray objectAtIndex:operationIndex]];
    NSInteger quantity = [[[mOrderArray objectAtIndex:operationIndex] objectForKey:kQuantity] integerValue];
    
    if (quantity>1) {
        [orderDictionary setObject:[NSNumber numberWithInteger:quantity-1] forKey:kQuantity];
        itemId = [[mOrderArray objectAtIndex:operationIndex] objectForKey:kItemId];
        categoryId = [[mOrderArray objectAtIndex:operationIndex] objectForKey:kCategoryId];
        [mOrderArray replaceObjectAtIndex:operationIndex withObject:orderDictionary];
        operation = kEdit;
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
    else{
        itemId = [[mOrderArray objectAtIndex:operationIndex] objectForKey:kItemId];
        categoryId = [[mOrderArray objectAtIndex:operationIndex] objectForKey:kCategoryId];
        [mOrderArray removeObjectAtIndex:indexPath.row];
        operation = kDelete;
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
    
    //Posting notification to order container to reflect the order change details
    NSMutableDictionary *orderChangeDictionary = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:operation,itemId,[NSNumber numberWithInteger:operationIndex],mOrderArray, nil] forKeys:[NSArray arrayWithObjects:kOperation,kItemId,kOperationIndex,kOrderArray, nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kOrderChangeNotification object:orderChangeDictionary];
   
    //Posting notification to item container to reflect the change details
    NSMutableDictionary *updateItemDictionary = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:categoryId,itemId,mOrderArray, nil] forKeys:[NSArray arrayWithObjects:kCategoryId,kItemId,kOrderArray, nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateItemNotification object:updateItemDictionary];
    
    //Hide the exapand view controller
    if ([mOrderArray count]<1) {
        [USER_DEFAULTS setObject:kNo forKey:kExpandedOrder];
        [[NSNotificationCenter defaultCenter] postNotificationName:kHideExpanadedOrderNotification object:nil];
    }
}

-(void)onClickDelete:(id)sender{
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    NSMutableDictionary *orderDictionary;
    NSString *operation = @"";
    NSInteger operationIndex;
    NSString *itemId = @"";
    NSString *categoryId = @"";
    
    operationIndex = indexPath.row;
    orderDictionary = [NSMutableDictionary dictionaryWithDictionary:[mOrderArray objectAtIndex:operationIndex]];
    
    itemId = [[mOrderArray objectAtIndex:operationIndex] objectForKey:kItemId];
    categoryId = [[mOrderArray objectAtIndex:operationIndex] objectForKey:kCategoryId];
    [mOrderArray removeObjectAtIndex:indexPath.row];
    operation = kDelete;
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    //Posting notification to order container to reflect the order change details
    NSMutableDictionary *orderChangeDictionary = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:operation,itemId,[NSNumber numberWithInteger:operationIndex],mOrderArray, nil] forKeys:[NSArray arrayWithObjects:kOperation,kItemId,kOperationIndex,kOrderArray, nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kOrderChangeNotification object:orderChangeDictionary];
    
    //Posting notification to item container to reflect the change details
    NSMutableDictionary *updateItemDictionary = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:categoryId,itemId,mOrderArray, nil] forKeys:[NSArray arrayWithObjects:kCategoryId,kItemId,kOrderArray, nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateItemNotification object:updateItemDictionary];
    
    //Hide the exapand view controller
    if ([mOrderArray count]<1) {
        [USER_DEFAULTS setObject:kNo forKey:kExpandedOrder];
        [[NSNotificationCenter defaultCenter] postNotificationName:kHideExpanadedOrderNotification object:nil];
    }
}

@end
