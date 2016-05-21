    //
    //  GridViewController.m
    //  Cartrize
    //
    //  Created by Admin on 21/07/14.
    //  Copyright (c) 2014 Syscraft. All rights reserved.
    //

#import "GridViewController.h"
#import "LoginView.h"
#import "MySingletonClass.h"
#import "CartrizeWebservices.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "AFTableViewCell.h"
#import "ListGridViewController.h"
#import "Reachability.h"

@interface GridViewController ()<UIWebViewDelegate>

@end

@implementation GridViewController
@synthesize contentOffsetDictionary;
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
//    wv=[[UIWebView alloc]init];
//    wv.frame=CGRectMake(0, 0, 10, 10);
  //wv=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];

    scroll.backgroundColor=[UIColor clearColor];
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
    
    //[colViewObj registerNib:[UINib nibWithNibName:@"GridCollctionCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    activity1.hidden=NO;
    [activity1 startAnimating];
    [activity startAnimating];
    activity.hidden=NO;
    bannerArr=[[NSMutableArray alloc] init];
    categoriesArr=[[NSMutableArray alloc] init];
    catProductList=[[NSMutableArray alloc] init];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        
         if ([[NSUserDefaults standardUserDefaults] valueForKey:@"email"]!=nil) {
        [self FetchCartId];
         }
        
        
    });
    
    [self getTheImagesFromWebServer];
       if ([[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayImages"] == nil) {
        [self getTheImagesFromWebServer];
    }
    else
    {
        bannerArr=[[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayImages"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        [self changeBanner];

    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayCategry"] != nil) {
        
        categoriesArr=[[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayCategry"];
        ////NSLog(@"hhhh %@",categoriesArr);
        //[self getCategoryProducts];
        [productList reloadData];
        [colViewObj reloadData];
        [activity1 stopAnimating];
        activity1.hidden=YES;

    }
    else
    {
        [self getAllCategories];
        

    }
  
    
    
    count=0;
    
}

-(void)CartIdWebService
{
    //  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //  hud.labelText = @"Please wait...";
    //  hud.dimBackground = YES;
    NSDictionary *params=@{@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    [CartrizeWebservices PostMethodWithApiMethod:@"creditcartview-2" Withparms:params WithSuccess:^(id response) {
        
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
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"Please wait...";
//    hud.dimBackground = YES;
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //[self FetchCartId];
        if([[NSUserDefaults standardUserDefaults]valueForKey:@"email"]!=nil)
        {
       [self FetchCartId];
        }
        
    });
    
    
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

-(void)FetchCartIdd
{
    //[[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cart_id"];
    
    //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //
    //            hud.labelText = @"Please wait...";
    //
    //            hud.dimBackground = NO;
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
            if ([AppDelegate appDelegate].arrAddToBag.count == 0 || [AppDelegate appDelegate].arrAddToBag == nil) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"getCheckOutHistory" object:nil];
            }
            /*
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
              
                }

                
               // [[NSNotificationCenter defaultCenter]postNotificationName:@"getCheckOutHistory" object:nil];
            });
             */
            
            
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
    
    
}
-(void)FetchCartId
{
    //[[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cart_id"];
    
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//            hud.labelText = @"Please wait...";
//
//            hud.dimBackground = NO;
    NSDictionary *params=@{@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"getcrtid" Withparms:params WithSuccess:^(id response) {
        
        NSDictionary *dict=[response JSONValue];
        
         NSLog(@"cartid is from webservice is%@",dict);
        
        if([dict valueForKey:@"cart_id"]==[NSNull null]) {
            
            NSLog(@"null");
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cart_id"];
            [self CartIdWebService];

        }
        else
        {
            NSLog(@"insert");
            
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"cart_id"] forKey:@"cart_id"];
            if ([AppDelegate appDelegate].arrAddToBag.count == 0 || [AppDelegate appDelegate].arrAddToBag == nil) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"getCheckOutHistory" object:nil];
            }

//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                
//            });

        
        }
       [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];



}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] != NSURLErrorCancelled) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"Error for WEBVIEW: %@", [error description]);
        //show error alert, etc.
    }
      NSLog(@"Error for WEBVIEW: %@", [error description]);
    
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [productList scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}
-(void)changeBanner
{
    [scroll setPagingEnabled:YES];
    
    for (int i=0; i<bannerArr.count; i++)
        {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
            {
            UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(768*i, 0, 768, 303)];
            img.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[bannerArr objectAtIndex:i]]];
                //[img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[bannerImgArr objectAtIndex:i]]] placeholderImage:nil completed:nil];
//                img.contentMode = UIViewContentModeScaleAspectFit;
//            [scroll addSubview:img];
            scroll.contentSize=CGSizeMake(768*i+768, 250);
            }
        else{
            if ([UIScreen mainScreen].bounds.size.height==568) {
                UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 152)];
                    //img.image=myImage;
               img.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[bannerArr objectAtIndex:i]]];
                    // img.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[bannerArr objectAtIndex:i]]];
               //  img.contentMode = UIViewContentModeScaleAspectFit;
                [scroll addSubview:img];
                scroll.contentSize=CGSizeMake(320*i+320, 120);
            }else{
                UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 132)];
                
               img.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[bannerArr objectAtIndex:i]]];
                    //img.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[bannerArr objectAtIndex:i]]];
               // img.contentMode = UIViewContentModeScaleAspectFit;
                [scroll addSubview:img];
                
                scroll.contentSize=CGSizeMake(320*i+320, 120);
            }
        }
        }
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollPages) userInfo:nil repeats:YES];
    count=0;
}
-(void)scrollPages{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [scroll setContentOffset:CGPointMake(768*count, 0) animated:YES];
    }else
        [scroll setContentOffset:CGPointMake(320*count, 0) animated:YES];
    count++;
    if (count>bannerArr.count-1) {
        count=0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}
#pragma mark - Webservice calling

-(void)getTheImagesFromWebServer
{
    bannerArr=[NSMutableArray arrayWithObjects:@"img_02.png",@"img_03.png",@"img_04.png", nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:bannerArr forKey:@"ArrayImages"];
    [self changeBanner];
    [activity stopAnimating];
    activity.hidden=YES;
    /*NSString *jsonString=[NSString stringWithFormat:@"getSpleshScreen"];
        // //NSLog(@"this is json string%@",jsonString);
    [[MySingletonClass sharedSingleton] getDataFromJson:jsonString getData:^(NSArray *data,NSError *error)
     {
     if (error)
         {
             //HUpendra  [self performSelector:@selector(getTheImagesFromWebServer) withObject:nil afterDelay:1];
         }
     else{
         
             // //NSLog(@"this is data%@",data);
         bannerArr=[data valueForKey:@"url"];
         [[NSUserDefaults standardUserDefaults] setObject:bannerArr forKey:@"ArrayImages"];
         [self changeBanner];
         [activity stopAnimating];
         activity.hidden=YES;
     }
     }];*/
}
-(void)getAllCategories{
   
    [CartrizeWebservices PostMethodWithApiMethod:@"GetCategory" Withparms:nil WithSuccess:^(id response) {
        
     categoriesArr=[response JSONValue];
        [[NSUserDefaults standardUserDefaults] setObject:categoriesArr forKey:@"ArrayCategry"];
         ////NSLog(@"hhhh %@",categoriesArr);
         //[self getCategoryProducts];
     [productList reloadData];
     [colViewObj reloadData];
     [activity1 stopAnimating];
     activity1.hidden=YES;
        
//        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]isEqualToString:@""])
//        {
       
       // }

       //[self ]
     } failure:^(NSError *error)
     {
     ////NSLog(@"Error =%@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}
-(void)getCategoryProducts
{
        // for (int i=0; i<categoriesArr.count; i++) {
        // NSDictionary *parameters = @{@"customer_id":[[categoriesArr valueForKey:@"category_id"] objectAtIndex:i]};
    [CartrizeWebservices PostMethodWithApiMethod:@"GetCategory" Withparms:nil WithSuccess:^(id response)
     {
         // //NSLog(@"Response = %@",[response JSONValue]);
     [catProductList addObject:[response JSONValue]];
         //if (i==categoriesArr.count-1) {
     [self getArray];
         //}
     } failure:^(NSError *error)
     {
         // //NSLog(@"Error =%@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
        // }
}
-(void)getArray
{
        // //NSLog(@"product List %@",categoriesArr);
    [productList reloadData];
    [colViewObj reloadData];
    [activity1 stopAnimating];
    activity1.hidden=YES;
}


#pragma mark- IBActions
-(IBAction)logoutAction:(id)sender{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"customer_id"];
     [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"subtotal"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    LoginView *gridObj=[[LoginView alloc] init];
    [self.navigationController pushViewController:gridObj animated:YES];
}
#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr=[[categoriesArr valueForKey:@"child_category"] objectAtIndex:indexPath.section] ;
    if (arr.count<1)
        {
        return 0;
        }
    else
        {
        return 130;
        }
}

#pragma mark - UICollectionViewDataSource Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = [[categoriesArr valueForKey:@"child_category"] objectAtIndex:collectionView.tag] ;
    return arr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr=[[categoriesArr valueForKey:@"child_category"] objectAtIndex:collectionView.tag] ;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    [[cell.contentView viewWithTag:10001] removeFromSuperview];
    UIImageView *imgBg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 90, 90)];
    imgBg.image=[UIImage imageNamed:@"bg_cateimg.png"];
    UIImageView * img=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 80, 80)];
    [imgBg addSubview:img];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 85, 90, 50)];

    lbl.tag=10001;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.font=[UIFont fontWithName:@"Helvetica" size:12];
    lbl.numberOfLines=0;
    if (arr.count>0)
        {
        [img setImageWithURL:[NSURL URLWithString:[[arr valueForKey:@"child_category_image"] objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:CRplacehoderimage]];
        
        lbl.text=@"";
        lbl.text=[[arr valueForKey:@"child_category_name"] objectAtIndex:indexPath.row];
        }
    [cell.contentView addSubview:lbl];
    [cell.contentView addSubview:imgBg];
    
        // NSArray *collectionViewArray = self.colorArray[collectionView.tag];
        // cell.backgroundColor = [UIColor redColor];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"Refined"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Name"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Desc"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ShortDesc"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Sku"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MinPrice"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MaxPrice"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *arr=[[categoriesArr valueForKey:@"child_category"] objectAtIndex:collectionView.tag] ;
    
    ListGridViewController *listView = [[ListGridViewController alloc] init];
    listView.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    listView.categoryId =[[arr valueForKey:@"child_category_id"] objectAtIndex:indexPath.row];
    listView.doUpdate = YES;
    
    [AppDelegate appDelegate].isCheckSearchType=NO;
    [self.navigationController pushViewController:listView animated:YES];
        //presentViewController:listView animated:YES completion:nil];
}

#pragma mark UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return categoriesArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        //NSArray *arr=[catProductList objectAtIndex:section];
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    AFTableViewCell *cell = (AFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        {
        cell = [[AFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    cell.tag=indexPath.section;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(AFTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell setCollectionViewDataSourceDelegate:self index:indexPath.section];
    NSInteger index = cell.collectionView.tag;
    newIndex=indexPath.section;
        // //NSLog(@"jkkgjkgjkgkjgkj %d",(int)indexPath.section);
    CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
    [cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[categoriesArr valueForKey:@"parent_category_name"] objectAtIndex:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 27)];
    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 27)];
    img.image=[UIImage imageNamed:@"bg_subhead_arrow.png"];
    [headerview addSubview:img];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 320, 27)];
    lbl.text=[[categoriesArr valueForKey:@"parent_category_name"] objectAtIndex:section];
    lbl.font=[UIFont fontWithName:@"Helvetica" size:13];
    lbl.textColor=[UIColor whiteColor];
    [img addSubview:lbl];
    
    return headerview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}
#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    NSInteger index = collectionView.tag;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
}
@end
