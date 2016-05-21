//
//  DashboardView.m
//  IShop
//
//  Created by Admin on 15/07/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "DashboardView.h"
#import "DashboardCell.h"
#import "CartrizeWebservices.h"
#import "JSON.h"
#import "DashboardDetail.h"
#import "UserProfileViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>


@interface DashboardView ()

@end

@implementation DashboardView
@synthesize progressHud,window;
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
    myAcc_view.backgroundColor=[UIColor clearColor];
    dashArray=[[NSMutableArray alloc] init];
    self.window=[UIApplication sharedApplication].keyWindow;
    self.navigationController.navigationBarHidden=YES;
    self.progressHud=[[MBProgressHUD alloc]init];
    self.progressHud.delegate=self;
    self.progressHud.labelText = @"Please wait...";
    [self.window addSubview:self.progressHud];
    [self.progressHud show:YES];
    [self setBorderColor:txtFName];
    [self setBorderColor:txtLName];
    [self setBorderColor:txtEmail];
    [self setBorderColor:txtFName];
    [self setBorderColor:txtPassword];
    [self setBorderColor:txtCnfmPassword];
    UIColor *color = [UIColor grayColor];
  
    txtFName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}];
    txtLName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}];
    txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}];
    txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}];
    txtCnfmPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}];

    // Do any additional setup after loading the view from its nib.
}

-(void)setBorderColor: (UITextField *)textField
{
//    textField.layer.cornerRadius=0.0f;
//    textField.layer.masksToBounds=YES;
//    textField.layer.borderColor=[[UIColor colorWithRed:56.0/255.0
//                                                green:199.0/255.0
//                                                 blue:214.0/255.0
//                                                alpha:1.0]CGColor];
//    textField.layer.borderWidth= 1.0f;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
  //  NSAttributedString *strEmail= [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    
    txtFName.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"firstname"];
    txtLName.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"lastname"];
    txtEmail.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
 
    //by me
   // txtEmail.placeholder=[[NSUserDefaults standardUserDefaults] objectForKey:@"RememberEmail"];
    //  [txtEmail setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    //
    
  //  txtPassword.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordSave"];
  //  txtCnfmPassword.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordSave"];
    txtEmail.userInteractionEnabled = YES;
    myAcc_view.hidden=YES;
    [self getDashboardDetails];
}

-(void)getDashboardDetails
{
    NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"]};

    [CartrizeWebservices PostMethodWithApiMethod:@"getOrderList" Withparms:parameters WithSuccess:^(id response)
     {
          //NSLog(@"Response = %@",[response JSONValue]);
         dashArray=[response JSONValue];
         [tab reloadData];
         [self.progressHud hide:YES];
     } failure:^(NSError *error)
     {
         [self.progressHud hide:YES];
         //NSLog(@"Error =%@",[error description]);
          [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];

}
#pragma mar - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dashArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid =@"CellId";
    DashboardCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        NSArray *nibArr=[[NSBundle mainBundle] loadNibNamed:@"DashboardCell" owner:self options:nil];
        cell=[nibArr objectAtIndex:0];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.shipto.text=[NSString stringWithFormat:@"%@",[[dashArray valueForKey:@"Ship To"] objectAtIndex:indexPath.row]];
    cell.orderNum.text=[NSString stringWithFormat:@"%@",[[dashArray valueForKey:@"Order"] objectAtIndex:indexPath.row]];
    cell.date.text=[NSString stringWithFormat:@"%@",[[dashArray valueForKey:@"Date"] objectAtIndex:indexPath.row]];
    NSString *str=[NSString stringWithFormat:@"%@",[[dashArray valueForKey:@"Order Total"] objectAtIndex:indexPath.row]];
    float val=[str floatValue];
    cell.orderTotal.text=[NSString stringWithFormat:@"$%.2f",val];
    cell.statuslbl.text=[NSString stringWithFormat:@"%@",[[dashArray valueForKey:@"Status"] objectAtIndex:indexPath.row]];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark - UITablViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor clearColor]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strXib = @"DashboardDetail";
    
    if(IS_IPHONE5)
    {
        strXib = @"DashboardDetail_iPhone5";
    }
    DashboardDetail *detail=[[DashboardDetail alloc] initWithNibName:strXib bundle:nil];
    detail.orderId=[NSString stringWithFormat:@"%@",[[dashArray valueForKey:@"Order"] objectAtIndex:indexPath.row]];
    detail.statusStr=[NSString stringWithFormat:@"%@",[[dashArray valueForKey:@"Status"] objectAtIndex:indexPath.row]];
    [self presentViewController:detail animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBActions
-(IBAction)backAction:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)segmentAction:(id)sender
{
    if (seg.selectedSegmentIndex==0)
    {
        myAcc_view.hidden=YES;
        tab.hidden=NO;
    }
    else
    {
        myAcc_view.hidden=NO;
        tab.hidden=YES;
    }
}

- (IBAction)btnNextStepAction:(id)sender
{
    NSString *password = txtPassword.text;
    NSString *confirmPassword = txtCnfmPassword.text;
    if([txtFName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter first name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if((txtFName.text.length>33))
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"First name maximum 32 characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([txtLName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter last name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if((txtLName.text.length>33))
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Last name maximum 32 characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if((txtPassword.text.length<6) || (txtPassword.text.length>21))
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
    
    
    if([password isEqualToString:confirmPassword])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Please Wait ...";
      //  hud.dimBackground = YES;
        
        NSURL *url = [NSURL URLWithString:@"http://cartrize.com/iosapi_cartrize.php?methodName=UpdatCustomer"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:txtEmail.text forKey:@"email"];
        [request setPostValue:txtPassword.text forKey:@"password"];
        [request setPostValue:txtFName.text forKey:@"fname"];
        [request setPostValue:txtLName.text forKey:@"lname"];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"customer_id"] forKey:@"CusloginId"];
        [request setDidFinishSelector:@selector(requestFinishedForService:)];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDelegate:self];
        [request startAsynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Password Do not match." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

#pragma mark - ASIHTTP Response

-(void)requestFinishedForService:(ASIHTTPRequest *)request
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *string =[request responseString];
    NSData *data = [request responseData];
    
    //NSLog(@"string -- %@",string);
    //NSLog(@"data -- %@",data);
    
    NSMutableDictionary *mutableDictResponce = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *strAlert = [mutableDictResponce valueForKey:@"error"];
    
    if ([[mutableDictResponce objectForKey:@"error"] isEqualToString:@""] || [mutableDictResponce objectForKey:@"error"] == nil)
    {
        [AppDelegate appDelegate].dictUserInfo = [mutableDictResponce copy];
        
        if ([[mutableDictResponce objectForKey:@"message"] isEqualToString:@"Invalid login or password."])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Invalid Login Id or password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alert show];
        }
        else
        {
            [AppDelegate appDelegate].isUserLogin = YES;
           // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",txtEmail.text] forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",txtPassword.text] forKey:@"passwordSave"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",txtFName.text] forKey:@"firstname"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",txtLName.text] forKey:@"lastname"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isRemember"];
            //[[NSUserDefaults standardUserDefaults] synchronize];
           // [userDefaults synchronize ] ;
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[mutableDictResponce objectForKey:@"success"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Profile updated succesfully!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(![[mutableDictResponce objectForKey:@"error"] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:strAlert delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Check your network connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Uitextfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
     [self.view setFrame:CGRectMake(0 , 0, 320 , [UIScreen mainScreen].bounds.size.height)];
    if(IS_IPHONE_4) {
        if(textField == txtPassword){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0 , -120, 320 , 460)];
            [UIView commitAnimations];
        }else if(textField == txtCnfmPassword) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0 , -150, 320 , 460)];
            [UIView commitAnimations];
        }
    }else {
        if(textField == txtPassword) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0 , -120, 320 , 548)];
            [UIView commitAnimations];
        }else if(textField == txtCnfmPassword)  {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0 , -150, 320 , 548)];
            [UIView commitAnimations];
        }
    }
       return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
     [self.view setFrame:CGRectMake(0 , 0, 320 , [UIScreen mainScreen].bounds.size.height)];
    
    
   /* if(!IS_IPHONE5)
    {
        if(textField == txtPassword)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0, 0, 320, 480)];
            [UIView commitAnimations];
        }
        else if(textField == txtCnfmPassword)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0, 0, 320, 480)];
            [UIView commitAnimations];
        }
    }
    else
    {
        if(textField == txtPassword)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0, 0, 320, 568)];
            [UIView commitAnimations];
        }
        else if(textField == txtCnfmPassword)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0, 0, 320, 568)];
            [UIView commitAnimations];
        }
    }
 */
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - validations

-(BOOL)emailValidation:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}


#pragma mark:-Hupendra 
-(void)removeKeyword {
    [self.view setFrame:CGRectMake(0 , 0, 320 , [UIScreen mainScreen].bounds.size.height)];
}

@end
