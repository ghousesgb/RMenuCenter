//
//  MenuViewController.h
//  RMenuCenter
//
//  Created by sandeep.v on 9/1/15.
//  Copyright (c) 2015 GlobalSoftwareSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mItemContainer;
@property (weak, nonatomic) IBOutlet UIView *mOrderContainer;
@property (weak, nonatomic) IBOutlet UIView *mExpandOrderContainer;
@end
