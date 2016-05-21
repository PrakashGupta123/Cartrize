//
//  SplashViewController.h
//  IShop
//
//  Created by Hashim on 4/30/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "ViewController.h"
#import "GridViewController.h"
//#import "ParentViewController.h"
//#import "SWRevealViewController.h"

@interface SplashViewController : UIViewController//<MHTabBarControllerDelegate,SWRevealViewControllerDelegate>
{
    IBOutlet UIActivityIndicatorView *activityIndicator;
}

//@property (strong, nonatomic) SWRevealViewController *revealView;

@property(strong,nonatomic)ViewController *viewController;
@property(strong,nonatomic)LoginView *loginObj;
@property(strong,nonatomic)GridViewController *gridObj;
-(void)LoginCheckAndgetUpdateCart;

@end
