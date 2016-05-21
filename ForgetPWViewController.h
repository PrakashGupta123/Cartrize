//
//  ForgetPWViewController.h
//  CartRize
//
//  Created by Dipesh on 12/11/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ForgetPWViewController : UIViewController<UIWebViewDelegate>
{
   // IBOutlet UIWebView *web;
}
@property(weak,nonatomic)IBOutlet UITextField *txtEmail;
- (IBAction)actionOnDismiss:(id)sender;
@end
