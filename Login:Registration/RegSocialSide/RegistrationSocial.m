    //
    //  RegistrationSocial.m
    //  IShop
    //
    //  Created by Avnish Sharma on 5/8/14.
    //  Copyright (c) 2014 Syscraft. All rights reserved.
    //

#import "RegistrationSocial.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "CartrizeWebservices.h"
#import "JSON.h"
#import "Reachability.h"
#import "KeychainWrapper.h"
#import "LoginView.h"
#import "ProductDetailView.h"
#import "ListGridViewController.h"
@interface RegistrationSocial ()<UIAlertViewDelegate>

@end

@implementation RegistrationSocial
@synthesize mainScrollVIew;
@synthesize imgValidaation;
@synthesize dicData;
    //@synthesize viewEmailValidation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(IS_IPHONE_4){
            self = [super initWithNibName:@"RegistrationSocial_iphone3.5" bundle:nibBundleOrNil];
        }else{
            self = [super initWithNibName:@"RegistrationSocial" bundle:nibBundleOrNil];
        }
    }
    return self;
}

#pragma mark:-Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if(IS_IPHONE_4)
        [self.mainScrollVIew setContentSize:CGSizeMake(0,500)];
    else
        [self.mainScrollVIew setContentSize:CGSizeMake(0,600)];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    if([[dicData valueForKey:@"socialSideName"] isEqualToString:@"twitter"])
//    {
//        //NSLog(@"%@",dicData);
//        if([[dicData valueForKey:@"name"] length]!=0)
//        {
//            NSArray *arrName= [[dicData valueForKey:@"name"] componentsSeparatedByString:@" "];
//            if(arrName.count!=0)
//            {
//                if(arrName.count==2)
//                {
//                    txtFName.text=[arrName objectAtIndex:0];
//                    txtLName.text=[arrName objectAtIndex:1];
//                }else
//                {
//                     txtFName.text=[arrName objectAtIndex:0];
//                }
//            }
//        }
//    }
   // else
   // {
    if ([dicData objectForKey:@"email"]) {
        txtEmail.text=[dicData valueForKey:@"email"];
    } else {
        
        txtEmail.text=@"";
    }
         txtFName.text=[dicData valueForKey:@"first_name"];
         txtLName.text=[dicData valueForKey:@"last_name"];
    //}
}

-(void)setBorderColor: (UITextField *)textField
{
    textField.layer.cornerRadius=0.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor colorWithRed:245.0/255.0
                                                 green:120.0/255.0
                                                  blue:114.0/255.0
                                                 alpha:1.0]CGColor];
    textField.layer.borderWidth= 1.5f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Methods

- (IBAction)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnNextStepAction:(id)sender
{
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
        
    }
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mailValidation];
    
    if([txtFName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        txtFName.text=@"";
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter first name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
    }
   /* if((txtFName.text.length>33))
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"First name maximum 32 characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }*/
    else if([txtLName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter last name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
        txtLName.text=@"";
    }
   /* if((txtLName.text.length>33))
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Last name maximum 32 characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }*/
     if([txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your email id!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if ([emailTest evaluateWithObject:txtEmail.text] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter valid email id!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter password!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(!(_txtPassword.text.length>5) || (_txtPassword.text.length>21))
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Password must contain min 6 and max 20 characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([_txtConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter confirm password!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if(![_txtConfirmPassword.text isEqualToString:_txtPassword.text]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Password and confirm password not match!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading ...";
       // hud.dimBackground = YES;
        [self callTwitterServiceAction];
        
    }
}

-(void)FbinsertData
{
    NSDictionary *requestPeram=@{@"fb_id":[[NSUserDefaults standardUserDefaults ]valueForKey:@"fbuserid"],@"fb_email":txtEmail.text};
    [CartrizeWebservices PostMethodWithApiMethod:@"insertfbdata" Withparms:requestPeram WithSuccess:^(id response){
        
       // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[[response JSONValue] objectForKey:@"Status"]isEqualToString:@"Sucess"])
        {
            NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
            [userDefualt setObject:@"YES" forKey:@"isRemember"];
            
            
            if ([[response JSONValue] objectForKey:@"cart_id"] == nil || [[response JSONValue] objectForKey:@"cart_id"] == (id)[NSNull null]) {
                [userDefualt setObject:@"" forKey:@"cart_id"];
            }
            else{
                [userDefualt setObject:[[response JSONValue] objectForKey:@"cart_id"] forKey:@"cart_id"];
            }
            [userDefualt setObject:txtFName.text forKey:@"firstname"];
            [userDefualt setObject:txtLName.text forKey:@"lastname"];
            [userDefualt setObject:txtEmail.text forKey:@"email"];
            [userDefualt setObject:txtEmail.text forKey:@"RememberEmail"];
            [userDefualt setBool:YES forKey:@"IsUserLogin"];
            KeychainWrapper *keyChain = [[KeychainWrapper alloc] init];
            [keyChain mySetObject:@"" forKey:(__bridge id)kSecValueData];
            
            [keyChain writeToKeychain];
            NSLog(@"password----->%@",[keyChain myObjectForKey:(__bridge id)kSecValueData]);
            [userDefualt setObject:@"" forKey:@"passwordSave"];
            
            [userDefualt setObject:@"" forKey:@"cart_id"];
            [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
            [userDefualt synchronize];
            [self CartIdWebService];

        }
        else
        { [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        
        }
        //NSLog(@"%@",[response JSONValue]);
       
        
    }failure:^(NSError *error){
        //NSLog(@"Error =%@",[error description]);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }];
    


}
-(void)callTwitterServiceAction
{
    NSMutableDictionary *requestPeram=[[NSMutableDictionary alloc] init];
    //NSLog(@"%@",[[FHSTwitterEngine sharedEngine]loggedInID]);
    [requestPeram setObject:txtEmail.text forKey:@"email"];
    [requestPeram setObject:txtFName.text forKey:@"fname"];
    [requestPeram setObject:txtLName.text forKey:@"lname"];
    [requestPeram setObject:_txtPassword.text forKey:@"password"];
    //[requestPeram setObject:[dicData valueForKey:@"id"] forKey:@"userid"];
    [requestPeram setObject:@"1" forKey:@"website_id"];
    [requestPeram setObject:@"1" forKey:@"store_id"];
    [requestPeram setObject:@"1" forKey:@"group_id"];
    
//    [CartrizeWebservices PostMethodWithApiMethod:@"twreg" Withparms:requestPeram WithSuccess:^(id response){
     [CartrizeWebservices PostMethodWithApiMethod:@"CreateCustomer" Withparms:requestPeram WithSuccess:^(id response){
         
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          //NSLog(@"%@",[response JSONValue]);
         if(![[[response JSONValue] valueForKey:@"error"]isEqualToString:@"Email address is already exist in our database"]){
             //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [[NSUserDefaults standardUserDefaults] setObject:[[response JSONValue] objectForKey:@"customer_id"] forKey:@"customer_id"];
             [self FbinsertData];
             
             
             
         }
       /* if([[[response JSONValue] valueForKey:@"success"] intValue]==1){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
            [userDefualt setObject:@"YES" forKey:@"isRemember"];
            [userDefualt setObject:[[response JSONValue] objectForKey:@"customer_id"] forKey:@"customer_id"];
            
            if ([[response JSONValue] objectForKey:@"cart_id"] == nil || [[response JSONValue] objectForKey:@"cart_id"] == (id)[NSNull null]) {
                [userDefualt setObject:@"" forKey:@"cart_id"];
            }
            else{
                [userDefualt setObject:[[response JSONValue] objectForKey:@"cart_id"] forKey:@"cart_id"];
            }
                [userDefualt setObject:txtFName.text forKey:@"firstname"];
                [userDefualt setObject:txtLName.text forKey:@"lastname"];
                [userDefualt setObject:txtEmail.text forKey:@"email"];
                [userDefualt setObject:txtEmail.text forKey:@"RememberEmail"];
            [userDefualt setBool:YES forKey:@"IsUserLogin"];
            KeychainWrapper *keyChain = [[KeychainWrapper alloc] init];
            [keyChain mySetObject:@"" forKey:(__bridge id)kSecValueData];
            
            [keyChain writeToKeychain];
            NSLog(@"password----->%@",[keyChain myObjectForKey:(__bridge id)kSecValueData]);
               [userDefualt setObject:@"" forKey:@"passwordSave"];
            
            [userDefualt setObject:@"YES" forKey:@"isRemember"];
            [userDefualt setObject:@"" forKey:@"cart_id"];
            [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
            [userDefualt synchronize];
            GridViewController *gridObj=[[GridViewController alloc] init];
            [self.navigationController pushViewController:gridObj animated:YES];
        }
        */else {

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"We already have this email id in our record,please use forgot password if you want to retrieve the password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //alert.tag=45678;
            [alert show];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        }
         
        
    }failure:^(NSError *error){
     //NSLog(@"Error =%@",[error description]);
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
     [alert show];
     }];
}


#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==45678)
    {
    if(buttonIndex==0)
    {
        LoginView *gridObj=[[LoginView alloc] init];
        [self.navigationController pushViewController:gridObj animated:YES];
    
    
    }
    
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Uitextfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    if(txtEmail==textField){
        if(!IS_IPHONE5){
            [self.mainScrollVIew setContentOffset:CGPointMake(0,150)];
        }
        else{
            [self.mainScrollVIew setContentOffset:CGPointMake(0, 150)];
        }
    }else if(_txtPassword==textField){
        if(IS_IPHONE5){
            [self.mainScrollVIew setContentOffset:CGPointMake(0, 150)];
        }else{
            [self.mainScrollVIew setContentOffset:CGPointMake(0, 150)];
        }
    }else if(_txtConfirmPassword==textField){
        if(IS_IPHONE5){
            [self.mainScrollVIew setContentOffset:CGPointMake(0, 150)];
        }else{
            [self.mainScrollVIew setContentOffset:CGPointMake(0, 150)];
        }
    }
    [UIView commitAnimations];
    return YES;}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
   /* NSInteger nextTag = textField.tag +1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.25];
    
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [self.mainScrollVIew setContentOffset:CGPointMake(0,0)];
        [textField resignFirstResponder];
    }
    [UIView commitAnimations];*/
    if (textField == txtFName) {
        [txtLName becomeFirstResponder];
    }
    else if (textField == txtLName) {
        [txtEmail becomeFirstResponder];
    }
    else if (textField == txtEmail) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.mainScrollVIew setContentOffset:CGPointMake(0, 150)];
        [UIView commitAnimations];
        
        [_txtPassword becomeFirstResponder];
    }
    else if (textField == _txtPassword) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.mainScrollVIew setContentOffset:CGPointMake(0, 150)];
        [UIView commitAnimations];
        
        [_txtConfirmPassword becomeFirstResponder];
    }
    else if (textField == _txtConfirmPassword) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.mainScrollVIew setContentOffset:CGPointMake(0, 0)];
        [UIView commitAnimations];
        
        [_txtConfirmPassword resignFirstResponder];
    }
    return YES;
}


#pragma mark - validations

-(BOOL)emailValidation:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}
-(void)CartIdWebService
{
    //  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //  hud.labelText = @"Please wait...";
    //  hud.dimBackground = YES;
    NSDictionary *params=@{@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    [CartrizeWebservices PostMethodWithApiMethod:@"creditcartview-2" Withparms:params WithSuccess:^(id response) {
        
        NSDictionary *dict=[response JSONValue];
        
        //[[NSUserDefaults standardUserDefaults]setObject:cartid forKey:@"cid"];
        wv=[[UIWebView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height)];
        NSURL *urlPath;
        NSURLRequest *requestObj;
        wv.hidden=YES;
        wv.delegate=self;
        NSString *url=[dict valueForKey:@"check_url"];
        urlPath = [NSURL URLWithString:url];
        //requestObj = [NSMutableURLRequest requestWithURL:[urlPath absoluteURL]];
        requestObj = [NSMutableURLRequest requestWithURL:urlPath
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:20.0];
        
        [wv loadRequest:requestObj];
        [self.view addSubview:wv];
        
        // NSLog(@"cartid is%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"cid"]);
        
        
        
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.labelText = @"Please wait...";
    //    hud.dimBackground = YES;
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish");
    
    [self FetchCartIdd];
}


-(void)FetchCartIdd
{
    
    NSDictionary *params=@{@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"getcrtid" Withparms:params WithSuccess:^(id response) {
        
        NSDictionary *dict=[response JSONValue];
        
        NSLog(@"cartid is from webservice is%@",dict);
        
        if([dict valueForKey:@"cart_id"]==[NSNull null]) {
            
            NSLog(@"null");
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cart_id"];
            
            
        }
        else
        {
            NSLog(@"insert");
            
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"cart_id"] forKey:@"cart_id"];
            
            
            
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([_strCheckViewControler isEqualToString:@"ProducatDetail"])
            {
                if ([controller isKindOfClass:[ProductDetailView class]]) {
                    
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    break;
                }
            }
            else
            {
                if ([controller isKindOfClass:[ListGridViewController class]]) {
                    
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    break;
                }
            }
            //Do not forget to import AnOldViewController.h
            
        }
        
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
    
    
}

@end
