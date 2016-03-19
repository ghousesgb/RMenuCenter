//
//  LaunchScreenViewController.m
//  RMenuCenter
//
//  Created by Shaik Ghouse Basha on 27/08/15.
//  Copyright (c) 2015 GlobalSoftwareSolutions. All rights reserved.
//

#import "LaunchScreenViewController.h"
//#import "THLabel.h"
#import "NSURLConnection+Blocks.h"

@interface LaunchScreenViewController ()
@property (strong, nonatomic) IBOutlet UILabel *mMenuLabel;
@property (strong, nonatomic) IBOutlet UILabel *mTagLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *mEnterButton;

@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden =YES;
    self.mMenuLabel.shadowColor  = kShadowColor1;
    self.mMenuLabel.shadowOffset = kShadowOffset;
//    self.mMenuLabel.shadowBlur   = kShadowBlur;
    
    self.mTagLineLabel.shadowColor  = kShadowColor3;
    self.mTagLineLabel.shadowOffset = kShadowOffset;
//    self.mTagLineLabel.shadowBlur   = kShadowBlur;

    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animateView) userInfo:nil repeats:YES];
    [GiFHUD setGifWithImageName:@"loading_01.gif"];
    [GiFHUD show];
    [self makeAPICall];
   
//    [self animateView];

}
-(void)animateView {
    
    CGPoint oldCenterOfMenu = self.mMenuLabel.center;
    CGPoint oldCenterOfTag  = self.mTagLineLabel.center;
    
    [UIView animateWithDuration:1
                          delay:0 usingSpringWithDamping:1.5
          initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear
                     animations:^
                     {
                          self.mMenuLabel.center    = CGPointMake(self.view.frame.size.width/2+325, self.view.frame.size.height/2);
                          self.mTagLineLabel.center = CGPointMake(self.view.frame.size.width/2+350, (self.view.frame.size.height/2)+75);
                         /*
                          self.mMenuLabel.transform = CGAffineTransformMakeScale(1.25, 1.25);*/
                     }completion:^(BOOL finished)
                     {
                         [UIView animateWithDuration:1.0 delay:0
                              usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:0 animations:^
                              {
                                  self.mMenuLabel.center    = oldCenterOfMenu;
                                  self.mTagLineLabel.center = oldCenterOfTag;
                              } completion:nil];
                         
   
                     }];
}
-(void)makeAPICall {
    NSString *categoryAPIURL = [NSString stringWithFormat:@"%s%s",BASE_URL,CATEGORY_LIST_URL];
    NSURL *url = [NSURL URLWithString:categoryAPIURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection asyncRequest:request
                          success:^(NSData *data, NSURLResponse *response) {
                              DLog(@"Success: %@",response);
                              NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                              [USER_DEFAULTS setObject:responseData forKey:kCATEGORY_RESPONSE];
                              [self enterButtonAction:nil];
                              [GiFHUD dismiss];
                          }
                          failure:^(NSData *data, NSError *error) {
                              DLog(@"Error: %@", error);
                                                         [GiFHUD dismiss];
                          }];
    
}

- (IBAction)enterButtonAction:(id)sender {
    self.mEnterButton.backgroundColor = [UIColor redColor];
    [self.mEnterButton setTitle:@"" forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.mEnterButton.transform = CGAffineTransformMakeScale(100, 100);
        self.mEnterButton.alpha = 0.0;
        
    } completion:^(BOOL finish){
        [self performSegueWithIdentifier:@"homeScreenSegue" sender:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
}


@end
