//
//  BillingAddressViewController.m
//  French Bakery
//
//  Created by Avnish Sharma on 10/4/13.
//  Copyright (c) 2013 Mayank. All rights reserved.
//

#import "BillingAddressViewController.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "PaymentDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PaymentTypeViewController.h"
#import "CustomCell.h"
#import "JSON.h"
#import "ShippingListViewController.h"
#import "CartrizeWebservices.h"

#import "CustomKeyboard.h"

#pragma mark -- TABLEVIEW DATA SOURCE
#pragma mark – UITableViewDataSource
#pragma mark tableview section methods
#pragma marl - UITableView Data Source number of section

@interface BillingAddressViewController ()<CustomKeyboardDelegate,UIAlertViewDelegate> {
    CustomKeyboard *customKeyboard;
}

@end

@implementation BillingAddressViewController

@synthesize arrayCountry,arrayStates;
@synthesize keyboardToolbar;
@synthesize doneButton;
@synthesize requestFor;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   /* btnState.hidden = YES;
    lblStateName.hidden = YES;
    txtFldState.hidden = NO;
    isStateSelect = NO;
    [txtFldState leftMargin:5];
    
    [btnState setUserInteractionEnabled:NO];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:CRmainBG]]];
        // Do any additional setup after loading the view from its nib.
    [pickerViewCountry setHidden:YES];
    
    
    self.arrayStates = [[NSMutableArray alloc] init];
    
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    UIImage *image=[UIImage imageNamed:CRcrossButton];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnCancelAction:) forControlEvents:UIControlEventTouchUpInside];
   
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    UIImage *image1=[UIImage imageNamed:@"black_arrow.png"];
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.bounds = CGRectMake( 0, 0, image1.size.width, image1.size.height );
    [buttonBack setBackgroundImage:image1 forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(btnCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItemRight = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
    self.navigationItem.leftBarButtonItem = barButtonItemRight;
    
    txtFldFirstName.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"firstname"];
    txtFldLastName.text =[[NSUserDefaults standardUserDefaults] valueForKey:@"lastname"];
    
    SelectedSection = -1;*/
    
    [self CartIdWebService];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
    
   
    
    BILLHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BILLHUD.labelText=@"Please Wait...";
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
    if(buttonIndex==0)
    {
        if(alertView.tag==4567)
        {
                [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
            GridViewController *objBillingAddressViewController;
            
            objBillingAddressViewController = [[GridViewController alloc] initWithNibName:@"GridViewController" bundle:nil];
            
            objBillingAddressViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:objBillingAddressViewController animated:YES];
        
        }
        else
        {
   
        }
    }


}

-(void)methodNamee
{
    NSLog(@"<<<<<<Called>>>>>>>");
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your order has been received successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag=4567;
    [alert show];
    
   // MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.labelText = @"Please wait...";
   // hud.dimBackground = YES;

}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"finish");
    [BILLHUD hide:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSURL* url = [webView.request URL];
  //  NSString  *strhtml = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
   // NSLog(@"HTML content is %@",strhtml);
    
    NSString *urlString = [url absoluteString];
    
    if([urlString isEqualToString:@"https://cartrize.com/index.php/checkout/onepage/?head=rem"])
    {
        NSLog(@"Not success payment page");
        
        
    }
    else if([urlString isEqualToString:@"https://cartrize.com/index.php/checkout/onepage/success/"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"done" forKey:@"billing"];
        wv.scrollView.contentOffset = CGPointMake(0, 100);
        wv.userInteractionEnabled=NO;
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cart_id"];
        //wv.scrollView.scrollEnabled = YES;
        [self performSelector:@selector(methodNamee) withObject:nil afterDelay:0.5];
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your Payment was not successfull. Please try again " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=@"2";
        [alert show];
       

        
    
    
    }
    NSLog(@"url fo the loded webpage%@",urlString);
   
    
}




-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] != NSURLErrorCancelled) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Error for WEBVIEW: %@", [error description]);
        //show error alert, etc.
    }
    NSLog(@"Error for WEBVIEW: %@", [error description]);
    [MBProgressHUD hideHUDForView:self.view animated:YES]; 
}

-(void)CartIdWebService
{
    NSDictionary *params=@{@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    [CartrizeWebservices PostMethodWithApiMethod:@"creditcartview" Withparms:params WithSuccess:^(id response) {
        
        NSDictionary *dict=[response JSONValue];
        
        //[[NSUserDefaults standardUserDefaults]setObject:cartid forKey:@"cid"];
        wv=[[UIWebView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height)];
        NSURL *urlPath;
        NSURLRequest *requestObj;
        wv.delegate=self;
//
//        urlPath = [NSURL URLWithString:@""];
//        requestObj = [NSURLRequest requestWithURL:urlPath];
//        [wv loadRequest:requestObj];
        //Webserviceurl=[dict valueForKey:@"check_url"];
        
       // urlPath = [NSURL URLWithString:Webserviceurl];
        //requestObj = [NSURLRequest requestWithURL:urlPath];
        NSString *url=[dict valueForKey:@"check_url"];
        urlPath = [NSURL URLWithString:url];
        //requestObj = [NSMutableURLRequest requestWithURL:[urlPath absoluteURL]];
        requestObj = [NSMutableURLRequest requestWithURL:urlPath
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:20.0];
        [wv loadRequest:requestObj];
        [self.view addSubview:wv];
        [self.view bringSubviewToFront:wv];
        // NSLog(@"cartid is%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"cid"]);
        
        
        
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   // [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.title = @"BILLING ADDRESS";
   /* ObjAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 //   [self CountryAction];
    
    if (!isCheckService)
    {
        [self StateAction];
    }
*/
    
}

#pragma mark - UIButton Action

- (void) CountryAction
{
    isCheckService = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    
    NSURL *onwURL = [[NSURL alloc] initWithString:all_country];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:onwURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if( theConnection )
    {
        nsDataCountry = [NSMutableData data];
    }
    else
    {
        //NSLog(@"theConnection is NULL");
    }
}

- (IBAction) btnCountryAction:(id)sender
{
    
    [self removeKeyword];
    if(IS_IPHONE5)
    {
        keyboardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 308, 320, 44)];
    }
    else
    {
        keyboardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 220, 320, 44)];
    }
    
    UIButton *done_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    done_Button.frame=CGRectMake(0.0, 0, 60.0, 30.0);
    [done_Button setTitle:@"Done" forState:UIControlStateNormal];
    [done_Button addTarget:self action:@selector(doneBtnPressToGetValue:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancel_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel_Button.frame=CGRectMake(0.0, 0, 60.0, 30.0);
    [cancel_Button setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel_Button addTarget:self action:@selector(CancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithCustomView:done_Button];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithCustomView:cancel_Button];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIView *toolBarNa = [[UIView alloc]initWithFrame:keyboardToolbar.bounds];
    [toolBarNa setBackgroundColor:[UIColor colorWithRed:166/255.0f green:187/255.0f blue:94/255.0f alpha:1.0]];
    
    [keyboardToolbar insertSubview:toolBarNa atIndex:0];
    
    CALayer *l=keyboardToolbar.layer;
    [l setCornerRadius:0.5];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
    [l setBorderWidth:0.5];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:btnCancel, flex, myButton, nil]];
    [self.view addSubview:keyboardToolbar];
    
    [txtFldFirstName resignFirstResponder];
    [txtFldLastName resignFirstResponder];
    [txtFldContact resignFirstResponder];
    [txtFldState resignFirstResponder];
    [txtFldStreet resignFirstResponder];
    [txtFldZipCode resignFirstResponder];
    [txtFldCity resignFirstResponder];

    isCheckService = NO;
    [pickerViewCountry setHidden:NO];
    [self.view bringSubviewToFront:pickerViewCountry];
    [pickerViewCountry reloadAllComponents];
}

-(IBAction)CancelButtonPressed:(id)sender
{
    [self removeKeyword];
    [pickerViewCountry setHidden:YES];
    [keyboardToolbar removeFromSuperview];
}

- (IBAction) btnCancelAction:(id)sender
{   [self removeKeyword];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneBtnPressToGetValue:(id)sender
{
    [self removeKeyword];
    [pickerViewCountry setHidden:YES];
    [keyboardToolbar removeFromSuperview];
    if (!isCheckService)
    {
        [self StateAction];
    }
}

- (void)StateAction
{
    lblCountryName.text=@"United States";
    isCheckService = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    iRequest = 2;
    NSURL *url = [NSURL URLWithString:region_country];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.timeOutSeconds = 120;
//    [request setPostValue:[[self.arrayCountry objectAtIndex:232] objectForKey:@"value"] forKey:@"value"];
    [request setPostValue:@"US" forKey:@"value"];
    [request setDidFinishSelector:@selector(requestFinishedForService:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (IBAction) btnStateAction:(id)sender
{
    [self removeKeyword];
    isCheckService = YES;
    [pickerViewCountry reloadAllComponents];
    [pickerViewCountry setHidden:NO];
}

- (IBAction) btnBackAction:(id)sender
{
    [self removeKeyword];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getCartIdDetail
{
        //getCartId
    [CartrizeWebservices GetMethodWithApiMethod:@"getCartId" WithSuccess:^(id response)
     {
     
     //NSLog(@"%@",[[response JSONValue] valueForKey:@"CartId"]);
         //HUpendra
     [AppDelegate appDelegate].strCartId=[[response JSONValue] valueForKey:@"CartId"];
         // //NSLog(@"Response Cart id = %@",[response JSONValue]);
     
     } failure:^(NSError *error)
     {
     //NSLog(@"Error = %@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}


- (IBAction) btnCountinueAction111:(id)sender
{
    [self removeKeyword];
    ShippingListViewController *shippingListViewController = [[ShippingListViewController alloc]initWithNibName:@"ShippingListViewController" bundle:nil];
    [self.navigationController pushViewController:shippingListViewController animated:YES];
}

- (IBAction) btnCountinueAction:(id)sender
{
    [self removeKeyword];
    if([txtFldFirstName.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Enter First name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([txtFldLastName.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Enter Last name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([txtFldContact.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Enter Contact number." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([txtFldContact.text length] < 10)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"The contact no. should contain minimum 10 numbers." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([lblCountryName.text isEqualToString:@""] || [lblCountryName.text isEqualToString:@"Please Select"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select Country." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if(isStateSelect == YES && ([lblStateName.text isEqualToString:@""] || [lblStateName.text isEqualToString:@"Please Select"]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select State." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if(isStateSelect == NO && [txtFldState.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Enter State." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([txtFldCity.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Enter City." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([txtFldStreet.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Enter Street address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([txtFldZipCode.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Enter Zip code." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else if([[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]==nil ||[[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] isEqualToString:@""]){
            //  [self getCartIdDetail];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Crad Id Not found,Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    
    iRequest = 0;
    
    
    if(![self.arrayStates count] == 0){
        //NSLog(@"%@",self.arrayStates);
        
        }
    else{
        //NSLog(@"%@",txtFldState.text);
        }
    
    //NSLog(@"CartId==%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]);
    //NSLog(@"bl_firstname==%@",txtFldFirstName.text);
    //NSLog(@"bl_lastname==%@",txtFldLastName.text);
    //NSLog(@"bl_street==%@",txtFldStreet.text);
    //NSLog(@"bl_city==%@",txtFldCity.text);
    //NSLog(@"bl_region==%@",[[self.arrayStates objectAtIndex:iRow]objectForKey:@"value"]);
    //NSLog(@"bl_postcode==%@",txtFldZipCode.text);
    //NSLog(@"bl_country_id==%@",[[self.arrayCountry objectAtIndex:iRow] objectForKey:@"value"]);
    //NSLog(@"bl_telephone==%@",txtFldContact.text);
    //NSLog(@"sh_firstname==%@",txtFldFirstName.text);
    //NSLog(@"sh_lastname==%@",txtFldLastName.text);
    //NSLog(@"sh_street==%@",txtFldStreet.text);
     //NSLog(@"sh_city==%@",txtFldCity.text);
     //NSLog(@"sh_region==%@",[[self.arrayStates objectAtIndex:iRow]objectForKey:@"value"]);
     //NSLog(@"sh_postcode==%@",txtFldZipCode.text);
     //NSLog(@"sh_country_id==%@",[[self.arrayCountry objectAtIndex:iRow] objectForKey:@"value"]);
    //NSLog(@"sh_telephone==%@",txtFldContact.text);
    
    
    NSMutableDictionary *dicPerameter=[[NSMutableDictionary alloc] init];
    [dicPerameter setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] forKey:@"CartId"];
    [dicPerameter setObject:txtFldFirstName.text forKey:@"bl_firstname"];
    [dicPerameter setObject:txtFldLastName.text forKey:@"bl_lastname"];
    [dicPerameter setObject:txtFldStreet.text forKey:@"bl_street"];
    [dicPerameter setObject:txtFldCity.text forKey:@"bl_city"];
    
    if(![self.arrayStates count] == 0)
        {
        [dicPerameter setObject:[[self.arrayStates objectAtIndex:iRow]objectForKey:@"value"] forKey:@"bl_region"];
        }
    else{
        [dicPerameter setObject:txtFldState.text forKey:@"bl_region"];
        }
    
    [dicPerameter setObject:txtFldZipCode.text forKey:@"bl_postcode"];
  
    //  [dicPerameter setObject:[[self.arrayCountry objectAtIndex:iRow] objectForKey:@"value"] forKey:@"bl_country_id"];
    //by me
     [dicPerameter setObject:@"US"forKey:@"bl_country_id"];
    //
    
    [dicPerameter setObject:txtFldContact.text forKey:@"bl_telephone"];
    [dicPerameter setObject:txtFldFirstName.text forKey:@"sh_firstname"];
    [dicPerameter setObject:txtFldLastName.text forKey:@"sh_lastname"];
    [dicPerameter setObject:txtFldStreet.text forKey:@"sh_street"];
    [dicPerameter setObject:txtFldCity.text forKey:@"sh_city"];
    
    if(![self.arrayStates count] == 0)
        {
        [dicPerameter setObject:[[self.arrayStates objectAtIndex:iRow]objectForKey:@"value"] forKey:@"sh_region"];
        }
    else
        {
        [dicPerameter setObject:txtFldState.text forKey:@"sh_region"];
        }
    
    [dicPerameter setObject:txtFldZipCode.text forKey:@"sh_postcode"];
//    [dicPerameter setObject:[[self.arrayCountry objectAtIndex:iRow] objectForKey:@"value"] forKey:@"sh_country_id"];
   [dicPerameter setObject:@"US" forKey:@"sh_country_id"];
    [dicPerameter setObject:txtFldContact.text forKey:@"sh_telephone"];
    
    
    
    
    NSURL *url = [NSURL URLWithString:set_cart_Address];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] forKey:@"CartId"];
    [request setPostValue:txtFldFirstName.text forKey:@"bl_firstname"];
    [request setPostValue:txtFldLastName.text forKey:@"bl_lastname"];
    [request setPostValue:txtFldStreet.text forKey:@"bl_street"];
    [request setPostValue:txtFldCity.text forKey:@"bl_city"];
    request.timeOutSeconds = 120;
    if(![self.arrayStates count] == 0)
    {
        [request setPostValue:[[self.arrayStates objectAtIndex:iRow]objectForKey:@"value"] forKey:@"bl_region"];
    }
    else
    {
        [request setPostValue:txtFldState.text forKey:@"bl_region"];
    }
    
    [request setPostValue:txtFldZipCode.text forKey:@"bl_postcode"];
  //  [request setPostValue:[[self.arrayCountry objectAtIndex:iRow] objectForKey:@"value"] forKey:@"bl_country_id"];
    
     [request setPostValue:@"US" forKey:@"bl_country_id"];
    [request setPostValue:txtFldContact.text forKey:@"bl_telephone"];
    
    [request setPostValue:txtFldFirstName.text forKey:@"sh_firstname"];
    [request setPostValue:txtFldLastName.text forKey:@"sh_lastname"];
    [request setPostValue:txtFldStreet.text forKey:@"sh_street"];
    [request setPostValue:txtFldCity.text forKey:@"sh_city"];
    
    if(![self.arrayStates count] == 0)
    {
        [request setPostValue:[[self.arrayStates objectAtIndex:iRow]objectForKey:@"value"] forKey:@"sh_region"];
    }
    else
    {
        [request setPostValue:txtFldState.text forKey:@"sh_region"];
    }

    [request setPostValue:txtFldZipCode.text forKey:@"sh_postcode"];
   // [request setPostValue:[[self.arrayCountry objectAtIndex:iRow] objectForKey:@"value"] forKey:@"sh_country_id"];
     [request setPostValue:@"US" forKey:@"sh_country_id"];
    [request setPostValue:txtFldContact.text forKey:@"sh_telephone"];
    
    [request setDidFinishSelector:@selector(requestFinishedForService:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDelegate:self];
    [request startAsynchronous];
}


/*
  inspirefnb.com/fashionworld/iosapi.php?methodName=UPSShipMethod&shippingcode=ups_2DA&CartId=516
 */

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
            ShippingListViewController *shippingListViewController = [[ShippingListViewController alloc]initWithNibName:@"ShippingListViewController" bundle:nil];
            [self.navigationController pushViewController:shippingListViewController animated:YES];
        }
    }
    else if (iRequest == 1)
    {
        NSData *data = [request responseData];
        
        //NSLog(@"string --%@", [request responseString]);
        NSDictionary *dictResponce = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        BOOL checkResponse = [[dictResponce objectForKey:@"value"] boolValue];
        
        if (checkResponse)
        {
            PaymentTypeViewController *paymentTypeViewController = [[PaymentTypeViewController alloc]initWithNibName:@"PaymentTypeViewController" bundle:nil];
            [self.navigationController pushViewController:paymentTypeViewController animated:YES];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    else if (iRequest == 2)
    {
        [btnState setUserInteractionEnabled:YES];
        //NSString *string =[request responseString];
        NSData *data = [request responseData];
        ////NSLog(@"string -- %@",string);
        
        self.arrayStates = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         ////NSLog(@"string -- %@",string);
        
        if ([self.arrayStates count] == 0 || self.arrayStates == nil )
        {
            btnState.hidden = YES;
            lblStateName.hidden = YES;
            txtFldState.hidden = NO;
            isStateSelect = NO;
        }
        else
        {
            btnState.hidden = NO;
            lblStateName.hidden = NO;
            txtFldState.hidden = YES;
            lblStateName.text = @"Please Select";
            isStateSelect = YES;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    else if (iRequest == 3)
    {
        NSString *string =[request responseString];
        NSData *data = [request responseData];
        //NSLog(@"string -- %@",string);
        
        NSDictionary *dictResponce = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        BOOL checkResponse = [[dictResponce objectForKey:@"value"] boolValue];
        
        if (checkResponse)
        {
            iRequest = 1;
            NSURL *url = [NSURL URLWithString:flat_shipMethod];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            request.timeOutSeconds = 120;
            [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] forKey:@"CartId"];
            [request setDidFinishSelector:@selector(requestFinishedForService:)];
            [request setDidFailSelector:@selector(requestFailed:)];
            [request setDelegate:self];
            [request startAsynchronous];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Check your network connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITextfield Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:CGRectMake(0 , 0, 320 , [UIScreen mainScreen].bounds.size.height)];
    [UIView commitAnimations];
    [textField resignFirstResponder];

    
    if(txtFldContact==textField) {
        customKeyboard = [[CustomKeyboard alloc] init];
        customKeyboard.delegate = self;
        [txtFldContact setInputAccessoryView:[customKeyboard getToolbarWithPrevNextDone:NO :NO]];
        customKeyboard.currentSelectedTextboxIndex =1;
    }
    
    
    if(textField == txtFldContact)
    {
        [self performSelector:@selector(addButtonToKeyboard) withObject:nil afterDelay:0.1];
    }
    if(!(textField == txtFldContact))
    {
        [doneButton removeFromSuperview];
    }
    if(textField == txtFldStreet || textField == txtFldZipCode)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        if(IS_IPHONE_4){
             [self.view setFrame:CGRectMake(0 , -150, 320 , [UIScreen mainScreen].bounds.size.height)];
        }else {
             [self.view setFrame:CGRectMake(0 , -100, 320 , [UIScreen mainScreen].bounds.size.height)];
        }
        [UIView commitAnimations];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtFldState) {
        [txtFldCity becomeFirstResponder];
    }
    else if (textField == txtFldCity) {
        [txtFldStreet becomeFirstResponder];
    }
    else if (textField == txtFldStreet) {
    
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.5];
//        [self.view setFrame:CGRectMake(0, 0, 320, 568)];
//        [UIView commitAnimations];
    
        [txtFldZipCode becomeFirstResponder];
    }
    else if (textField == txtFldZipCode) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.view setFrame:CGRectMake(0 , 0, 320 , [UIScreen mainScreen].bounds.size.height)];
        [UIView commitAnimations];
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)addButtonToKeyboard
{
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 163, 106, 53);
    doneButton.adjustsImageWhenHighlighted = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0)
    {
        [doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
        [doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
        [doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
    }
    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    // locate keyboard view
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++)
    {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        // keyboard found, add the button
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2)
        {
            if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
                [keyboard addSubview:doneButton];
        }
        else
        {
            if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
                [keyboard addSubview:doneButton];
        }
    }
}

- (void)doneButton:(id)sender
{
	//NSLog(@"doneButton");
    [doneButton removeFromSuperview];
    [txtFldContact resignFirstResponder];
}

#pragma mark - NSURLConnection Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (!isCheckService)
    {
        [nsDataCountry setLength: 0];
    }
    else
    {
        [nsDataState setLength: 0];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!isCheckService)
    {
        [nsDataCountry appendData:data];
    }
    else
    {
        [nsDataState appendData:data];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"ERROR with theConenction");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (!isCheckService)
    {
        //NSLog(@"DONE. Received Bytes: %d", [nsDataCountry length]);
        self.arrayCountry = [NSJSONSerialization JSONObjectWithData:nsDataCountry options:NSJSONReadingMutableContainers error:nil];
        [self.arrayCountry removeObjectAtIndex:0];
    }
    else
    {
        //NSLog(@"DONE. Received Bytes: %d", [nsDataState length]);
        self.arrayStates = [NSJSONSerialization JSONObjectWithData:nsDataState options:NSJSONReadingMutableContainers error:nil];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - UIPickerView Delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count;
    if (!isCheckService)
    {
        count = [self.arrayCountry count];
    }
    else
    {
        count = [self.arrayStates count];
    }
	return count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, pickerViewCountry.frame.size.width, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    
    NSString *strValue;
    
    if (!isCheckService)
    {
        strValue = [[self.arrayCountry objectAtIndex:row] objectForKey:@"label"];
    }
    else
    {
        strValue = [[self.arrayStates objectAtIndex:row]objectForKey:@"label"];
    }
    
    label.text = [NSString stringWithFormat:@"%@", strValue];
    return label;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    iRow = row;
    NSLog(@"RRRRRRROOOOOWWWWWW:-%d",iRow);
    if (!isCheckService)
    {
        lblCountryName.text = [[self.arrayCountry objectAtIndex:row] objectForKey:@"label"];
    }
    else
    {
        lblStateName.text = [[self.arrayStates objectAtIndex:row]objectForKey:@"label"];
        [pickerViewCountry setHidden:YES];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 300;
}


#pragma mark:-Hupendra Raghuwanshi

- (void)nextClicked:(NSUInteger)sender
{
    [self removeKeyword];
}
- (void)previousClicked:(NSUInteger)sender
{
    [self removeKeyword];
}
- (void)resignResponder:(NSUInteger)sender
{
    [self removeKeyword];
}

-(void)removeKeyword
{
   
    [self.view setFrame:CGRectMake(0 , 0, 320 , [UIScreen mainScreen].bounds.size.height)];
    [txtFldFirstName resignFirstResponder];
    [txtFldContact resignFirstResponder];
    [txtFldCity resignFirstResponder];
    [txtFldStreet resignFirstResponder];
    [txtFldZipCode resignFirstResponder];
    [txtFldState resignFirstResponder];
}

@end
