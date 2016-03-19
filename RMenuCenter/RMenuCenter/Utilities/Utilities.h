//
//  Utilities.h
//  RMenuCenter
//
//  Created by Shaik Ghouse Basha on 31/08/15.
//  Copyright (c) 2015 GlobalSoftwareSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "GiFHUD.h"

@interface Utilities : NSObject

+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;
+ (void)dismissGlobalHUD;
+ (MBProgressHUD *)showHUDReportIt:(NSString *)title withTag:(NSInteger)tag;
@end
