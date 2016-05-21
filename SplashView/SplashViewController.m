//
//  SplashViewController.m
//  IShop
//
//  Created by Hashim on 4/30/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "SplashViewController.h"
//#import "GridViewController.h"
#import "ViewController.h"
#import "CartrizeWebservices.h"
//#import "ParentViewController.h"
//#import "SWRevealViewController.h"
//#import "WomancategoryView.h"
#import "KeychainWrapper.h"
#import "JSON.h"


@interface SplashViewController ()<UIAlertViewDelegate>
{
    BOOL IsCalled;
}
@end

@implementation SplashViewController
@synthesize viewController,loginObj,gridObj;//revealView=_revealView,navigationController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [AppDelegate appDelegate].IsCalled = YES;
    
  }

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
if(alertView.tag==12321)
{
    if(buttonIndex==0)
    {
       self.loginObj=[[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
       
            [self.navigationController pushViewController:self.loginObj animated:YES];
        }

    
    
    
    

}
    

}


-(void)LoginCheckAndgetUpdateCart
{
    NSString *strUserId,*Password;
    KeychainWrapper *keyChain = [[KeychainWrapper alloc] init];
    if ([keyChain myObjectForKey:(__bridge id)kSecValueData]) {
        
        strUserId = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
        Password =[keyChain myObjectForKey:(__bridge id)kSecValueData];
        
    }
    else
    {
        strUserId = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
        Password = @"";
    }
    
    
    
    NSDictionary *parameters = @{@"email":strUserId};
    
    
    [CartrizeWebservices PostMethodWithApiMethod:@"userLogin1" Withparms:parameters WithSuccess:^(id response) {
        
        NSDictionary *responsedic=[response JSONValue];
        
        
        if([[responsedic objectForKey:@"message"] isEqualToString:@"Invalid login or password."])
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
            [userDefualt synchronize];
            if ([AppDelegate appDelegate].IsCalled == YES ) {
                 [self performSelector:@selector(goToRootViewController) withObject:nil afterDelay:0.1];
            }
           
  
           
            
        }
        
        
        
    } failure:^(NSError *error) {
         [self performSelector:@selector(goToRootViewController) withObject:nil afterDelay:0.1];
        
        NSLog(@"error----%@",error.localizedDescription);
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"IsFirst"] boolValue] == NO) {
        
          [activityIndicator startAnimating];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsFirst"];
        [self performSelector:@selector(goToRootViewController) withObject:nil afterDelay:0.3];
        
    }
    else
    {
          [activityIndicator startAnimating];
        
        NSString *customer_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"];
        
        if(customer_id == nil)
            
        {
            
            customer_id = @"";
            
        }
        
        if(![customer_id isEqualToString:@""] && [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]!=nil)
            
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getCheckOutHistory" object:nil];
        }
        else
        {
              [self performSelector:@selector(goToRootViewController) withObject:nil afterDelay:0.3];
        }
    }
    

    
 }

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [AppDelegate appDelegate].IsCalled = NO;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-Go for nextView
-(void)goToRootViewController{
    NSLog(@"GotoRootViewController called again");
  
   // self.viewController=[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
   
   // self.loginObj=[[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
    
    self.gridObj=[[GridViewController alloc] initWithNibName:@"GridViewController" bundle:nil];
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"customer_id"];
    
    if (str.length==0)
        {
            NSLog(@"%@",self.navigationController);

        [self.navigationController pushViewController:self.gridObj animated:YES];
            
        }
        else
        {
                NSLog(@"%@",self.navigationController);
            NSLog(@"Navigate by itself....Splash code is runnig");
            
            [self.navigationController pushViewController:self.gridObj animated:YES];
            }
    
    
    
    
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"FirstTime"] isEqualToString:@"No"])
//    {
//        NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"customer_id"];
//        if (str.length==0)
//        {
//            [self.navigationController pushViewController:self.loginObj animated:YES];
//        }else
//        {
//            [self.navigationController pushViewController:self.gridObj animated:YES];
//        }
//    }
//    else
//    {
//           [self.navigationController pushViewController:self.loginObj animated:YES];
//    }

}

@end
