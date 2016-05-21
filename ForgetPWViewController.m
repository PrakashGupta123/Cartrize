//
//  ForgetPWViewController.m
//  CartRize
//
//  Created by Dipesh on 12/11/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "ForgetPWViewController.h"
#import "CartrizeWebservices.h"
#import "Reachability.h"
#import "JSON.h"

@interface ForgetPWViewController ()

@end

@implementation ForgetPWViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
   
    
//    //load url into webview
//    NSString *strURL = @"http://www.cartrize.com";
//    NSURL *url = [NSURL URLWithString:strURL];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [web loadRequest:urlRequest];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}
-(IBAction)actionForgaotPass:(id)sender{
    
    [_txtEmail resignFirstResponder];
    
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
        
    }
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mailValidation];
    
    if([_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your email id!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    else if ([emailTest evaluateWithObject:_txtEmail.text] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter valid email id!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
           return;
    }
    
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading ...";
   // hud.dimBackground = YES;
   
    
    NSDictionary *parameters = @{@"email":_txtEmail.text};
    
    
    [CartrizeWebservices PostMethodWithApiMethod:@"forgotpassword" Withparms:parameters WithSuccess:^(id response){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *responsedic=[response JSONValue];
        NSLog(@"%@",responsedic);
        if([[responsedic valueForKey:@"result"]isEqualToString:@"Please check your Email to get new password."])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please check your Email to get new password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
        
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
     }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionOnDismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//#pragma mark - WebView Delegate
//
//-(void)webViewDidFinishLoad:(UIWebView *)webView {
//    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}
//
//
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}

@end
