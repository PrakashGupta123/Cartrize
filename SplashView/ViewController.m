//
//  ViewController.m
//  Cartrize
//
//  Created by Admin on 19/07/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "ViewController.h"
#import "LoginView.h"
@interface ViewController ()

@end

@implementation ViewController

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
    UIColor *color = [UIColor whiteColor];
    zipCodetf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Your Zip Code" attributes:@{NSForegroundColorAttributeName: color}];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark IBActions
-(IBAction)continueAction:(id)sender{
    if(zipCodetf.text.length!=0){
    [[NSUserDefaults standardUserDefaults] setObject:zipCodetf.text forKey:@"ZipCode"];
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"FirstTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    LoginView *login=[[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
    [self.navigationController pushViewController:login animated:YES];
    }
}
@end
