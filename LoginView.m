    //
    //  LoginView.m
    //  Cartrize
    //
    //  Created by Admin on 19/07/14.
    //  Copyright (c) 2014 Syscraft. All rights reserved.
    //

#import "LoginView.h"
#import "iToast.h"
#import "CartrizeWebservices.h"
#import "GridViewController.h"
#import "JSON.h"
#import "FHSTwitterEngine.h"
#import "Reachability.h"
#import "RegistrationViewController.h"
#import "RegistrationSocial.h"
#import "ListGridViewController.h"

#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <QuartzCore/QuartzCore.h>
#import <TwitterKit/TwitterKit.h>
#import <Twitter/Twitter.h>
#import "KeychainWrapper.h"


@interface LoginView ()<GPPSignInDelegate> {
    NSString *strSocialName;
   
}

@end

@implementation LoginView
@synthesize accountStore,window,progressHud;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [btnSignUp.layer setCornerRadius:5.0];
    [btnSignUp setClipsToBounds:YES];
    
    UIColor *color = [UIColor whiteColor];
    emailTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"E-mail address" attributes:@{NSForegroundColorAttributeName: color}];
    passTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    
        // Do any additional setup after loading the view from its nib.
    
    //dipesh.-
    
    [scrollBase setContentSize:CGSizeMake(320, [UIScreen mainScreen].bounds.size.height+100)];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [emailTf setText:@""];
    [passTf setText:@""];
    
  [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}
#pragma mark IBActions
-(IBAction)loginAction:(id)sender
{
    //dipesh. - to dismiss keyboard first.
    [emailTf resignFirstResponder];
    [passTf resignFirstResponder];
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
        
    }
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mailValidation];
    
    if([emailTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your email id!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
            
        }
    else if ([emailTest evaluateWithObject:emailTf.text] == NO)
        {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter valid email id!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        }
    else if([passTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your password!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        }
    else
        {
            
        [self showLoadingAlert];
        NSDictionary *parameters = @{@"email":emailTf.text,@"password":passTf.text};
        [CartrizeWebservices PostMethodWithApiMethod:@"userLogin" Withparms:parameters WithSuccess:^(id response)
         {
            
            KeychainWrapper *keyChain = [[KeychainWrapper alloc] init];
             [[NSUserDefaults standardUserDefaults] setValue:emailTf.text forKey:@"EMAIL"];
          //  [keyChain mySetObject:emailTf.text forKey:(__bridge id)kSecAttrAccount];
             [keyChain mySetObject:passTf.text forKey:(__bridge id)kSecValueData];
             
             [keyChain writeToKeychain];
             NSLog(@"password----->%@",[keyChain myObjectForKey:(__bridge id)kSecValueData]);

        // [self removeLoadingAlert];
         
         NSDictionary *responsedic=[response JSONValue];
         
         if([[responsedic objectForKey:@"message"] isEqualToString:@"Invalid login or password."])
             {
                 [self removeLoadingAlert];
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid email or password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             }
         else
             {
                /* [CartrizeWebservices GetMethodWithApiMethod:@"getcrtid" WithSuccess:^(id response)
                  {
                      
                      NSLog(@"Response of gourav id API%@",[response JSONValue] );
                      
                      //HUpendra
                      
                      // //NSLog(@"Response Cart id = %@",[response JSONValue]);
                      
                  } failure:^(NSError *error)
                  {
                      //NSLog(@"Error = %@",[error description]);
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  }];*/
                 
             NSDictionary *detail=[responsedic objectForKey:@"customer_data"];
                 
             NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
             
             [userDefualt setObject:@"YES" forKey:@"isRemember"];
             [userDefualt setObject:[[response JSONValue] objectForKey:@"customer_id"] forKey:@"customer_id"];
                 
                                 //dipesh. - to check for null from server.

//                 if ([[response JSONValue] objectForKey:@"cart_id"] == nil || [[response JSONValue] objectForKey:@"cart_id"] == (id)[NSNull null]) {
//                     [userDefualt setObject:@"" forKey:@"cart_id"];
//                 }
//                 else{
//                     [userDefualt setObject:[[response JSONValue] objectForKey:@"cart_id"] forKey:@"cart_id"];
//                     
//                     
//                    
//
//                 }
                 [userDefualt setObject:@"" forKey:@"cart_id"];
                 [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
             [userDefualt setObject:[detail objectForKey:@"firstname"] forKey:@"firstname"];
             [userDefualt setObject:[detail objectForKey:@"lastname"] forKey:@"lastname"];
             [userDefualt setObject:[detail objectForKey:@"email"] forKey:@"email"];
             [userDefualt setObject:[detail objectForKey:@"password_hash"] forKey:@"passwordSave"];
                 
            [userDefualt setObject:[detail objectForKey:@"email"] forKey:@"RememberEmail"];
                 
             [userDefualt setObject:@"YES" forKey:@"isRemember"];
                 [userDefualt setBool:YES forKey:@"IsUserLogin"];
             [userDefualt synchronize];
               [self FetchCartIdd];
          //   GridViewController *gridObj=[[GridViewController alloc] init];
           //  [self.navigationController pushViewController:gridObj animated:YES];
               //  [self.navigationController popViewControllerAnimated:YES];
             }
         } failure:^(NSError *error)
 
         {
//             ListGridViewController *listView = [[ListGridViewController alloc] init];
//             [self.navigationController pushViewController:listView animated:YES];
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
        }
}


-(IBAction)fbLoginAction:(id)sender

{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cart_id"];
    //[self showLoadingAlert];
    
    /*
    NSHTTPCookieStorage *storage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[FBSession activeSession] handleDidBecomeActive];
    [[FBSession activeSession] closeAndClearTokenInformation];
    [FBSession setActiveSession:[AppDelegate appDelegate].session];
    
    FBSessionLoginBehavior behaviour=FBSessionLoginBehaviorForcingWebView;
    
    [[AppDelegate appDelegate].session openWithBehavior:behaviour completionHandler:^(FBSession *session1,FBSessionState status,NSError *error){
        if (error) {
            [[iToast makeText:@"Error..Please Login again"] show];
        }else{
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,id result,NSError *error){
                if (!error) {
                    
                    //NSLog(@"hhhh %@",result);
                    [self callFBServiceAction:result];
                    
                }
            }];
        }
    }];*/
    
//    NSHTTPCookieStorage *storage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]) {
//        [storage deleteCookie:cookie];
//    }
    /*
    [[FBSession activeSession] handleDidBecomeActive];
    [[FBSession activeSession] closeAndClearTokenInformation];
    [FBSession setActiveSession:[AppDelegate appDelegate].session];
    [AppDelegate appDelegate].isFBCheck=YES;

    [SCFacebook loginCallBack:^(BOOL success, id result) {
        //NSLog(@"%d",success);
        if (success) {
            [self showLoadingAlert];
            strSocialName=@"FB";
            
           [self callCheckSocialAccountExistsOrNot:result];
        }else
        
        {
            Alert1(@"Alert", [result description]);
        }
    }];*/
  /*  FBSession *session = [[FBSession alloc] initWithAppID:@"1699507676973235" permissions:nil defaultAudience:FBSessionDefaultAudienceEveryone urlSchemeSuffix:nil tokenCacheStrategy:nil];
    [FBSettings setDefaultAppID: @"1699507676973235"];
    [FBSession setActiveSession:session];
    [FBSession openActiveSessionWithReadPermissions:@[@"email",@"user_birthday",@"user_hometown"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if ([session isOpen]) {
            [FBRequestConnection startWithGraphPath:@"me" parameters:[NSDictionary dictionaryWithObject:@"cover,picture.type(large),id,name,first_name,last_name,gender,birthday,email,location,hometown,bio,photos" forKey:@"fields"] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {
                 {
                     if (!error)
                     {
                         if ([result isKindOfClass:[NSDictionary class]])
                         {
                             NSLog(@"%@",result);
                              //strSocialName=@"FB";
                             [self FaceBookLogin:result];
                             
                         }
                     }
                    
                 }
             }];;
        }
    }];*/
    
    [self FbLoginMethod];

}


-(void)FbLoginMethod
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorNative;
    [AppDelegate appDelegate].isFBCheck=YES;
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        [self fetchUserInfo];
    }
    else
    {
        [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alert show];
                 NSLog(@"Login process error");
             }
             else if (result.isCancelled)
             {
                 NSLog(@"User cancelled login");
             }
             else
             {
                 NSLog(@"Login Success");
                 
                 if ([result.grantedPermissions containsObject:@"email"])
                 {
                     NSLog(@"result is:%@",result);
                     
                    
                     [self fetchUserInfo];
                 }
                 else
                 {
                     // [SVProgressHUD showErrorWithStatus:@"Facebook email permission error"];
                     
                 }
             }
         }];
    }
}

#pragma mark Get Facebook Login Responce
-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
       // [activityIndicator startAnimating];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email,first_name,last_name,link,locale"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             //[activityIndicator stopAnimating];
             if (!error)
             {
                 NSLog(@"results Facebook Details:%@",result);
                 
                // NSString *email = [result objectForKey:@"email"];
                // NSString *userId = [result objectForKey:@"id"];
                 [self FaceBookLogin:result];
               /*   if ([result objectForKey:@"email"])
                 {
                     //Start you app Todo
                     [self FaceBookLogin:result];
                 }
                 else
                 {
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     RegistrationSocial *reg=[[RegistrationSocial alloc] init];
                     reg.dicData=[result copy];
                     [self.navigationController pushViewController:reg animated:YES];
                     NSLog(@"Facebook email is not verified");
                 }*/
             }
             
             else{
                 NSLog(@"Error %@",error);
             }
         }];
    }
}



-(void)FaceBookLogin:(NSDictionary *)dict
{
    //[self showLoadingAlert];
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
        
    }
    NSLog(@"dict is %@",dict);
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    //hud.dimBackground = YES;
   // NSDictionary *params=@{@"email":[dict valueForKey:@"email"],@"fb_id":[dict valueForKey:@"id"]};
    NSDictionary *params=@{@"fb_id":[dict valueForKey:@"id"]};
    [[NSUserDefaults standardUserDefaults]setValue:[dict valueForKey:@"id"] forKey:@"fbuserid"];
    
//    [CartrizeWebservices PostMethodWithApiMethod:@"checkfblogin" Withparms:params WithSuccess:^(id response) {
     [CartrizeWebservices PostMethodWithApiMethod:@"getfbcheck" Withparms:params WithSuccess:^(id response) {
         NSDictionary *responsedict=[response JSONValue];
        
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        if(![[responsedict valueForKey:@"user_status"]isEqualToString:@"Not Found"])
        {
           
          //  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if([responsedict objectForKey:@"customer_id"]isEqual:<#(id)#>)
            if([[responsedict valueForKey:@"customer_id"]isEqual:[NSNull null]]||[[responsedict valueForKey:@"customer_id"]isEqual:nil])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again something went wrong!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return ;
                
                
            }
            if([[responsedict valueForKey:@"Email"]isEqual:[NSNull null]]||[[responsedict valueForKey:@"Email"]isEqual:nil])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Email not found please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return ;
                
                
            }
            NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
            [userDefualt setObject:[responsedict objectForKey:@"customer_id"] forKey:@"customer_id"];
            [userDefualt setBool:YES forKey:@"IsUserLogin"];
            [userDefualt setObject:[dict objectForKey:@"first_name"] forKey:@"firstname"];
            [userDefualt setObject:[dict objectForKey:@"last_name"] forKey:@"lastname"];
            [userDefualt setObject:[responsedict objectForKey:@"Email"] forKey:@"email"];
            [userDefualt setObject:[responsedict objectForKey:@"Email"] forKey:@"RememberEmail"];
            [userDefualt setObject:@"" forKey:@"passwordSave"];
            [userDefualt setObject:@"YES" forKey:@"isRemember"];
            
            
            if ([responsedict objectForKey:@"cartid"] == nil || [responsedict objectForKey:@"cartid"] == (id)[NSNull null]) {
                [userDefualt setObject:@"" forKey:@"cart_id"];
            }
            else{
                [userDefualt setObject:[responsedict objectForKey:@"cartid"] forKey:@"cart_id"];
                //[[NSUserDefaults standardUserDefaults]setObject:[[response JSONValue] objectForKey:@"cart_id"] forKey:@"cid"];
                
            }
           [userDefualt synchronize];
//            GridViewController *gridObj=[[GridViewController alloc] init];
//            [self.navigationController pushViewController:gridObj animated:YES];
            [self FetchCartIdd];
          
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            RegistrationSocial *reg=[[RegistrationSocial alloc] init];
            reg.dicData=[dict copy];
            reg.strCheckViewControler =_strCheckViewControler;
            [self.navigationController pushViewController:reg animated:YES];
          
       
        }
        //[[NSUserDefaults standardUserDefaults]setObject:cartid forKey:@"cid"];
        
        // NSLog(@"cartid is%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"cid"]);
        
        
        
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

         //[MBProgressHUD hideHUDForView:self.view animated:YES];
     }];


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
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getCheckOutHistory" object:nil];
            
        }
        [self performSelector:@selector(Redirection) withObject:nil afterDelay:1.0];
       
        
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
    
    
}

-(void)Redirection
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 
 [AppDelegate appDelegate].isFBCheck=YES;
 
 [SCFacebook loginCallBack:^(BOOL success, id result) {
 
 //NSLog(@"%d",success);
 
 if (success) {
 [self shared_ON_Facebook];
 
 //Alert(@"Alert", @"Success");
 }else{
 Alert1(@"Alert", [result description]);
 }
 }];
 
 */


-(IBAction)twLoginAction:(id)sender
{
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
            //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    
    }else {
        
        
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self LoginWithTwitterActionMethod];
        /*
        [[FHSTwitterEngine sharedEngine]showOAuthLoginControllerFromViewController:self withCompletion:^
         
         (BOOL success) {
             
             if (success) {
                 
                 [self showLoadingAlert];
                 strSocialName=@"Twitter";
                 [self getTwitterUserDetail];
                 //NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
             }
             else {
                 [self removeLoadingAlert];
             }
        }
         
         ];
         */
        
    }
}

-(void)LoginWithTwitterActionMethod
{
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (session) {
            NSLog(@"signed in as %@ %@", [session userName],[session userID]);

            /* Get user info */
            TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];

            [client loadUserWithID:[session userID] completion:^(TWTRUser * _Nullable user, NSError * _Nullable error) {
                
                
            }];
            

            
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}



-(void)getTwitterUserDetail:(NSString *)StrUSerId {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            id dicUserDetail= [[FHSTwitterEngine sharedEngine] getTimelineForUser:StrUSerId isID:YES count:1];
            dispatch_sync(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    
                    NSArray *srrTwData=[dicUserDetail valueForKey:@"user"];
                    if(srrTwData.count!=0){
                        NSMutableDictionary *dicUserData=[[NSMutableDictionary alloc] init];
                        [dicUserData setObject:[[srrTwData objectAtIndex:0] valueForKey:@"screen_name"] forKey:@"screen_name"];
                        [dicUserData setObject:[[srrTwData objectAtIndex:0] valueForKey:@"id_str"] forKey:@"id"];
                        [dicUserData setObject:[[srrTwData objectAtIndex:0] valueForKey:@"name"] forKey:@"name"];
                        [dicUserData setObject:[[srrTwData objectAtIndex:0] valueForKey:@"profile_image_url"] forKey:@"profile_image_url"];
                         [dicUserData setObject:[[FHSTwitterEngine sharedEngine]loggedInID] forKey:@"id"];
                         strSocialName=@"twitter";
                        [self callCheckSocialAccountExistsOrNot:dicUserData];
                    }else
                    {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    
                    }
                }
            });
        }
    });
    
}

#pragma mark:-Twitter Methods

- (NSString *)loadAccessToken
{
    return Nil;
}
- (void)storeAccessToken:(NSString *)accessToken
{
   
    //NSLog(@"%@",accessToken);
}


-(IBAction)ForgotPasswordAction:(id)sender
{
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        
        //        [self performSelector:@selector(killHUD)];
        
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        
        
        [alert show];
        
        return;
        
    }
    
    ForgetPWViewController *forget = [[ForgetPWViewController alloc]init];
    [self presentViewController:forget animated:YES completion:nil];
}

-(IBAction)singupAction:(id)sender
{
    RegistrationViewController *objRegistrationViewController;
    if (IS_IPHONE5){
        objRegistrationViewController = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];
        }
    else{
//        objRegistrationViewController = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];

        objRegistrationViewController = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController_iphone3.5" bundle:nil];
        }
    objRegistrationViewController.strCheckViewControler= _strCheckViewControler;
    [self.navigationController pushViewController:objRegistrationViewController animated:YES];
}

- (IBAction)googlePlusLogin:(id)sender
{
//    [AppDelegate appDelegate].isFBCheck=NO;
//    GPPSignIn *signIn = [GPPSignIn sharedInstance];
//    signIn.shouldFetchGooglePlusUser = YES;
//    signIn.shouldFetchGoogleUserEmail = YES;
//    signIn.delegate = self;
//    [signIn authenticate];
}

#pragma mark - GPPSignInDelegate

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        [NSString stringWithFormat:@"Status: Failed to disconnect: %@", error];
    } else {
        
        [NSString stringWithFormat:@"Status: Disconnected"];
    }
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {
    if (error) {
        [NSString stringWithFormat:@"Status: Authentication error: %@", error];
        return;
    }

    NSString  *accessTocken = [auth valueForKey:@"accessToken"]; // access tocken pass in .pch file
    //NSLog(@"%@",accessTocken);
    NSString *str=[NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?access_token=%@",accessTocken];
    NSString *escapedUrl = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",escapedUrl]];
    NSString *jsonData = [[NSString alloc] initWithContentsOfURL:url usedEncoding:nil error:nil];
    NSMutableDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    [self callGooglePlusServiceAction:jsonDictionary];
    [[GPPSignIn sharedInstance] signOut];
}

-(IBAction)sKipAction:(id)sender{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"customer_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    GridViewController *gridObj=[[GridViewController alloc] init];
    [self.navigationController pushViewController:gridObj animated:YES];
    
}
#pragma mark UITextfieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //dipesh. - auto scroll with animation.
    
    if (textField == passTf) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [scrollBase setContentOffset:CGPointMake(0, 60)];
                         }];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == emailTf) {
        [passTf becomeFirstResponder];
    }
    else if (textField == passTf) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [scrollBase setContentOffset:CGPointMake(0, 0)];
                         }];
        [passTf resignFirstResponder];
    }
    return YES;
}
#pragma mark LODER METHOD
-(void)showLoadingAlert
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading ...";
   // hud.dimBackground = YES;
}
-(void)removeLoadingAlert
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark:- Call Web service

-(void)callCheckSocialAccountExistsOrNot:(NSMutableDictionary *)dicData  {
    NSLog(@"%@",dicData);
    [dicData setObject:strSocialName forKey:@"socialSideName"];
    NSMutableDictionary *requestPeram=[[NSMutableDictionary alloc] init];
    
   
    [requestPeram setObject:[dicData valueForKey:@"id"] forKey:@"userid"];
    
    
    [CartrizeWebservices PostMethodWithApiMethod:@"twlogin" Withparms:requestPeram WithSuccess:^(id response){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        //NSLog(@"%@",[response JSONValue]);
        //NSLog(@"%lu",(unsigned long)[[[response JSONValue] valueForKey:@"error"] length]);
        
        if([[[response JSONValue] valueForKey:@"error"] isEqualToString:@"User id address is already exist in our database"]){
        
            NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
            [userDefualt setObject:@"YES" forKey:@"isRemember"];
     
            [userDefualt setObject:[[response JSONValue] objectForKey:@"email"] forKey:@"RememberEmail"];

            [userDefualt setObject:[[response JSONValue] objectForKey:@"customer_id"] forKey:@"customer_id"];
        
            if ([[response JSONValue] objectForKey:@"cart_id"] == nil || [[response JSONValue] objectForKey:@"cart_id"] == (id)[NSNull null]) {
                [userDefualt setObject:@"" forKey:@"cart_id"];
            }
            else{
                [userDefualt setObject:[[response JSONValue] objectForKey:@"cart_id"] forKey:@"cart_id"];
            }
            
            if([strSocialName isEqualToString:@"twitter"]) {
                if([[dicData valueForKey:@"name"] length]!=0){
                    NSArray *arrName= [[dicData valueForKey:@"name"] componentsSeparatedByString:@" "];
                    if(arrName.count!=0){
                        if(arrName.count==2){
                            [userDefualt setObject:[arrName objectAtIndex:0] forKey:@"firstname"];
                            [userDefualt setObject:[arrName objectAtIndex:1] forKey:@"lastname"];
                        }else {
                            [userDefualt setObject:[arrName objectAtIndex:0] forKey:@"firstname"];
                            [userDefualt setObject:@"" forKey:@"lastname"];
                        }
                    }
                }else{
                    [userDefualt setObject:@"" forKey:@"firstname"];
                    [userDefualt setObject:@"" forKey:@"lastname"];
                }
       
            }else {
                [userDefualt setObject:[dicData valueForKey:@"first_name"] forKey:@"firstname"];
                [userDefualt setObject:[dicData valueForKey:@"last_name"] forKey:@"lastname"];
 
            }
            if ([dicData valueForKey:@"email"] !=nil)
            {
                  [userDefualt setObject:[dicData valueForKey:@"email"] forKey:@"email"];
            }
          
            
            [userDefualt setObject:@"" forKey:@"passwordSave"];
            
            [userDefualt setObject:@"YES" forKey:@"isRemember"];
            [userDefualt synchronize];
         
            //NSLog(@"%@",[userDefualt valueForKey:@"email"]);
            //NSLog(@"%@",[userDefualt valueForKey:@"lastname"]);
            //NSLog(@"%@",[userDefualt valueForKey:@"firstname"]);
            //NSLog(@"%@",[userDefualt valueForKey:@"cart_id"]);
            //NSLog(@"%@",[userDefualt valueForKey:@"customer_id"]);
            GridViewController *gridObj=[[GridViewController alloc] init];
            [self.navigationController pushViewController:gridObj animated:YES];
    
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            RegistrationSocial *reg=[[RegistrationSocial alloc] init];
            reg.dicData=[dicData copy];
            [self.navigationController pushViewController:reg animated:YES];
        }
    } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
     }];

}



-(void)callFBServiceAction:(NSDictionary *)dicData {
   
    
    //NSLog(@"%@",dicData);
    NSMutableDictionary *requestPeram=[[NSMutableDictionary alloc] init];
    
    [requestPeram setObject:[dicData valueForKey:@"last_name"] forKey:@"userid"];
    
    [CartrizeWebservices PostMethodWithApiMethod:@"twlogin" Withparms:requestPeram WithSuccess:^(id response){
        
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
       
        if([[response JSONValue] valueForKey:@"customer_id"]!=nil){
           
        
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



-(void)callTwitterServiceAction {
    
    NSMutableDictionary *requestPeram=[[NSMutableDictionary alloc] init];
    
    //NSLog(@"%@",[[FHSTwitterEngine sharedEngine]loggedInID]);
    
    [requestPeram setObject:[[FHSTwitterEngine sharedEngine]loggedInID ] forKey:@"userid"];
 
    [CartrizeWebservices PostMethodWithApiMethod:@"twlogin" Withparms:requestPeram WithSuccess:^(id response){
      
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //NSLog(@"%d",[[[response JSONValue] valueForKey:@"error"]length]==0);
        
        if(![[[response JSONValue] valueForKey:@"error"]isEqualToString:@"User id address is already exist in our database"]){
            
            RegistrationViewController *objRegistrationViewController;
            if (IS_IPHONE5){
                objRegistrationViewController = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];
            }else{
                objRegistrationViewController = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController_iphone3.5" bundle:nil];
            }
            [objRegistrationViewController setStrTwitterId:[[FHSTwitterEngine sharedEngine] loggedInID]];
            [self.navigationController pushViewController:objRegistrationViewController animated:YES];
            
        }else{
            NSUserDefaults *defualt=[NSUserDefaults standardUserDefaults];
            
            [defualt setObject:@"YES" forKey:@"isRemember"];
            
            [defualt setObject:[[response JSONValue] valueForKey:@"message"] forKey:@"email"];
            
            [defualt setObject:[[response JSONValue] valueForKey:@"customer_id"] forKey:@"customer_id"];
           
            [defualt setObject:[[response JSONValue] valueForKey:@"userid"] forKey:@"userid"];
           
            [defualt setObject:[[response JSONValue] valueForKey:@"userid"] forKey:@"userid"];
            
//            [defualt setObject:[[response JSONValue] valueForKey:@"cart_id"] forKey:@"cart_id"];
            
            //dipesh. - to check for null from server.
            
            if ([[response JSONValue] objectForKey:@"cart_id"] == nil || [[response JSONValue] objectForKey:@"cart_id"] == (id)[NSNull null]) {
                [defualt setObject:@"" forKey:@"cart_id"];
            }
            else{
                [defualt setObject:[[response JSONValue] objectForKey:@"cart_id"] forKey:@"cart_id"];
            }

            [defualt setObject:[[FHSTwitterEngine sharedEngine] loggedInUsername] forKey:@"firstname"];
           
            [defualt setObject:[[FHSTwitterEngine sharedEngine] loggedInUsername] forKey:@"lastname"];
           
            [defualt setObject:@"" forKey:@"passwordSave"];
            
            [defualt synchronize];
           

            GridViewController *gridObj=[[GridViewController alloc] init];
            [self.navigationController pushViewController:gridObj animated:YES];

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    } failure:^(NSError *error)
     {
     //NSLog(@"Error =%@",[error description]);
         
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
     [alert show];
     }];
}

-(void)callGooglePlusServiceAction:(NSDictionary *)dicData {
    
    
    //NSLog(@"%@",dicData);
    NSMutableDictionary *requestPeram=[[NSMutableDictionary alloc] init];
    
    [requestPeram setObject:[dicData valueForKey:@"email"] forKey:@"email"];
    [requestPeram setObject:[dicData valueForKey:@"given_name"] forKey:@"fname"];
    [requestPeram setObject:[dicData valueForKey:@"family_name"] forKey:@"fname"];
    
    [CartrizeWebservices PostMethodWithApiMethod:@"googlePluslogin" Withparms:requestPeram WithSuccess:^(id response){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if([[response JSONValue] valueForKey:@"customer_id"]!=nil){
            
            NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
            
            [userDefualt setObject:@"YES" forKey:@"isRemember"];
            [userDefualt setObject:[[response JSONValue] objectForKey:@"customer_id"] forKey:@"customer_id"];
            
            [userDefualt setObject:[[response JSONValue] objectForKey:@"cart_id"] forKey:@"cart_id"];
            
            [userDefualt setObject:[dicData valueForKey:@"first_name"] forKey:@"firstname"];
            [userDefualt setObject:[dicData valueForKey:@"last_name"] forKey:@"lastname"];
            [userDefualt setObject:[dicData valueForKey:@"email"] forKey:@"email"];
            
            [userDefualt setObject:@"" forKey:@"passwordSave"];
            [userDefualt setObject:@"YES" forKey:@"isRemember"];
            [userDefualt synchronize];
            
            
            GridViewController *gridObj=[[GridViewController alloc] init];
            [self.navigationController pushViewController:gridObj animated:YES];
        }
        else
        {
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

-(IBAction)ActionBack:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
}

@end

