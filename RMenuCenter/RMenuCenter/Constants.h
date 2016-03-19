//
//  Constants.h
//  THLabelExample
//
//  Created by Tobias Hagemann on 09/09/14.
//  Copyright (c) 2014 tobiha.de. All rights reserved.
//

#define BASE_URL            "http://192.168.0.205:8888/RMenuCenter/"
#define CATEGORY_LIST_URL   "categoryList.php"
#define SAVE_ORDER_URL      "saveOrder.php"

#define USER_DEFAULTS       [NSUserDefaults standardUserDefaults]

#define kShadowColor1		[UIColor redColor]
#define kShadowColor2		[UIColor colorWithWhite:0.0 alpha:0.75]
#define kShadowColor3		[UIColor yellowColor]

#define kShadowOffset		CGSizeMake(0.0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0 : 2.0)

#define kShadowBlur			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 10.0 : 5.0)
#define kInnerShadowOffset	CGSizeMake(0.0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 2.0 : 1.0)
#define kInnerShadowBlur	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0 : 2.0)

#define kStrokeColor		[UIColor blackColor]
#define kStrokeSize			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6.0 : 3.0)

#define kGradientStartColor	[UIColor colorWithRed:255.0 / 255.0 green:193.0 / 255.0 blue:127.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:255.0 / 255.0 green:163.0 / 255.0 blue:64.0 / 255.0 alpha:1.0]


//LaunchScreenViewController
#define kCATEGORY_RESPONSE  @"CategoryAPIResponse"

//MenuViewController
#define kResult @"Result"
#define kCategoryId @"CategoryId"
#define kCategoryName @"CategoryName"
#define kItemList @"ItemList"
#define kItemId @"ItemId"
#define kItemType @"ItemType"
#define kItemName @"ItemName"
#define kItemDescription @"ItemDescription"
#define kItemPrice @"ItemPrice"
#define kQuantity @"Quantity"
#define kItem @"Item"
#define kPrice @"Price"
#define kPriceSymbol @"R"//R for Rupees; D for Dollar and P for Pounds
#define kRupees @"R"
#define kDollar @"D"
#define kPounds @"P"
#define kRupeeIcon @"rupee.png"
#define kDollarIcon @"dollar.png"
#define kPoundsIcon @"pounds.png"
#define kCategoryImage @"category.png";
#define kItemSegue @"itemSegue"
#define kOrderArray @"orderArray"
#define kVegColor [UIColor colorWithRed:0.50f green:0.87f blue:0.43f alpha:1.0f]
#define kVegSelectedColor [UIColor colorWithRed:0.50f green:0.8f blue:0.43f alpha:1.0f]
#define kNonVegColor [UIColor colorWithRed:0.9f green:0.4f blue:0.3f alpha:1.0f]
#define kNonVegSelectedColor [UIColor colorWithRed:0.8f green:0.26f blue:0.3f alpha:1.0f]
#define kExpandedOrder @"expandedOrder"
#define kYes @"yes"
#define kNo @"no"

//Order controller
#define kInsert @"insert"
#define kDelete @"delete"
#define kEdit @"edit"
#define kOperation @"operation"
#define kOperationIndex @"operationIndex"

//Notifications
#define kOrderChangeNotification @"orderChangeNotification"
#define kSectionChangedNotification @"sectionChangedNotification"
#define kSectionSelectedNotification @"sectionSelectedNotification"
#define kShowExpanadedOrderNotification @"showExpandedOrderNotification"
#define kHideExpanadedOrderNotification @"hideExpanadedOrderNotification"
#define kUpdateItemNotification @"updateItemNotification"

