//
//  ShippingListViewController.m
//  IShop
//
//  Created by Avnish Sharma on 8/6/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "ShippingListViewController.h"
#import "CartrizeWebservices.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "PaymentTypeViewController.h"
#import "IQActionSheetPickerView.h"
#import "CustomKeyboard.h"

@interface ShippingListViewController ()<CustomKeyboardDelegate>
{
    CustomKeyboard *customKeyboard;

}
@end

@implementation ShippingListViewController
@synthesize date_Picker,view_For_datePicker;

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
  
    txtTime.enabled=NO;
    btnSelectDatel.enabled=NO;

    // Do any additional setup after loading the view from its nib.
    [txtDate leftMargin:5];
    [txtTime leftMargin:5];
    arrTimeAvail = [[NSMutableArray alloc]init];
    
    //[self getUPSShipMethodList];
    [self getDateTimeWS];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)getUPSShipMethodList
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    [CartrizeWebservices GetMethodWithApiMethod:@"GetUPSShipMethodList" WithSuccess:^(id response)
     {
         SelectedSection = -1;
         _mArrayUPSShipping = [response JSONValue];
         [_tableViewShipList reloadData];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     } failure:^(NSError *error)
     {
         //NSLog(@"error =%@",[error description]);
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- TABLE VIEW DELEGATE AND DATASOURCE

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _mArrayUPSShipping.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @autoreleasepool {
        UIView *sectionHederView=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 260.0,40.0)];
        sectionHederView.backgroundColor = [UIColor clearColor];
        sectionHederView.layer.cornerRadius=2.0f;
        sectionHederView.layer.borderWidth=2.0f;
        sectionHederView.layer.borderColor=(__bridge CGColorRef)([UIColor clearColor]);
        sectionHederView.layer.masksToBounds=YES;
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 300, 40)];
        [imgView setImage:[UIImage imageNamed:@"bg_box.png"]];
        [sectionHederView addSubview:imgView];
        
        if(section == SelectedSection && AB == YES)
        {
            UIImageView *imgArrow = [[UIImageView alloc]initWithFrame:CGRectMake(280, 13, 13, 8)];
            [imgArrow setImage:[UIImage imageNamed:@"shipping_arrow.png"]];
            [sectionHederView addSubview:imgArrow];
        }
        else
        {
            UIImageView *imgArrow = [[UIImageView alloc]initWithFrame:CGRectMake(280, 13, 8, 13)];
            [imgArrow setImage:[UIImage imageNamed:@"shipping_arrow1.png"]];
            [sectionHederView addSubview:imgArrow];
        }
        
        UIButton *PlusButton=[UIButton buttonWithType:UIButtonTypeCustom];
        PlusButton.frame=CGRectMake(0.0, 0.0, 267.0, 30.0);
        PlusButton.backgroundColor=[UIColor clearColor];
        PlusButton.tag=section;
        PlusButton.opaque = NO;
        PlusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [PlusButton addTarget:self action:@selector(ActionEventForButton:) forControlEvents:UIControlEventTouchUpInside];
        [sectionHederView addSubview:PlusButton];
        
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 250, 21)];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor blackColor];
        lblTitle.text = [[_mArrayUPSShipping objectAtIndex:section] objectForKey:@"main_label"];
        [sectionHederView addSubview:lblTitle];
       
        return sectionHederView;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    viewFooter.backgroundColor =[UIColor clearColor];
    return viewFooter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(void)ActionEventForButton:(UIButton *)sender
{
    @autoreleasepool {
        
        if (SelectedSection == sender.tag)
        {
            SelectedSection = sender.tag;
            if (AB == NO)
            {
                AB=YES;
                _RowArray =[[NSMutableArray alloc]initWithArray:[[_mArrayUPSShipping objectAtIndex:sender.tag] objectForKey:@"active_array"]];
            }
            else
            {
                AB=NO;
                _RowArray=[[NSMutableArray alloc]init];
            }
        }
        else
        {
            SelectedSection=sender.tag;
            AB=YES;
            _RowArray=[[NSMutableArray alloc]initWithArray:[[_mArrayUPSShipping objectAtIndex:sender.tag] objectForKey:@"active_array"]];
            
        }
        [_tableViewShipList reloadData];
    }
}

#pragma mark - UITableViewDataSource/Delegate Cell For Row Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (AB==NO)
    {
        return 0;
    }
    else
    {
        if (section == SelectedSection)
        {
            return _RowArray.count;
        }
        else
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @autoreleasepool
    {
        static NSString *cellIdentifier = @"cell123456789105";
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 300, 35)];
//        [imgView setImage:[UIImage imageNamed:@"bg_box.png"]];
        [imgView setBackgroundColor:[UIColor lightGrayColor]];
        [cell addSubview:imgView];
        
//        UIImageView *imgViewSeperator = [[UIImageView alloc]initWithFrame:CGRectMake(22, 29, 280,1)];
//        imgViewSeperator.image =[UIImage imageNamed:@"bdr.png"];
//        [cell addSubview:imgViewSeperator];
        
        if (indexPath.section == SelectedSection)
        {
            UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(22, 5, 280, 21)];
            lblTitle.textColor = [UIColor blackColor];
            lblTitle.text = [[_RowArray objectAtIndex:indexPath.row] objectForKey:@"sub_label"];
            lblTitle.backgroundColor = [UIColor clearColor];
            lblTitle.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
            [cell addSubview:lblTitle];
        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    //FreeShaping Hupendra some code changes
    
    //freeshipping_freeshipping
    
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
   // NSDictionary *parameters = @{@"shippingcode":[[_RowArray objectAtIndex:indexPath.row] objectForKey:@"sub_value"],@"CartId":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
    
    
    //this is fixed set pe
    
      NSDictionary *parameters = @{@"shippingcode":@"freeshipping_freeshipping",@"CartId":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
    
    appDelegate.mDictShipping = [_RowArray objectAtIndex:indexPath.row];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    
    [CartrizeWebservices PostMethodWithApiMethod:@"UPSShipMethod" Withparms:parameters WithSuccess:^(id response)
     {
         //NSLog(@"UPSShipMethod Response = %@",[response JSONValue]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         PaymentTypeViewController *paymentTypeViewController = [[PaymentTypeViewController alloc]initWithNibName:@"PaymentTypeViewController" bundle:nil];
         [self.navigationController pushViewController:paymentTypeViewController animated:YES];
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         PaymentTypeViewController *paymentTypeViewController = [[PaymentTypeViewController alloc]initWithNibName:@"PaymentTypeViewController" bundle:nil];
         [self.navigationController pushViewController:paymentTypeViewController animated:YES];
     }];
}

#pragma mark -- Date Picker.

- (IBAction)action_On_OpenDatePicker_Done:(id)sender {
  
    [txtViewDetail resignFirstResponder];
    [dropDown removeFromSuperview];
   
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Date Picker" delegate:self];
    [picker setMinimumDate:[NSDate date]];
    //setMinimumDate
    [picker setTag:1];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray*)titles {
    
    if(pickerView.tag==1){
        
        NSString *myString = [titles componentsJoinedByString:@" - "];
        
        if ([myString length] >= 10)
            strDate = [myString substringToIndex:10];
            txtDate.text=strDate;
            txtTime.enabled=YES;
            btnSelectDatel.enabled=YES;
            strDayName=[self getday:strDate];
            [self checkDateTime];
    }
    
}


#pragma mark -- UIButton Method
- (void)checkDateTime {
  
    NSArray *arrListData=nil;
    for (int i=0; i<arrTimeAvail.count; i++) {
        if([[[arrTimeAvail objectAtIndex:i] valueForKey:@"day"] isEqualToString:strDayName]) {
            if([[[arrTimeAvail objectAtIndex:i] valueForKey:@"arrTime"]isKindOfClass:[NSArray class] ]) {
                arrListData=[[arrTimeAvail objectAtIndex:i] valueForKey:@"arrTime"];
                break;
            }
        }
    }
   
    if(arrListData!=nil){
        
    }else {
        txtDate.text=@"";
        txtTime.text=@"";
        
        NSString *strDeliveryDay=@"";
        for (int i=0; i<arrTimeAvail.count; i++) {
            if([[[arrTimeAvail objectAtIndex:i] valueForKey:@"dayValues"] intValue]==1) {
                if([strDeliveryDay length]==0){
                    strDeliveryDay=[NSString stringWithFormat:@"%@",[[arrTimeAvail objectAtIndex:i] valueForKey:@"day"]];
                }else{
                   strDeliveryDay=[NSString stringWithFormat:@"%@-%@",strDeliveryDay,[[arrTimeAvail objectAtIndex:i] valueForKey:@"day"]];
                }
            }
        }
      
        if([strDeliveryDay length]==0){
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Our Delivery Days." message:@"Not have any Delivery Days in this week." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];

        }else{
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Our Delivery Days." message:strDeliveryDay delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
 
        }
        
    }

}


-(NSString *)getday :(NSString *)strDate1{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy-MM-dd";
    NSDate *yourDate = [dateFormatter1 dateFromString:strDate1];
    NSDateFormatter *dateFormatter11 = [[NSDateFormatter alloc] init] ;
    [dateFormatter11 setDateFormat:@"EEEE"];
    NSString *weekDay = [dateFormatter11 stringFromDate:yourDate];
    //NSLog(@"%@",weekDay);
    return weekDay;
}



- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if(pickerView.tag==1){
        
    }else if (pickerView.tag==2) {
        
    }
}



- (IBAction)action_On_datePicker_Cancel:(id)sender {
    [txtTime resignFirstResponder];
}

- (IBAction)action_On_datePicker_Done:(id)sender {
    
   
}

#pragma mark Textfidld Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    [textField setInputView:view_For_datePicker];
    return YES;
}



#pragma mark -- BACK ACTION
-(IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark:-Webserives code by hupendra 
//http://cartrize.com/iosapi_cartrize.php?methodName=DeliveryTime

//GetMethodWithApiMethod
-(void)getDateTimeWS {
  
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    
    [CartrizeWebservices GetMethodWithApiMethod:@"DeliveryTime" WithSuccess:^(id response) {
        
        //NSLog(@"UPSShipMethod Response = %@",[response JSONValue]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[response JSONValue] isKindOfClass:[NSArray class]])
        {
            NSArray *arrData=[response JSONValue];
            for (int i=0; i<arrData.count; i++) {
                
                NSMutableDictionary*dicDateTime=[[NSMutableDictionary alloc] init];
                
                if([[[arrData objectAtIndex:i] valueForKey:@"interval"] isKindOfClass:[NSArray class]]){
                    NSArray *arrKey=[[arrData objectAtIndex:i] valueForKey:@"interval"];
                    //NSLog(@"%@",[[arrData objectAtIndex:i] valueForKey:@"interval"]);
                    [dicDateTime setObject:arrKey forKey:@"arrTime"];
              
                }else{
                    [dicDateTime setObject:@"No" forKey:@"arrTime"];
                }
                
                if(i==0) {
                    [dicDateTime setObject:@"Monday" forKey:@"day"];
                    if([[[arrData objectAtIndex:i] valueForKey:@"mon"] intValue]==1){
                        [dicDateTime setObject:@"1" forKey:@"dayValues"];
                    }else {
                       [dicDateTime setObject:@"0" forKey:@"dayValues"];
                    }
               
                }else if (i==1){
                    [dicDateTime setObject:@"Tuesday" forKey:@"day"];
                    if([[[arrData objectAtIndex:i] valueForKey:@"tue"] intValue]==1){
                        [dicDateTime setObject:@"1" forKey:@"dayValues"];
                    }else {
                        [dicDateTime setObject:@"0" forKey:@"dayValues"];
                    }
                }else if (i==2){
                    [dicDateTime setObject:@"Wednesday" forKey:@"day"];
                    if([[[arrData objectAtIndex:i] valueForKey:@"wed"] intValue]==1){
                        [dicDateTime setObject:@"1" forKey:@"dayValues"];
                    }else {
                        [dicDateTime setObject:@"0" forKey:@"dayValues"];
                    }
                }else if (i==3){
                    [dicDateTime setObject:@"Thursday" forKey:@"day"];
                    if([[[arrData objectAtIndex:i] valueForKey:@"thu"] intValue]==1){
                        [dicDateTime setObject:@"1" forKey:@"dayValues"];
                    }else {
                        [dicDateTime setObject:@"0" forKey:@"dayValues"];
                    }
                }else if (i==4){
                    [dicDateTime setObject:@"Friday" forKey:@"day"];
                    if([[[arrData objectAtIndex:i] valueForKey:@"fri"] intValue]==1){
                        [dicDateTime setObject:@"1" forKey:@"dayValues"];
                    }else {
                        [dicDateTime setObject:@"0" forKey:@"dayValues"];
                    }
                }else if (i==5){
                    [dicDateTime setObject:@"Saturday" forKey:@"day"];
                    if([[[arrData objectAtIndex:i] valueForKey:@"sat"] intValue]==1){
                        [dicDateTime setObject:@"1" forKey:@"dayValues"];
                    }else {
                        [dicDateTime setObject:@"0" forKey:@"dayValues"];
                    }
                }else if (i==6){
                    [dicDateTime setObject:@"Sunday" forKey:@"day"];
                    if([[[arrData objectAtIndex:i] valueForKey:@"sun"] intValue]==1){
                        [dicDateTime setObject:@"1" forKey:@"dayValues"];
                    }else {
                        [dicDateTime setObject:@"0" forKey:@"dayValues"];
                    }
                }
                
                [arrTimeAvail addObject:dicDateTime];
            }
            
        
            //NSLog(@"%@",arrTimeAvail);
            
        }else if([[response JSONValue] isKindOfClass:[NSDictionary class]]){
          
        }
        
    }failure:^(NSError *error) {
        //NSLog(@"Error =%@",[error description]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}



#pragma mark -- UIButton Method
- (IBAction)action_On_OpenTimePicker_Done:(id)sender
{
    [txtViewDetail resignFirstResponder];
    NSArray *arrListData=nil;
   
    for (int i=0; i<arrTimeAvail.count; i++) {
     
        if([[[arrTimeAvail objectAtIndex:i] valueForKey:@"day"] isEqualToString:strDayName]) {
            if([[[arrTimeAvail objectAtIndex:i] valueForKey:@"arrTime"]isKindOfClass:[NSArray class] ]) {
                arrListData=[[arrTimeAvail objectAtIndex:i] valueForKey:@"arrTime"];
                break;
            }
        }
    }
    
    if(arrListData!=nil){
        
        NSMutableArray *arrList=[[NSMutableArray alloc] init];
        for (int i=0; i<arrListData.count; i++) {
            [arrList addObject:[arrListData objectAtIndex:i]];
        }
        //NSLog(@"%@",arrList);
        UIButton *btnSender=(UIButton *)sender;
        if(dropDown == nil) {
            CGFloat height =[arrListData count]* 40;
            dropDown = [[VSPDropDownView alloc]showDropDown:btnSender andWithHeight:height andWithArray:arrList andWithDirection:@"down"];
            dropDown.backgroundColor=[UIColor whiteColor];
            dropDown.delegate = self;
        }
        else{
            [dropDown hideDropDown:sender];
            [self nilDropDownView];
        }
    }
}

- (void) getStrData: (NSDictionary *)dicDate {
    strTimeId=[dicDate valueForKey:@"timeid"];
    txtTime.text=[dicDate valueForKey:@"times"];
}

-(void)VSPDropDownDelegateMethod:(VSPDropDownView *)sender {
    //NSLog(@"%ld",(long)sender.tag);
    [self nilDropDownView];
}

-(void)nilDropDownView {
    dropDown = nil;
}


//- (IBAction)action_On_OpenTimePicker_Done:(id)sender {
//   
//
//}

#pragma mark:-Hupendra Raghuwanshi
-(void)WSSendDateTimeWS {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
   
    [CartrizeWebservices GetMethodWithApiMethod:@"DeliveryTime" WithSuccess:^(id response) {
        //NSLog(@"UPSShipMethod Response = %@",[response JSONValue]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }failure:^(NSError *error) {
        //NSLog(@"Error =%@",[error description]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

- (void)nextClicked:(NSUInteger)sender {
    [txtViewDetail resignFirstResponder];
}
- (void)previousClicked:(NSUInteger)sender {
    [txtViewDetail resignFirstResponder];
}
- (void)resignResponder:(NSUInteger)sender {
    [txtViewDetail resignFirstResponder];
}

//- (void)textViewShouldBeginEditing:(UITextView *)textView {
//    customKeyboard = [[CustomKeyboard alloc] init];
//    customKeyboard.delegate = self;
//    [txtViewDetail setInputAccessoryView:[customKeyboard getToolbarWithPrevNextDone:NO :NO]];
//    customKeyboard.currentSelectedTextboxIndex =1;
//
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  
    if ([text isEqualToString:@"\n"]) {
        [txtViewDetail resignFirstResponder];
        return NO;
    }
    return YES;
}


- (IBAction)nextViewController:(id)sender
{
    if([txtDate.text length]==0) {
        UIAlertView *aletView=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aletView show];
    }else if ([txtTime.text length]==0){
        UIAlertView *aletView=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aletView show];
    }
//    else if ([txtViewDetail.text length]==0)
//    {
//        UIAlertView *aletView=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Please Enter Message." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [aletView show];
//    }
    else
    {
        PaymentTypeViewController *paymentTypeViewController = [[PaymentTypeViewController alloc]initWithNibName:@"PaymentTypeViewController" bundle:nil];
        [self.navigationController pushViewController:paymentTypeViewController animated:YES];
        
        NSUserDefaults *defualtData=[NSUserDefaults standardUserDefaults];
        [defualtData setObject:txtDate.text forKey:@"Date"];
        [defualtData setObject:txtTime.text forKey:@"Time"];
        [defualtData setObject:txtViewDetail.text forKey:@"TextViewData"];
        [defualtData setObject:strTimeId forKey:@"TimeId"];
        [defualtData synchronize];
    }
    
   // [self callWSForGettingResponse];
}


-(void)callWSForGettingResponse {
    // NSDictionary *parameters = @{@"shippingcode":[[_RowArray objectAtIndex:indexPath.row] objectForKey:@"sub_value"],@"CartId":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
    //this is fixed set pe

    NSDictionary *parameters = @{@"shippingcode":@"freeshipping_freeshipping",@"CartId":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    
    [CartrizeWebservices PostMethodWithApiMethod:@"UPSShipMethod" Withparms:parameters WithSuccess:^(id response)
     {
         //NSLog(@"UPSShipMethod Response = %@",[response JSONValue]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         PaymentTypeViewController *paymentTypeViewController = [[PaymentTypeViewController alloc]initWithNibName:@"PaymentTypeViewController" bundle:nil];
         [self.navigationController pushViewController:paymentTypeViewController animated:YES];
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         PaymentTypeViewController *paymentTypeViewController = [[PaymentTypeViewController alloc]initWithNibName:@"PaymentTypeViewController" bundle:nil];
         [self.navigationController pushViewController:paymentTypeViewController animated:YES];
     }];

}




@end
