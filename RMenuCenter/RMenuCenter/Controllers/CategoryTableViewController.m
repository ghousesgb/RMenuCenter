//
//  CategoryTableViewController.m
//  RMenuCenter
//
//  Created by sandeep.v on 9/3/15.
//  Copyright (c) 2015 GlobalSoftwareSolutions. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "CustomCell.h"

@interface CategoryTableViewController ()
@property (strong,nonatomic) NSMutableArray *mCategoryArray;
@end

@implementation CategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSectionChangeHandler:) name:kSectionChangedNotification object:nil];
    
    self.mCategoryArray = [[NSMutableArray alloc] init];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger sections = 1;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSUInteger row = 0;
    if ([self.mCategoryArray count]>0) {
        row = [self.mCategoryArray count];
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    static NSString *CellIdentifier = @"categoryCell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.mCategoryLable setText:[[self.mCategoryArray objectAtIndex:indexPath.row] objectForKey:kCategoryName]];
    [cell.mCategoryImageView setImage:[UIImage imageNamed:@"categoryButton.png"]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectedBackgroundView:[self selectionViewForCell:cell]];
    
    return cell;
}

#pragma mark - Table view delegate
#pragma mark - 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *expandedOrderFlag = [USER_DEFAULTS objectForKey:kExpandedOrder];
    if ([expandedOrderFlag isEqualToString:kYes]) {
        [USER_DEFAULTS setObject:kNo forKey:kExpandedOrder];
        [[NSNotificationCenter defaultCenter] postNotificationName:kHideExpanadedOrderNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kSectionSelectedNotification object:[NSNumber numberWithInteger:indexPath.row]];
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
#pragma mark - Section change notification handler
#pragma mark -

-(void) onSectionChangeHandler:(NSNotification*)notification{
    NSInteger section = [[notification object] integerValue];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Other methods
#pragma mark -

-(UIView*) selectionViewForCell:(CustomCell*)cell{
    UIView *selectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cell.frame.size.width, cell.frame.size.height)];
    [selectionView setBackgroundColor:[UIColor yellowColor]];
    [cell setSelectedBackgroundView:selectionView];
    return selectionView;
}

@end
