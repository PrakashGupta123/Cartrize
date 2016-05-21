//
//  LoginView.h
//  Cartrize
//
//  Created by Admin on 19/07/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>// 4Apr Facebook
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Social/Social.h>
#import "MBProgressHUD.h"
#import "ForgetPWViewController.h"

@class GPPSignInButton;

@interface LoginView : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>{
    IBOutlet UITextField *emailTf;
    IBOutlet UITextField *passTf;
        // FBSession *session;
    NSHTTPCookie *cookie;
    IBOutlet UIScrollView *scrollBase;
    IBOutlet UIButton *btnSignUp;
    UIWebView *webView;
    
}
@property(nonatomic,retain)MBProgressHUD *progressHud;
@property(nonatomic,retain)UIWindow *window;
@property (nonatomic,strong) ACAccountStore *accountStore;
@property (nonatomic,strong) NSString *strCheckViewControler;


-(IBAction)loginAction:(id)sender;
-(IBAction)fbLoginAction:(id)sender;
-(IBAction)twLoginAction:(id)sender;
-(IBAction)ForgotPasswordAction:(id)sender;
-(IBAction)sKipAction:(id)sender;
-(IBAction)singupAction:(id)sender;
- (IBAction)googlePlusLogin:(id)sender;
@end
