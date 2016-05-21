    //
    //  PaymentTypeViewController.m
    //  IShop
    //
    //  Created by Avnish Sharma on 7/17/14.
    //  Copyright (c) 2014 Syscraft. All rights reserved.
    //

#import "PaymentTypeViewController.h"
#import "CustomCell.h"
#import "PaymentDetailViewController.h"
#import "CartrizeWebservices.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>

#import "DashboardView.h"
#import "DashboardDetail.h"
#define kPayPalEnvironment PayPalEnvironmentNoNetwork


@interface PaymentTypeViewController ()
{
    NSMutableArray *arrDash;
}
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation PaymentTypeViewController
@synthesize strPresent;
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
        // Do any additional setup after loading the view from its nib.
    
    arrDash=[[NSMutableArray alloc]init];
  strPresent=@"";
    [self getPaymentTypeList];
    self.environment = kPayPalEnvironment;
    
    strShippingRate = @"0.00";
    
    [self getShippingRate];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([strPresent isEqualToString:@"MOVED"])
    {
        strPresent=@"";
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
    
//    if ((_isPresent=YES))
//    {
//        _isPresent=NO;
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//    }
    //[PayPalMobile preconnectWithEnvironment:self.environment];
    //[_tableViewPaymentTypeList reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

-(IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark -- GET PAYMENT TYPE LIST
-(void)getPaymentTypeList
{
        //Cash On Delivery
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    [CartrizeWebservices GetMethodWithApiMethod:@"ActivePaymentList" WithSuccess:^(id response)
     {
     //NSLog(@"response =%@",[response JSONValue]);
    
     _mArrayPaymentType = [response JSONValue];
     [_tableViewPaymentTypeList reloadData];
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     } failure:^(NSError *error)
     {
     //NSLog(@"error =%@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

#pragma mark -- TABLEVIEW DELEGATE METHODS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    //return [_mArrayPaymentType count];
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PaymentType";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        {
        NSArray *cellView = [[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = (CustomCell *)[cellView objectAtIndex:1];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor = [UIColor clearColor];
        }
    
   // cell.lblPrdAttibuteTitle.text =@"Cash On Delivery(COD)";

        //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
   // if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"payment_title"] isEqualToString:@"Cash"]) {
        
    cell.lblPrdAttibuteTitle.text = [[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"payment_title"];
   // }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]);
    
  /*  NSMutableDictionary *dicPerameter = [[NSMutableDictionary alloc] init];
    [dicPerameter setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] forKey:@"CartId"];
    if([[_mArrayPaymentType objectAtIndex:1] valueForKey:@"code"]!=nil)
    {
        [dicPerameter setObject:[[_mArrayPaymentType objectAtIndex:1] valueForKey:@"code"] forKey:@"code"];
    }
    
    
    
    [CartrizeWebservices PostMethodWithApiMethod:@"CashOnDeliveryPayMethod" Withparms:dicPerameter WithSuccess:^(id response)
     {
         //NSLog(@"Mony Order Payment Response hupendra== %@",[response JSONValue]);
         
         [self getCartInfo];
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alert show];
     }];
*/
    //Hupendra New Code
    if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"payment_title"] isEqualToString:@"Credit Card"])
        {
        PaymentDetailViewController *objPaymentDetailViewController;
        if (IS_IPHONE5){
            objPaymentDetailViewController = [[PaymentDetailViewController alloc] initWithNibName:@"PaymentDetailViewController" bundle:nil];
        }else{
            objPaymentDetailViewController = [[PaymentDetailViewController alloc] initWithNibName:@"PaymentDetailViewController_3.5screen" bundle:nil];
        }
        
        [self.navigationController pushViewController:objPaymentDetailViewController animated:YES];
        
        }else if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"payment_title"] isEqualToString:@"Cash"]) {
         
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Please wait...";
            hud.dimBackground = YES;
            
            //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]);
            
            NSMutableDictionary *dicPerameter = [[NSMutableDictionary alloc] init];
            [dicPerameter setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] forKey:@"CartId"];
            if([[_mArrayPaymentType objectAtIndex:1] valueForKey:@"code"]!=nil)
            {
               [dicPerameter setObject:[[_mArrayPaymentType objectAtIndex:1] valueForKey:@"code"] forKey:@"code"];
            }

            
            
            [CartrizeWebservices PostMethodWithApiMethod:@"CashOnDeliveryPayMethod" Withparms:dicPerameter WithSuccess:^(id response)
             {
             //NSLog(@"Mony Order Payment Response hupendra== %@",[response JSONValue]);
             
              [self getCartInfo];
             
             } failure:^(NSError *error)
             {
             //NSLog(@"Error =%@",[error description]);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [alert show];
             }];
        }else if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"payment_title"] isEqualToString:@"Payment (Authorize.net)"]) {
        
        }
        //HUpendra
    /*
    if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"payment_title"] isEqualToString:@"Credit Card"])
     {
     //Credit Cart
     PaymentDetailViewController *objPaymentDetailViewController;
     if (IS_IPHONE5)
     {
     objPaymentDetailViewController = [[PaymentDetailViewController alloc] initWithNibName:@"PaymentDetailViewController" bundle:nil];
     }
     else
     {
     objPaymentDetailViewController = [[PaymentDetailViewController alloc] initWithNibName:@"PaymentDetailViewController_3.5screen" bundle:nil];
     }
     // objPaymentDetailViewController.requestFor = requestFor;
     // objPaymentDetailViewController.mDictProductDetail = _mDictProductDetail;
     [self.navigationController pushViewController:objPaymentDetailViewController animated:YES];
     }
     else if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"payment_title"] isEqualToString:@"Cash"])
     {
     //Mony Order
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     hud.labelText = @"Please wait...";
     hud.dimBackground = YES;
     
    
     
     NSDictionary *parameters = @{@"CartId":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
     
     [CartrizeWebservices PostMethodWithApiMethod:@"MonyOrderPayMethod" Withparms:parameters WithSuccess:^(id response)
     {
     
     //NSLog(@"Mony Order Payment Response = %@",[response JSONValue]);
     [self getCartInfo];
     
     } failure:^(NSError *error)
     {
     //NSLog(@"Error =%@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
     }
     else if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"payment_title"] isEqualToString:@"No Payment Information Required"])
     {
     }
     else if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"payment_title"] isEqualToString:@"Cash On Delivery"])
     {
     //Cash On Delivery
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     hud.labelText = @"Please wait...";
     hud.dimBackground = YES;
     
     
     NSDictionary *parameters = @{@"CartId":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
     
     [CartrizeWebservices PostMethodWithApiMethod:@"CashOnDeliveryPayMethod" Withparms:parameters WithSuccess:^(id response)
     {
     //NSLog(@"Mony Order Payment Response = %@",[response JSONValue]);
     [self getCartInfo];
     
     } failure:^(NSError *error)
     {
     //NSLog(@"Error =%@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     [alert show];
     }];
     }
     else if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"code"] isEqualToString:@"paypal_standard"])
     {
     //NSLog(@"Bags Products =%@",[AppDelegate appDelegate].arrAddToBag);
     
     self.environment =@"sandbox";
     [PayPalMobile preconnectWithEnvironment:@"sandbox"];
     
     // [self payPalPayment:NO];
     [self payPalPayment:YES];
     }
     else if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"code"] isEqualToString:@"paypal_express"])
     {
     self.environment =@"sandbox";
     [PayPalMobile preconnectWithEnvironment:self.environment];
     
     [self payPalPayment:NO];
     }
     else if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"authorizenet"] isEqualToString:@"authorizenet"])
     {
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Work in progress..." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
     [alert show];
     }
     else if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"payment_title"] isEqualToString:@""])
     {
     }
     else if ([[[_mArrayPaymentType objectAtIndex:indexPath.row] valueForKey:@"payment_title"] isEqualToString:@""])
     {
     
     }
    */
    
}
    //Hupendra Change Code Start for cash payment

-(void)cashPayment {
    
    iRequest=0;
    
    NSURL *url = [NSURL URLWithString:set_Payment_Method];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.timeOutSeconds = 120;
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] forKey:@"CartId"];
   
    [request setDidFinishSelector:@selector(requestFinishedForService:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


#pragma mark - ASIHTTP Response

-(void)requestFinishedForService:(ASIHTTPRequest *)request
{
    if (iRequest == 0)
        {
        NSString *string =[request responseString];
        NSData *data = [request responseData];
        //NSLog(@"string -- %@",string);
        NSDictionary *dictResponce = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        BOOL checkResponse = [[dictResponce objectForKey:@"value"] boolValue];
        if (checkResponse)
            {
            iRequest = 1;
            NSURL *url = [NSURL URLWithString:set_Cart_info];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                //[request setPostValue:@"getCrtInfo" forKey:@"methodName"];
            [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] forKey:@"CartId"];
            request.timeOutSeconds = 120;
            [request setDidFinishSelector:@selector(requestFinishedForService:)];
            [request setDidFailSelector:@selector(requestFailed:)];
            [request setDelegate:self];
            [request startAsynchronous];
            }
        else
            {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your Card number or Cvv number may be incorrect!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }
    else if (iRequest == 1)
        {
        NSString *string =[request responseString];
        NSData *data = [request responseData];
        //NSLog(@"string -- %@",string);
        
        _mDictPaymentResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[_mDictPaymentResponse objectForKey:@"error"] isEqualToString:@""])
            {
                //REMOVE ALL PRODUCTS FROM BAG
            for(int i = 0; i < [[AppDelegate appDelegate].arrAddToBag count];i++)
                {
                NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:i];
                NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"product_id":[mDict valueForKeyPath:@"prd_id"],@"uniq_id":[mDict valueForKey:@"uniq_id"],@"get":@"0",@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
                
                [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
                 {
                 
                 [[AppDelegate appDelegate] getCheckOutHistory];
                 
                 } failure:^(NSError *error)
                 {
                
                 //NSLog(@"Error =%@",[error description]);
                 }];
                }
          
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Thank you for your payment." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            alert.tag = 1001;
            [alert show];
            }
        else
            {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    
    else if (iRequest == 2)
        {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[AppDelegate appDelegate] getCheckOutHistory];
        }
}

//Hupendra Change Code End

-(void)getCartInfo
{
    NSDictionary *parameters = @{@"CartId":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
    [CartrizeWebservices PostMethodWithApiMethod:@"getCrtInfo" Withparms:parameters WithSuccess:^(id response)
     {
     //NSLog(@"Get Cart ID Response =%@",[response JSONValue]);
     
         strIncrement_id=[[response JSONValue] objectForKey:@"value"];
         
         [self cartRemove];
     } failure:^(NSError *error)
     {
     //NSLog(@"Error = %@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

/*
-(void)cartRemove
{
    [CartrizeWebservices GetMethodWithApiMethod:@"CartDelete" WithSuccess:^(id response)
     {
     //NSLog(@"CartRemove =%@",response);
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Thank you for your payment." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     alert.tag = 1001;
     [alert show];
     } failure:^(NSError *error)
     {
     //NSLog(@"Error =%@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}*/


#pragma mark:- Hupendra Raghuwanshi 
-(void)cartRemove
{
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"]);
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"cart_id"]);
    
    NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"CartId":[[NSUserDefaults standardUserDefaults]objectForKey:@"cart_id"]};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"removecart" Withparms:parameters WithSuccess:^(id response)
     {
         [self getDeliveryTime];
         //Call TimeDelivry Web services
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
     }];
    
}

-(void)getDeliveryTime {
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];
    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"Time"] forKey:@"dtimetext"];
    [parameters setObject:strIncrement_id forKey:@"increment_id"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeId"] forKey:@"timeid"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"TextViewData"] forKey:@"ddate_comment"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"Date"] forKey:@"ddate"];
    
    [CartrizeWebservices PostMethodWithApiMethod:@"GetDeliveryTime" Withparms:parameters WithSuccess:^(id response)
     {
         [self getUserCheckoutHistory];
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
     }];
}


-(void)getUserCheckoutHistory
{
  
    //[dicPerameter setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] forKey:@"CartId"]
    
    //GetCheckoutItemsDelete
    NSString *productIds = [[NSString alloc] init];
    
    NSString *strUniqId=[[NSString alloc] init];
    
    
    for(int i = 0; i < [[AppDelegate appDelegate].arrAddToBag count];i++)
    {
        NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:i];
        
        //NSLog(@"hupendra getCrtInfo detail==%@",mDict);
        
        productIds=[NSString stringWithFormat:@"%@%@,",productIds,[mDict valueForKey:@"uniq_id"]];

          NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"product_id":[mDict valueForKeyPath:@"prd_id"],@"uniq_id":[mDict valueForKey:@"uniq_id"],@"get":@"0",@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
       
          [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
           {
               //NSLog(@"hupendra GetUserCheckoutHistory==%@",response);
               [[AppDelegate appDelegate] getCheckOutHistory];
       
       
           } failure:^(NSError *error)
           {
               //NSLog(@"Error =%@",[error description]);
           }];
        
        
    }//By Suyash
//    NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"product_id":[mDict valueForKeyPath:@"prd_id"],@"uniq_id":[mDict valueForKey:@"uniq_id"],@"get":@"0",@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
//    
//    [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
//     {
//         //NSLog(@"hupendra GetUserCheckoutHistory==%@",response);
//         [[AppDelegate appDelegate] getCheckOutHistory];
//         
//         
//     } failure:^(NSError *error)
//     {
//         //NSLog(@"Error =%@",[error description]);
//     }];
    
    
   
    strUniqId = [productIds substringToIndex:[productIds length] - 1];
    
    NSLog(@"UUUUNNNIIIKKK IIIDDDD:-%@",strUniqId);
   
    NSDictionary *parameters = @{@"uniq_id":strUniqId,@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"GetCheckoutItemsDelete" Withparms:parameters WithSuccess:^(id response)
     {
         
         //NSLog(@"hupendra GetUserCheckoutHistory==%@",response);
         [[AppDelegate appDelegate] getCheckOutHistory];
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
     }];
  
    //[self cartRemove];
    
      [self getDashboardDetails];
 //   [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(showAlert:) userInfo:nil repeats:NO];
}

- (void) showAlert:(NSTimer *) timer
{
    
}

-(void)getDashboardDetails
{
    NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"]};
    [CartrizeWebservices PostMethodWithApiMethod:@"getOrderList" Withparms:parameters WithSuccess:^(id response)
     {
         //NSLog(@"Response = %@",[response JSONValue]);
         arrDash=[response JSONValue];
         
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Thank you for your payment." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         alert.tag = 1001;
         [alert show];
         
       // [self.progressHud hide:YES];
     } failure:^(NSError *error)
     {
        // [self.progressHud hide:YES];
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}


#pragma mark -- ALERT DELEGATE
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000)
        {
        switch (buttonIndex)
            {
                self.environment =@"sandbox";
                [PayPalMobile preconnectWithEnvironment:self.environment];
                case 1:
                {
                    //PayPal Payments Advanced Credit Cart
                    //PAYPAL METHOD CREDIT CART ENABLE AND DECABLE
                [self payPalPayment:YES];
                break;
                }
                case 2:
                {
                    //PayPal Payments Pro Credit Cart
                    //PAYPAL METHOD CREDIT CART ENABLE AND DECABLE
                [self payPalPayment:YES];
                break;
                }
                case 3:
                {
                    //PayPal Payments Standard URL
                    //PAYPAL METHOD CREDIT CART ENABLE AND DECABLE
                [self payPalPayment:NO];
                break;
                }
                case 4:
                {
                    //Express Checkout URL
                    //PAYPAL METHOD CREDIT CART ENABLE AND DECABLE
                [self payPalPayment:NO];
                break;
                }
                default:
                break;
            }
        }
    else if (alertView.tag == 1001)
        {
        [AppDelegate appDelegate].isPaymentComplete = YES;
   //     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            
            // by me
            
//            strPresent=@"MOVED";
//            NSString *strXib = @"DashboardView_iPhone3.5";
//            if(IS_IPHONE5)
//            {
//                strXib =@"DashboardView";
//            }
//            DashboardView *dash=[[DashboardView alloc] initWithNibName:strXib bundle:nil];
//          //  [self.navigationController popToViewController:dash animated:YES];
//            [self presentViewController:dash animated:YES completion:nil];
            
            //
           strPresent=@"MOVED";
            
            NSString *strXib22 = @"DashboardDetail";
            
            if(IS_IPHONE5)
            {
                strXib22 = @"DashboardDetail_iPhone5";
            }
            DashboardDetail *detail=[[DashboardDetail alloc] initWithNibName:strXib22 bundle:nil];
            detail.orderId=[NSString stringWithFormat:@"%@",[[arrDash valueForKey:@"Order"] objectAtIndex:arrDash.count-1]];
            detail.statusStr=[NSString stringWithFormat:@"%@",[[arrDash valueForKey:@"Status"] objectAtIndex:arrDash.count-1]];
            [self presentViewController:detail animated:YES completion:nil];
            
        }
}
-(void)getShippingRate
{
    
    NSDictionary *parameters = @{@"CartId":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"shippignrate" Withparms:parameters WithSuccess:^(id response)
     {
     
     strShippingRate = (NSString *)response ;
     
     } failure:^(NSError *error)
     {
     //NSLog(@"Error = %@",[error description]);
     }];
}

#pragma mark PayPalPaymentDelegate methods
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    //NSLog(@"PayPal Payment Success!");
    //NSLog(@"CompletedPayment Description =%@",[completedPayment description]);
    
        // self.resultText = [completedPayment description];
    [self getInvoiceIdByPayPal:@"Payment"];
    [self showSuccess];
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    //NSLog(@"PayPal Payment Canceled");
        //self.resultText = nil;
        // self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment
{
        // TODO: Send completedPayment.confirmation to server
    //NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}

#pragma mark - Authorize Future Payments

- (IBAction)getUserAuthorization:(id)sender
{
    PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfig delegate:self];
    [self presentViewController:futurePaymentViewController animated:YES completion:nil];
}

#pragma mark - Helpers
- (void)showSuccess
{
        // [self getCartInfo];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
        // self.successView.alpha = 0.0f;
    [UIView commitAnimations];
}

-(void)getInvoiceIdByPayPal :(NSString *)status
{
    
    NSDictionary *parameters = @{@"shippingcode":[[AppDelegate appDelegate].mDictShipping valueForKey:@"sub_value"],@"CartId":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],@"shippingname":[[AppDelegate appDelegate].mDictShipping valueForKey:@"sub_label"],@"status":status};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    
    [CartrizeWebservices PostMethodWithApiMethod:@"PaypalPayMethod" Withparms:parameters WithSuccess:^(id response)
     {
     //NSLog(@"Response =%@",[response JSONValue]);
     [self cartRemove];
     
         //REMOVE ALL PRODUCTS FROM BAG
     for(int i = 0; i < [[AppDelegate appDelegate].arrAddToBag count];i++)
         {
         NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:i];
         NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"product_id":[mDict valueForKeyPath:@"prd_id"],@"uniq_id":[mDict valueForKey:@"uniq_id"],@"get":@"0",@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
        
        [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
          {
              
          [[AppDelegate appDelegate] getCheckOutHistory];
          
          } failure:^(NSError *error)
          {
          //NSLog(@"Error =%@",[error description]);
          [MBProgressHUD hideHUDForView:self.view animated:YES];
          }];
         }
     } failure:^(NSError *error)
     {
     //NSLog(@"Error =%@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

#pragma mark --- PAYPAL CREDIT CART ENABLE AND DECABLE
-(void)payPalPayment:(BOOL)acceptCreditCards
{
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.languageOrLocale = @"en";
        //_payPalConfig.merchantName = @"mayurwadhe@gmail.com";
    _payPalConfig.merchantName = @"dev.syscraft@gmail.com";
        // _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
        // _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
        // Do any additional setup after loading the view, typically from a nib.
        //self.successView.hidden = YES;
        // use default environment, should be Production in real life
        //self.environment = kPayPalEnvironment;
    //NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
    //NSLog(@"Bags Products =%@",[AppDelegate appDelegate].arrAddToBag);
    NSMutableArray *items =  [[NSMutableArray alloc]init];
    for (NSMutableDictionary *mDictProduct in [AppDelegate appDelegate].arrAddToBag)
        {
        NSString *price = [NSString stringWithFormat:@"%@",[mDictProduct valueForKey:@"prd_update_price"]];
        
        PayPalItem *item = [PayPalItem itemWithName:[mDictProduct valueForKey:@"prd_name"]
                                       withQuantity:[[mDictProduct valueForKey:@"prd_qty"]intValue]
                                          withPrice:[NSDecimalNumber decimalNumberWithString:price]
                                       withCurrency:@"USD"
                                            withSku:[mDictProduct valueForKey:@"prd_sku"]];
        
        [items addObject:item];
        }
    
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
        // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:strShippingRate];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Cartrize Shopping";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable)
        {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
        }
    
        // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

@end
