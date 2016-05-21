//
//  DashboardView.h
//  IShop
//
//  Created by Admin on 15/07/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@interface DashboardView : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate>{

    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtFName;
    IBOutlet UITextField *txtLName;
    IBOutlet UITextField *txtCnfmPassword;

    IBOutlet UITableView *tab;
    NSMutableArray *dashArray;
    IBOutlet UISegmentedControl *seg;
    IBOutlet UIView *myAcc_view;
}
@property(nonatomic,retain)MBProgressHUD *progressHud;
@property(nonatomic,retain)UIWindow *window;
-(IBAction)backAction:(id)sender;
-(IBAction)segmentAction:(id)sender;
- (IBAction) btnNextStepAction:(id)sender;

@end
