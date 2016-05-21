//
//  WomancategoryView.m
//  IShop
//
//  Created by Hashim on 4/30/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "WomancategoryView.h"
#import "MySingletonClass.h"
#import "ListGridViewController.h"
#import "SWRevealViewController.h"

@interface WomancategoryView ()

@end

@implementation WomancategoryView
@synthesize categoryArray,listTbl;

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
    self.window=[UIApplication sharedApplication].keyWindow;
    self.navigationController.navigationBarHidden=YES;
    self.progressHud=[[MBProgressHUD alloc]init];
    self.progressHud.delegate=self;
    self.progressHud.labelText = @"Please wait...";

    [self.window addSubview:self.progressHud];
    [self.progressHud show:YES];
    [self getTheDataFromWomanCategory];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-Tableview delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier=@"CellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    self.listTbl.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    cell.textLabel.text=[[self.categoryArray objectAtIndex:indexPath.row] valueForKey:@"category_name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"Refined"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Name"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Desc"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ShortDesc"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Sku"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MinPrice"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MaxPrice"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    SWRevealViewController *revealController = [self revealViewController];
    ListGridViewController *listView = [[ListGridViewController alloc] init];
    listView.categoryId =[[self.categoryArray valueForKey:@"category_id"] objectAtIndex:indexPath.row];
    listView.doUpdate = YES;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:listView];
    [revealController pushFrontViewController:navigationController animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,2, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    NSString *string =@"Category";
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:50/255.0 green:197/255.0 blue:214/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

#pragma mark-webservice methods

-(void)getTheDataFromWomanCategory
{
    NSString *jsonString=[NSString stringWithFormat:@"getAllCategoriesWomen"];
    //NSLog(@"this is json string%@",jsonString);
    
    [[MySingletonClass sharedSingleton] getDataFromJson:jsonString getData:^(NSArray *data,NSError *error){
        if (error)
        {
            [self.progressHud hide:YES];
        }
        else{
            //NSLog(@"this is data%@",data);
            self.categoryArray=data;
            [self.progressHud hide:YES];
            [self.listTbl reloadData];
        }
    }];
}


@end
