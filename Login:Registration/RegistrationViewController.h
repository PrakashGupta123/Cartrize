//
//  RegistrationViewController.h
//  IShop
//
//  Created by Avnish Sharma on 5/8/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RegistrationViewController : UIViewController<UITextFieldDelegate,UIWebViewDelegate>
{
    //iVar uitextfield
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtFName;
    IBOutlet UITextField *txtLName;
    IBOutlet UITextField *txtCnfmPassword;
    UIWebView *wv;
    
    //Mutable Data iVar
    NSMutableData *webData;
    BOOL checkWebView;
}
@property(nonatomic ,retain)IBOutlet UIScrollView *mainScrollVIew;
@property(nonatomic ,retain)IBOutlet UIView *viewTxtValidation,*viewContent;
@property (nonatomic,strong) NSString *strCheckViewControler;
    //@property(nonatomic,strong)IBOutlet UIView *viewEmailValidation;

@property(nonatomic ,retain)IBOutlet UIImageView *imgValidaation;
- (IBAction) btnNextStepAction:(id)sender;
- (IBAction) btnBackAction:(id)sender;

@property(strong,nonatomic)NSString *strTwitterId;

@end
