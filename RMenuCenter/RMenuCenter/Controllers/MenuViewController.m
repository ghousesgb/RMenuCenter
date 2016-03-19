//
//  MenuViewController.m
//  RMenuCenter
//
//  Created by sandeep.v on 9/1/15.
//  Copyright (c) 2015 GlobalSoftwareSolutions. All rights reserved.
//

#import "MenuViewController.h"
#import "CustomCell.h"

@interface MenuViewController (){
    double lastRotation;
    
    IBOutlet UIView *mWaiterView;
    IBOutlet UITextField *mTableNumber;
    IBOutlet UITextField *mWaiterName;
    IBOutlet UIButton *mSaveWaiterDetailsButton;
    IBOutlet UIImageView *mBackgroundView;
    
}
@property (weak, nonatomic) IBOutlet UITableView *mListTableView;
@property (weak, nonatomic) IBOutlet UITableView *mListDetailTableView;
@property (weak, nonatomic) IBOutlet UITableView *mOrderTableView;
@property (strong,nonatomic) NSMutableArray *mListArray;
@property (strong,nonatomic) NSMutableArray *mListDetailArray;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mItemContainer setHidden:NO];
    [self.mOrderContainer setHidden:NO];
    [self.mExpandOrderContainer setHidden:YES];
    [USER_DEFAULTS setObject:kNo forKey:kExpandedOrder];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showExpanadedOrderHandler:) name:kShowExpanadedOrderNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideExpanadedOrderHandler:) name:kHideExpanadedOrderNotification object:nil];
    
//    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
//    [rotationRecognizer setDelegate:self];
//    [self.view addGestureRecognizer:rotationRecognizer];
    
//    UIRotationGestureRecognizer *twoFingersRotate =
//    [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingersRotate:)];
//    [[self view] addGestureRecognizer:twoFingersRotate];
}

//- (void)twoFingersRotate:(UIRotationGestureRecognizer *)recognizer {
//    // Convert the radian value to show the degree of rotation
//    NSLog(@"Rotation in degrees since last change: %f", [recognizer rotation] * (180 / M_PI));
//}

//-(void)rotate:(id)sender{
//    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
//        lastRotation = 0.0;
//        return;
//    }
//    
//    CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
//    
//    CGAffineTransform currentTransform = self.view.transform;
//    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
//    
//    [self.view setTransform:newTransform];
//    
//    lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- UITableViewDatasource methods
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger sections = 1;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSUInteger row = 0;
    if ([tableView tag]==0) {
        if ([self.mListArray count]>0) {
            row = [self.mListArray count];
        }
    }else if ([tableView tag]==1){
        if ([self.mListDetailArray count]>0) {
            row = [self.mListDetailArray count];
        }
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"listCell";
    static NSString *CellIdentifier1 = @"listDetailCell";
    if([tableView tag]==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [[self.mListArray objectAtIndex:indexPath.row] objectForKey:kCategoryName];
        return cell;
    }else if([tableView tag]==1) {
        CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        }
        cell.mItemName.text = [[self.mListDetailArray objectAtIndex:indexPath.row] objectForKey:kItemName];
        cell.mItemDescription.text = [[self.mListDetailArray objectAtIndex:indexPath.row] objectForKey:kItemDescription];
        cell.mItemPrice.text = [[self.mListDetailArray objectAtIndex:indexPath.row] objectForKey:kItemPrice];
        if ([kPriceSymbol isEqualToString:kRupees]) {
            [cell.mPriceSymbol setImage:[UIImage imageNamed:kRupeeIcon]];
        }else if ([kPriceSymbol isEqualToString:kDollar]) {
            [cell.mPriceSymbol setImage:[UIImage imageNamed:kDollarIcon]];
        }else if([kPriceSymbol isEqualToString:kPounds]) {
                [cell.mPriceSymbol setImage:[UIImage imageNamed:kPoundsIcon]];
        }
        return cell;
    }
    return nil;
}

#pragma mark- UITableViewDelegate methods
#pragma mark-

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView tag]==0) {
        [self.mListDetailArray removeAllObjects];
        self.mListDetailArray = [NSMutableArray arrayWithArray:[[self.mListArray objectAtIndex:indexPath.row] objectForKey:kItemList]];
        [self.mListDetailTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = 44.0f;
    if ([tableView tag]==1) {
        height = 132.0f;
    }
    return height;
}

#pragma mark - TapRecognizer
- (IBAction)tapRecognizerAction:(id)sender {
    mBackgroundView.frame = self.view.frame;
    [self.view addSubview:mBackgroundView];
    [self.view addSubview:mWaiterView];
    mWaiterView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"waiterView":mWaiterView};
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mWaiterView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:mBackgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mWaiterView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:mBackgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[waiterView(370)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[waiterView(128)]" options:0 metrics:nil views:views]];
    
}

- (IBAction)saveWaiterButtonAction:(id)sender {
    CGRect imageFrame = mWaiterView.frame;
    CGRect backFrame  = mBackgroundView.frame;
    imageFrame.origin.y = self.view.bounds.size.height;
    backFrame.origin.y  = self.view.bounds.size.height*-1;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         mWaiterView.frame = imageFrame;
                     }
                     completion:^(BOOL finished){
                         [mWaiterView removeFromSuperview];
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              mBackgroundView.frame = backFrame;
                                          }
                                          completion:^(BOOL finished){
                                              [mBackgroundView removeFromSuperview];
                                          }];
                    }];
}

#pragma mark - Notification handler
#pragma mark -

-(void) showExpanadedOrderHandler:(NSNotification*)notification{
    [self.mItemContainer setHidden:YES];
    [self.mOrderContainer setHidden:YES];
    [self.mExpandOrderContainer setHidden:NO];
}

-(void) hideExpanadedOrderHandler:(NSNotification*)notification{
    [self.mItemContainer setHidden:NO];
    [self.mOrderContainer setHidden:NO];
    [self.mExpandOrderContainer setHidden:YES];
}

@end
