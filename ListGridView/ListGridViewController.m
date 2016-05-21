//
//  ListGridViewController.m
//  IShop
//
//  Created by Hashim on 5/1/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//http://cartrize.com/iosapi_cartrize.php?methodName=getProductsByCatId&cat_id=

#import "ListGridViewController.h"
#import "SWRevealViewController.h"
#import "ListGrid.h"
#import "AddCartViewController.h"
#import "RefineViewController.h"
#import "MySingletonClass.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailView.h"
#import "RCHBackboard.h"
#import "TopSliderViewController.h"
#import "RegistrationViewController.h"
#import "FavouriteViewController.h"
#import "Currency_Size_VC.h"
#import "UserProfileViewController.h"
#import "ASIFormDataRequest.h"
#import "UtilityServices.h"
#import "CartrizeWebservices.h"
#import "Constants.h"
#import "JSON.h"
#import "DashboardView.h"
#import "CustomCell.h"
#import "CMSPageViewController.h"
#import "LoginView.h"
#import "SVPullToRefresh.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#define kNotificationRefreshProductItem @"RefreshProductItem"
#define kNotificationAddFavoriteProduct @"AddFavoriteProduct"


@interface ListGridViewController ()<CurrencyDelegate,UIWebViewDelegate>
{
    NSTimer *timer;
}
@end

@implementation ListGridViewController
@synthesize myCollectionView,arrContaintList;
@synthesize dataArray,tooglBackBtn,tooglBackBtnBottom,pickerView,pickerToolbar,filterTxtField,categoryId,progressHud,bigGridBtn,smallGridBtn;
@synthesize btnSignIn, btnSignOut,arrayRecommended,isRefined,refinedArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        
//       // if([[AppDelegate appDelegate].arrAddToBag count]<=0)
//       // {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"getCheckOutHistory" object:nil];
//            
//        //}
////        else
////        {
////            [self getYourBagItem];
////            
////        }
//
//    });
//
   // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"";
    hud.color=[UIColor clearColor];
       // hud.dimBackground = YES;
    [AppDelegate appDelegate].dataArray = [NSMutableArray new];
    [[AppDelegate appDelegate].dataArray removeAllObjects];
    valueForPullRequest = 0;
    
     [self insertRowAtBottom];
    
 __weak typeof(self) weakSelf = self;
    // setup pull-to-refresh insertRowAtBottom
    [self.myCollectionView addInfiniteScrollingWithActionHandler:^{
        if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
            
            UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
            return;
            
        }
        
        if (isREFINED)
        {
            [weakSelf.myCollectionView.pullToRefreshView stopAnimating];
            [weakSelf.myCollectionView.infiniteScrollingView stopAnimating];
            return ;
        }else if (![AppDelegate appDelegate].isCheckSearchType)
        {
            
        }else
        {
            [weakSelf.myCollectionView.pullToRefreshView stopAnimating];
            [weakSelf.myCollectionView.infiniteScrollingView stopAnimating];
            return;
        }
        
        
        if (valueForPullRequest<0) {
            [weakSelf.myCollectionView.pullToRefreshView stopAnimating];
            [weakSelf.myCollectionView.infiniteScrollingView stopAnimating];
            return;
        }
            [weakSelf insertRowAtBottom];
    }];
    
    
    // Do any additional setup after loading the view from its nib.
    //collection view layOut
    isRecomonded = NO;
    isSearch = NO;
    isRefine=NO;
    if([[AppDelegate appDelegate].arrAddToBag count ]>0)
    {
        lblDownBagCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[AppDelegate appDelegate].arrAddToBag count ]];
    }
    else
    {
        lblDownBagCount.text=@"0";
        
    }
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]isEqualToString:@""])
    {
        NSLog(@"cartidwebservice");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            //[self FetchCartId];
           // [self CartIdWebService];
            
        });
               
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshProductItem:) name:kNotificationRefreshProductItem object:nil];
   
    
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [self.myCollectionView triggerPullToRefresh];
}

- (void)insertRowAtBottom {
    
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"Please wait...";
//    hud.dimBackground = YES;
    
     __weak typeof(self) weakSelf = self;
    int64_t delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        
         [weakSelf getProductsByCatIdWSAction:valueForPullRequest];
        
    });
    
}

-(void)CartIdWebService
{
  //  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  //  hud.labelText = @"Please wait...";
  //  hud.dimBackground = YES;
    NSDictionary *params=@{@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    [CartrizeWebservices PostMethodWithApiMethod:@"creditcartview" Withparms:params WithSuccess:^(id response) {
        
        NSDictionary *dict=[response JSONValue];
        
        //[[NSUserDefaults standardUserDefaults]setObject:cartid forKey:@"cid"];
        wv=[[UIWebView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height)];
        NSURL *urlPath;
        NSURLRequest *requestObj;
        wv.hidden=YES;
        wv.delegate=self;
        NSString *url=[dict valueForKey:@"check_url"];
        urlPath = [NSURL URLWithString:url];
        //requestObj = [NSMutableURLRequest requestWithURL:[urlPath absoluteURL]];
        requestObj = [NSMutableURLRequest requestWithURL:urlPath
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:20.0];
        
        [wv loadRequest:requestObj];
        [self.view addSubview:wv];
        
        // NSLog(@"cartid is%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"cid"]);
        
        
        
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish");
    
//    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]isEqualToString:@""])
//    {
//        NSLog(@"FetchCartId");
//       // [self FetchCartId];
//        
//    }
    if(isLogout==YES)
    {
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You have been successfully log out" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=6789;
        [alert show];
    //LoginView *login=[[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
    //[self.navigationController pushViewController:login animated:YES];
    }
    
 
    
}

-(void)FetchCartId
{
    NSDictionary *params=@{@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    [CartrizeWebservices PostMethodWithApiMethod:@"getcrtid" Withparms:params WithSuccess:^(id response) {
        
        NSDictionary *dict=[response JSONValue];
        NSLog(@"cartid is from webservice is%@",dict);
        if([dict valueForKey:@"cart_id"]==[NSNull null]) {
            
            NSLog(@"null");
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cart_id"];
            
        }
        else
        {
            NSLog(@"insert");
            
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"cart_id"] forKey:@"cart_id"];
            
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        }
       // [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
    
    
}

-(void)callWSForAllDetails{
    
    [CartrizeWebservices PostMethodWithApiMethod:@"GetAllPages" Withparms:nil WithSuccess:^(id response)
     {
         responseArr=[response JSONValue];
        
         [self.tableViewTopContent reloadData];
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

-(IBAction)actionDashboard:(id)sender
{
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"] isEqualToString:@""]){
        
        DashboardView *dash=[[DashboardView alloc] initWithNibName:@"DashboardView" bundle:nil];
        dash.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:dash animated:YES
                         completion:nil];
        //[self.navigationController pushViewController:dash animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign in to save" message:@"You'll need to sign in to view or add to your saved items. Don't worry, you only have to do it once." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Sign in",@"Cancel", nil];
        alert.tag = 102;
        [alert show];
        
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Refined"] isEqualToString:@"Yes"])
    {
        [refineBtn setImage:[UIImage imageNamed:@"RefineCheck.png"] forState:UIControlStateNormal];
    }
    else
    {
        [refineBtn setImage:[UIImage imageNamed:@"Refine.png"] forState:UIControlStateNormal];
    }
    
    btnCurrency.tag=1001;
    btnSize.tag=2001;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [btnCurrency setTitle:[NSString stringWithFormat:@"CURRENCY: %@",[AppDelegate appDelegate].CurrentCurrency] forState:UIControlStateNormal];
    ////NSLog(@"current symbolllll %@ %@",objAppDelegate.CurrentCurrency,objAppDelegate.currencySymbol);
    [self getYourBagItem];
    
    [self.myCollectionView registerClass:[ListGrid class] forCellWithReuseIdentifier:@"ListGrid"];
    [self.myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.myCollectionView.backgroundColor=[UIColor clearColor];
    [self.myCollectionView reloadData];
    [self.smallGridBtn setImage:[UIImage imageNamed:@"Item2.png"] forState:UIControlStateNormal];
    [self.smallGridBtn setImage:[UIImage imageNamed:@"Item2Hover.png"] forState:UIControlStateSelected];
    [self.bigGridBtn setImage:[UIImage imageNamed:@"Item1.png"] forState:UIControlStateNormal];
    [self.bigGridBtn setImage:[UIImage imageNamed:@"Item1Hover.png"] forState:UIControlStateSelected];
    isSelectedTypeGird = 1;
    
    //NSLog(@"SelecteGrid [AppDelegate appDelegate] = %d",[AppDelegate appDelegate].isSelecteGrid);
    
    if([AppDelegate appDelegate].isSelecteGrid == 1)
    {
        isSelectedTypeGird = 1;
        [self.bigGridBtn setSelected:YES];
        [self.smallGridBtn setSelected:NO];
        [self isSelected1];
    }
    else if([AppDelegate appDelegate].isSelecteGrid == 2)
    {
        isSelectedTypeGird = 2;
        [self.bigGridBtn setSelected:NO];
        [self.smallGridBtn setSelected:YES];
        [self isSelected2];
    }
    else if ([AppDelegate appDelegate].isSelecteGrid == 0)
    {
    }
    
    BOOL boolFromPrefs = [[NSUserDefaults standardUserDefaults] boolForKey:@"isListGrid"];
    
    if(boolFromPrefs == YES)
    {
        categoryId = [AppDelegate appDelegate].selectedCateId;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isListGrid"];
    }
    
    if ([AppDelegate appDelegate].ChangeCurrency == NO)
    {
        if (![AppDelegate appDelegate].isCheck)
        {
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Refined"] isEqualToString:@"Yes"])
            {
                isRecomonded = YES;
                //                [AppDelegate appDelegate].dataArray=self.refinedArray;
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[AppDelegate appDelegate].arrBackUp];
                if(arr.count!=0)
                {
                    [AppDelegate appDelegate].dataArray=arr;
                    [myCollectionView reloadData];
                }
                else
                {
                    if (self.doUpdate)
                    {
                        isREFINED = NO;
                        [self getTheProductByCategoryFromWebService];
                    }
                }
            }
            else
            {
                if (self.doUpdate)
                {
                    [self getTheProductByCategoryFromWebService];
                }
            }
        }
    }
    else
    {
        [AppDelegate appDelegate].ChangeCurrency = NO;
    }
    //code for reveal view
    // revealController = [self revealViewController];
    //  [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    self.navigationController.navigationBarHidden = YES;
    
    [self.tooglBackBtn setImage:[UIImage imageNamed:@"reveal-icon.png"] forState:UIControlStateNormal];
    
    [self.tooglBackBtn addTarget:self action:@selector(getLeftSlideData:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tooglBackBtnBottom addTarget:self action:@selector(getLeftSlideData:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([AppDelegate appDelegate].isSelecteGrid == 0)
    {
        //set images on grid button by outlets
        [self.bigGridBtn setSelected:YES];
        [self.smallGridBtn setSelected:NO];
        
        if (![AppDelegate appDelegate].isCheck)
        {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            [flowLayout setItemSize:CGSizeMake(300, 300)];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            [self.myCollectionView setCollectionViewLayout:flowLayout];
        }
    }
    
    //topMenuSliderView.hidden = YES;
    CGRect frame = [topMenuSliderView frame];
    frame.origin.y = -323;
    frame.size.width = 320;
    frame.size.height = 378;
    [topMenuSliderView setFrame:frame];
    CGRect frameCollectionView = self.myCollectionView.frame;
    frameCollectionView.origin.y = 111;
    self.myCollectionView.frame = frameCollectionView;
    self.myCollectionView.userInteractionEnabled = YES;
    
    isVisibleTopView = NO;
    _viewGridButtons.hidden = NO;
    
    // menuView.hidden = YES;
    
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"] isEqualToString:@""]) {
        
        //NSLog(@"%@==%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"isRemember"],[[NSUserDefaults standardUserDefaults] objectForKey:@"firstname"]);
        
        
        lblWelcomeuser.text = [NSString stringWithFormat:@"Hi %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"firstname"]];
        self.btnSignIn.hidden = YES;
        self.btnSignOut.hidden = NO;
        self.btnJoin.hidden = YES;
        self.btnMyAccount.hidden = NO;
    }
    else
    {
        lblWelcomeuser.text = @"";
        self.btnSignIn.hidden = NO;
        self.btnSignOut.hidden = YES;
        self.btnJoin.hidden = NO;
        self.btnMyAccount.hidden = YES;
    }
    if ([AppDelegate appDelegate].isCheck)
    {
        //[self.progressHud hide:YES];
        [self.myCollectionView reloadData];
    }
    
    // arrContaintList = [[NSMutableArray alloc]init];
    arrContaintList = [[[NSUserDefaults standardUserDefaults]objectForKey:@"searchProductsList"] mutableCopy];
    [_tableViewTopContent reloadData];
}

- (void) getLeftSlideData:(id)sender
{
    [UIView beginAnimations:@"animationOff" context:NULL];
    [UIView setAnimationDuration:0.2f];
    //topMenuSliderView.hidden = YES;
    CGRect frame = [topMenuSliderView frame];
    frame.origin.y = -323;
    frame.size.width = 320;
    frame.size.height = 378;
    [topMenuSliderView setFrame:frame];
    CGRect frameCollectionView = self.myCollectionView.frame;
    frameCollectionView.origin.y = 111;
    self.myCollectionView.frame = frameCollectionView;
    self.myCollectionView.userInteractionEnabled = YES;
    
    isVisibleTopView = NO;
    
    [UIView commitAnimations];
    // revealController = [self revealViewController];
    //  [revealController revealToggle:sender];
    
}

-(void)refreshProductItem:(NSNotification *)notification
{
    [self getYourBagItem];
}

-(void)addFavoriteProduct:(NSNotification *)notification
{
    [self getTheProductByCategoryFromWebService];
    [self.myCollectionView reloadData];
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void) getYourBagItem
{
    //    int totalItem = 0;
    //    for(NSMutableDictionary *mDict in [AppDelegate appDelegate].arrAddToBag)
    //    {
    //        totalItem = totalItem + [[mDict valueForKey:@"prd_qty"]intValue];
    //    }
    
    //    lblDownBagCount.text = [NSString stringWithFormat:@"%d",totalItem];
    //    lblBagCount.text = [NSString stringWithFormat:@"%d",totalItem];
    
    lblDownBagCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[AppDelegate appDelegate].arrAddToBag.count];
    
    
    lblBagCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[AppDelegate appDelegate].arrAddToBag.count];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [[AppDelegate appDelegate].dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Refined"]isEqualToString:@"Yes"])
    {
        lblRecommended.text=@"What's New";
        [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"Refined"];
        
    
    }
    
    static NSString *cellIdentifier = @"ListGrid";
    
    ListGrid *cell = (ListGrid *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Refined"] isEqualToString:@"Yes"])
    {
        //[cell.img setImageWithURL:[NSURL URLWithString:[[[AppDelegate appDelegate].dataArray valueForKey:@"prd_thumb"]objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:CRplacehoderimage]];
        
        [cell.img sd_setImageWithURL:[NSURL URLWithString:[[[AppDelegate appDelegate].dataArray valueForKey:@"prd_thumb"]objectAtIndex:indexPath.row]]
                          placeholderImage:[UIImage imageNamed:CRplacehoderimage]];
        
    }
    else
    {
        
        [cell.img sd_setImageWithURL:[NSURL URLWithString:[[[AppDelegate appDelegate].dataArray valueForKey:@"prd_thumb"]objectAtIndex:indexPath.row]]
                    placeholderImage:[UIImage imageNamed:CRplacehoderimage]];
        
    }
    
    if (isSelectedTypeGird == 1)
    {
        cell.img.contentMode = UIViewContentModeScaleAspectFit;
    }
    else
    {
        cell.img.contentMode = UIViewContentModeScaleToFill;
        // cell.img.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    imgProduct = cell.img;
    cell.titlelalbe.text = [[[AppDelegate appDelegate].dataArray valueForKey:@"prd_name"]objectAtIndex:indexPath.row];
    cell.priceLbl.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,[[[[AppDelegate appDelegate].dataArray valueForKey:@"prd_price"]objectAtIndex:indexPath.row] floatValue]];
    
    //new dev
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isRemember"] isEqualToString:@"YES"])
    {
        
        NSString *customer_id  = [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"];
        
        NSString *strPro  =[NSString stringWithFormat:@"%@", [[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] valueForKey:@"customer_ids"]] ;
        
        if([strPro isEqualToString:@"<null>"] || [strPro isEqualToString:@""])
        {
            [cell.btnFavourite setImage:[UIImage imageNamed:@"unselected_star.png"] forState:UIControlStateNormal];
        }
        else
        {
            NSMutableArray *mArraycustomer_id = [[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] valueForKey:@"customer_ids"];
            
            if ([mArraycustomer_id containsObject:customer_id])
            {
                [cell.btnFavourite setImage:[UIImage imageNamed:@"selected_star.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.btnFavourite setImage:[UIImage imageNamed:@"unselected_star.png"] forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        [cell.btnFavourite setImage:[UIImage imageNamed:@"unselected_star.png"] forState:UIControlStateNormal];
    }
    
    //end new dev
    
    if ([[[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] valueForKey:@"QTY"] intValue] <= 0)
    {  cell.lblimgDiscount.transform = CGAffineTransformMakeRotation(-M_PI/4);
        cell.layer.masksToBounds=YES;
        cell.lblimgDiscount.hidden=NO;
    }
    if ([[[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] valueForKey:@"pro_stock"] intValue] <= 0)
    {  cell.lblimgDiscount.transform = CGAffineTransformMakeRotation(-M_PI/4);
        cell.layer.masksToBounds=YES;
        cell.lblimgDiscount.hidden=NO;
    }
    else
    {
        cell.lblimgDiscount.hidden=YES;
        
    }
    
    
    cell.btnFavourite.tag = indexPath.row;
    [cell.btnFavourite addTarget:self action:@selector(btnFavouriteAction:) forControlEvents:UIControlEventTouchUpInside];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (cell.frame.size.width == 146)
            {
                [cell.titlelalbe setFont:[UIFont systemFontOfSize:15.0]];
                [cell.priceLbl setFont:[UIFont systemFontOfSize:12.0]];
                
                cell.titlelalbe.frame = CGRectMake(2, 192, 140-15, 20);
                cell.priceLbl.frame = CGRectMake(2, 212, 100, 20);
                //NSLog(@"%f  %f",cell.btnFavourite.frame.origin.x, cell.btnFavourite.frame.origin.y+5);
                cell.btnFavourite.frame = CGRectMake(120, 203, 20, 20);
                
            }
        });
    
    return cell;
}


-(void)CallWebserviceIntoBackground
{
    
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
        
    }

    NSLog(@"array at particular index %@",[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row]);
    
    //    -(void)WebserviceForWebview
    //    {
    //        NSDictionary *dict =@{@"producturl":[NSString stringWithFormat:@"%@",[mutDictProductDetail valueForKey:@"product_url"]]};
    //
    //        [CartrizeWebservices PostMethodWithApiMethod:@"getproductdetailurl" Withparms:dict WithSuccess:^(id response) {
    //
    //            NSLog(@"%@",response);
    //            [self LoadWebviewOnView:[NSString stringWithFormat:@"%@?purl=ada",[mutDictProductDetail valueForKey:@"product_url"]]];
    //
    //        } failure:^(NSError *error) {
    //
    //            NSLog(@"%@",error.localizedDescription);
    //        }];
    //
    //    }
    ProductDetailView *objProductDetailView;
    if (IS_IPHONE5)
    {
        objProductDetailView = [[ProductDetailView alloc] initWithNibName:@"ProductDetailView" bundle:nil];
    }
    else
    {
        objProductDetailView = [[ProductDetailView alloc] initWithNibName:@"ProductDetailView_iphone3.5" bundle:nil];
    }
    
    objProductDetailView.strSelectValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    objProductDetailView.mutDictProductDetail = [[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] mutableCopy];
    objProductDetailView.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    //[self presentViewController:objProductDetailView animated:YES completion:nil];
    [self.navigationController pushViewController:objProductDetailView animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([AppDelegate appDelegate].isSelecteGrid == 1)
    {
        return CGSizeMake(300, 300);
    }
    else
    {
        return CGSizeMake(146, 232);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if([AppDelegate appDelegate].isSelecteGrid == 1)
    {
        return UIEdgeInsetsMake(0, 10, 0, 10); // top, left, bottom, right
    }
    else
    {
        return UIEdgeInsetsMake(0, 9, 0, 9); // top, left, bottom, right
    }
}

#pragma mark - Call web serivecs fot searching and refined

-(void)getTheProductByCategoryFromWebService
{
    
   
    
    if (isREFINED)
    {//isRefine
        [self filterByRecomondedAndPrice];
    }else if (![AppDelegate appDelegate].isCheckSearchType)
    {
        if(isRecomonded)
         {
           [self filterByRecomondedAndPrice];
          }
     //   [self getProductsByCatIdWSAction];
        
//        if ([[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@",self.categoryId]]  != nil) {
//            
//            [AppDelegate appDelegate].dataArray = [NSMutableArray new];
//            [[AppDelegate appDelegate].dataArray removeAllObjects];
//            [AppDelegate appDelegate].dataArray = [[[NSUserDefaults standardUserDefaults] valueForKey:self.categoryId] mutableCopy];
//            
//            if(isRecomonded)
//            {
//                [self filterByRecomondedAndPrice];
//            }
//            
//            [self RefreshCurrencydelegatemethod:[AppDelegate appDelegate].currencySymbol withvalue:[AppDelegate appDelegate].currencyValue];
//            
//            if ([[AppDelegate appDelegate].dataArray count] != 0)
//            {
//                //[self.myCollectionView reloadData];
//            }
//            else
//            {
//                //  [self.myCollectionView reloadData];
//                
//                [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
//                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No product found for this category!!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//            
//
//
//        }
//        else
//        {
//             [self performSelector:@selector(getProductsByCatIdWSAction) withObject:nil afterDelay:0.1];
//        }
       
    }else
    {
        [self getSearchByNameWSAction];
    }
}


-(void)getProductsByCatIdWSAction:(NSInteger)PullRequest
{
    
    NSString *jsonString;
//    [AppDelegate appDelegate].dataArray = [NSMutableArray new];
//    [[AppDelegate appDelegate].dataArray removeAllObjects];
   // [self.myCollectionView reloadData];
    
    jsonString = [NSString stringWithFormat:@"http://cartrize.com/iosapi_cartrize.php?methodName=getProductsByCatId&cat_id=%@&pagination=%ld",self.categoryId,(long)PullRequest];
    
    NSString* encodedUrl = [jsonString stringByAddingPercentEscapesUsingEncoding:
                            NSASCIIStringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:120.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError)
     {
         // handle response
         
         [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];

         if (data==nil) {
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             return ;
             
         }
         NSMutableDictionary *mDictResponceData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         if (mDictResponceData!=nil) {
             
             NSMutableArray *mArryResponceData = [mDictResponceData valueForKey:@"data"];
             NSInteger PagCount = [[mDictResponceData valueForKey:@"paginationvalue"] integerValue];
 
             if (mArryResponceData && [mArryResponceData isKindOfClass:[NSMutableArray class]]) {
                 
                 for (NSDictionary *mediaDictionaryValue in mArryResponceData) {
                     
                     if (![[AppDelegate appDelegate].dataArray containsObject:mediaDictionaryValue]) {
                         [[AppDelegate appDelegate].dataArray addObject:mediaDictionaryValue];
                     }
                 }
                 if (mArryResponceData.count<PagCount) {
                     valueForPullRequest = -1;
                 }
                 else
                 {
                     valueForPullRequest = PullRequest+PagCount;
                 }
                 
             }
             
         }
         
//
//         if (mArryResponceData!=nil) {
//             
//             for (NSDictionary *mediaDictionaryValue in mArryResponceData) {
//                 
//                 if (![[AppDelegate appDelegate].dataArray containsObject:mediaDictionaryValue]) {
//                     [[AppDelegate appDelegate].dataArray addObject:mediaDictionaryValue];
//                 }
//             }
//             if (mArryResponceData.count<3) {
//                 valueForPullRequest = -1;
//             }
//             else
//             {
//                 valueForPullRequest = PullRequest+3;
//             }
//
//         }
         [self.myCollectionView.pullToRefreshView stopAnimating];
         [self.myCollectionView.infiniteScrollingView stopAnimating];
         NSLog(@"this is data --- %@",[AppDelegate appDelegate].dataArray);
         //[hud hide:YES];
         if(isRecomonded)
         {
             [self filterByRecomondedAndPrice];
         }
         //Yogendra Girase Check Method
         [self RefreshCurrencydelegatemethod:[AppDelegate appDelegate].currencySymbol withvalue:[AppDelegate appDelegate].currencyValue];
      //   [[NSUserDefaults standardUserDefaults]
     //     setObject: [AppDelegate appDelegate].dataArray forKey:[NSString stringWithFormat:@"%@",self.categoryId]];
         [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
//         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//             [[NSNotificationCenter defaultCenter]postNotificationName:@"getCheckOutHistory" object:nil];
//         });
         if ([[AppDelegate appDelegate].dataArray count] != 0)
         {
            
             [self.myCollectionView reloadData];
         }
         else
         {
             //  [self.myCollectionView reloadData];
             
             [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No product found for this category!!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
         }
         
         
     }];
    
}


-(void)getSearchByNameWSAction
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    hud.color= [UIColor clearColor];
   // hud.dimBackground = YES;
    [AppDelegate appDelegate].dataArray = [NSMutableArray new];
    [[AppDelegate appDelegate].dataArray removeAllObjects];
    [self.myCollectionView reloadData];
    NSString *jsonString;
    //        jsonString = [NSString stringWithFormat:@"http://192.168.88.139/cartrizenew/iosapi_cartrize.php?methodName=getSearchByName&name=%@&long_description=&short_description=&sku=&",[AppDelegate appDelegate].strSearchName];
    
    jsonString = [NSString stringWithFormat:@"http://cartrize.com/iosapi_cartrize.php?methodName=getSearchByName&name=%@&long_description=&short_description=&sku=&",[AppDelegate appDelegate].strSearchName];
    
    NSString* encodedUrl = [jsonString stringByAddingPercentEscapesUsingEncoding:
                            NSASCIIStringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError)
     {
         // handle response
         
         [hud hide:YES];
         if (data==nil) {
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             return ;
             
         }
         
         [AppDelegate appDelegate].dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         //  //NSLog(@"this is data --- %@",objAppDelegate.dataArray);
         [hud hide:YES];
         
         if(isRecomonded)
         {
             [self filterByRecomondedAndPrice];
         }
         
         [self RefreshCurrencydelegatemethod:[AppDelegate appDelegate].currencySymbol withvalue:[AppDelegate appDelegate].currencyValue];
         
         if ([[AppDelegate appDelegate].dataArray count] != 0)
         {
             // [self.myCollectionView reloadData];
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No product found for this category!!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
         }
     }];
    
}

#pragma mark - Webservice Methods

//This method not use now hupendra

-(void)getTheProductByCategoryFromWebService1
{
    //   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    
    NSString *jsonString;
    
    if (![AppDelegate appDelegate].isCheckSearchType)
    {
      
        jsonString = [NSString stringWithFormat:@"http://cartrize.com/iosapi_cartrize.php?methodName=getProductsByCatId&cat_id=%@",self.categoryId];
        
    }
    else
    {
        //        jsonString = [NSString stringWithFormat:@"http://192.168.88.139/cartrizenew/iosapi_cartrize.php?methodName=getSearchByName&name=%@&long_description=&short_description=&sku=&",[AppDelegate appDelegate].strSearchName];
        jsonString = [NSString stringWithFormat:@"http://cartrize.com/iosapi_cartrize.php?methodName=getSearchByName&name=%@&long_description=&short_description=&sku=&",[AppDelegate appDelegate].strSearchName];
        
        
        // [AppDelegate appDelegate].isCheckSearchType=nil;
    }
    
    NSString* encodedUrl = [jsonString stringByAddingPercentEscapesUsingEncoding:
                            NSASCIIStringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError)
     {
         
           [hud hide:YES];
         if (data==nil) {
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             return ;
             
         }
         // handle response
         [AppDelegate appDelegate].dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         //  //NSLog(@"this is data --- %@",objAppDelegate.dataArray);
       
         
         if(isRecomonded)
         {
             [self filterByRecomondedAndPrice];
         }
         
         [self RefreshCurrencydelegatemethod:[AppDelegate appDelegate].currencySymbol withvalue:[AppDelegate appDelegate].currencyValue];
         
         if ([[AppDelegate appDelegate].dataArray count] != 0)
         {
             // [self.myCollectionView reloadData];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No product found for this category!!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
         }
     }];
}


-(void)Logout
{
    wv=[[UIWebView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height)];
    NSURL *urlPath;
    NSURLRequest *requestObj;
    wv.hidden=YES;
    wv.delegate=self;
    NSString *url=@"https://cartrize.com/index.php/customer/account/logout/";
    urlPath = [NSURL URLWithString:url];
    //requestObj = [NSMutableURLRequest requestWithURL:[urlPath absoluteURL]];
    requestObj = [NSMutableURLRequest requestWithURL:urlPath
                                         cachePolicy:NSURLRequestReloadIgnoringCacheData
                                     timeoutInterval:20.0];
    
    [wv loadRequest:requestObj];
    [self.view addSubview:wv];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //getCartId
    [CartrizeWebservices GetMethodWithApiMethod:@"userLogout" WithSuccess:^(id response)
     {
         NSDictionary *lgresponse=[response JSONValue];
         
         
         if([[lgresponse valueForKey:@"result"]isEqualToString:@"success"])
         {
                          isLogout=YES;
             
             FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
             [loginManager logOut];
             [FBSDKAccessToken setCurrentAccessToken:nil];
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"customer_id"];
             [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"subtotal"];
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cart_id"];
             [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"email"];
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"firstname"];
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"lastname"];
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"fbuserid"];
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"IsUserLogin"];
             [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
             lblBagCount.text=@"0";
             lblDownBagCount.text=@"0";
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         }
         else
         {
             UIAlertView *Lgalert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Unable to logout please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Lgalert show];
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         }
         
        
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error = %@",[error description]);
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];     }];
}
#pragma mark - UIAlertView Deleagte method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == 101 || alertView.tag == 102)
    {
        if (buttonIndex == 0)
        {
            [self Logout];
           
        }
    }
    else if(alertView.tag==6789)
    {
        
        GridViewController *listGridViewController =[[GridViewController alloc]initWithNibName:@"GridViewController" bundle:nil];
        [self.navigationController pushViewController:listGridViewController animated:YES];
        
    }
    else if (alertView.tag==1012)
    {
        
        if(buttonIndex==1)
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
            objRegistrationViewController.strCheckViewControler = @"ListGrid";
            [self.navigationController pushViewController:objRegistrationViewController animated:YES];
        }
        else if(buttonIndex==0)
        {
            LoginView *objLoginView;
            objLoginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
            objLoginView.strCheckViewControler = @"ListGrid";
            [self.navigationController pushViewController:objLoginView animated:YES];
            
            
        }
        else
        {
            [alertView dismissWithClickedButtonIndex:2 animated:YES];
        
        }
        
    }
    else
    {
        if(buttonIndex == 1)
        {
            //NSLog(@"%@",self.navigationController.viewControllers);
            
            [AppDelegate appDelegate].isUserLogin = NO;
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isRemember"];
            [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
            [self getYourBagItem];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"customer_id"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"firstname"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"lastname"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"email"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"RememberEmail"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"subtotal"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cart_id"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.btnSignIn.hidden = NO;
            self.btnSignOut.hidden = YES;
            self.btnJoin.hidden = NO;
            self.btnMyAccount.hidden = YES;
            lblWelcomeuser.text = @"Welcome to CartRize";
            
            
            
            
            //            [AppDelegate appDelegate].isUserLogin = NO;
            //            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isRemember"];
            //
            //            [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
            //            //[objAppDelegate.arrFavourite removeAllObjects];
            //
            //            [self getYourBagItem];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"customer_id"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"firstname"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"lastname"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"email"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"RememberEmail"];
            //
            //            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[LoginView class]])
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
            else
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }
            
            if (buttonIndex==0)
            {
                NSLog(@"MANOJ");
            }
        }
    }
}

-(IBAction)btnActionMyAccount:(id)sender
{
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"] isEqualToString:@""]){
        
        NSString *strXib = @"DashboardView_iPhone3.5";
        if(IS_IPHONE5)
        {
            strXib =@"DashboardView";
        }
        DashboardView *dash=[[DashboardView alloc] initWithNibName:strXib bundle:nil];
        dash.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:dash animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign in to save" message:@"You'll need to sign in to view or add to your saved items. Don't worry, you only have to do it once." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Sign in",@"Cancel", nil];
        alert.tag = 102;
        [alert show];
    }
    
    /*
     UserProfileViewController *objUserProfileViewController;
     if (IS_IPHONE5)
     {
     objUserProfileViewController = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
     }
     else
     {
     objUserProfileViewController = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController_iphone3.5" bundle:nil];
     }
     [self.navigationController pushViewController:objUserProfileViewController animated:YES];
     */
}


#pragma mark - CUSTOM method

- (void) signIn
{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"customer_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    LoginView *gridObj=[[LoginView alloc] init];
    [self.navigationController pushViewController:gridObj animated:YES];
}

- (void)ChangeGridIntoSmall
{
    
}

#pragma mark - UIBUtton ACTION method

- (IBAction)topNavigationSliderAction:(id)sender
{
    if (isVisibleTopView)
    {
        [UIView beginAnimations:@"animationOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        //topMenuSliderView.hidden = NO;
        CGRect frame = [topMenuSliderView frame];
        frame.origin.y = -323;
        [topMenuSliderView setFrame:frame];
        
        _viewGridButtons.hidden = NO;
        CGRect frameCollectionView = self.myCollectionView.frame;
        frameCollectionView.origin.y = 111;
        self.myCollectionView.frame = frameCollectionView;
        self.myCollectionView.userInteractionEnabled = YES;
        //menuView.hidden = YES;
        isVisibleTopView = NO;
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:@"animationOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        //topMenuSliderView.hidden = NO;
        CGRect frame = [topMenuSliderView frame];
        frame.origin.y = 0;
        frame.size.width = 320;//Some value
        frame.size.height = 378;//some value
        [topMenuSliderView setFrame:frame];
        _viewGridButtons.hidden = YES;
        
        CGRect frameCollectionView = self.myCollectionView.frame;
        frameCollectionView.origin.y = 378;
        self.myCollectionView.frame = frameCollectionView;
        self.myCollectionView.userInteractionEnabled = NO;
        isVisibleTopView = YES;
        [self.view  bringSubviewToFront:topMenuSliderView];
        [UIView commitAnimations];
        //menuView.hidden = NO;
    }
}

- (IBAction) btnJoinAction:(id)sender
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

- (IBAction) btnSignInAction:(id)sender
{
    [UIView beginAnimations:@"animationOff" context:NULL];
    [UIView setAnimationDuration:0.2f];
    //topMenuSliderView.hidden = NO;
    CGRect frame = [topMenuSliderView frame];
    frame.origin.y = -323;
    frame.size.width = 320;
    frame.size.height = 378;
    [topMenuSliderView setFrame:frame];
    CGRect frameCollectionView = self.myCollectionView.frame;
    frameCollectionView.origin.y = 111;
    self.myCollectionView.frame = frameCollectionView;
    isVisibleTopView = NO;
    self.myCollectionView.userInteractionEnabled = YES;
    
    [UIView commitAnimations];
    [self performSelector:@selector(signIn) withObject:nil afterDelay:0.5];
}

- (IBAction)btnSignOutAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Do you want to Sign Out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.tag=101;
    [alert show];
}

- (IBAction) button1press:(id)sender
{
    isSelectedTypeGird = 2;
    [AppDelegate appDelegate].isSelecteGrid = 2;
    [self isSelected2];
}

-(void) isSelected2
{
    [self.smallGridBtn setSelected:YES];
    [self.bigGridBtn setSelected:NO];
    [self.myCollectionView reloadData];
     [self performSelector:@selector(reloadCollection) withObject:nil afterDelay:0.1];

//    int cont = [AppDelegate appDelegate].dataArray.count-1;
//    NSIndexPath *myIP = [NSIndexPath indexPathForRow:cont inSection:0] ;
//    [self.myCollectionView scrollToItemAtIndexPath:myIP atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

    
}
-(void)reloadCollection
{
    [self.myCollectionView reloadData];
}

- (IBAction)button2Press:(id)sender
{
    isSelectedTypeGird = 1;
    [AppDelegate appDelegate].isSelecteGrid = 1;
    [self isSelected1];
}

-(void) isSelected1
{
    isSelectedTypeGird = 1;
    [self.smallGridBtn setSelected:NO];
    [self.bigGridBtn setSelected:YES];
     [self.myCollectionView reloadData];
    
    [self performSelector:@selector(reloadCollection) withObject:nil afterDelay:0.1];
}


- (IBAction)SeacrhButtonPress:(id)sender
{
    isSearch = YES;
    [AppDelegate appDelegate].isCheckSearchType = YES;
    searchView = (SearchView *)[[[NSBundle mainBundle]loadNibNamed:@"SearchView" owner:self options:nil]objectAtIndex:0 ];
    [searchView.btnHideView addTarget:self action:@selector(hideSearchView:) forControlEvents:UIControlEventTouchUpInside];
    searchView.txtSearch.delegate = self;
    
    
    [searchView.tableViewSearchResult setBackgroundColor:[UIColor clearColor]];
    searchView.tableViewSearchResult.delegate = self;
    searchView.tableViewSearchResult.dataSource = self;
    
    // [searchView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:searchView];
    [searchView.tableViewSearchResult reloadData];
}

-(IBAction)hideSearchView:(id)sender
{
    if (  [AppDelegate appDelegate].isCheckSearchType == NO)
        [self getTheProductByCategoryFromWebService];
    
    isSearch = NO;
    [searchView removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
        return NO;
        
    }
    if([textField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter a search keyword" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       @autoreleasepool
                       {
                           [AppDelegate appDelegate].isCheckSearchType = YES;
                           [AppDelegate appDelegate].strSearchName = textField.text;
                           
                           if(arrContaintList == nil)
                           {
                               arrContaintList = [[NSMutableArray alloc]init];
                           }
                           
                           
                           NSString *strSearch=[NSString stringWithFormat:@"%@",textField.text];
                           
                           
                           if (![arrContaintList containsObject:strSearch])
                           {
                               [arrContaintList addObject:strSearch];
                           }
                           [[NSUserDefaults standardUserDefaults]setObject:arrContaintList forKey:@"searchProductsList"];
                           [[NSUserDefaults standardUserDefaults]synchronize];
                           [self getTheProductByCategoryFromWebService];
                       }
                   });
    
    [textField resignFirstResponder];
    [self performSelector:@selector(hideSearchView:) withObject:nil];
    
    return YES;
}

#pragma mark - UITableView DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isSearch)
    {
        if([arrContaintList count]==0){
            return 0;
        }
        return 44;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSearch)
    {
        return 44;
    }
    else
    {
        return 32;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(isSearch)
    {
        if([arrContaintList count] > 0)
        {
            UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            viewHeader.backgroundColor = [UIColor clearColor];
            
            UILabel *lblHeaderTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 222, 21)];
            lblHeaderTitle.text = @"YOUR RECENT SEARCHES:";
            lblHeaderTitle.font = [UIFont systemFontOfSize:11];
            lblHeaderTitle.textColor = [UIColor blackColor];
            [viewHeader addSubview:lblHeaderTitle];
            
            UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
            btnClear.frame = CGRectMake(235, 5, 60, 23);
            
            [btnClear setTitle:@"Clear" forState:UIControlStateNormal];
            
            [btnClear setBackgroundColor:[UIColor colorWithRed:166.0/255.0 green:187.0/255.0 blue:94.0/255.0 alpha:1.0]];
            //  [btnClear setImage:[UIImage imageNamed:@"clear_r"] forState:UIControlStateNormal];
            [btnClear addTarget:self action:@selector(actionClearSearchList:) forControlEvents:UIControlEventTouchUpInside];
            [viewHeader addSubview:btnClear];
            return viewHeader;
        }
        return nil;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearch)
    {
        return [arrContaintList count];
    }
    else
    {
        return responseArr.count;
    }
    return 1 + [[AppDelegate appDelegate].mArrayCMSPages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSearch)
    {
        static NSString *CellIdentifier = nil;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor clearColor];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
        }
        cell.textLabel.text = [arrContaintList objectAtIndex:indexPath.row] ;
        // cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        //   cell.backgroundColor=[UIColor clearColor];
        
        
        UIImageView *imgDescloser=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        [imgDescloser setImage:[UIImage imageNamed:@"shipping_arrow1.png"]];
        //[imgDescloser setBackgroundColor:[UIColor redColor]];
        
        UILabel *lblLine=[[UILabel alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
        lblLine.text=@"";
        [lblLine setBackgroundColor:[UIColor lightGrayColor]];
        
        [cell  addSubview:lblLine];
        cell.accessoryView=imgDescloser;
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
        //        if(indexPath.row == 0)
        //        {
        ////            cell.lblPrdAttibuteTitle.text = [[NSString stringWithFormat:@"CURRENCY: %@",[AppDelegate appDelegate].CurrentCurrency] uppercaseString];
        //
        //
        //            [cell.btnCell addTarget:self action:@selector(btnChangeCurrency:) forControlEvents:UIControlEventTouchUpInside];
        //        }
        //        else
        //        {
        //            cell.lblPrdAttibuteTitle.text = [[[[AppDelegate appDelegate].mArrayCMSPages objectAtIndex:indexPath.row - 1]valueForKey:@"title"]uppercaseString];
        
        
        
        //////////********************/////////////
        cell.lblPrdAttibuteTitle.text = [[responseArr objectAtIndex:indexPath.row] valueForKey:@"title"];
        
        
        cell.btnCell.tag = indexPath.row;
        
        [cell.btnCell addTarget:self action:@selector(actionGoToCMSPages:) forControlEvents:UIControlEventTouchUpInside];
        //        }
        
        
        return cell;
    }
}

#pragma mark - UITableView Delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Array at particular index %@",responseArr);
    
    if(isSearch)
    {
        if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
            
            UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
            return;
            
        }
        [AppDelegate appDelegate].strSearchName = [arrContaintList objectAtIndex:indexPath.row];
        [AppDelegate appDelegate].isCheckSearchType = YES;
        
        [self getTheProductByCategoryFromWebService];
        [self performSelector:@selector(hideSearchView:) withObject:nil];
    }
}

-(IBAction)actionGoToCMSPages:(id)sender
{
    
    CMSPageViewController *cMSPageViewController = [[CMSPageViewController alloc]initWithNibName:@"CMSPageViewController" bundle:nil];
    
    cMSPageViewController.strTitle = [[[responseArr objectAtIndex:[sender tag]]valueForKey:@"title"]uppercaseString];
    
    cMSPageViewController.strDescreption = [[responseArr objectAtIndex:[sender tag]]valueForKey:@"content"];
    
    [self.navigationController pushViewController:cMSPageViewController animated:YES];
}

-(IBAction)actionClearSearchList:(id)sender
{
    [AppDelegate appDelegate].isCheckSearchType = NO;
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"searchProductsList"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    arrContaintList = [[NSMutableArray alloc]init];
    [searchView.tableViewSearchResult reloadData];
}

- (IBAction) btnAddToBagAction:(id)sender
{
    
    
   if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"IsUserLogin"] boolValue]) {
        
        AddCartViewController *addCart = [[AddCartViewController alloc]initWithNibName:@"AddCartViewController" bundle:nil];
        [self.navigationController pushViewController:addCart animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please sign in" message:@"To add item to your bag and make purchases, please sign in or join now" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Sign In",@"Join",@"Cancel", nil];
        alert.tag = 1012;
        [alert show];
    }
}

- (IBAction)ShowPicker:(id)sender
{
    [self OpenThePickerView];
}

- (IBAction)refineButtonPress:(id)sender
{
    RefineViewController *refine = [[RefineViewController alloc]initWithNibName:@"RefineViewController" bundle:nil];
    refine.delegate=self;
    refine.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:refine animated:YES completion:nil];
}

- (IBAction)btnCancelToolbarAction:(id)sender
{
    self.pickerView.hidden = YES;
    self.pickerToolbar.hidden = YES;
    myCollectionView.userInteractionEnabled = YES;
}

- (IBAction)btnDoneToolbarAction:(id)sender
{
    lblRecommended.text = strRecomonded;
    self.pickerView.hidden = YES;
    self.pickerToolbar.hidden = YES;
    myCollectionView.userInteractionEnabled = YES;
     isRecomonded = YES;
    if(isREFINED){
        
//               if ([strRecomonded isEqualToString:@"What's New"]) {
//                   lblRecommended.text = strRecomonded;
//               }
                //            [[AppDelegate appDelegate].dataArray removeAllObjects];
        //            [AppDelegate appDelegate].dataArray=[AppDelegate appDelegate].arrBackUp;
        //            [myCollectionView reloadData];
        //        }
        //        else {
        [self filterByRecomondedAndPrice];
        //        }
    }
    
    else{
        
        
        [self getTheProductByCategoryFromWebService];
    }
   
}

-(void)filterByRecomondedAndPrice
{
    
    NSSortDescriptor *sortDescriptor;
    
    switch (selectRow)
    {
        case 0:
        {
            sortDescriptor = [[NSSortDescriptor alloc]
                              initWithKey:@"product_update_date" ascending:NO];
            if (isREFINED) {
                
                lblRecommended.text=@"What's New";
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[AppDelegate appDelegate].arrBackUp];
                [AppDelegate appDelegate].dataArray=arr;
            }
            
        }
            break;
        case 1:
        {
            [AppDelegate appDelegate].dataArray = [self setValuesToNumber:[AppDelegate appDelegate].dataArray];
            sortDescriptor = [[NSSortDescriptor alloc]
                              initWithKey:@"prd_price" ascending:YES];
            NSArray *sortDescriptors = @[sortDescriptor];
            [[AppDelegate appDelegate].dataArray sortUsingDescriptors:sortDescriptors];
        }
            break;
        case 2:
        {
            [AppDelegate appDelegate].dataArray = [self setValuesToNumber:[AppDelegate appDelegate].dataArray];
            sortDescriptor = [[NSSortDescriptor alloc]
                              initWithKey:@"prd_price" ascending:NO];
            NSArray *sortDescriptors = @[sortDescriptor];
            [[AppDelegate appDelegate].dataArray sortUsingDescriptors:sortDescriptors];
        }
            break;
        default:
            break;
    }
    
    
    [self.myCollectionView reloadData];
    [self performSelector:@selector(HideLoaderAfterDelay) withObject:nil afterDelay:0.3];
    
}

-(NSMutableArray *)setValuesToNumber:(NSMutableArray *)arr
{
    for (int i=0 ; i<[arr count]; i++)
    {
        NSMutableDictionary *dict = [[arr objectAtIndex:i] mutableCopy];
        
        NSNumber *strDistance = [NSNumber numberWithFloat: [[dict valueForKey:@"prd_price"] floatValue]];
        
        [dict setValue:strDistance forKey:@"prd_price"];
        
        [arr replaceObjectAtIndex:i withObject:dict];
    }
    return arr;
}

-(void)HideLoaderAfterDelay
{
    [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
    
  
}
- (IBAction)btnSaveItemAction:(id)sender
{
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"] isEqualToString:@""]){
        
        FavouriteViewController *objFavouriteViewController = [[FavouriteViewController alloc]initWithNibName:@"FavouriteViewController" bundle:nil];
        //  [self presentViewController:objFavouriteViewController animated:YES completion:nil];
        
        [self.navigationController pushViewController:objFavouriteViewController animated:NO];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign in to save" message:@"You'll need to sign in to view or add to your saved items. Don't worry, you only have to do it once." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Sign in",@"Cancel", nil];
        alert.tag = 102;
        [alert show];
    }
}


#pragma mark:-Webservice Methods

- (IBAction) btnFavouriteAction:(id)sender
{
    
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"] isEqualToString:@""]){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Please wait...";
        hud.dimBackground = YES;
        //NSLog(@"app data array %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"]);
        NSString *product_id = [[[AppDelegate appDelegate].dataArray objectAtIndex:[sender tag]]objectForKey:@"prd_id"];
        
        NSMutableDictionary *mDictProduct = [[AppDelegate appDelegate].dataArray objectAtIndex:[sender tag]];
        
        NSString *add_remove_Favorite = @"0";
        randomNumber = arc4random() % 999999;
        if (![self matchFoundForEventId:product_id WithArray:[AppDelegate appDelegate].arrFavourite])
        {
            //[objAppDelegate.arrFavourite addObject:[objAppDelegate.dataArray objectAtIndex:[sender tag]]];
            add_remove_Favorite = @"1";
        }
        
        NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[mDictProduct objectForKey:@"prd_qty"],@"product_id":product_id,@"prd_default_price":[mDictProduct valueForKey:@"prd_price"],@"prd_update_price":[mDictProduct valueForKey:@"prd_price"],@"uniq_id":[NSString stringWithFormat:@"%d",randomNumber],@"get":add_remove_Favorite};
        
        //        NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"]};
        
        [CartrizeWebservices PostMethodWithApiMethod:@"GetUserFavoriteHistory" Withparms:parameters WithSuccess:^(id response)
         {
             //NSLog(@"favvvvvv Response = %@",[response JSONValue]);
             [AppDelegate appDelegate].requestFor = ADDFAVORITES;
             [[AppDelegate appDelegate] getFavoriteHistory];
             // self.arrAddToBag = [response JSONValue];
         } failure:^(NSError *error)
         {
             //NSLog(@"Error =%@",[error description]);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign in to save" message:@"You'll need to sign in to view or add to your saved items. Don't worry, you only have to do it once." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Sign in",@"Cancel", nil];
        alert.tag = 102;
        [alert show];
    }
}

- (BOOL)matchFoundForEventId:(NSString *)eventId WithArray:(NSMutableArray *)ConditionArray
{
    index = 0;
    for (NSDictionary *dataDict in ConditionArray)
    {
        NSString *createId = [dataDict objectForKey:@"prd_id"];
        if ([eventId isEqualToString:createId])
        {
            randomNumber = [[NSString stringWithFormat:@"%@",[dataDict valueForKey:@"uniq_id"]]intValue];
            return YES;
        }
        index++;
    }
    return NO;
}


#pragma mark - OpenAndCreatePickerView

- (void)OpenThePickerView
{
    myCollectionView.userInteractionEnabled = NO;
    self.arrayRecommended = [[NSMutableArray alloc] init];
    NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"What's New", @"name",  nil];
    NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Price - Low to High", @"name",  nil];
    NSDictionary *dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Price - High to Low", @"name",  nil]; //Low to High
    [self.arrayRecommended addObject:dic2];
    [self.arrayRecommended addObject:dic3];
    [self.arrayRecommended addObject:dic4];
    [self.pickerView reloadAllComponents];
    
    self.pickerView.hidden = NO;
    self.pickerToolbar.hidden = NO;
}

- (IBAction)dismissActionSheet:(id)sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - UIPickerView DataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.arrayRecommended count];
}

#pragma mark - UIPickerView Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.pickerView.frame.size.width, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    
    NSString *strTitle = [[self.arrayRecommended objectAtIndex:row] objectForKey:@"name"];
    
    label.text = [NSString stringWithFormat:@"%@", strTitle];
    return label;
}

//If the user chooses from the pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Let's print in the console what the user had chosen;
    strRecomonded = [[self.arrayRecommended objectAtIndex:row] objectForKey:@"name"];
    if([[[self.arrayRecommended objectAtIndex:row] objectForKey:@"name"] isEqualToString:@"Price - High to Low"])
    {
        strRecomonded = @"High to Low";
    }
    else if ([[[self.arrayRecommended objectAtIndex:row] objectForKey:@"name"] isEqualToString:@"Price - Low to High"])
    {
        strRecomonded = @"Low to High";
    }
    selectRow = (int)row;
}

#pragma mark - UITestField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.filterTxtField.inputAccessoryView = self.pickerToolbar;
    if(!isSearch)
    {
        self.pickerView.hidden=NO;
    }
    self.filterTxtField.inputView=self.pickerView;
}
- (IBAction)btnChangeCurrency:(id)sender
{
    Currency_Size_VC *Currency_Size_view = [[Currency_Size_VC alloc] initWithNibName:@"Currency_Size_VC" bundle:nil];
    Currency_Size_view.delegate=self;
    Currency_Size_view.delegateCurrency=self;
    Currency_Size_view.isSelectedValue = 1001;
    [self.navigationController pushViewController:Currency_Size_view animated:YES];
}

- (IBAction)btnChangeSize:(id)sender
{
    Currency_Size_VC *Currency_Size_view = [[Currency_Size_VC alloc] initWithNibName:@"Currency_Size_VC" bundle:nil];
    Currency_Size_view.delegateCurrency=self;
    Currency_Size_view.isSelectedValue = [sender tag];
    [self.navigationController pushViewController:Currency_Size_view animated:YES];
}

-(void)RefreshCurrencydelegatemethod:(NSString *)symbol withvalue:(NSString *)value
{
    
    for (int i=0; i<[AppDelegate appDelegate].dataArray.count; i++)
    {
        NSString *prod_price=[NSString stringWithFormat:@"%@",[[[AppDelegate appDelegate].dataArray objectAtIndex:i] objectForKey:@"prd_price"]];
        CGFloat final_price=[prod_price floatValue]*[value floatValue];
        NSLog(@"%@",[[AppDelegate appDelegate].dataArray objectAtIndex:i]);
        
       // [[[AppDelegate appDelegate].dataArray objectAtIndex:i] setValue:[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:final_price]] forKey:@"prd_price"];
    }
    
    [myCollectionView reloadData];
    [self performSelector:@selector(HideLoaderAfterDelay) withObject:nil afterDelay:0.2];
    
}
-(IBAction)backAction:(id)sender
{
    isREFINED = NO;
    //[self.navigationController popViewControllerAnimated:YES];
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[GridViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
            break;
        }
    }
    
}

- (IBAction)funcProfile:(id)sender
{
    
    NSString *name= @"";
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"IsUserLogin"] boolValue]) {
        name=[NSString stringWithFormat:@"Hi %@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"firstname"]capitalizedString]];
        
    }
    else{
        name=@"";
    }
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:name
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                                  
                                  
                              }];
    UIAlertAction* button1;
    UIAlertAction* button2;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"IsUserLogin"] boolValue]) {
        button1 = [UIAlertAction
                   actionWithTitle:@"My Dashboard"
                   style:UIAlertActionStyleDefault
                   handler:^(UIAlertAction * action)
                   {
                       //  The user tapped on "Take a photo"
                       DashboardView *dash=[[DashboardView alloc] initWithNibName:@"DashboardView" bundle:nil];
                       dash.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                       [self presentViewController:dash animated:YES
                                        completion:nil];
                       
                   }];
        
        button2 = [UIAlertAction
                   actionWithTitle:@"Signout"
                   style:UIAlertActionStyleDefault
                   handler:^(UIAlertAction * action)
                   {
                       //  The user tapped on "Choose existing"
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Do you want to Sign Out?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
                       alert.tag=101;
                       [alert show];
                       
                       
                   }];
        
    }
    else
    {
        button1 = [UIAlertAction
                   actionWithTitle:@"Sign In"
                   style:UIAlertActionStyleDefault
                   handler:^(UIAlertAction * action)
                   {
                       
                       LoginView *objLoginView;
                       objLoginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
                       objLoginView.strCheckViewControler = @"ListGrid";
                       [self.navigationController pushViewController:objLoginView animated:YES];
                       
                   }];
        
        button2 = [UIAlertAction
                   actionWithTitle:@"Join"
                   style:UIAlertActionStyleDefault
                   handler:^(UIAlertAction * action)
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
                       objRegistrationViewController.strCheckViewControler = @"ListGrid";
                       [self.navigationController pushViewController:objRegistrationViewController animated:YES];
                       
                   }];
    }
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
