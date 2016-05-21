//
//  RegistrationSocial.h
//  IShop
//
//  Created by Avnish Sharma on 5/8/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RegistrationSocial : UIViewController<UITextFieldDelegate,UIWebViewDelegate>
{
    //iVar uitextfield
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtFName;
    IBOutlet UITextField *txtLName;
    UIWebView *wv;
    
  }

@property(nonatomic ,retain)NSDictionary *dicData;

@property(nonatomic ,retain)IBOutlet UIScrollView *mainScrollVIew;
@property(nonatomic ,retain)IBOutlet UITextField *txtPassword;
@property(nonatomic ,retain)IBOutlet UITextField *txtConfirmPassword;
@property(nonatomic ,retain)IBOutlet UIImageView *imgValidaation;
@property (nonatomic,strong) NSString *strCheckViewControler;

- (IBAction) btnNextStepAction:(id)sender;
- (IBAction) btnBackAction:(id)sender;

@end
