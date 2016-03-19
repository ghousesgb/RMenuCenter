//
//  Utilities.m
//  RMenuCenter
//
//  Created by Shaik Ghouse Basha on 31/08/15.
//  Copyright (c) 2015 GlobalSoftwareSolutions. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities
#pragma mark -
#pragma mark Global Usage of the HUD
#pragma mark -

+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    hud.accessibilityLabel=@"loadingHUD";
    return hud;
}

+ (void)dismissGlobalHUD {
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

+ (MBProgressHUD *)showHUDReportIt:(NSString *)title withTag:(NSInteger)tag {
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = title;
    
    NSString *imageFile=@"";
    if(tag==1)
        imageFile = @"successReport";
    else
        imageFile = @"failedReport";
    
    hud.accessibilityLabel=imageFile;
    hud.isAccessibilityElement=YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageFile]];
    [hud show:YES];
    [hud hide:YES afterDelay:5];
    return hud;
}


@end
