//
//  ItemCell.h
//  RMenuCenter
//
//  Created by sandeep.v on 9/1/15.
//  Copyright (c) 2015 GlobalSoftwareSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mItemName;
@property (weak, nonatomic) IBOutlet UILabel *mItemDescription;
@property (weak, nonatomic) IBOutlet UILabel *mItemPrice;
@property (weak, nonatomic) IBOutlet UILabel *mItemQuantity;
@property (weak, nonatomic) IBOutlet UIButton *mAddButton;
@property (weak, nonatomic) IBOutlet UIButton *mMinusButton;
@property (weak, nonatomic) IBOutlet UIImageView *mPriceSymbol;
@property (weak, nonatomic) IBOutlet UIImageView *mCategoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *mCategoryLable;
@property (weak, nonatomic) IBOutlet UILabel *mOrderSNo;
@property (weak, nonatomic) IBOutlet UILabel *mOrderItem;
@property (weak, nonatomic) IBOutlet UILabel *mOrderItemQuantity;
@property (weak, nonatomic) IBOutlet UILabel *mExpandedOrderItemName;
@property (weak, nonatomic) IBOutlet UILabel *mExpandedOrderPrice;
@property (weak, nonatomic) IBOutlet UILabel *mExpandedOrderQuantity;
@property (weak, nonatomic) IBOutlet UILabel *mExpandedOrderProgress;
@property (weak, nonatomic) IBOutlet UIButton *mExpandedOrderMinusButton;
@property (weak, nonatomic) IBOutlet UIButton *mExpandedOrderPlusButton;
@property (weak, nonatomic) IBOutlet UIButton *mExpandedOrderDeleteButton;
@end
