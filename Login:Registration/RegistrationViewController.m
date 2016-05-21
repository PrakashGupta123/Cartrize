    //
    //  RegistrationViewController.m
    //  IShop
    //
    //  Created by Avnish Sharma on 5/8/14.
    //  Copyright (c) 2014 Syscraft. All rights reserved.
    //

#import "RegistrationViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "CartrizeWebservices.h"
#import "JSON.h"
#import "Reachability.h"
#import "LoginView.h"
#import "KeychainWrapper.h"
#import "ProductDetailView.h"
#import "ListGridViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize viewTxtValidation,viewContent;
@synthesize mainScrollVIew;
@synthesize imgValidaation;
    //@synthesize viewEmailValidation;
@synthesize strTwitterId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
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
    
    if(IS_IPHONE5)
        [self.mainScrollVIew setContentSize:CGSizeMake(0,700)];
    else
        [self.mainScrollVIew setContentSize:CGSizeMake(0,700)];
    
//    [self setBorderColor:txtPassword];
//    [self setBorderColor:txtLName];
//    [self setBorderColor:txtFName];
//    [self setBorderColor:txtEmail];
//    [self setBorderColor:txtCnfmPassword];
    
    if([strTwitterId length]!=0){
            //txtFName.enabled=NO;
        txtFName.text=[[FHSTwitterEngine sharedEngine]loggedInUsername];
    }
    
}


-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    
    if([strTwitterId length]!=0){
        [txtPassword setEnabled:NO];
        [txtCnfmPassword setEnabled:NO];
    }
    
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

    if([strTwitterId length]==0)
    {
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mailValidation];

        if([txtFName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter first name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
            txtFName.text=@"";
        }
     /*   if((txtFName.text.length>33))
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"First name maximum 32 characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }*/
        else if([txtLName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter last name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
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
        else if([txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter password!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        if((txtPassword.text.length<6) || (txtPassword.text.length>21))
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Password must contain min 6 and max 20 characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else if([txtCnfmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter confirm password!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else if(![txtCnfmPassword.text isEqualToString:txtPassword.text]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Password and confirm password not match!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Loading ...";
          //  hud.dimBackground = YES;
            [self registrationServiceActioin];
        }
  
    }else{
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mailValidation];
        
        if([txtFName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter first name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
            txtFName.text=@"";
        }
//        if((txtFName.text.length>33))
//        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"First name maximum 32 characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
        else if([txtLName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            txtLName.text=@"";
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter last name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
        }
//        if((txtLName.text.length>33))
//        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Last name maximum 32 characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
        else if([txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
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
        else if([txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter password!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        if(!(txtPassword.text.length>5) || (txtPassword.text.length>21))
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Password must contain min 6 and max 20 characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else if([txtCnfmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter confirm password!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else if(![txtCnfmPassword.text isEqualToString:txtPassword.text]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Password and confirm password not match!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
       
        else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Loading ...";
           // hud.dimBackground = YES;
            [self TwitterServiceActioin];
        }
    }
    
}

-(void)registrationServiceActioin
{
    NSURL *url = [NSURL URLWithString:user_registration];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:txtEmail.text forKey:@"email"];
    [request setPostValue:txtPassword.text forKey:@"password"];
    [request setPostValue:txtFName.text forKey:@"fname"];
    [request setPostValue:txtLName.text forKey:@"lname"];
    [request setPostValue:@1 forKey:@"website_id"];
    [request setPostValue:@1 forKey:@"store_id"];
    [request setPostValue:@1 forKey:@"group_id"];
    [request setDidFinishSelector:@selector(requestFinishedForService:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDelegate:self];
    [request startAsynchronous];
    
   
}

-(void)callTwitterServiceAction {
   
    NSMutableDictionary *requestPeram=[[NSMutableDictionary alloc] init];
    //NSLog(@"%@",[[FHSTwitterEngine sharedEngine]loggedInID]);
    [requestPeram setObject:txtEmail.text forKey:@"email"];
    [requestPeram setObject:txtPassword.text forKey:@"password"];
    [requestPeram setObject:txtFName.text forKey:@"fname"];
    [requestPeram setObject:txtLName.text forKey:@"lname"];
    [requestPeram setObject:@"1" forKey:@"website_id"];
    [requestPeram setObject:@"1" forKey:@"store_id"];
    [requestPeram setObject:@"1" forKey:@"group_id"];
    
    [CartrizeWebservices PostMethodWithApiMethod:@"CreateCustomer" Withparms:requestPeram WithSuccess:^(id response){
        
       
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //NSLog(@"%d",[[[response JSONValue] valueForKey:@"error"]length]==0);
        
        if(![[[response JSONValue] valueForKey:@"error"]isEqualToString:@"User id address is already exist in our database"]){
            
      
        }else{
          
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSUserDefaults *defualt=[NSUserDefaults standardUserDefaults];
            
            [defualt setObject:[[response JSONValue] valueForKey:@"message"] forKey:@"email"];
            [defualt setObject:[[response JSONValue] valueForKey:@"customer_id"] forKey:@"customer_id"];
            [defualt setObject:[[response JSONValue] valueForKey:@"userid"] forKey:@"userid"];
            [defualt setObject:[[response JSONValue] valueForKey:@"userid"] forKey:@"userid"];
            KeychainWrapper *keyChain = [[KeychainWrapper alloc] init];
           
            //  [keyChain mySetObject:emailTf.text forKey:(__bridge id)kSecAttrAccount];
            [keyChain mySetObject:txtPassword.text forKey:(__bridge id)kSecValueData];
            
            [keyChain writeToKeychain];
            NSLog(@"password----->%@",[keyChain myObjectForKey:(__bridge id)kSecValueData]);
            [defualt setObject:[[FHSTwitterEngine sharedEngine] loggedInUsername] forKey:@"firstname"];
            [defualt setObject:[[FHSTwitterEngine sharedEngine] loggedInUsername] forKey:@"lastname"];
            [defualt setObject:@"" forKey:@"cart_id"];
            [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
            [defualt synchronize];
            
            GridViewController *gridObj=[[GridViewController alloc] init];
            [self.navigationController pushViewController:gridObj animated:YES];
            
        }
    } failure:^(NSError *error)
     {
     //NSLog(@"Error =%@",[error description]);
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
     [alert show];
     }];
}



#pragma mark - ASIHTTP Response

-(void)requestFinishedForService:(ASIHTTPRequest *)request
{
    AppDelegate *objAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *string =[request responseString];
    NSData *data = [request responseData];
    //NSLog(@"string -- %@",string);
    //NSLog(@"data -- %@",data);
    NSMutableDictionary *mutableDictResponce = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
        // NSString *strAlert = [mutableDictResponce valueForKey:@"error"];
    if ([[mutableDictResponce objectForKey:@"error"] isEqualToString:@""] || [mutableDictResponce objectForKey:@"error"] == nil)
        {
            

        objAppDelegate.dictUserInfo = [mutableDictResponce copy];
        
        if ([[mutableDictResponce objectForKey:@"message"] isEqualToString:@"Invalid login or password."]){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Invalid Login Id or password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else{
            objAppDelegate.isUserLogin = YES;
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:[NSString stringWithFormat:@"%@",txtEmail.text] forKey:@"email"];
            //dipesh.
            [userDefaults setObject:[NSString stringWithFormat:@"%@",txtEmail.text] forKey:@"RememberEmail"];
            
            [userDefaults setValue:[NSString stringWithFormat:@"%@",txtPassword.text] forKey:@"passwordSave"];
            
            [userDefaults setObject:[NSString stringWithFormat:@"%@",txtFName.text] forKey:@"firstname"];
            [userDefaults setObject:[NSString stringWithFormat:@"%@",txtLName.text] forKey:@"lastname"];
            [userDefaults setObject:@"YES" forKey:@"isRemember"];
            [userDefaults setBool:YES forKey:@"IsUserLogin"];
            [userDefaults setObject:[mutableDictResponce valueForKey:@"success"] forKey:@"success"];
            [userDefaults setObject:[mutableDictResponce valueForKey:@"message"] forKey:@"message"];
            [userDefaults setObject:[mutableDictResponce valueForKey:@"customer_id"] forKey:@"customer_id"];
            [userDefaults setObject:[[mutableDictResponce valueForKey:@"customer_data"] valueForKey:@"email"] forKey:@"email"];
            [userDefaults setObject:[[mutableDictResponce valueForKey:@"customer_data"] valueForKey:@"firstname"] forKey:@"firstname"];
            [userDefaults setObject:[[mutableDictResponce valueForKey:@"customer_data"] valueForKey:@"website_id"] forKey:@"website_id"];
            [userDefaults setObject:[[mutableDictResponce valueForKey:@"customer_data"] valueForKey:@"lastname"] forKey:@"lastname"];
           [userDefaults setObject:@"" forKey:@"cart_id"];
            [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
            [userDefaults setObject:@"YES" forKey:@"checkRegistration"];
            
            [userDefaults synchronize];
            [self CartIdWebService];
//            GridViewController *gridObj=[[GridViewController alloc] init];
//            [self.navigationController pushViewController:gridObj animated:YES];
//            UIViewController *controller;
//            if ([controller isKindOfClass:[_strCheckViewControoler class]]) {
//                
//                [self.navigationController popToViewController:controller
//                                                      animated:YES];
//               // break;
//            }
            
            
           // [self.navigationController popViewControllerAnimated:YES];
        }
        
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Email address is already exist" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
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
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Check your network connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}



-(void)TwitterServiceActioin {
   
    
    NSMutableDictionary *requestPeram=[[NSMutableDictionary alloc] init];
    [requestPeram setObject:txtEmail.text forKey:@"email"];
    [requestPeram setObject:txtFName.text forKey:@"fname"];
    [requestPeram setObject:txtLName.text forKey:@"lname"];
    [requestPeram setObject:[[FHSTwitterEngine sharedEngine]loggedInID ] forKey:@"userid"];

    [CartrizeWebservices PostMethodWithApiMethod:@"twreg" Withparms:requestPeram WithSuccess:^(id response){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        //NSLog(@"%@",[response JSONValue]);
        
        if([[[response JSONValue] valueForKey:@"success"]intValue]==1){
           
            NSUserDefaults *defualt=[NSUserDefaults standardUserDefaults];
            
            [defualt setObject:[[response JSONValue] valueForKey:@"customer_email"] forKey:@"email"];

            //dipesh.
            [defualt setObject:[[response JSONValue] valueForKey:@"customer_email"] forKey:@"RememberEmail"];
            
            [defualt setObject:[[response JSONValue] valueForKey:@"message"] forKey:@"message"];
            [defualt setBool:YES forKey:@"IsUserLogin"];

            [defualt setObject:[[response JSONValue] valueForKey:@"customer_id"] forKey:@"customer_id"];
            [defualt setObject:@"" forKey:@"cart_id"];
            [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
            [defualt synchronize];
            
            GridViewController *gridObj=[[GridViewController alloc] init];
            [self.navigationController pushViewController:gridObj animated:YES];
       
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error)
     {
     //NSLog(@"Error =%@",[error description]);
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
     [alert show];
     }];
  
}






#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    }else if(txtPassword==textField){
        if(IS_IPHONE5){
            [self.mainScrollVIew setContentOffset:CGPointMake(0, 150)];
        }else{
            [self.mainScrollVIew setContentOffset:CGPointMake(0, 150)];
        }
    }else if(txtCnfmPassword==textField){
        if(IS_IPHONE5){
            [self.mainScrollVIew setContentOffset:CGPointMake(0, 150)];
        }else{
            [self.mainScrollVIew setContentOffset:CGPointMake(0, 150)];
        }
    }
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
        
        [txtPassword becomeFirstResponder];
    }
    else if (textField == txtPassword) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.mainScrollVIew setContentOffset:CGPointMake(0, 150)];
        [UIView commitAnimations];
        
        [txtCnfmPassword becomeFirstResponder];
    }
    else if (textField == txtCnfmPassword) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.mainScrollVIew setContentOffset:CGPointMake(0, 0)];
        [UIView commitAnimations];
        
        [txtCnfmPassword resignFirstResponder];
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

#pragma mark - NSURLConnection Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"ERROR with theConenction");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"DONE. Received Bytes: %d", [webData length]);
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
