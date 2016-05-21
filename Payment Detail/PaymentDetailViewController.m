//
//  PaymentDetailViewController.m
//  French Bakery
//
//  Created by Avnish Sharma on 10/11/13.
//  Copyright (c) 2013 Mayank. All rights reserved.
//

#import "PaymentDetailViewController.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"
#import "CartrizeWebservices.h"
#import "JSON.h"
#import "PaymentTypeViewController.h"
#import "CustomKeyboard.h"
#import "DashboardView.h"

@interface PaymentDetailViewController ()<CustomKeyboardDelegate>
{
    CustomKeyboard *customKeyboard;
}
@end
@implementation PaymentDetailViewController
@synthesize arrayCardType;
@synthesize doneButton;
@synthesize txtFldCvvNumber,arrayMonth,arrayYear,strPresenting;
@synthesize requestFor;

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
    
    [txtFldCardNumber leftMargin:5];
    [txtFldLastOnwerName leftMargin:5];
    [txtFldCvvNumber leftMargin:5];
    
    
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:CRmainBG]]];
        // Do any additional setup after loading the view from its nib.
    [pickerViewCountry setHidden:YES];
    // [self.navigationController setNavigationBarHidden:NO animated:NO];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *nowDate = [NSDate date];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit fromDate:nowDate];
    int year = [comps year];
    
    self.arrayYear = [NSMutableArray array];
    for (int y = year; y < year + 10; y++)
    {
        [self.arrayYear addObject:[NSString stringWithFormat:@"%d",y]];
    }
    self.arrayMonth = [[NSMutableArray alloc] initWithObjects:@"01", @"02", @"03", @"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
    
    [self showLoader];

    NSURL *onwURL = [[NSURL alloc] initWithString:set_card_type];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:onwURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if( theConnection )
    {
        nsDataCardType = [NSMutableData data];
    }
    else
    {
        //NSLog(@"theConnection is NULL");
    }
    
    [self setBorderColor:txtFldCardNumber];
    [self setBorderColor:txtFldCvvNumber];
    [self setBorderColor:txtFldExpiryMonth];
    [self setBorderColor:txtFldExpiryYear];
    [self setBorderColor:txtFldLastOnwerName];

}

-(void)setBorderColor: (UITextField *)textField
{
//    textField.layer.cornerRadius=0.0f;
//    textField.layer.masksToBounds=YES;
//    textField.layer.borderColor=[[UIColor colorWithRed:56.0/255.0
//                                                 green:199.0/255.0
//                                                  blue:214.0/255.0
//                                                 alpha:1.0]CGColor];
//    textField.layer.borderWidth= 1.5f;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
  //  [self.navigationController setNavigationBarHidden:NO animated:NO];
    ObjAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([strPresenting isEqualToString:@"MOVED"])
    {
        strPresenting=@"";
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- SHOW LOADER
-(void)showLoader
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
}

#pragma mark - NSURLConnection Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [nsDataCardType setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [nsDataCardType appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"ERROR with theConenction");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"DONE. Received Bytes: %d", [nsDataCardType length]);
    self.arrayCardType = [NSJSONSerialization JSONObjectWithData:nsDataCardType options:NSJSONReadingMutableContainers error:nil];
    [self.arrayCardType removeObjectAtIndex:0];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - UIPickerView Delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int count = 0;
    
    switch (isSelectedPickr)
    {
        case 0:
            count = [self.arrayCardType count];
            break;
        case 1:
            count = [self.arrayYear count];
            break;
        case 2:
            count = [self.arrayMonth count];
            break;
        default:
            break;
    }
    
   	return count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, pickerViewCountry.frame.size.width, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    
    NSString *strValue;
    switch (isSelectedPickr)
    {
        case 0:
            strValue = [[self.arrayCardType objectAtIndex:row]objectForKey:@"label"];
            break;
        case 1:
            strValue = [self.arrayYear objectAtIndex:row];
            break;
        case 2:
            strValue = [self.arrayMonth objectAtIndex:row];
            break;
        default:
            break;
    }
    
    label.text = [NSString stringWithFormat:@"%@", strValue];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    iRow = row;
    [pickerViewCountry setHidden:YES];
    switch (isSelectedPickr)
    {
        case 0:
            lblCardType.text = [[self.arrayCardType objectAtIndex:row]objectForKey:@"label"];
            strCartType = [[self.arrayCardType objectAtIndex:row]objectForKey:@"value"];
            break;
        case 1:
            lblYear.text = [self.arrayYear objectAtIndex:row] ;
            break;
        case 2:
            lblmonth.text = [self.arrayMonth objectAtIndex:row];
            break;
        default:
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 300;
}

#pragma mark - UIButton Action

- (IBAction)btnCardTypeAction:(id)sender {
    [self removeKeyword];
    isSelectedPickr = 0;
    [pickerViewCountry setHidden:NO];
    [pickerViewCountry reloadAllComponents];
}

- (IBAction) btnYearDDAction:(id)sender {
     [self removeKeyword];
    isSelectedPickr = 1;
    [pickerViewCountry setHidden:NO];
    [pickerViewCountry reloadAllComponents];
    
}
- (IBAction) btnMonthDDAction:(id)sender
{
    [self removeKeyword];
    [txtFldCardNumber resignFirstResponder];
    [txtFldExpiryMonth resignFirstResponder];
    [txtFldExpiryYear resignFirstResponder];
    [txtFldCvvNumber resignFirstResponder];
    isSelectedPickr = 2;
    [pickerViewCountry setHidden:NO];
    [pickerViewCountry reloadAllComponents];
}

- (IBAction) btnContinueAction:(id)sender
{
    [self removeKeyword];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    comps.month = 0;
    NSDate *date1 = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date1]; // Get necessary date components
    //NSLog(@"Previous month: %d",[components month]);
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    NSString *dateString1 = [NSString stringWithFormat:@"%ld", (long)[components month]];
    
    NSString *strTypeYear = lblYear.text;
    NSString *strTypeMonth = lblmonth.text;
    
    int y = [dateString intValue];
    int year = [strTypeYear intValue];
    
    int m = [dateString1 intValue];
    int month = [strTypeMonth intValue];
    
    NSString *strCardExpiryYear = lblYear.text;
    
    //NSString *strCardExpiryMonth = lblmonth;
    
    if([lblCardType.text isEqualToString:@""] || [lblCardType.text isEqualToString:@"Please Select"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select Card type." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([txtFldCardNumber.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter Card number." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([txtFldCvvNumber.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter Cvv number." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([txtFldLastOnwerName.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Enter Card Owner name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([lblYear.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Enter Credit Card expiry year." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        NSComparisonResult result;
        result = [dateString compare:strCardExpiryYear]; // comparing two dates
        if(result == NSOrderedAscending)
        {
            //NSLog(@"today is less");
        }
        else if(result == NSOrderedDescending)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Your Credit Card has Expired." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
            //NSLog(@"newDate is less");
        }
        else
        {
            //NSLog(@"Both dates are same");
        }
    }
    if([lblmonth.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Enter Credit Card expiry month." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        if (y <= year)
        {
            if(y == year)
            {
                if (m <= month)
                {
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Your Credit Card has Expired." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
            }
        }
        else
        {
        }
    }
    
    [self showLoader];
    
    iRequest = 0;
    
    NSURL *url = [NSURL URLWithString:set_Payment_Method];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.timeOutSeconds = 120;
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] forKey:@"CartId"];
    [request setPostValue:txtFldCardNumber.text forKey:@"cc_number"];
    [request setPostValue:txtFldCvvNumber.text forKey:@"cc_cid"];
    [request setPostValue:txtFldLastOnwerName.text forKey:@"cc_owner"];
    [request setPostValue:strCartType forKey:@"cc_type"];
    [request setPostValue:lblYear.text forKey:@"cc_exp_year"];
    [request setPostValue:lblmonth.text forKey:@"cc_exp_month"];
    [request setDidFinishSelector:@selector(requestFinishedForService:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (IBAction) btnCancelAction:(id)sender
{
    [self removeKeyword];
    
    NSArray *arrControllers=self.navigationController.viewControllers;
    
    for (int i=0; i<arrControllers.count; i++) {
        
        if([[arrControllers objectAtIndex:i] isKindOfClass:[PaymentTypeViewController class]]){
          
            //NSLog(@"%@",[arrControllers objectAtIndex:i]);
            [self.navigationController popToViewController:[arrControllers objectAtIndex:i] animated:NO];
        }
    }
        ////NSLog(@"%@",self.navigationController.viewControllers);
    
        //[self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction) btnBackAction:(id)sender
{
    [self removeKeyword];
    [self.navigationController popViewControllerAnimated:YES];
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
            NSLog(@"cartid is %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]);
            
            
            [request setPostValue:@"318" forKey:@"CartId"];
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
        //Call Remove Card
        _mDictPaymentResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
      
        if ([[_mDictPaymentResponse objectForKey:@"error"] isEqualToString:@""])
        {
            strIncrement_id=[_mDictPaymentResponse objectForKey:@"value"];
            [self wsRemoveCard];
        }else{
           [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
       
    }else if (iRequest == 2){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[AppDelegate appDelegate] getCheckOutHistory];
    }
}

#pragma mark:-Hupendra Call services 

-(void)wsRemoveCard {
    
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
         //Call TimeDelivry Web services
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
     }];
}

-(void)getUserCheckoutHistory
{
        //REMOVE ALL PRODUCTS FROM BAG
        for(int i = 0; i < [[AppDelegate appDelegate].arrAddToBag count];i++)
        {
            NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:i];
            NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"product_id":[mDict valueForKeyPath:@"prd_id"],@"uniq_id":[mDict valueForKey:@"uniq_id"],@"get":@"0",@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
            [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
             {
                 [[AppDelegate appDelegate] getCheckOutHistory];
                 
                 //Call TimeDelivry Web services
                 
             } failure:^(NSError *error)
             {
                 //NSLog(@"Error =%@",[error description]);
             }];
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Thank you for your payment." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.tag = 1001;
        [alert show];
    
}

#pragma mark - UIAlert Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001)
    {
      [AppDelegate appDelegate].isPaymentComplete = YES;
      //NSLog(@"%@",[self.navigationController.viewControllers objectAtIndex:0]);
    //  [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
      
        // by me
      
        strPresenting=@"MOVED";
        NSString *strXib = @"DashboardView_iPhone3.5";
        if(IS_IPHONE5)
        {
            strXib =@"DashboardView";
        }
        DashboardView *dash=[[DashboardView alloc] initWithNibName:strXib bundle:nil];
        //  [self.navigationController popToViewController:dash animated:YES];
        [self presentViewController:dash animated:YES completion:nil];
        
        //
    }
}

#pragma mark - Uitextfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [pickerViewCountry setHidden:YES];
    
    if(txtFldCardNumber==textField) {
        customKeyboard = [[CustomKeyboard alloc] init];
        customKeyboard.delegate = self;
        [txtFldCardNumber setInputAccessoryView:[customKeyboard getToolbarWithPrevNextDone:NO :NO]];
        customKeyboard.currentSelectedTextboxIndex =1;
    }else if(txtFldCvvNumber==textField) {
        customKeyboard = [[CustomKeyboard alloc] init];
        customKeyboard.delegate = self;
        [txtFldCvvNumber setInputAccessoryView:[customKeyboard getToolbarWithPrevNextDone:NO :NO]];
        customKeyboard.currentSelectedTextboxIndex =2;
    }
     if(textField == txtFldCardNumber || textField == txtFldCvvNumber)
    {
        [self performSelector:@selector(addButtonToKeyboard) withObject:nil afterDelay:0.1];
    }
    if (txtFldCvvNumber==textField) {
        if(IS_IPHONE_4){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0,-80,320,480)];
            [UIView commitAnimations];
        }
    }else
    if(textField == txtFldLastOnwerName)
    {
        if(IS_IPHONE_4){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0,-105,320,480)];
            [UIView commitAnimations];
        }else{
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0,-30,320,568)];
            [UIView commitAnimations];
        }
    }
    
    if(textField == txtFldLastOnwerName)
    {
        [doneButton removeFromSuperview];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField == txtFldLastOnwerName)
    {
        if(IS_IPHONE_4){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
            [UIView commitAnimations];
        }else{
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
            [UIView commitAnimations];
        }
    }
    [textField resignFirstResponder];
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
    if(lblYear || lblmonth)
    {
        if(IS_IPHONE5)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0, 0, 320, 568)];
            [UIView commitAnimations];
        }
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0, 0, 320, 480)];
            [UIView commitAnimations];
        }
    }
    [txtFldCardNumber resignFirstResponder];
    [txtFldExpiryMonth resignFirstResponder];
    [txtFldExpiryYear resignFirstResponder];
    [txtFldCvvNumber resignFirstResponder];
    [doneButton removeFromSuperview];
}


#pragma mark:- Hupendra add methods 

- (void)nextClicked:(NSUInteger)sender {
  
    [self removeKeyword];
}
- (void)previousClicked:(NSUInteger)sender {
   
    [self removeKeyword];
}
- (void)resignResponder:(NSUInteger)sender {
   
    [self removeKeyword];
}

-(void)removeKeyword {
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    [UIView commitAnimations];
    [txtFldCardNumber resignFirstResponder];
    [txtFldLastOnwerName resignFirstResponder];
    [txtFldExpiryYear resignFirstResponder];
    [txtFldExpiryMonth resignFirstResponder];
    [txtFldCvvNumber resignFirstResponder];
}

@end
