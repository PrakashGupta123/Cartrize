//
//  UserProfileViewController.m
//  IShop
//
//  Created by Hashim on 6/19/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "DashboardView.h"
#import "ListGridViewController.h"
@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

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
    
    txtEmail.userInteractionEnabled = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    txtFName.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"firstname"];
    txtLName.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"lastname"];
    txtEmail.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    txtPassword.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordSave"];
    txtCnfmPassword.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordSave"];

    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    self.title = @"MY ACCOUNT";
    UIImage *image=[UIImage imageNamed:CRcrossButton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
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
    NSString *password = txtPassword.text;
    NSString *confirmPassword = txtCnfmPassword.text;
    
    if([txtFName.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter first name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([txtLName.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter last name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([txtEmail.text length] > 0 )
    {
        if (![self emailValidation:txtEmail.text])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter Correct email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter e-mail." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if([txtPassword.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([txtCnfmPassword.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter confirm password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if([password isEqualToString:confirmPassword])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Please Wait ...";
        hud.dimBackground = YES;
        
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
    AppDelegate *objAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *string =[request responseString];
    NSData *data = [request responseData];
    
    //NSLog(@"string -- %@",string);
    //NSLog(@"data -- %@",data);
    
    NSMutableDictionary *mutableDictResponce = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *strAlert = [mutableDictResponce valueForKey:@"error"];
    
    if ([[mutableDictResponce objectForKey:@"error"] isEqualToString:@""] || [mutableDictResponce objectForKey:@"error"] == nil)
    {
        objAppDelegate.dictUserInfo = [mutableDictResponce copy];
        
        if ([[mutableDictResponce objectForKey:@"message"] isEqualToString:@"Invalid login or password."])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Invalid Login Id or password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alert show];
        }
        else
        {
            objAppDelegate.isUserLogin = YES;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:txtEmail.text forKey:@"email"];
            [userDefaults setObject:txtPassword.text forKey:@"passwordSave"];
            [userDefaults setObject:txtFName.text forKey:@"firstname"];
            [userDefaults setObject:txtLName.text forKey:@"lastname"];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isRemember"];
            
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
    if(!IS_IPHONE5)
    {
        if(textField == txtPassword)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0 , -120, 320 , 460)];
            [UIView commitAnimations];
        }
        else if(textField == txtCnfmPassword)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0 , -150, 320 , 460)];
            [UIView commitAnimations];
        }
    }
    else
    {
        if(textField == txtPassword)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0 , -120, 320 , 548)];
            [UIView commitAnimations];
        }
        else if(textField == txtCnfmPassword)
        {
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
    if(!IS_IPHONE5)
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
#pragma mark - IBActions
-(IBAction)backAction:(id)sender{
    
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)segmentAction:(id)sender{
    if (seg.selectedSegmentIndex==0) {
        DashboardView *dash=[[DashboardView alloc] initWithNibName:@"DashboardView" bundle:nil];
        [self presentViewController:dash animated:NO completion:nil];

    }else{
        
    }
}

@end
