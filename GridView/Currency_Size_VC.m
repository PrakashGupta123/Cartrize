//
//  Currency_Size_VC.m
//  IShop
//
//  Created by Vivek  on 30/05/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "Currency_Size_VC.h"
#import "RegistrationViewController.h"
#import "AddCartViewController.h"
#import "FavouriteViewController.h"
#import "UserProfileViewController.h"
#import "ListGridViewController.h"
#import "CustomCell.h"
#import "CMSPageViewController.h"
#import "DashboardView.h"

@interface Currency_Size_VC ()
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;
@property (weak, nonatomic) IBOutlet UITableView *table_currency_size;

- (IBAction)backAction:(id)sender;

@end

@implementation Currency_Size_VC
@synthesize isSelectedValue;
@synthesize btnMyAccount, btnJoin,delegate;

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
    [_table_currency_size reloadData];
   
    isSearch = NO;
    arrContaintList = [[NSMutableArray alloc]init];
    arrContaintList = [[NSUserDefaults standardUserDefaults]objectForKey:@"searchProductsList"];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    isTablcontent = 0;
    
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //topMenuSliderView.hidden = YES;
    CGRect frame = [topMenuSliderView frame];
    frame.origin.y = -323;
    frame.size.width = 320;
    frame.size.height = 378;
    [topMenuSliderView setFrame:frame];
    CGRect frameTable= self.table_currency_size.frame;
    frameTable.origin.y = 53;
    self.table_currency_size.frame = frameTable;
    isVisibleTopView = NO;
    // menuView.hidden = YES;
    _table_currency_size.userInteractionEnabled = YES;
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isRemember"] isEqualToString:@"YES"])
    {
        lblWelcomeuser.text = [NSString stringWithFormat:@"Hi %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"firstname"]];
        self.btnSignIn.hidden = YES;
        self.btnSignOut.hidden = NO;
        self.btnJoin.hidden = YES;
        self.btnMyAccount.hidden = NO;
    }
    else
    {
        lblWelcomeuser.text = @"Welcome to CardRize";
        self.btnSignIn.hidden = NO;
        self.btnSignOut.hidden = YES;
        self.btnJoin.hidden = NO;
        self.btnMyAccount.hidden = YES;
    }
    
    [self getYourBagItem];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    
    NSURL *url;
    //NSLog(@"selectd val %d",isSelectedValue);
    if (isSelectedValue == 1001)
    {
        url = [NSURL URLWithString:currency_code];
    }
    else
    {
        NSMutableString *path = [NSMutableString stringWithFormat:@"%@",[NSString stringWithFormat:refine_search,@"Size"]];
        url = [NSURL URLWithString:path];
    }
        
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0];
    
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(theConnection)
    {
        webData = [NSMutableData data];
    }
    else
    {
        //NSLog(@"theConnection is NULL");
    }
}

-(IBAction)btnActionMyAccount:(id)sender
{
    
    NSString *strXib = @"DashboardView_iPhone3.5";
    if(IS_IPHONE5)
    {
        strXib =@"DashboardView";
    }
    DashboardView *dash=[[DashboardView alloc] initWithNibName:strXib bundle:nil];
    [self presentViewController:dash animated:YES completion:nil];
    
//    UserProfileViewController *objUserProfileViewController;
//    if (IS_IPHONE5)
//    {
//        objUserProfileViewController = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
//    }
//    else
//    {
//        objUserProfileViewController = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController_iphone3.5" bundle:nil];
//    }
//    [self.navigationController pushViewController:objUserProfileViewController animated:YES];
}

-(void) getYourBagItem
{
    int totalItem = 0;
    for(NSMutableDictionary *mDict in [AppDelegate appDelegate].arrAddToBag)
    {
        totalItem = totalItem + [[ mDict valueForKey:@"prd_qty"]intValue];
    }
    lblDownBagCount.text = [NSString stringWithFormat:@"%d",totalItem];
    lblBagCount.text = [NSString stringWithFormat:@"%d",totalItem];
}

#pragma mark - Response

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"ERROR with theConenction");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    _dataArray = [NSJSONSerialization JSONObjectWithData:webData options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"Responce-- %@",_dataArray);
    [self.table_currency_size reloadData];
}

#pragma mark - Action method

- (IBAction)topNavigationSliderAction:(id)sender
{
    if (isVisibleTopView)
    {
        isTablcontent = 0;
        [_table_currency_size reloadData];
        _table_currency_size.userInteractionEnabled = YES;
        [UIView beginAnimations:@"animationOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        //topMenuSliderView.hidden = NO;
        CGRect frame = [topMenuSliderView frame];
        frame.origin.y = -323;
        [topMenuSliderView setFrame:frame];
        
        CGRect frameTable = self.table_currency_size.frame;
        frameTable.origin.y = 53;
        self.table_currency_size.frame = frameTable;
        //menuView.hidden = YES;
        isVisibleTopView = NO;
        [UIView commitAnimations];
    }
    else
    {
        isTablcontent = 2;
        [_tableViewTopContent reloadData];
        _table_currency_size.userInteractionEnabled = NO;
        [UIView beginAnimations:@"animationOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        //topMenuSliderView.hidden = NO;
        CGRect frame = [topMenuSliderView frame];
        frame.origin.y = 0;
        frame.size.width = 320;//Some value
        frame.size.height = 378;//some value
        [topMenuSliderView setFrame:frame];
        
        CGRect frameTable = self.table_currency_size.frame;
        frameTable.origin.y = 378;
        self.table_currency_size.frame = frameTable;
        
        isVisibleTopView = YES;
        [self.view  bringSubviewToFront:topMenuSliderView];
        [UIView commitAnimations];
        //menuView.hidden = NO;
    }
}

- (IBAction)btnJoinAction:(id)sender
{
    RegistrationViewController *objRegistrationViewController;
    if (IS_IPHONE5)
    {
        objRegistrationViewController = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];
    }
    else
    {
        objRegistrationViewController = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController_iphone3.5" bundle:nil];
    }
    
    [self.navigationController pushViewController:objRegistrationViewController animated:YES];
}

- (IBAction)btnSignInAction:(id)sender
{
    //topMenuSliderView.hidden = NO;
    [UIView beginAnimations:@"animationOff" context:NULL];
    [UIView setAnimationDuration:0.2f];

    CGRect frame = [topMenuSliderView frame];
    frame.origin.y = -323;
    frame.size.width = 320;
    frame.size.height = 378;
    [topMenuSliderView setFrame:frame];
    CGRect frameTable= self.table_currency_size.frame;
    frameTable.origin.y = 53;
    self.table_currency_size.frame = frameTable;
    isVisibleTopView = NO;
    [UIView commitAnimations];

    [self performSelector:@selector(signIn) withObject:nil afterDelay:0.5];
}

- (void) signIn
{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"customer_id"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"subtotal"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    LoginView *gridObj=[[LoginView alloc] init];
    [self.navigationController pushViewController:gridObj animated:YES];
}

- (IBAction)btnSignOutAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isRemember"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"customer_id"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"firstname"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"lastname"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"email"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Do you want to Sign Out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [AppDelegate appDelegate].isUserLogin = NO;
        self.btnSignIn.hidden = NO;
        self.btnSignOut.hidden = YES;
    }
}
-(IBAction)SeacrhButtonPress:(id)sender
{
    isTablcontent = 1;
    searchView = (SearchView *)[[[NSBundle mainBundle]loadNibNamed:@"SearchView" owner:self options:nil]objectAtIndex:0 ];
    [searchView.btnHideView addTarget:self action:@selector(hideSearchView:) forControlEvents:UIControlEventTouchUpInside];
    isSearch = YES;
    searchView.txtSearch.delegate = self;
    searchView.tableViewSearchResult.delegate = self;
    searchView.tableViewSearchResult.dataSource = self;
    [self.view addSubview:searchView];
    [searchView.tableViewSearchResult reloadData];
}

-(IBAction)hideSearchView:(id)sender
{
    isTablcontent = 0;
    isSearch = NO;
    [AppDelegate appDelegate].isCheckSearchType = NO;
    [searchView removeFromSuperview];
  
    [_table_currency_size reloadData];
    //topMenuSliderView.hidden = YES;
    CGRect frame = [topMenuSliderView frame];
    frame.origin.y = -323;
    frame.size.width = 320;
    frame.size.height = 378;
    [topMenuSliderView setFrame:frame];
    CGRect frameTable= self.table_currency_size.frame;
    frameTable.origin.y = 53;
    self.table_currency_size.frame = frameTable;
    isVisibleTopView = NO;
    // menuView.hidden = YES;
    _table_currency_size.userInteractionEnabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter a search keyword" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    [AppDelegate appDelegate].isCheckSearchType = YES;
    
    [textField resignFirstResponder];
    
    [AppDelegate appDelegate].strSearchName = textField.text;
    
    if(arrContaintList == nil)
    {
        arrContaintList = [[NSMutableArray alloc]init];
    }
    [arrContaintList addObject:textField.text];
    
    [[NSUserDefaults standardUserDefaults]setObject:arrContaintList forKey:@"searchProductsList"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"Refined"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Name"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Desc"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ShortDesc"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Sku"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MinPrice"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MaxPrice"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    ListGridViewController *listGridViewController = [[ListGridViewController alloc]initWithNibName:@"ListGridViewController" bundle:nil];
    listGridViewController.doUpdate=NO;
    [self.navigationController pushViewController:listGridViewController animated:YES];
    return YES;
}

-(IBAction)addCartButtonPress:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isRemember"] isEqualToString:@"YES"])
    {
        AddCartViewController *addCart = [[AddCartViewController alloc]initWithNibName:@"AddCartViewController" bundle:nil];
        [self.navigationController pushViewController:addCart animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please login with your account" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)btnSaveItemAction:(id)sender
{
    FavouriteViewController *objFavouriteViewController = [[FavouriteViewController alloc]initWithNibName:@"FavouriteViewController" bundle:nil];
    //[self presentViewController:objFavouriteViewController animated:YES completion:nil];
    [self.navigationController pushViewController:objFavouriteViewController animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isTablcontent == 1){
        return 44;
    }
    else{
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isTablcontent == 0){
        return [_dataArray count];
    }
    else if (isTablcontent == 1){
        return [arrContaintList count];
    }
    else{
        return 1 + [[AppDelegate appDelegate].mArrayCMSPages count];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(isTablcontent == 1)
        {
        if([arrContaintList count] > 0)
        {
            UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            viewHeader.backgroundColor = [UIColor whiteColor];
            
            UILabel *lblHeaderTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 222, 21)];
            lblHeaderTitle.text = @"YOUR RECENT SEARCHES:";
            lblHeaderTitle.font = [UIFont systemFontOfSize:11];
            lblHeaderTitle.textColor = [UIColor blackColor];
            [viewHeader addSubview:lblHeaderTitle];
            
            UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
            btnClear.frame = CGRectMake(235, 5, 60, 23);
            [btnClear setImage:[UIImage imageNamed:@"clear_r"] forState:UIControlStateNormal];
            [btnClear addTarget:self action:@selector(actionClearSearchList:) forControlEvents:UIControlEventTouchUpInside];
            [viewHeader addSubview:btnClear];
            return viewHeader;
        }
        return nil;
    }
    else
        return nil;
}

-(IBAction)actionClearSearchList:(id)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"searchProductsList"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    arrContaintList = [[NSMutableArray alloc]init];

    [searchView.tableViewSearchResult reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isTablcontent == 0)
    {//Currency
        static  NSString *cellidentifier = @"cellid";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellidentifier];
        
        if (cell == Nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
        }
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
        
        if([self.checkedIndexPath isEqual:indexPath])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (isSelectedValue == 1001)
        {
            cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"currency_code"];
        }
        else
        {
            cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row]objectAtIndex:0];
        }
        
        return cell;
    }
    else if (isTablcontent == 1)
    {
        //Search 
        static NSString *CellIdentifier = nil;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        cell.textLabel.text = [arrContaintList objectAtIndex:indexPath.row] ;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"CMSContent";
        CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSArray *cellView = [[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = (CustomCell *)[cellView objectAtIndex:2];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor = [UIColor clearColor];
        //        if (cell == nil)
        //        {
        //            NSArray *cellView = [[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil];
        //            cell = (CustomCell *)[cellView objectAtIndex:2];
        //            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //            cell.contentView.backgroundColor = [UIColor clearColor];
        //        }
        
        if(indexPath.row == 0)
        {
            cell.lblPrdAttibuteTitle.text = [[NSString stringWithFormat:@"CURRENCY: %@",[AppDelegate appDelegate].CurrentCurrency] uppercaseString];
            [cell.btnCell addTarget:self action:@selector(btnChangeCurrency:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.lblPrdAttibuteTitle.text = [[[[AppDelegate appDelegate].mArrayCMSPages objectAtIndex:indexPath.row - 1]valueForKey:@"title"]uppercaseString];
            cell.btnCell.tag = indexPath.row - 1;
            [cell.btnCell addTarget:self action:@selector(actionGoToCMSPages:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSearch)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"Refined"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Name"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Desc"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ShortDesc"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Sku"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MinPrice"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MaxPrice"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [AppDelegate appDelegate].strSearchName = [arrContaintList objectAtIndex:indexPath.row];
        ListGridViewController *listGridViewController = [[ListGridViewController alloc]initWithNibName:@"ListGridViewController" bundle:nil];
        listGridViewController.doUpdate=NO;
        [self.navigationController pushViewController:listGridViewController animated:YES];
    }
    else
    {
        // Uncheck the previous checked row
        if(self.checkedIndexPath)
        {
            UITableViewCell* uncheckCell = [tableView
                                            cellForRowAtIndexPath:self.checkedIndexPath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.checkedIndexPath = indexPath;
        
        if (isSelectedValue == 1001)
        {
            NSString *currencystr=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"currency_code"];
            NSString *code = [currencystr substringFromIndex: [currencystr length] - 3];
            NSArray *listItems = [currencystr componentsSeparatedByString:@" "];
            NSString *symbol=[listItems objectAtIndex:0];
            
            //NSLog(@"%@",symbol);
            
            NSString *urlString = [NSString stringWithFormat:@"http://www.freecurrencyconverterapi.com/api/convert?q=%@-%@&compact=y",[AppDelegate appDelegate].CurrentCurrency,code];
            
            NSString *KEY=[NSString stringWithFormat:@"%@-%@",[AppDelegate appDelegate].CurrentCurrency,code];
            
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data, NSError *connectionError)
             {
                 if (data==nil) {
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                     return ;
                     
                 }
                 
                 if (data.length > 0 && connectionError == nil)
                 {
                     NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:NULL];
                     NSDictionary * resultRespons=result[KEY];
                     //NSLog(@"%@",resultRespons);
                     
                     [self.delegateCurrency RefreshCurrencydelegatemethod:symbol withvalue:[resultRespons objectForKey:@"val"]];
                    [AppDelegate appDelegate].currencyValue=[resultRespons objectForKey:@"val"];
                 }
             }];
            if ([delegate respondsToSelector:@selector(setDoUpdate:)])
            {
                [delegate setDoUpdate:NO];
            }
            //objAppDelegate.ChangeCurrency=YES;
            [AppDelegate appDelegate].currencySymbol = symbol;
            [AppDelegate appDelegate].CurrentCurrency = [listItems objectAtIndex:1];
            [AppDelegate appDelegate].selectedCurrentCurrency =  [NSString stringWithFormat:@"CURRENCY: %@",[listItems objectAtIndex:1]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if ([delegate respondsToSelector:@selector(setDoUpdate:)])
            {
                [delegate setDoUpdate:NO];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (IBAction)btnChangeCurrency:(id)sender
{
    [UIView beginAnimations:@"animationOff" context:NULL];
    [UIView setAnimationDuration:0.4f];
    //topMenuSliderView.hidden = NO;
    CGRect frame = [topMenuSliderView frame];
    frame.origin.y = -323;
    [topMenuSliderView setFrame:frame];
    CGRect frameTable = self.table_currency_size.frame;
    frameTable.origin.y = 53;
    self.table_currency_size.frame = frameTable;
    //menuView.hidden = YES;
    isVisibleTopView = NO;
    [UIView commitAnimations];
}

-(IBAction)actionGoToCMSPages:(id)sender
{
    
    CMSPageViewController *cMSPageViewController = [[CMSPageViewController alloc]initWithNibName:@"CMSPageViewController" bundle:nil];
    
    cMSPageViewController.strTitle = [[[[AppDelegate appDelegate].mArrayCMSPages objectAtIndex:[sender tag]]valueForKey:@"title"]uppercaseString];
    cMSPageViewController.strDescreption = [[[AppDelegate appDelegate].mArrayCMSPages objectAtIndex:[sender tag]]valueForKey:@"content"];
    [self.navigationController pushViewController:cMSPageViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
    if ([delegate respondsToSelector:@selector(setDoUpdate:)])
    {
        [delegate setDoUpdate:NO];
    }

    [self.navigationController popViewControllerAnimated:YES];
}
@end
