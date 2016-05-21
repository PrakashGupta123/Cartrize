//
//  AppDelegate.m
//  IShop
//
//  Created by Hashim on 4/29/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import <GooglePlus/GooglePlus.h>
#import "CartrizeWebservices.h"
#import "JSON.h"
#import "Constants.h"
#import "PayPalMobile.h"
#import "Flurry.h"
#import "FHSTwitterEngine.h"
#import "SplashViewController.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "KeychainWrapper.h"
#import "GridViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>//4Apr

#define kNotificationDeleteProduct @"DeleteProduct"
#define kNotificationAddProduct @"AddProduct"
#define kNotificationEditProduct @"EditProduct"
#define kNotificationAddFavoriteProduct @"AddFavoriteProduct"
#define kNotificationRefreshProductItem @"RefreshProductItem"
#define kNotificationDeleteFavoriteProduct @"DeleteFavoriteProduct"
#define kNotificationEditFavoriteProduct @"EditFavoriteProduct"
#define kNotificationMoveToBagProduct @"MoveToBagProduct"
#define kNotificationDeleteProductFromBag @"DeleteProductFromBag"



//#define serviceURL @"http://192.168.88.139/cartrizenew/iosapi_cartrize.php?methodName="
//#define BASEURL @"http://192.168.88.139/cartrizenew/"


#define serviceURL @"http://cartrize.com/iosapi_cartrize.php?methodName="
#define BASEURL @"http://cartrize.com/"

static NSString * const kClientID =
@"348873979382-1r3gq1o4a5orednn3vktdnf27gqvufka.apps.googleusercontent.com";

@interface AppDelegate () <GPPDeepLinkDelegate>

@end
@implementation AppDelegate
@synthesize splashView;
@synthesize strPassword, selectedCateId;
@synthesize isUserLogin;
@synthesize arrAddToBag,strCartId,isPaymentComplete,dictUserInfo,arrFavourite,isCheck,isCheckSearchType,strSearchName;
@synthesize isSelecteGrid,selectedCurrentCurrency,selectedCurrentSize;
@synthesize requestFor;
@synthesize twitterEngine;
@synthesize isFBCheck;
@synthesize arrBackUp;
@synthesize PricePayment;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    arrBackUp = [[NSMutableArray alloc]init];
    [Fabric with:@[[Twitter class],[Crashlytics class]]];
    
    [GPPSignIn sharedInstance].clientID = kClientID;
    // [GPPSignIn sharedInstance].clientID = @"452265719636-qbqmhro0t3j9jip1npl69a3er7biidd2.apps.googleusercontent.com";
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCheckOutHistory) name:@"getCheckOutHistory" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getFavoriteHistory) name:@"getFavoriteHistory" object:nil];
    
    NSHTTPCookieStorage *storage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:kOAuthConsumerKey andSecret:kOAuthConsumerSecret];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    
    [Flurry startSession:@"BYZH42K5P97RRJ2CJT5Z"];//client's id

	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = window;
    
    isCheckOut = NO;
    _IsCalled = NO;
    isSelecteGrid = 1;
    
    //PayPal 
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",
                                                           PayPalEnvironmentSandbox : @"ARQnpBC1C5p9PcsbqQtRJhXy2pn_9owscAXAdkKMavR1Q6YedGqMzTzlJMEd"}];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"Refined"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Name"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Desc"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ShortDesc"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Sku"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MinPrice"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MaxPrice"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [GPPSignIn sharedInstance].clientID = GOOGLE_kClientID;
    
    // Read Google+ deep-link data.
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];

    self.currencySymbol=@"$";
    self.currencyValue=@"1";
    
    _ChangeCurrency=NO;
    self.CurrentCurrency=@"USD";
    self.strPassword = @"";
    isUserLogin = NO;
    isPaymentComplete = NO;
    self.strCustomerPassword = @"";
    self.strSearchName = @"";
    isCheck = NO;
    isCheckSearchType = NO;
    self.selectedCurrentCurrency = @"CURRENCY: USD";
    self.selectedCurrentSize = @"SIZES: US";
    
    self.arrAddToBag = [[NSMutableArray alloc] init];
    self.dictUserInfo = [[NSMutableDictionary alloc] init];
    self.arrFavourite = [[NSMutableArray alloc] init];
    self.MoreInfoarray_Recent= [[NSMutableArray alloc]init];
    
  //  SplashViewController *splash;
    
    if (IS_IPHONE5){
        splashView = [[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:nil];
    }else{
        splashView = [[SplashViewController alloc]initWithNibName:@"SplashViewController_iphone3.5" bundle:nil];
    }
    _navigatoin= [[UINavigationController alloc] initWithRootViewController:splashView];
    
    _navigatoin.navigationBarHidden = YES;
	
    self.window.rootViewController = _navigatoin;
	[self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    [self logUser];
   // [self getCheckOutHistory];
    return YES;
}

- (void) logUser {
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:@"12345"];
    [CrashlyticsKit setUserEmail:@"user@fabric.io"];
    [CrashlyticsKit setUserName:@"Test User"];
}


#pragma mark:-Static Delegate Object
+(AppDelegate*)appDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

-(void)getFavoriteHistory
{
    NSString *customer_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"];
    if(customer_id == nil)
    {
        customer_id = @"";
    }
    
    if(![customer_id isEqualToString:@""])
    {
        NSDictionary *parameters = @{@"customer_id": customer_id};
        
        
        [CartrizeWebservices PostMethodWithApiMethod:@"GetUserAllFavoriteHistory" Withparms:parameters WithSuccess:^(id response)
        {
            if(arrFavourite.count!=0)
            {
                [arrFavourite removeAllObjects];
            }
            
         //   NSArray *arrData=[response JSONValue];

            
         arrFavourite=[response JSONValue];
//            
//            for(int i=0; i<arrData.count;  i++)
//            {
//                NSDictionary *dicData=[arrData objectAtIndex:i];
//                if([[dicData valueForKey:@"prd_qty"] intValue]!=0)
//                {
//                    [arrFavourite addObject:dicData];
//                }
//            }
            
            //  //NSLog(@"Response array =%@",self.arrFavourite);
            if(requestFor == ADDFAVORITES)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationAddFavoriteProduct object:nil];
            }
            if(requestFor == DELETEFAVORITEPRODUCT)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDeleteFavoriteProduct object:nil];
            }
            if(requestFor == EDITFAVORITEPRODUCT)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationEditFavoriteProduct object:nil];
            }
        } failure:^(NSError *error)
         {
             //NSLog(@"Error =%@",[error description]);
         }];
    }
}

-(void)getCheckOutHistory

{
    
    isCheckOut = YES;
    
        //  NSDictionary *parameters = @{@"customer_id": customer_id, @"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
        
        
        
        /* [CartrizeWebservices PostMethodWithApiMethod:@"GetUserAllCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
         
         {
         
         if(arrAddToBag.count!=0)
         
         {
         
         [arrAddToBag removeAllObjects];
         
         }
         
         
         
         NSArray *arrData=[response JSONValue];
         
         
         
         for(int i=0; i<arrData.count;  i++)
         
         {
         
         NSDictionary *dicData=[arrData objectAtIndex:i];
         
         if([[dicData valueForKey:@"prd_qty"] intValue]!=0)
         
         {
         
         [arrAddToBag addObject:dicData];
         
         }
         
         }
         
         
         
         [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationRefreshProductItem object:nil];
         
         */
        
        NSLog(@"request is %d",requestFor);
        
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
//        
//        hud.labelText = @"Please wait...";
//        
//        hud.dimBackground = NO;
    if ([[NSUserDefaults standardUserDefaults ] valueForKey:@"cart_id"]==nil &&[[NSUserDefaults standardUserDefaults] valueForKey:@"email"]==nil ) {
        
        return;
    }
        
        
       NSDictionary *param=@{@"cartid":[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"],@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
        
    
    [CartrizeWebservices PostMethodWithApiMethod:@"getitembyshopping" Withparms:param WithSuccess:^(id response)
         
         {
          
             NSLog(@"Dataa Get For Cart----%@",[response JSONValue]);
         
             
            
             NSMutableDictionary *mDict=[response JSONValue];
      
            if (![[mDict valueForKey:@"data"] isKindOfClass:[NSNull class]]) {
                             [AppDelegate appDelegate].arrAddToBag=[[NSMutableArray alloc]init];
                             
                             [[AppDelegate appDelegate].arrAddToBag removeAllObjects];

                         [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[mDict valueForKey:@"subtotal"]] forKey:@"subtotal"];
                 

                   [AppDelegate appDelegate].arrAddToBag=[mDict valueForKey:@"data"];
                 
                 AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 // splashView = [[SplashViewController alloc] init];
                 if ( _isCartID == NO) {
                    
                       [app.splashView LoginCheckAndgetUpdateCart];
                 }
              
             }
            
             //[AppDelegate appDelegate].requestFor = ADDPRODUCT;
             [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationRefreshProductItem object:nil];
             
             if(requestFor == ADDPRODUCT)
             {
                 [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationAddProduct object:nil];
             }
//             if(requestFor == DELETEPRODUCT)
//             {
//                 [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDeleteProduct object:nil];
//             }
//             if(requestFor == EDITPRODUCT)
//             {
//                 [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationEditProduct object:nil];
//             }
//             if(requestFor == MOVETOBAGPRODUCT)
//             {
//                 [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationMoveToBagProduct object:nil];
//             }
//             if(requestFor == DELETEPRODUCTFROMBAG)
//             {
//                 [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDeleteProductFromBag object:nil];
//             }

             //[MBProgressHUD hideHUDForView:self.window animated:YES];
             
             
             
             //[self addToBagProduct:mDict];
             
             
             
         } failure:^(NSError *error)
         
         {
             
               //[MBProgressHUD hideHUDForView:self.window animated:YES];
             
             //NSLog(@"Error =%@",[error description]);
             GridViewController *gridObj=[[GridViewController alloc]init];
             gridObj=[[GridViewController alloc] initWithNibName:@"GridViewController" bundle:nil];
             [self.navigatoin pushViewController:gridObj animated:YES];
             
         }];
        
    }
    




-(void)callWebserviceForLogin
{
       
}
/*
-(void)getCheckOutHistoryi
{
    isCheckOut = YES;
    
    NSString *customer_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"];
    if(customer_id == nil)
    {
        customer_id = @"";
    }
    
    if(![customer_id isEqualToString:@""] && [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]!=nil)
    {
        NSDictionary *parameters = @{@"customer_id": customer_id, @"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
    
       [CartrizeWebservices PostMethodWithApiMethod:@"GetUserAllCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
        {
            if(arrAddToBag.count!=0)
            {
                [arrAddToBag removeAllObjects];
            }
            
            NSArray *arrData=[response JSONValue];
            
            for(int i=0; i<arrData.count;  i++)
            {
                NSDictionary *dicData=[arrData objectAtIndex:i];
                if([[dicData valueForKey:@"prd_qty"] intValue]!=0)
                {
                    [arrAddToBag addObject:dicData];
                }
            }
            
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationRefreshProductItem object:nil];
        
        if(requestFor == ADDPRODUCT)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationAddProduct object:nil];
            }
            if(requestFor == DELETEPRODUCT)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDeleteProduct object:nil];
            }
            if(requestFor == EDITPRODUCT)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationEditProduct object:nil];
            }
            if(requestFor == MOVETOBAGPRODUCT)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationMoveToBagProduct object:nil];
            }
            if(requestFor == DELETEPRODUCTFROMBAG)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDeleteProductFromBag object:nil];
            }

        } failure:^(NSError *error)
         {
             //NSLog(@"Error =%@",[error description]);
         }];
    }
}
*/
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    if(isFBCheck){
       
        isFBCheck=NO;
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                            sourceApplication:sourceApplication
                                                                   annotation:annotation];
;
    
    }else{
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
    }
        // attempt to extract a token from the url
}

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
    // An example to handle the deep link data.
    UIAlertView *alert = [[UIAlertView alloc]
                           initWithTitle:@"Deep-link Data"
                           message:[deepLink deepLinkID]
                           delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    [alert show];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp]; // 4Apr Facebook
   /* if(isFBCheck){
        [CartrizeWebservices GetMethodWithApiMethod:@"GetAllPages" WithSuccess:^(id response)
         {
             // //NSLog(@"CMS Pages response = %@",[response JSONValue]);
         _mArrayCMSPages = [response JSONValue];
         } failure:^(NSError *error)
         {
         //NSLog(@"Error =%@",[error description]);
         }];
        
            //Get Check Out History
        [self getCheckOutHistory];
            //Get Favorite History
        //[self getFavoriteHistory];
    }*/
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"email"]!=nil)
    {
    [self LoginCheckAndgetUpdateCart];
    }
    
}
-(void)LoginCheckAndgetUpdateCart
{
    NSString *strUserId;
    strUserId = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
       
    
    
    
    
    NSDictionary *parameters = @{@"email":strUserId};
    
    
    [CartrizeWebservices PostMethodWithApiMethod:@"userLogin1" Withparms:parameters WithSuccess:^(id response) {
        
       // NSDictionary *responsedic=[response JSONValue];
        
        
       /* if([[responsedic objectForKey:@"message"] isEqualToString:@"Invalid login or password."])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your session is expired please login  inorder to continue" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag=12321;
            [alert show];
            
        }
        else
        {
            if ([AppDelegate appDelegate].isCartID == NO) {
                NSLog(@"Cart id is YES");
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"getCheckOutHistory" object:nil];
                [AppDelegate appDelegate].isCartID = YES;
                
            }
            
            
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
            //  [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
            [userDefualt setObject:[detail objectForKey:@"firstname"] forKey:@"firstname"];
            [userDefualt setObject:[detail objectForKey:@"lastname"] forKey:@"lastname"];
            [userDefualt setObject:[detail objectForKey:@"email"] forKey:@"email"];
            [userDefualt setObject:[detail objectForKey:@"password_hash"] forKey:@"passwordSave"];
            [userDefualt setBool:YES forKey:@"IsUserLogin"];
            
            [userDefualt setObject:[detail objectForKey:@"email"] forKey:@"RememberEmail"];
            
            [userDefualt setObject:@"YES" forKey:@"isRemember"];
            [userDefualt synchronize];*/
        
            
        }
        
        
        
     failure:^(NSError *error) {
       
        
        NSLog(@"error----%@",error.localizedDescription);
    }];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
