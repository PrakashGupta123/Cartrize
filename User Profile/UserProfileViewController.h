//
//  UserProfileViewController.h
//  IShop
//
//  Created by Hashim on 6/19/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserProfileViewController : UIViewController<UITextFieldDelegate>
{
    //iVar uitextfield
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtFName;
    IBOutlet UITextField *txtLName;
    IBOutlet UITextField *txtCnfmPassword;
    IBOutlet UISegmentedControl *seg;

}
-(IBAction)backAction:(id)sender;
-(IBAction)segmentAction:(id)sender;

- (IBAction) btnNextStepAction:(id)sender;
- (IBAction) btnBackAction:(id)sender;

@end
