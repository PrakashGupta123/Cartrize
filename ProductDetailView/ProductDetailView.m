//
//  ProductDetailView.m
//  IShop
//
//  Created by Hashim on 5/3/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "ProductDetailView.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "AddCartViewController.h"
#import <Social/Social.h>
#import "FavouriteViewController.h"
#import "MoreInfoCollectionCell.h"
#import "ViewFullSizeImageVC.h"
#import "RegistrationViewController.h"
#import "Currency_Size_VC.h"
#import "UserProfileViewController.h"
#import "BillingAddressViewController.h"
#import "Constants.h"
#import "PaymentDetailViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "CartrizeWebservices.h"
#import "CustomCell.h"
#import "JSON.h"
#import "ListGridViewController.h"
#import "CMSPageViewController.h"
#import "StarRatingView.h"
#import "ReviewAndRatingViewController.h"
#import "DashboardView.h"
#import "Reachability.h"
#import "LoginView.h"
#import "AppDelegate.h"
#import <FBSDKShareKit/FBSDKShareKit.h>


#define kNotificationRefreshProductItem @"RefreshProductItem"
#define kNotificationAddProduct @"AddProduct"

#define kNotificationAddFavoriteProduct @"AddFavoriteProduct"


#define kLabelAllowance 25.0f
#define kStarViewHeight 13.0f
#define kStarViewWidth 50.0f
#define kLeftPadding 4.0f

@interface ProductDetailView ()<CurrencyDelegate,GPPShareDelegate,GPPSignInDelegate>
{
    BOOL recent_is;
    NSString *strURL;
    NSData *dataForPost;
    NSString *strFacebook,*strWeightSelect,*strOptionId,*strOptionType;
    NSMutableArray *responseArr;
    BOOL isSelectWeight;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonBuythelook;
@property (weak, nonatomic) IBOutlet UIButton *buttonWeRecom;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecentView;
@property (weak, nonatomic) IBOutlet UIButton *buttonClearAll;

@property (weak, nonatomic) IBOutlet UILabel *lblButTheItems;
@property (weak, nonatomic) IBOutlet UILabel *lblRecentItems;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionMoreInfo;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontroller;

- (IBAction) BuyTheLookMethod:(id)sender;
- (IBAction) WeRecommendMethod:(id)sender;
- (IBAction) RecentViewMethod:(id)sender;
- (IBAction) ClearAllMethod:(id)sender;
- (IBAction) change_image_via_page:(id)sender;

@end

@implementation ProductDetailView

@synthesize scrollViewProductDetail,mutDictProductDetail,arrProductColorAndSize,arrProductColor,arrProductSize,popupView,popupViewSave;
@synthesize  pickerToolbar1,pickerViewColorandSize;
@synthesize btnPickerCancel, btnPickerDone, btnJoin, btnMyAccount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark:- Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    strRecent=@"0";
     //[[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cart_id"];
    NSLog(@"cartis viewdidload %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]);
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]isEqualToString:@""])
    {
       // [self WebserviceForGetResponseWebview];
    
    }
    activity.hidden=YES;
    
    strPrdOptionId=@"";
    strPrdOptionTypeId=@"";
    strprdqty=@"1";
    [self getWeightOptionWebService:[[mutDictProductDetail valueForKey:@"prd_id"] intValue]];
    strWeightSelect =[[arrWeight objectAtIndex:0] valueForKey:@"custome_title"];
    [self setContentView];
   
    isSelectWeight = YES;
     // NSString *strTwitterShare=@"dipesh\nmanoj";
    totalArr=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    isRecomded = NO;
    if([[AppDelegate appDelegate].arrAddToBag count ]>0)
    {
    lblDownBagCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[AppDelegate appDelegate].arrAddToBag count ]];
    }
    else
    {
        lblDownBagCount.text=@"0";
    
    }
    //arrWeight=[[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addProduct:) name:kNotificationAddProduct object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshProductItem:) name:kNotificationRefreshProductItem object:nil];
    
    arrProductColorAndSize = [[NSMutableArray alloc]init];
    //[self getBottomGridData];
    //arrContaintList = [[NSMutableArray alloc]init];
    isTablcontent = 0;
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addFavoriteProduct:) name:kNotificationAddFavoriteProduct object:nil];
    
   // [self getWeightOptionWebService:[[mutDictProductDetail valueForKey:@"prd_id"] intValue]];
    if([[mutDictProductDetail objectForKey:@"pro_stock"]intValue]<=0)
    {
        _btnOption.userInteractionEnabled=NO;
        _btncartietms.userInteractionEnabled=NO;
        _btnOption.enabled=NO;
        _btncartietms.enabled=NO;
        [_btnOption setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_btncartietms setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    
    }
    else
    {
        _btnOption.userInteractionEnabled=YES;
        _btncartietms.userInteractionEnabled=YES;
        _btnOption.enabled=YES;
        _btncartietms.enabled=YES;
        [_btnOption setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btncartietms setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    }
    mArrayQuantity = [[NSMutableArray alloc] init];
    //NSNumber *num = ;
    int totalQty = [[NSString stringWithFormat:@"%@",[mutDictProductDetail objectForKey:@"pro_stock"]] intValue];
    
    
    for(int i=1;i <= totalQty;i++)
    {
        [mArrayQuantity addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    
   
    self.viewBackGround.hidden=YES;
    isLoadedWebview = NO;
    
  
}

-(void)CheckCartIdAgain
{
    
    NSDictionary *params=@{@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    [CartrizeWebservices PostMethodWithApiMethod:@"getcrtid" Withparms:params WithSuccess:^(id response) {
        
        NSDictionary *dict=[response JSONValue];
        NSLog(@"cartid is from webservice is%@",dict);
        if([dict valueForKey:@"cart_id"]==[NSNull null]) {
            
            NSLog(@"null");
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cart_id"];
            // [self WebserviceForWebview];
            
        }
        else
        {
            NSLog(@"insert");
            
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"cart_id"] forKey:@"cart_id"];
           
            
            
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
    
}


-(void)LoadWebviewOnView:(NSString *)StrUrl
{
    WebCallAccordingCartId = YES;
    //viewMainWebview = [[UIView alloc] init];
   // viewMainWebview.frame =CGRectMake(0, 55, self.view.frame.size.width, self.view.frame.size.height);
    isLoadedWebview = YES;
   // viewMainWebview.hidden=YES;
    UIWebView *webview = [[UIWebView alloc] init];
    webview.delegate = self;
    webview.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    webview.hidden=YES;
    NSURL *websiteUrl = [NSURL URLWithString:StrUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [webview loadRequest:urlRequest];
    [self.view addSubview:webview];
    isLoadedWebview2=YES;
    //isLoadedWebview3=NO;
    //[self.view addSubview:viewMainWebview];
    
    
}

#pragma mark webview delegate methods

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"url: %@", [[request URL] absoluteString]);
   // NSLog(@"urlhost: %@", [[request URL] host]);

    
    if ([[[request URL] absoluteString] isEqualToString:@"cartrize://"]) {
        
        
       // [self WebserviceForGetResponseWebview];
        
    }
    
    return YES;
    
}

-(void)AddToCartWebserviceWebview
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
            
            
            
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    

}

-(void)WebserviceForGetResponseWebview
{
   
    NSDictionary *params=@{@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    [CartrizeWebservices PostMethodWithApiMethod:@"creditcartview" Withparms:params WithSuccess:^(id response) {
        
        WebCallAccordingCartId = NO;
        NSDictionary *dict=[response JSONValue];
        
        //[[NSUserDefaults standardUserDefaults]setObject:cartid forKey:@"cid"];
        wv=[[UIWebView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height)];
        NSURL *urlPath;
        NSURLRequest *requestObj;
       // wv.hidden=YES;
        wv.delegate=self;
        NSString *url=[dict valueForKey:@"check_url"];
        urlPath = [NSURL URLWithString:url];
        //requestObj = [NSMutableURLRequest requestWithURL:[urlPath absoluteURL]];
        requestObj = [NSMutableURLRequest requestWithURL:urlPath
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:20.0];
        
        [wv loadRequest:requestObj];
        
       // isLoadedWebview3=YES;
        [self.view addSubview:wv];
        //[self fetchCartId];
        //[self AddToCartWebserviceWebview];
    
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    

}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"didfinish");
    // [[AppDelegate appDelegate] removeLoadingAlert:self.view];
   /* if(isLoadedWebview3==YES)
    {
    [self WebserviceForWebview];
    }
    if(isLoadedWebview2==YES)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    }*/
    if(isLoadedWebview2==YES)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isLoadedWebview2=NO;
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"email"];
        GridViewController *listGridViewController =[[GridViewController alloc]initWithNibName:@"GridViewController" bundle:nil];
       [self.navigationController pushViewController:listGridViewController animated:YES];
    }
    if(isLogout==YES)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You have been successfully log out" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=6789;
        [alert show];
//        LoginView *login=[[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
//        [self.navigationController pushViewController:login animated:YES];
    
    }
    //NSLog(@"loading complete");
   // [self fetchCartId];
    
//    if (WebCallAccordingCartId == YES) {
//        [self WebserviceForGetResponseWebview];
//    }
//    else
//    {
       // [self fetchCartId];
    //}
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];

}


- (void)webViewDidStartLoad:(UIWebView *)webView {

    NSLog(@"Start loading");
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}


-(void)WebserviceForWebview
{
     NSDictionary *dict =@{@"producturl":[NSString stringWithFormat:@"%@?purl=ada",[mutDictProductDetail valueForKey:@"product_url"]]};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"getproductdetailurl" Withparms:dict WithSuccess:^(id response) {
        
        NSLog(@"link for addingcart webview is%@",[NSString stringWithFormat:@"%@?purl=ada",[mutDictProductDetail valueForKey:@"product_url"]]);
        
          [self LoadWebviewOnView:[NSString stringWithFormat:@"%@?purl=ada",[mutDictProductDetail valueForKey:@"product_url"]]];
         //[self WebserviceForGetResponseWebview];

    } failure:^(NSError *error) {
        
        NSLog(@"%@",error.localizedDescription);
    }];
    
}
-(void)callWSForAllDetails
{
    [CartrizeWebservices PostMethodWithApiMethod:@"GetAllPages" Withparms:nil WithSuccess:^(id response)
     {
         responseArr=[response JSONValue];
         //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];

         [self.tableViewTopContent reloadData];
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
     }];
}

-(void)getWeightOptionWebService:(int)prdID
{
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
        
    }

    
   // if(![[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]isEqualToString:@""])
    
   // {
    
    hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud3.dimBackground = NO;
   // }
   // hud.color= [UIColor clearColor];
    
    NSString *jsonString = [NSString stringWithFormat:@"http://cartrize.com/iosapi_cartrize.php?methodName=getAllProductsOptions&prd_id=%d",prdID];
    
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
          hud3.hidden =YES;
         if (data==nil) {
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             return ;
             
         }
         //NSMutableArray *arrResponse=[[NSMutableArray alloc]init];
        arrWeight= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         strWeightSelect =[[arrWeight objectAtIndex:0] valueForKey:@"custome_title"];
           [_btnOption setTitle:strWeightSelect forState:UIControlStateNormal];
         NSString *str =[NSString stringWithFormat:@"%@",[[arrWeight objectAtIndex:0] valueForKey:@"isrequired"]];
         if ([str isEqualToString:@"1"]) {
             isSelectWeight = YES;
         }
         else
         {
             isSelectWeight = NO;
         }
         
         if(![[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]isEqualToString:@""])
             
         {

         hud3.hidden =YES;
         }
         if (arrWeight == nil)
         {
             [_btnOption setHidden:YES];
             
             [_viewPrdAttributes setFrame:CGRectMake(_viewPrdAttributes.frame.origin.x, _viewPrdAttributes.frame.origin.y-25, _viewPrdAttributes.frame.size.width, _viewPrdAttributes.frame.size.height)];
         }
         else
         {
           [_btnOption setHidden:NO];
              [_viewPrdAttributes setFrame:CGRectMake(_viewPrdAttributes.frame.origin.x, _viewPrdAttributes.frame.origin.y, _viewPrdAttributes.frame.size.width, _viewPrdAttributes.frame.size.height)];
         
         }
         // //NSLog(@"this is data --- %@",[AppDelegate appDelegate].dataArray);
         
         //arrWeight=[NSMutableArray arrayWithArray:[arrResponse valueForKey:@"custome_values"]];
         
         [_CollectionMoreInfo reloadData];
         //[hud hide:YES];
         
         [self RefreshCurrencydelegatemethod:[AppDelegate appDelegate].currencySymbol withvalue:[AppDelegate appDelegate].currencyValue];
//         
//         if ([[AppDelegate appDelegate].dataArray count] != 0)
//         {
//             // [self.myCollectionView reloadData];
//             NSLog(@"MANOJ");
//         }
//         else
//         {
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No product found for this category!!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//             [alert show];
//         }
     }];
}


-(void)getBottomGridData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = NO;
    
    NSString *jsonString = [NSString stringWithFormat:@"http://cartrize.com/iosapi_cartrize.php?methodName=getProductsByCatId&cat_id=%@",[AppDelegate appDelegate].selectedCateId];
    
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
         
         hud.hidden =YES;
         if (data==nil) {
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             return ;
             
         }
         
         [AppDelegate appDelegate].dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         // //NSLog(@"this is data --- %@",[AppDelegate appDelegate].dataArray);
         [_CollectionMoreInfo reloadData];
         [hud hide:YES];
         
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

-(void)refreshProductItem:(NSNotification *)notification
{
    [self getYourBagItem];
}

-(void)addProduct:(NSNotification *)notification
{
    //[self getYourBagItem];
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)reportAuthStatus
{
    if ([GPPSignIn sharedInstance].authentication){
        // signInAuthStatus_.text = @"Status: Authenticated";
        [self retrieveUserInfo];
        //[self enableSignInSettings:NO];
    }
    else{
        // To authenticate, use Google+ sign-in button.
        // signInAuthStatus_.text = @"Status: Not authenticated";
        //[self enableSignInSettings:YES];
    }
}

- (void)retrieveUserInfo
{
    
}
//
-(void)setContentView
{
   
    popupView.hidden = YES;
    popupViewSave.hidden = YES;
    viewMoreInfo.hidden = YES;
    
    btnSizePicker.hidden = YES;
    lblProductSize.hidden = YES;
    btnColorPicker.hidden = YES;
    lblProductColor.hidden = YES;
    
    isWebserviceCount = 1;
    
    popupView.hidden = YES;
    popupViewSave.hidden = YES;
    viewMoreInfo.hidden = YES;
    self.pickerToolbar1.hidden = YES;
    self.pickerViewColorandSize.hidden = YES;
    
    lblProductColor.text = @"Color";
    
    
    request_gallery = [NSMutableString stringWithFormat:@"%@", [NSString stringWithFormat:product_gallery, [mutDictProductDetail objectForKey:@"prd_id"]]];
    strPriceFinal = [NSString stringWithFormat:@"%@",[mutDictProductDetail objectForKey:@"prd_price"]];
    //NSMutableString *request_options = [NSMutableString stringWithFormat:@"%@", [NSString stringWithFormat:product_option, [mutDictProductDetail objectForKey:@"prd_id"]]];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        [self getResponce:request_gallery :1];
//    });
  //Comment GiraSe  [self performSelectorInBackground:@selector(getResponce) withObject:nil];
    
  
    
    
    lblProductName.text = [mutDictProductDetail objectForKey:@"prd_name"];
    
    lblProductPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,[[mutDictProductDetail objectForKey:@"prd_price"] floatValue]];
    NSNumber *valueInNum = [mutDictProductDetail objectForKey:@"prd_price"];
    strDefaultPrice = [valueInNum floatValue];
    

    lblProductProductCode.text = [NSString stringWithFormat:@"SKU %@",[mutDictProductDetail objectForKey:@"prd_sku"]];
    NSString *str=[mutDictProductDetail objectForKey:@"prd_desc"];
    
    
    CGSize constraint = CGSizeMake(295 - (10 * 2), 20000.0f);
  
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
   
    CGFloat height = MAX(size.height, 44.0);
   
 
    lblProductProductDiscription.text =[mutDictProductDetail objectForKey:@"prd_desc"];

    lblProductProductDiscription.frame = CGRectMake(16, lblAboutMe.frame.origin.y+lblAboutMe.frame.size.height+3, 295, height+10);
    
    descLblBg.frame = CGRectMake(10, lblAboutMe.frame.origin.y+lblAboutMe.frame.size.height, 305, height+10);
    
    
    btnInfo.frame = CGRectMake(12,lblProductProductDiscription.frame.size.height+lblProductProductDiscription.frame.origin.y+10, 296, 30);
    productDetView.frame = CGRectMake(10,lblProductProductDiscription.bounds.size.height+300, 300, 236);
    lblProductProductDiscription.numberOfLines = 0;
    imageViewBG.frame = CGRectMake(0, 101, 320, lblProductProductDiscription.bounds.size.height + 408);
    
  
    if (IS_IPHONE_4)
    {
       // self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, 500);
    }
    else
    {
     //   self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, 1940+height);
    }
    //self.scrollViewProductDetail.contentOffset = CGPointMake (self.scrollViewProductDetail.bounds.origin.x, 0);
    stringHt=height;
    [self setdata];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideGuestView:)];
    [self.view addGestureRecognizer:gesture];
    
    // 30-05-14 collection registration
    UINib *cellNib = [UINib nibWithNibName:@"MoreInfoCollectionCell" bundle:nil];
    [_CollectionMoreInfo registerNib:cellNib forCellWithReuseIdentifier:@"MoreInfoCollectionCell"];
    
    // hide clear all button default
    _buttonClearAll.hidden=YES;
    _lblRecentItems.hidden=YES;
    // check and save Recent visited
    NSString *product_id = [mutDictProductDetail objectForKey:@"prd_id"];
    if (![self matchFoundForEventId:product_id WithArray:[AppDelegate appDelegate].MoreInfoarray_Recent])
    {
        
        [[AppDelegate appDelegate].MoreInfoarray_Recent addObject:[mutDictProductDetail mutableCopy]];
         _lblButTheItems.text=[NSString stringWithFormat:@"%d items",(int)[AppDelegate appDelegate].MoreInfoarray_Recent.count];
        [_CollectionMoreInfo reloadData];
    }
    if([strRecent isEqualToString:@"1"])
    {
        
        if([AppDelegate appDelegate].MoreInfoarray_Recent.count>0)
        {
            _lblButTheItems.text=[NSString stringWithFormat:@"%d items",(int)[AppDelegate appDelegate].MoreInfoarray_Recent.count];
        }
        else
        {
            _lblButTheItems.text=[NSString stringWithFormat:@"0 item"];
            
        }
        
    }
    else
    {
    
    if([AppDelegate appDelegate].dataArray.count>0)
    {
    _lblButTheItems.text=[NSString stringWithFormat:@"%d items",(int)[AppDelegate appDelegate].dataArray.count];
    }
    else
    {
          _lblButTheItems.text=[NSString stringWithFormat:@"0 item"];
    
    }
    }
}

-(void)setdata
{
    self.scrollViewProductDetail.contentOffset = CGPointMake (0, 0);
    
            strURL = [mutDictProductDetail objectForKey:@"prd_thumb"];
            
            // Here we use the new provided setImageWithURL: method to load the web image
            [imgViewProducts sd_setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:CRplacehoderimage] ];
    
            //[imgViewProducts addSubview:activityIndicatorForImage];
            
            UITapGestureRecognizer *singleTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productGalleryFullView:)];
            //imgViewProducts.tag=i;
            singleTap.view.tag=imgViewProducts.tag;
            imgViewProducts.userInteractionEnabled=YES;
            [imgViewProducts addGestureRecognizer:singleTap];
    if ([[mutDictProductDetail valueForKey:@"QTY"] intValue] <= 0)
    {  _lblDiscountshow.transform = CGAffineTransformMakeRotation(-M_PI/4);
        for (UIView *view in self.scrollViewProductDetail.subviews) {
            NSLog(@"%@",self.scrollViewProductDetail.subviews);
            if (view.tag == 121254) {
                view.layer.masksToBounds = YES;
            }
        }
      //  _lblDiscountshow.layer.cornerRadius = 5.0;
       // _lblDiscountshow.layer.masksToBounds = YES;
        _lblDiscountshow.hidden=NO;
    }
    if ([[mutDictProductDetail valueForKey:@"pro_stock"] intValue] <= 0)
    {  _lblDiscountshow.transform = CGAffineTransformMakeRotation(-M_PI/4);
        for (UIView *view in self.scrollViewProductDetail.subviews) {
            NSLog(@"%@",self.scrollViewProductDetail.subviews);
            if (view.tag == 121254) {
                view.layer.masksToBounds = YES;
            }
        }
        //  _lblDiscountshow.layer.cornerRadius = 5.0;
        // _lblDiscountshow.layer.masksToBounds = YES;
        _lblDiscountshow.hidden=NO;
    }
    else
    {
        _lblDiscountshow.hidden=YES;
        
    }
           // [self.scrolViewPrductImages addSubview:imgViewProducts];

    CGRect newTableFrame = self.tableViewPrdAttributes.frame;
        
        newTableFrame.size.height = [arrProductColorAndSize count] * 36;
        self.tableViewPrdAttributes.frame = newTableFrame;
        
        CGRect viewProductFrame = self.viewPrdAttributes.frame;
        
        viewProductFrame.origin.y = self.tableViewPrdAttributes.frame.origin.y + self.tableViewPrdAttributes.frame.size.height - 14 ;
        
        self.viewPrdAttributes.frame = viewProductFrame;
        float heightScroll = 1880 + ([arrProductColorAndSize count]-1) * 36;
        
        if (IS_IPHONE_4)
        {
            self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, heightScroll+stringHt-375);
        }else{
            self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, heightScroll+stringHt-270);
        }
        
        [self.tableViewPrdAttributes reloadData];

}

- (void)viewWillAppear:(BOOL)animated
{
      [super viewWillAppear:animated];
    activity.hidden=YES;
    strPrdOptionId=@"";
    strPrdOptionTypeId=@"";
    strprdqty=@"1";
//     [self getWeightOptionWebService:[[mutDictProductDetail valueForKey:@"prd_id"] intValue]];
//      strWeightSelect =[[arrWeight objectAtIndex:0] valueForKey:@"custome_title"];
    [_btnOption setTitle:strWeightSelect forState:UIControlStateNormal];
    [_btncartietms setTitle:@"----Select Quantity----" forState:UIControlStateNormal];

    
    arrContaintList = [[[NSUserDefaults standardUserDefaults]objectForKey:@"searchProductsList"] mutableCopy];
    isTablcontent = 0;
    isShowLoader = NO;

  
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setScrollContent];
    [self getYourBagItem];
}

-(void)setScrollContent
{
    popupView.hidden = YES;
    popupViewSave.hidden = YES;
    
    //topMenuSliderView.hidden = NO;
    CGRect frame = [topMenuSliderView frame];
    frame.origin.y = -323;
    [topMenuSliderView setFrame:frame];
    
    CGRect frameScroll = [self.scrollViewProductDetail frame];
    frameScroll.origin.y = 55;
    [self.scrollViewProductDetail setFrame:frameScroll];
    self.scrollViewProductDetail.userInteractionEnabled = YES;
    
    
    //self.scrolViewPrductImages.userInteractionEnabled = YES;
    
    isVisibleTopView = NO;
    
     if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"] isEqualToString:@""]) {
        
       lblWelcomeuser.text = [NSString stringWithFormat:@"Hi %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"firstname"]];
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if (![arrContaintList containsObject:textField.text])
    {
        [arrContaintList addObject:textField.text];
    }
    
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
    listGridViewController.doUpdate = YES;
    [self.navigationController pushViewController:listGridViewController animated:YES];
    return YES;
}


#pragma mark --- Table View Delegate and Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isTablcontent == 1)
    {
        return 44;
    }
    else
    {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(isTablcontent == 1)
    {
        if([arrContaintList count] > 0)
        {
            UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
         //   viewHeader.backgroundColor = [UIColor whiteColor];
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
            
           // [btnClear setImage:[UIImage imageNamed:@"clear_r"] forState:UIControlStateNormal];
            [btnClear addTarget:self action:@selector(actionClearSearchList:) forControlEvents:UIControlEventTouchUpInside];
            [viewHeader addSubview:btnClear];
            return viewHeader;
        }
        return nil;
    }
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  return 36;
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isTablcontent == 0)
    {
        return [arrProductColorAndSize count];
    }
    else if (isTablcontent == 1)
    {
        return [arrContaintList count];
    }
    else
    {
       // return 1 + [[AppDelegate appDelegate].mArrayCMSPages count];
         return responseArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(isTablcontent == 0)
    {
        static NSString *cellIdentifier = @"Prd_Attributes";
        CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            NSArray *cellView = [[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil];
            cell = (CustomCell *)[cellView objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        
        if([[[arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
        {
            cell.lblPrdAttibuteTitle.text = [[arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"custome_title"];
        }
        else
        {
            cell.lblPrdAttibuteTitle.text = [[arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"prd_Attribute_Title"];
        }
        cell.btnPicker.userInteractionEnabled = YES;
        
        [cell.btnPicker addTarget:self action:@selector(btnColorAndSizeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnPicker.tag = indexPath.row;
        return cell;
    }
    else if(isTablcontent == 1)
    {
        static NSString *CellIdentifier = nil;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
             cell.backgroundColor=[UIColor clearColor];
          //  [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        //MANOJ
        cell.textLabel.text = [arrContaintList objectAtIndex:indexPath.row] ;
 //       cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        
        UIImageView *imgDescloser=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        [imgDescloser setImage:[UIImage imageNamed:@"shipping_arrow1.png"]];
       
        
        UILabel *lblLine=[[UILabel alloc] initWithFrame:CGRectMake(0,43, 320, 1)];
        lblLine.text=@"";
        [lblLine setBackgroundColor:[UIColor lightGrayColor]];
        
        [cell  addSubview:lblLine];
        cell.accessoryView=imgDescloser;

        
        UIButton *btnClick = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClick.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        btnClick.backgroundColor = [UIColor clearColor];
        [btnClick addTarget:self action:@selector(actionGotoListView:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnClick];
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
        
//        if(indexPath.row == 0)
//        {
//            cell.lblPrdAttibuteTitle.text = [[NSString stringWithFormat:@"CURRENCY: %@",[AppDelegate appDelegate].CurrentCurrency] uppercaseString];
//            [cell.btnCell addTarget:self action:@selector(btnChangeCurrency:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        else
//        {
//            cell.lblPrdAttibuteTitle.text = [[[[AppDelegate appDelegate].mArrayCMSPages objectAtIndex:indexPath.row - 1]valueForKey:@"title"]uppercaseString];
//            cell.btnCell.tag = indexPath.row - 1;
//            [cell.btnCell addTarget:self action:@selector(actionGoToCMSPages:) forControlEvents:UIControlEventTouchUpInside];
//        }
        
        //Write hupendra
        if (arrProductColorAndSize.count>0)
        {
            if([[[arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"selecte"] isEqualToString:@"NO"])
            {
                cell.lblPrdAttibuteTitle.text = [[arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"custome_title"];
            }else
            {
                cell.lblPrdAttibuteTitle.text = [[arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"selecte"];
            }
        }
        [cell.btnPicker addTarget:self action:@selector(btnColorAndSizeAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnPicker.tag = indexPath.row;
        
     //   [self FoterValues];
       // [self setTotalValue];
        
        cell.lblPrdAttibuteTitle.text = [[responseArr objectAtIndex:indexPath.row] valueForKey:@"title"];
        
        cell.btnCell.tag = indexPath.row;
        
        [cell.btnCell addTarget:self action:@selector(actionGoToCMSPages:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
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
    
    if(isTablcontent == 1)
    {
        [AppDelegate appDelegate].strSearchName = [arrContaintList objectAtIndex:indexPath.row];
        ListGridViewController *listGridViewController = [[ListGridViewController alloc]initWithNibName:@"ListGridViewController" bundle:nil];
        listGridViewController.doUpdate = YES;
        [AppDelegate appDelegate].isCheckSearchType = YES;
        
        [self.navigationController pushViewController:listGridViewController animated:YES];
    }
    if(isTablcontent == 2)
    {
        if(indexPath.row == 0)
        {
            Currency_Size_VC *Currency_Size_view = [[Currency_Size_VC alloc] initWithNibName:@"Currency_Size_VC" bundle:nil];
            Currency_Size_view.delegateCurrency=self;
            Currency_Size_view.isSelectedValue=1001;
            [self.navigationController pushViewController:Currency_Size_view animated:YES];
        }
        else
        {
            CMSPageViewController *cMSPageViewController = [[CMSPageViewController alloc]initWithNibName:@"CMSPageViewController" bundle:nil];
            
            cMSPageViewController.strTitle = [[[[AppDelegate appDelegate].mArrayCMSPages objectAtIndex:indexPath.row - 1]valueForKey:@"title"]uppercaseString];
            cMSPageViewController.strDescreption = [[[AppDelegate appDelegate].mArrayCMSPages objectAtIndex:indexPath.row - 1]valueForKey:@"content"];
            [self.navigationController pushViewController:cMSPageViewController animated:YES];
        }
    }
}

-(IBAction)actionGotoListView:(id)sender
{
    [AppDelegate appDelegate].strSearchName = [arrContaintList objectAtIndex:[sender tag]];
    ListGridViewController *listGridViewController = [[ListGridViewController alloc]initWithNibName:@"ListGridViewController" bundle:nil];
    listGridViewController.doUpdate = YES;
    [AppDelegate appDelegate].isCheckSearchType = YES;
    [self.navigationController pushViewController:listGridViewController animated:YES];
}

-(IBAction)actionClearSearchList:(id)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"searchProductsList"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    arrContaintList = [[NSMutableArray alloc]init];
    [searchView.tableViewSearchResult reloadData];
}

-(IBAction)actionGoToCMSPages:(id)sender
{
    
//    CMSPageViewController *cMSPageViewController = [[CMSPageViewController alloc]initWithNibName:@"CMSPageViewController" bundle:nil];
//    
//    cMSPageViewController.strTitle = [[[[AppDelegate appDelegate].mArrayCMSPages objectAtIndex:[sender tag]]valueForKey:@"title"]uppercaseString];
//    cMSPageViewController.strDescreption = [[[AppDelegate appDelegate].mArrayCMSPages objectAtIndex:[sender tag]]valueForKey:@"content"];
//    [self.navigationController pushViewController:cMSPageViewController animated:YES];
    
    //by me
    
    
    CMSPageViewController *cMSPageViewController = [[CMSPageViewController alloc]initWithNibName:@"CMSPageViewController" bundle:nil];
    
    cMSPageViewController.strTitle = [[[responseArr objectAtIndex:[sender tag]]valueForKey:@"title"]uppercaseString];
    
    cMSPageViewController.strDescreption = [[responseArr objectAtIndex:[sender tag]]valueForKey:@"content"];
    
    [self.navigationController pushViewController:cMSPageViewController animated:YES];

    
}

#pragma mark - Custom Method
-(void) getYourBagItem
{
//    int totalItem = 0;
//    for(NSMutableDictionary *mDict in [AppDelegate appDelegate].arrAddToBag)
//    {
//        totalItem = totalItem + [[ mDict valueForKey:@"prd_qty"]intValue];
//    }
//    lblDownBagCount.text = [NSString stringWithFormat:@"%d",totalItem];
//    lblBagCount.text = [NSString stringWithFormat:@"%d",totalItem];
    if([[AppDelegate appDelegate].arrAddToBag count]>0)
    {
    
    lblDownBagCount.text = [NSString stringWithFormat:@"%d",[AppDelegate appDelegate].arrAddToBag.count];
    lblBagCount.text = [NSString stringWithFormat:@"%d",[AppDelegate appDelegate].arrAddToBag.count];
    }
    else
    {
         lblDownBagCount.text=@"0";
            lblDownBagCount.text=@"0";
            
        
    
    }
}

#pragma mark -- REVIEW AND RATING
-(IBAction)actionReviewAndRating:(id)sender
{
    NSString *strXIB = @"ReviewAndRatingViewController";
    if(!IS_IPHONE5)
    {
        strXIB = @"ReviewAndRatingViewController_iPhon3.5";
    }
    ReviewAndRatingViewController *reviewAndRatingViewController = [[ReviewAndRatingViewController alloc]initWithNibName:strXIB bundle:nil];
    reviewAndRatingViewController.strProductID = [mutDictProductDetail objectForKey:@"prd_id"];
    [self.navigationController pushViewController:reviewAndRatingViewController animated:YES];
}
/*
- (void) getResponceProductDetail:(NSString *)strURL :(int)service_count
{
    
    if (service_count == 1){
        
        
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data,NSError *connectionError){
                                   
                                   if (service_count == 1)
                                   {
                                       for (UIImageView *subImageView in self.scrolViewPrductImages.subviews)
                                       {
                                           [subImageView removeFromSuperview];
                                       }
                                       mutArrayProductImages = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                       //NSLog(@"Responce-- %@",mutArrayProductImages);
                                       
                                       self.scrolViewPrductImages.contentSize = CGSizeMake(320 * [mutArrayProductImages count], self.scrolViewPrductImages.frame.size.height);
                                       
                                       self.scrolViewPrductImages.contentOffset = CGPointMake (self.scrolViewPrductImages.bounds.origin.x, self.scrollViewProductDetail.bounds.origin.y);
                                       _pagecontroller.numberOfPages = mutArrayProductImages.count;
                                       _pagecontroller.currentPage=0;
                                       
                                       for (int i = 0; i < [mutArrayProductImages count]; i++)
                                       {
                                           imgViewProducts = [[UIImageView alloc] initWithFrame:CGRectMake(10+(i * 300),10, 300,330)];
                                           imgViewProducts.layer.masksToBounds=YES;
                                           imgViewProducts.layer.borderColor=[[UIColor colorWithRed:150.0/255.0 green:175.0/255.0 blue:84.0/255.0 alpha:1.0]CGColor];
                                           imgViewProducts.layer.borderWidth= 1.0f;
                                           imgViewProducts.backgroundColor = [UIColor clearColor];
                                           imgViewProducts.contentMode = UIViewContentModeScaleAspectFit;
                                           
                                           NSString *strURL = [[mutArrayProductImages objectAtIndex:i] objectForKey:@"prd_img"];
                                           
                                           __block UIActivityIndicatorView *activityIndicatorForImage = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                                           activityIndicatorForImage.center = imgViewProducts.center;
                                           activityIndicatorForImage.hidesWhenStopped = YES;
                                           
                                           // Here we use the new provided setImageWithURL: method to load the web image
                                           
                                           [imgViewProducts setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:CRplacehoderimage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                                               if(!error ){
                                                   [activityIndicatorForImage removeFromSuperview];
                                               }
                                           }];
                                           [imgViewProducts addSubview:activityIndicatorForImage];
                                           
                                           UITapGestureRecognizer *singleTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productGalleryFullView:)];
                                           imgViewProducts.tag=i;
                                           singleTap.view.tag=imgViewProducts.tag;
                                           imgViewProducts.userInteractionEnabled=YES;
                                           [imgViewProducts addGestureRecognizer:singleTap];
                                           [self.scrolViewPrductImages addSubview:imgViewProducts];
                                       }
                                   }
                               }];
        
    }else if (service_count==2) {
        
        if(arrProductColorAndSize.count!=0){
            [arrProductColorAndSize removeAllObjects];
        }else{
            arrProductColorAndSize=[[NSMutableArray alloc] init];
        }
        
        NSMutableArray *optionArray = [mutDictProductDetail valueForKey:@"product_options"] ;
        for (int i = 0; i < [optionArray count]; i++)
        {
            NSMutableDictionary *mDict1=[[NSMutableDictionary alloc] init];
            [mDict1 setValue:@"NO"  forKey:@"selecte"];
            [mDict1 setValue:[[optionArray objectAtIndex:i] valueForKey:@"custome_title"]  forKey:@"custome_title"];
            [mDict1 setValue:[[optionArray objectAtIndex:i] valueForKey:@"product_id"]  forKey:@"product_id"];
            [mDict1 setValue:[[optionArray objectAtIndex:i] valueForKey:@"product_title"]  forKey:@"product_title"];
            [mDict1 setValue:[[optionArray objectAtIndex:i] valueForKey:@"product_price"]  forKey:@"product_price"];
            [mDict1 setObject:[[optionArray objectAtIndex:i] valueForKey:@"custome_values"] forKey:@"custome_values"];
            [arrProductColorAndSize addObject:mDict1];
        }
        
        
        //NSLog(@"Responce-- %@",arrProductColorAndSize);
        
        CGRect newTableFrame = self.tableViewPrdAttributes.frame;
        
        newTableFrame.size.height = [arrProductColorAndSize count] * 36;
        self.tableViewPrdAttributes.frame = newTableFrame;
        
        CGRect viewProductFrame = self.viewPrdAttributes.frame;
        
        viewProductFrame.origin.y = self.tableViewPrdAttributes.frame.origin.y + self.tableViewPrdAttributes.frame.size.height - 14;
        
        self.viewPrdAttributes.frame = viewProductFrame;
        
        //  float heightScroll = 891 + ([_arrProductColorAndSize count]-1) * 36; old code
        
        float heightScroll = 10 + ([arrProductColorAndSize count]-1) * 36; //hupendra code
        
        //NSLog(@"%f",heightScroll);
        
        self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, heightScroll+heightScroll - 170);
        
        [self.tableViewPrdAttributes reloadData];
    }
    
}
 */
/*
- (void) getResponce
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   // hud.labelText = @"Please wait...";
    hud.dimBackground = NO;
    hud.color = [UIColor clearColor];
    activity.hidden=YES;
    [activity startAnimating];
    scrollViewProductDetail.contentOffset = CGPointMake(0,0);
    NSURL *url = [NSURL URLWithString:request_gallery];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data,NSError *connectionError){
                               
                               NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                             
                               if (responseBody == (id)[NSNull null] || responseBody.length == 0 || responseBody==nil || [responseBody isEqual:[NSNull null]] || [responseBody isEqualToString:@"null"])
                              {
                                  [hud setHidden:YES];
                              
                              }
                            int service_count = 1;
                                [hud setHidden:YES];
                               if (service_count == 1)
                               {
                                   for (UIImageView *subImageView in self.scrolViewPrductImages.subviews)
                                   {
                                       [subImageView removeFromSuperview];
                                   }
                                   mutArrayProductImages = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   // //NSLog(@"Responce-- %@",mutArrayProductImages);
                                   
                                   self.scrolViewPrductImages.contentSize = CGSizeMake(289 * [mutArrayProductImages count], self.scrolViewPrductImages.frame.size.height);
                                   self.scrolViewPrductImages.contentOffset = CGPointMake (self.scrolViewPrductImages.bounds.origin.x, self.scrollViewProductDetail.bounds.origin.y);
                                   _pagecontroller.numberOfPages = mutArrayProductImages.count;
                                   _pagecontroller.currentPage=0;
                                   
                                   for (int i = 0; i < [mutArrayProductImages count]; i++)
                                   {
                                       imgViewProducts = [[UIImageView alloc] initWithFrame:CGRectMake(i * 289, 0, 289,290)];
                                       imgViewProducts.backgroundColor = [UIColor clearColor];
                                       imgViewProducts.contentMode = UIViewContentModeScaleAspectFit;
                                       
                                       strURL = [[mutArrayProductImages objectAtIndex:i] objectForKey:@"prd_img"];
                                       
                                       __block UIActivityIndicatorView *activityIndicatorForImage = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                                       activityIndicatorForImage.center = imgViewProducts.center;
                                       activityIndicatorForImage.hidesWhenStopped = YES;
                                       
                                       // Here we use the new provided setImageWithURL: method to load the web image
                                       [imgViewProducts sd_setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:CRplacehoderimage] ];
                                        [hud setHidden:YES];
//                                       [imgViewProducts setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:CRplacehoderimage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
//                                           if(!error ){
////                                               if (isShowLoader) {
////                                                   isShowLoader = NO;
//                                                    [hud setHidden:YES];
//                                               NSLog(@"Response 1");
//                                              // }
//                                              
//                                               [activityIndicatorForImage removeFromSuperview];
//                                               
//                                           }
//                                           else
//                                           {
//                                               [hud setHidden:YES];
//                                              
//                                           }
//                                       }];
                                       //[hud setHidden:YES];
                                       [imgViewProducts addSubview:activityIndicatorForImage];
                                       
                                       UITapGestureRecognizer *singleTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productGalleryFullView:)];
                                       imgViewProducts.tag=i;
                                       singleTap.view.tag=imgViewProducts.tag;
                                       imgViewProducts.userInteractionEnabled=YES;
                                       [imgViewProducts addGestureRecognizer:singleTap];
                                       
                                       [self.scrolViewPrductImages addSubview:imgViewProducts];
                                   }
                                   CGRect newTableFrame = self.tableViewPrdAttributes.frame;
                                   
                                   newTableFrame.size.height = [arrProductColorAndSize count] * 36;
                                   self.tableViewPrdAttributes.frame = newTableFrame;
                                   
                                   CGRect viewProductFrame = self.viewPrdAttributes.frame;
                                   
                                   viewProductFrame.origin.y = self.tableViewPrdAttributes.frame.origin.y + self.tableViewPrdAttributes.frame.size.height - 14 ;
                                   
                                   self.viewPrdAttributes.frame = viewProductFrame;
                                   float heightScroll = 1880 + ([arrProductColorAndSize count]-1) * 36;
                                   
                                   if (IS_IPHONE_4)
                                   {
                                       self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, heightScroll+stringHt-375);
                                   }else{
                                       self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, heightScroll+stringHt-300);
                                   }
                                   
                                   [self.tableViewPrdAttributes reloadData];
                               }
                               else
                               {
                                  
                                 
                                   NSMutableArray *mArrayResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   arrProductColorAndSize = [[NSMutableArray alloc]init];
                                   for(NSMutableDictionary *mDict in mArrayResponse)
                                   {
                                       [mDict setValue:@"" forKey:@"prd_Attribute_Title"];
                                       [mDict setValue:@"" forKey:@"prd_option_id"];
                                       [mDict setValue:@"" forKey:@"prd_option_type_id"];
                                       
                                       [mDict setValue:@"0" forKey:@"prd_New_Price"];
                                       
                                       [arrProductColorAndSize addObject:mDict];
                                   }
                                   
                                 
                                   
                                   
                                   if(arrProductColorAndSize.count!=0){
                                       [arrProductColorAndSize removeAllObjects];
                                   }else{
                                       arrProductColorAndSize=[[NSMutableArray alloc] init];
                                   }
                                   
                                   NSMutableArray *optionArray = [mutDictProductDetail valueForKey:@"product_options"] ;
                                   for (int i = 0; i < [optionArray count]; i++) {
                                       
                                       NSMutableDictionary *mDict1=[[NSMutableDictionary alloc] init];
                                       [mDict1 setValue:@"NO"  forKey:@"selecte"];
                                       [mDict1 setValue:[[optionArray objectAtIndex:i] valueForKey:@"custome_title"]  forKey:@"custome_title"];
                                       [mDict1 setValue:[[optionArray objectAtIndex:i] valueForKey:@"product_id"]  forKey:@"product_id"];
                                       [mDict1 setValue:[[optionArray objectAtIndex:i] valueForKey:@"product_title"]  forKey:@"product_title"];
                                       [mDict1 setValue:[[optionArray objectAtIndex:i] valueForKey:@"product_price"]  forKey:@"product_price"];
                                       [mDict1 setObject:[[optionArray objectAtIndex:i] valueForKey:@"custome_values"] forKey:@"custome_values"];
                                       [arrProductColorAndSize addObject:mDict1];
                                   }
                                   

                                   
                                   // //NSLog(@"Responce-- %@",arrProductColorAndSize);
                                   
                                   CGRect newTableFrame = self.tableViewPrdAttributes.frame;
                                   
                                   newTableFrame.size.height = [arrProductColorAndSize count] * 36;
                                   self.tableViewPrdAttributes.frame = newTableFrame;
                                   
                                   CGRect viewProductFrame = self.viewPrdAttributes.frame;
                                   
                                   viewProductFrame.origin.y = self.tableViewPrdAttributes.frame.origin.y + self.tableViewPrdAttributes.frame.size.height - 14 ;
                                   
                                   self.viewPrdAttributes.frame = viewProductFrame;
                                   
                                   float heightScroll = 1880 + ([arrProductColorAndSize count]-1) * 36;
                                
                                   if (IS_IPHONE_4)
                                   {
                                       self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, heightScroll+stringHt-375);
                                   }else{
                                       self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, heightScroll+stringHt-300);
                                   }
                                   [self.tableViewPrdAttributes reloadData];
                                   [hud setHidden:YES];
                                   NSLog(@"Response 2");


                               }
                            //   [MBProgressHUD hideHUDForView:self.view animated:YES];
                           }];
    
    
}
*/
#pragma mark - UIButton Method

- (void) signIn
{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"customer_id"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"subtotal"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    LoginView *gridObj=[[LoginView alloc] init];
    [self.navigationController pushViewController:gridObj animated:YES];
}

- (IBAction)topNavigationSliderAction:(id)sender
{
    if (isVisibleTopView)
    {
        isTablcontent = 0;
        [_tableViewPrdAttributes reloadData];
        [UIView beginAnimations:@"animationOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        //topMenuSliderView.hidden = NO;
        CGRect frame = [topMenuSliderView frame];
        frame.origin.y = -323;
        [topMenuSliderView setFrame:frame];
        CGRect frameScroll = [self.scrollViewProductDetail frame];
        frameScroll.origin.y = 55;
        [self.scrollViewProductDetail setFrame:frameScroll];
        self.scrollViewProductDetail.userInteractionEnabled = YES;
        
        
        //self.scrolViewPrductImages.userInteractionEnabled = YES;
        isVisibleTopView = NO;
        if (isLoadedWebview) {
            CGRect frameScroll = [viewMainWebview frame];
            frameScroll.origin.y = 55;
            viewMainWebview.frame =frameScroll;
        }
        [UIView commitAnimations];
    }
    else
    {
        isTablcontent = 2;
        topMenuSliderView.userInteractionEnabled = YES;
        menuView.userInteractionEnabled = YES;
        [_tableViewTopContent reloadData];
        [UIView beginAnimations:@"animationOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        //topMenuSliderView.hidden = NO;
        CGRect frame = [topMenuSliderView frame];
        frame.origin.y = 0;
        frame.size.width = 320;//Some value
        frame.size.height = 378;//some value
        [topMenuSliderView setFrame:frame];
        CGRect frameScroll = [self.scrollViewProductDetail frame];
        frameScroll.origin.y = 378;
        [self.scrollViewProductDetail setFrame:frameScroll];
        self.scrollViewProductDetail.userInteractionEnabled = NO;
       // self.scrolViewPrductImages.userInteractionEnabled = NO;
        _tableViewPrdAttributes.userInteractionEnabled =YES;
        isVisibleTopView = YES;
        if (isLoadedWebview) {
            CGRect frameScroll = [viewMainWebview frame];
            frameScroll.origin.y = 378;
            viewMainWebview.frame =frameScroll;
        }
        [self.view  bringSubviewToFront:topMenuSliderView];
        [UIView commitAnimations];
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
    [UIView setAnimationDuration:0.4f];
    //topMenuSliderView.hidden = NO;
    CGRect frame = [topMenuSliderView frame];
    frame.origin.y = -323;
    [topMenuSliderView setFrame:frame];
    
    CGRect frameScroll = [self.scrollViewProductDetail frame];
    frameScroll.origin.y = 55;
    [self.scrollViewProductDetail setFrame:frameScroll];
    self.scrollViewProductDetail.userInteractionEnabled = YES;
    
    
    //self.scrolViewPrductImages.userInteractionEnabled = YES;
    isVisibleTopView = NO;
    [UIView commitAnimations];
    
    [self performSelector:@selector(signIn) withObject:nil afterDelay:0.5];
}

- (IBAction)btnSignOutAction:(id)sender
{
      
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Do you want to Sign Out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.tag=101;
    [alert show];
}

- (IBAction)SeacrhButtonPress:(id)sender
{
    isTablcontent = 1;
    isSearch = YES;
    searchView = (SearchView *)[[[NSBundle mainBundle]loadNibNamed:@"SearchView" owner:self options:nil]objectAtIndex:0 ];
    [searchView.btnHideView addTarget:self action:@selector(hideSearchView:) forControlEvents:UIControlEventTouchUpInside];
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign in to save" message:@"You'll need to sign in to view or add to your saved items. Don't worry, you only have to do it once." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Sign in",@"Join",@"Cancel", nil];
        alert.tag = 102;
        [alert show];
    }
}

- (IBAction) btnFavouriteAction:(id)sender
{
    
    NSString *product_id = [[[AppDelegate appDelegate].dataArray objectAtIndex:[sender tag]]objectForKey:@"prd_id"];
    
    if (![self matchFoundForEventId:product_id WithArray:[AppDelegate appDelegate].arrFavourite])
    {
        [[AppDelegate appDelegate].arrFavourite addObject:[[AppDelegate appDelegate].dataArray objectAtIndex:[sender tag]]];
    }
}

- (IBAction)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
   /* if (isVisibleTopView == YES)
    {
        [UIView beginAnimations:@"animationOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        //topMenuSliderView.hidden = NO;
        CGRect frame = [topMenuSliderView frame];
        frame.origin.y = -323;
        [topMenuSliderView setFrame:frame];
        CGRect frameScroll = [self.scrollViewProductDetail frame];
        frameScroll.origin.y = 55;
        [self.scrollViewProductDetail setFrame:frameScroll];
        self.scrollViewProductDetail.userInteractionEnabled = YES;
       // self.scrolViewPrductImages.userInteractionEnabled = YES;
        
        isVisibleTopView = NO;
        [UIView commitAnimations];
        [self performSelector:@selector(backView) withObject:nil afterDelay:0.3];
    }
    else
    {
       // [self.navigationController popViewControllerAnimated:YES];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            //Do not forget to import AnOldViewController.h
            if ([controller isKindOfClass:[ListGridViewController class]]) {
                
                [self.navigationController popToViewController:controller
                                                      animated:YES];
                break;
            }
        }
        
    }*/
    
}

- (void) backView
{
   // [self.navigationController popViewControllerAnimated:YES];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        //Do not forget to import AnOldViewController.h
        if ([controller isKindOfClass:[ListGridViewController class]]) {
            
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
        }
    }
}

-(void)GetCartItemms
{
   
   NSDictionary *param=@{@"cartid":[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"],@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    
            [CartrizeWebservices PostMethodWithApiMethod:@"getitembyshopping" Withparms:param WithSuccess:^(id response)
         {
             
             
             NSMutableDictionary *mDict=[response JSONValue];
             arrayCartData=[[NSMutableArray alloc]init];
             [arrayCartData removeAllObjects];
             arrayCartData =[mDict valueForKey:@"data"];
             
//             if([arrayCartData count]==0)
//                 
//             {
//                 [AppDelegate appDelegate].isCartID=NO;
//                 [[NSNotificationCenter defaultCenter]postNotificationName:@"getCheckOutHistory" object:nil];
//                 
//             }
//             else
//             {
             [[NSUserDefaults standardUserDefaults]setObject:[mDict valueForKey:@"subtotal"] forKey:@"subtotal"];
             //[[NSUserDefaults standardUserDefaults]setObject:arrayCartData forKey:@"arrayCartData"];
             [AppDelegate appDelegate].arrAddToBag=[[NSMutableArray alloc]init];
             [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
             [AppDelegate appDelegate].arrAddToBag=[arrayCartData mutableCopy];
             if([[AppDelegate appDelegate].arrAddToBag count ]>0)
             {
                 lblDownBagCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[AppDelegate appDelegate].arrAddToBag count ]];
             }
             else
             {
                 lblDownBagCount.text=@"0";
                 
             }
             
             [[NSNotificationCenter defaultCenter]postNotificationName:@"kNotificationReloadCartData" object:nil];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             //}
             
         } failure:^(NSError *error)
         {
             //NSLog(@"Error = %@",[error description]);
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }];
    
    
    
    }

- (IBAction)btnAddToBagAction:(id)sender
{
   
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
        
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"IsUserLogin"] boolValue]) {
        
        if ([[mutDictProductDetail valueForKey:@"QTY"] intValue] <= 0)
        {
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"This product is out of stock!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            
            return;
        }
        

        /*
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]isEqualToString:@""]||[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]==nil)
        
    {
        UIAlertView *cartalert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please wait your cart id is being generated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //[cartalert show];
       // return;
    
    }
    */
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"] isEqualToString:@""])
    {
        // Change karna h key===prd_qty
        
        
        if (arrWeight.count != 0) {
            
            if (isSelectWeight == YES) {
                if ([strWeightSelect isEqualToString:_btnOption.titleLabel.text]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Select option." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                else
                {
                    
                }
               
            }
            if (allIndex == 0)
            {
                strOptionId= @"";
                strOptionType = @"";
            }
            else
            {
                strOptionId=[[_mArrayProductAttributes objectAtIndex:weightIndex]valueForKey:@"option_id"];
                strOptionType=[[_mArrayProductAttributes objectAtIndex:weightIndex]valueForKey:@"option_type_id"];
                if(strOptionId==nil)
                {
                strOptionId=@"";
                }
                if(strOptionType==nil)
                {
                    strOptionType=@"";
                }
               
                  
                
            }
        }
        else
        {
            strOptionId= @"";
            strOptionType = @"";
        
        }
        NSLog(@"CartId------->%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]);
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]isEqualToString:@""]||[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]==nil)
        {
            //[self fetchCartId];
            [self cartIdNull];
            
           // [self WebserviceForGetResponseWebview];
            return;
        }
        else
        {
            
            
         BOOL isFound;
            
            if([[AppDelegate appDelegate].arrAddToBag count]!=0)
            {
                int strWeightTtl =[[mutDictProductDetail valueForKey:@"product_weight_title"] intValue];
                if (strWeightTtl == 0)
                {
                    strWeightTtl =[[mutDictProductDetail valueForKey:@"prd_weight"] intValue];
                }
            for(int i=0;i<[[AppDelegate appDelegate].arrAddToBag count];i++)
            {
                NSString *strWiegthTitle =[[[AppDelegate appDelegate].arrAddToBag objectAtIndex:i]valueForKey:@"weight_title_word"];
                if ([strWiegthTitle intValue] == 0) {
                    
                   strWiegthTitle =[[[AppDelegate appDelegate].arrAddToBag objectAtIndex:i]valueForKey:@"prd_weight"];
                }
               
            if([[[[AppDelegate appDelegate].arrAddToBag objectAtIndex:i]valueForKey:@"prd_sku"]isEqualToString:[mutDictProductDetail valueForKey:@"prd_sku"]]&&[[NSString stringWithFormat:@"%d",[strWiegthTitle intValue]]isEqualToString:[NSString stringWithFormat:@"%d",strWeightTtl]])
            {
                isFound = YES;
                int qty;
                NSMutableDictionary *dict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:i];
                
                if([_btncartietms.titleLabel.text isEqualToString:@"----Select Quantity----"])
                {
                    qty=1;
                    
                    
                }
                else
                {
                 qty = [[dict valueForKey:@"prd_qty"] intValue]+[strprdqty intValue];
                }
                //float qtyfloat =(float)qty;
               // float price = qtyfloat*[[dict valueForKey:@"prd_qty"] floatValue];
                
                [dict setValue:[NSString stringWithFormat:@"%d",qty] forKey:@"prd_qty"];
                //[dict setValue:[NSString stringWithFormat:@"%.2f",price] forKey:@"prd_price"];
                [[AppDelegate appDelegate].arrAddToBag replaceObjectAtIndex:i withObject:dict];
                break;
            }
                else
                {
                    isFound = NO;

                }
                
            }
            
            if (isFound == NO) {
                
                
                
                if([_btncartietms.titleLabel.text isEqualToString:@"----Select Quantity----"])
                {
                    [mutDictProductDetail setValue:@"1" forKey:@"prd_qty"];
                    
                    
                }
                
                [[AppDelegate appDelegate].arrAddToBag addObject:[mutDictProductDetail mutableCopy]];
                if([[AppDelegate appDelegate].arrAddToBag count ]>0)
                {
                    lblDownBagCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[AppDelegate appDelegate].arrAddToBag count ]];
                }
                else
                {
                    lblDownBagCount.text=@"0";
                    
                }
                
            }
            }
            else
            {
               
                
                if ([AppDelegate appDelegate].arrAddToBag == nil || [AppDelegate appDelegate].arrAddToBag.count == 0) {
                    
                    [AppDelegate appDelegate].arrAddToBag  =[NSMutableArray new];
                }
                 [[AppDelegate appDelegate].arrAddToBag addObject:[mutDictProductDetail mutableCopy]];
            }
            
            if([[AppDelegate appDelegate].arrAddToBag count ]>0)
            {
                
                lblDownBagCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[AppDelegate appDelegate].arrAddToBag count ]];
            }
            else
            {
                lblDownBagCount.text=@"0";
                
            }
            
            
            
            //Yogendra Girase Added
            float PriceValue=0.0;
            for(int i=0;i<[[AppDelegate appDelegate].arrAddToBag count];i++)
            {
                 NSMutableDictionary *dictCartProduct = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:i];
                float prices=[[dictCartProduct objectForKey:@"prd_qty"] intValue]*[[dictCartProduct valueForKey:@"prd_price"] floatValue];
                PriceValue = PriceValue + prices;
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",PriceValue] forKey:@"subtotal"];
            
           
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
                             NSDictionary *parameters = @{@"prod_id":[mutDictProductDetail valueForKey:@"prd_id"],@"cart_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"],@"prod_sku":[mutDictProductDetail valueForKey:@"prd_sku"],@"optionvalue":strOptionType,@"optionid":strOptionId,@"prod_qty":strprdqty,@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
                
                             
                             [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsAddg" Withparms:parameters WithSuccess:^(id response)
                              {
                                  
                                  NSDictionary *responsedict=[response JSONValue];
                                  
                                  if([[responsedict valueForKey:@"result"]isEqualToString:@"Sucssess"])
                                      
                                  {
                                     
                                     
                                   [self  GetCartItemms];
                                      
                                  }
                                  
                                  [self.scrollViewProductDetail addSubview:popupView];
                                  [self.view bringSubviewToFront:popupView];
                                  
                                  popupView.frame = CGRectMake(10, self.viewPrdAttributes.frame.origin.y - 63, 300, 93);
                                  popupView.hidden = NO;

                                      
                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                

                                                                 //
                                  
                                 
                                  
                              } failure:^(NSError *error)
                              {
                                  
                                  //NSLog(@"Error = %@",[error description]);
                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                              }];
             
            
        
                        // }) ;
            
    
       
    
}
    }
}
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please sign in" message:@"To add item to your bag and make purchases, please sign in or join now" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Sign In",@"Join",@"Cancel", nil];
        alert.tag = 1012;
        [alert show];
           }
}

-(void)cartIdNull
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Shopping cart is generating...";
    hud.dimBackground = NO;
//      NSDictionary *parameters = @{@"prod_id":[mutDictProductDetail valueForKey:@"prd_id"],@"prod_qty":[mutDictProductDetail valueForKey:@"prd_qty"],@"cart_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"],@"prod_sku":[mutDictProductDetail valueForKey:@"prd_sku"]};
    
    if(strPrdOptionId==nil)
    {
        strPrdOptionId=@"";
    
    }
    if(strPrdOptionTypeId==nil)
    {
        strPrdOptionTypeId=@"";
        
    }
    NSLog(@"%@%@%@%@%@%@",[mutDictProductDetail valueForKey:@"prd_id"],[mutDictProductDetail valueForKey:@"prd_sku"],strprdqty,strPrdOptionId,strPrdOptionTypeId,[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]);
    
    NSDictionary *param = @{@"proid":[mutDictProductDetail valueForKey:@"prd_id"],@"sku":[mutDictProductDetail valueForKey:@"prd_sku"],@"qty":strprdqty,@"optid":strPrdOptionId,@"optvalue":strPrdOptionTypeId,@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    
    //[AppDelegate appDelegate].strwebservice =@"WEB";
    [CartrizeWebservices PostMethodWithApiMethod:@"creditcartview1" Withparms:param WithSuccess:^(id response) {
        
        NSDictionary *dict=[response JSONValue];
        
        NSLog(@"Link  is%@",[NSString stringWithFormat:@"%@",[dict valueForKey:@"check_url"]]);
        isLoadedWebview2=YES;
        [self LoadWebviewOnView:[NSString stringWithFormat:@"%@",[dict valueForKey:@"check_url"]]];
          //[self WebserviceForGetResponseWebview];
        // [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];



}

-(void)fetchCartId
{
    NSDictionary *params=@{@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    [CartrizeWebservices PostMethodWithApiMethod:@"getcrtid" Withparms:params WithSuccess:^(id response) {
       
        NSDictionary *dict=[response JSONValue];
        NSLog(@"cartid is from webservice is%@",dict);
        isLoadedWebview3=NO;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([dict valueForKey:@"cart_id"]==[NSNull null]) {
            
            NSLog(@"null");
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cart_id"];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Unable to create your shopping cart please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            
            
        }
        else
        {
            NSLog(@"insert");
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"billing"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"cart_id"] forKey:@"cart_id"];
            
           
               [self GetCartItemms];

            
//            NSDictionary *parameters = @{@"prod_id":[mutDictProductDetail valueForKey:@"prd_id"],@"prod_qty":[mutDictProductDetail valueForKey:@"prd_qty"],@"cart_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"],@"prod_sku":[mutDictProductDetail valueForKey:@"prd_sku"]};
            
            
        /*    BOOL isFound;
            
            
            if([[AppDelegate appDelegate].arrAddToBag count]!=0)
            {
                
                
                for(int i=0;i<[[AppDelegate appDelegate].arrAddToBag count];i++)
                {
                    
                    if([[[[AppDelegate appDelegate].arrAddToBag objectAtIndex:i]valueForKey:@"prd_sku"]isEqualToString:[mutDictProductDetail valueForKey:@"prd_sku"]]&&[[NSString stringWithFormat:@"%@",[[[AppDelegate appDelegate].arrAddToBag objectAtIndex:i]valueForKey:@"prd_weight"]]isEqualToString:[NSString stringWithFormat:@"%@",[mutDictProductDetail valueForKey:@"prd_weight"]]])
                    {
                        isFound = YES;
                        
                        NSMutableDictionary *dict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:i];
                        int qty = [[dict valueForKey:@"prd_qty"] intValue];
                        //float qtyfloat =(float)qty;
                        // float price = qtyfloat*[[dict valueForKey:@"prd_qty"] floatValue];
                        
                        [dict setValue:[NSString stringWithFormat:@"%d",qty] forKey:@"prd_qty"];
                        //[dict setValue:[NSString stringWithFormat:@"%.2f",price] forKey:@"prd_price"];
                        [[AppDelegate appDelegate].arrAddToBag replaceObjectAtIndex:i withObject:dict];
                        break;
                    }
                    else
                    {
                        isFound = NO;
                        
                    }
                    
                }
                
                if (isFound == NO) {
                    [[AppDelegate appDelegate].arrAddToBag addObject:[mutDictProductDetail mutableCopy]];
                    if([[AppDelegate appDelegate].arrAddToBag count ]>0)
                    {
                        lblDownBagCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[AppDelegate appDelegate].arrAddToBag count ]];
                    }
                    else
                    {
                        lblDownBagCount.text=@"0";
                        
                    }
                    
                }
            }
            else
            {
                
                
                if ([AppDelegate appDelegate].arrAddToBag == nil || [AppDelegate appDelegate].arrAddToBag.count == 0) {
                    
                    [AppDelegate appDelegate].arrAddToBag  =[NSMutableArray new];
                }
                [[AppDelegate appDelegate].arrAddToBag addObject:[mutDictProductDetail mutableCopy]];
            }
            
            if([[AppDelegate appDelegate].arrAddToBag count ]>0)
            {
                
                lblDownBagCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[AppDelegate appDelegate].arrAddToBag count ]];
            }
            else
            {
                lblDownBagCount.text=@"0";
                
            }
            
            
            //Yogendra Girase Added
            float PriceValue=0.0;
            for(int i=0;i<[[AppDelegate appDelegate].arrAddToBag count];i++)
            {
                NSMutableDictionary *dictCartProduct = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:i];
                float prices=[[dictCartProduct objectForKey:@"prd_qty"] intValue]*[[dictCartProduct valueForKey:@"prd_price"] floatValue];
                PriceValue = PriceValue + prices;
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",PriceValue] forKey:@"subtotal"];*/
            
//            popupViewSave.hidden = YES;
//            
//            popupView.frame = CGRectMake(10, self.viewPrdAttributes.frame.origin.y - 63, 300, 93);
//            popupView.hidden = NO;
//            [self.scrollViewProductDetail addSubview:popupView];
//            [self.view bringSubviewToFront:popupView];
            
           
                
                
               // [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsAddg" Withparms:parameters WithSuccess:^(id response)
                // {
            
                     /* NSMutableDictionary *mDict = [response JSONValue];
                      NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
                      [userDefualt setObject:[[mDict valueForKey:@"customerdetails"] valueForKey:@"cartid"] forKey:@"cart_id"];
                      //[userDefualt synchronize];
                      NSArray *valArray=[mDict valueForKey:@"ProductDetails"];
                      for(int i=0; i< valArray.count ;i++)
                      {
                      if([[[valArray objectAtIndex:i]valueForKey:@"ProductId"]isEqualToString:strProId])
                      {
                      strweight= [[valArray objectAtIndex:i]valueForKey:@"getRowWeight"];
                      
                      }
                      
                      }*/
                     //[self addToBagProduct:mDict];
                     //             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     //             hud.labelText = @"Please wait...";
                     //             hud.dimBackground = NO;
                     //                                  NSDictionary *param=@{@"cartid":[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]};
                     //                                  NSDictionary *strResponse=[response JSONValue];
                     //                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                     // hud.hidden = YES;
                     
                     
                     
                     //             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                     //
                     //
                     //             });
                     //
                     //             [[AppDelegate appDelegate].arrAddToBag count];
                     //             [AppDelegate appDelegate].arrAddToBag=[[NSMutableArray alloc]init];
                     //             [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
                     //             [AppDelegate appDelegate].arrAddToBag=[strResponse valueForKey:@"data"];
                     
                     // [self getYourBagItem];
                     //             if (([[strResponse valueForKey:@"result"]isEqualToString:@"sucsess"])) {
                     /*
                      popupViewSave.hidden = YES;
                      
                      popupView.frame = CGRectMake(10, self.viewPrdAttributes.frame.origin.y - 63, 300, 93);
                      popupView.hidden = NO;
                      [self.scrollViewProductDetail addSubview:popupView];
                      [self.view bringSubviewToFront:popupView];
                      */
                     
                     //[AppDelegate appDelegate].requestFor = ADDPRODUCT;
                     
                     //                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                     //
                     //
                     //                 [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsget" Withparms:param WithSuccess:^(id response)
                     //                  {
                     //                      /* NSMutableDictionary *mDict = [response JSONValue];
                     //                       NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
                     //                       [userDefualt setObject:[[mDict valueForKey:@"customerdetails"] valueForKey:@"cartid"] forKey:@"cart_id"];
                     //                       //[userDefualt synchronize];
                     //                       NSArray *valArray=[mDict valueForKey:@"ProductDetails"];
                     //                       for(int i=0; i< valArray.count ;i++)
                     //                       {
                     //                       if([[[valArray objectAtIndex:i]valueForKey:@"ProductId"]isEqualToString:strProId])
                     //                       {
                     //                       strweight= [[valArray objectAtIndex:i]valueForKey:@"getRowWeight"];
                     //
                     //                       }
                     //
                     //                       }*/
                     //
                     //                      NSMutableDictionary *mDict=[response JSONValue];
                     //                      arrayCartData=[[NSMutableArray alloc]init];
                     //                      [arrayCartData removeAllObjects];
                     //                      arrayCartData =[mDict valueForKey:@"data"];
                     //
                     //                      [[NSUserDefaults standardUserDefaults]setObject:[mDict valueForKey:@"subtotal"] forKey:@"subtotal"];
                     //                      //[[NSUserDefaults standardUserDefaults]setObject:arrayCartData forKey:@"arrayCartData"];
                     //                      [AppDelegate appDelegate].arrAddToBag=[[NSMutableArray alloc]init];
                     //                      [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
                     //                      [AppDelegate appDelegate].arrAddToBag=arrayCartData;
                     //                      if([[AppDelegate appDelegate].arrAddToBag count ]>0)
                     //                      {
                     //                          lblDownBagCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[AppDelegate appDelegate].arrAddToBag count ]];
                     //                      }
                     //                      else
                     //                      {
                     //                          lblDownBagCount.text=@"0";
                     //
                     //                      }
                     //
                     //                      popupViewSave.hidden = YES;
                     //                      popupView.frame = CGRectMake(10, self.viewPrdAttributes.frame.origin.y - 63, 300, 93);
                     //                      popupView.hidden = NO;
                     //                      [self.scrollViewProductDetail addSubview:popupView];
                     //                      [self.view bringSubviewToFront:popupView];
                     //
                     //                      [AppDelegate appDelegate].requestFor = ADDPRODUCT;
                     //                        //[self addToBagProduct:mDict];
                     //                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     //
                     //                  } failure:^(NSError *error)
                     //                  {
                     //                      //NSLog(@"Error = %@",[error description]);
                     //                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                     //                  }];
                     //                 });
                     //
                     //                [MBProgressHUD hideHUDForView:self.view animated:YES];
                     // }
                     
                     
                // } failure:^(NSError *error)
                // {
                     //NSLog(@"Error = %@",[error description]);
                     //[MBProgressHUD hideHUDForView:self.view animated:YES];
                 //}];
                
            
            
            
            
            
            
        
            //[self AddingProductToBag];
            //[self AddToBagIfCartIsNull]
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
            
        }
        
     
     
    } failure:^(NSError *error)
     {
         ////NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
    
    
}
-(void)AddingProductToBag
{
    NSDictionary *parameters = @{@"prod_id":[mutDictProductDetail valueForKey:@"prd_id"],@"prod_qty":[mutDictProductDetail valueForKey:@"prd_qty"],@"cart_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"],@"prod_sku":[mutDictProductDetail valueForKey:@"prd_sku"]};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsAddg" Withparms:parameters WithSuccess:^(id response)
     {
         /* NSMutableDictionary *mDict = [response JSONValue];
          NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
          [userDefualt setObject:[[mDict valueForKey:@"customerdetails"] valueForKey:@"cartid"] forKey:@"cart_id"];
          //[userDefualt synchronize];
          NSArray *valArray=[mDict valueForKey:@"ProductDetails"];
          for(int i=0; i< valArray.count ;i++)
          {
          if([[[valArray objectAtIndex:i]valueForKey:@"ProductId"]isEqualToString:strProId])
          {
          strweight= [[valArray objectAtIndex:i]valueForKey:@"getRowWeight"];
          
          }
          
          }*/
         //[self addToBagProduct:mDict];
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         hud.labelText = @"Please wait...";
         hud.dimBackground = NO;
        NSDictionary *param=@{@"cartid":[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"],@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
         NSDictionary *strResponse=[response JSONValue];
         if (([[strResponse valueForKey:@"result"]isEqualToString:@"sucsess"])) {
            
             [CartrizeWebservices PostMethodWithApiMethod:@"getitembyshopping" Withparms:param WithSuccess:^(id response)
              {
                  /* NSMutableDictionary *mDict = [response JSONValue];
                   NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
                   [userDefualt setObject:[[mDict valueForKey:@"customerdetails"] valueForKey:@"cartid"] forKey:@"cart_id"];
                   //[userDefualt synchronize];
                   NSArray *valArray=[mDict valueForKey:@"ProductDetails"];
                   for(int i=0; i< valArray.count ;i++)
                   {
                   if([[[valArray objectAtIndex:i]valueForKey:@"ProductId"]isEqualToString:strProId])
                   {
                   strweight= [[valArray objectAtIndex:i]valueForKey:@"getRowWeight"];
                   
                   }
                   
                   }*/
                  
                  NSMutableDictionary *mDict=[response JSONValue];
                  arrayCartData=[[NSMutableArray alloc]init];
                  [arrayCartData removeAllObjects];
                  arrayCartData =[mDict valueForKey:@"data"];
                  
                  [[NSUserDefaults standardUserDefaults]setObject:[mDict valueForKey:@"subtotal"] forKey:@"subtotal"];
                  //[[NSUserDefaults standardUserDefaults]setObject:arrayCartData forKey:@"arrayCartData"];
                  [AppDelegate appDelegate].arrAddToBag=[[NSMutableArray alloc]init];
                  [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
                  [AppDelegate appDelegate].arrAddToBag=arrayCartData;
                  if([[AppDelegate appDelegate].arrAddToBag count ]>0)
                  {
                      lblDownBagCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[AppDelegate appDelegate].arrAddToBag count ]];
                  }
                  else
                  {
                      lblDownBagCount.text=@"0";
                      
                  }
                  
                  popupViewSave.hidden = YES;
                  popupView.frame = CGRectMake(10, self.viewPrdAttributes.frame.origin.y - 63, 300, 93);
                  popupView.hidden = NO;
                  [self.scrollViewProductDetail addSubview:popupView];
                  [self.view bringSubviewToFront:popupView];
                  
                  [AppDelegate appDelegate].requestFor = ADDPRODUCT;
                  //[self addToBagProduct:mDict];
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                  
              } failure:^(NSError *error)
              {
                  //NSLog(@"Error = %@",[error description]);
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              }];
             
             
             
         }
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error = %@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];

}

-(void)addToBagProduct :(NSMutableDictionary *)CartParam
{
    
    // [[AppDelegate appDelegate] getCheckOutHistory];
    
    NSString *product_id = [mutDictProductDetail objectForKey:@"prd_id"];
    BOOL isUpdateQty = NO;
    
    // if (![self matchFoundForEventId:product_id WithArray:[AppDelegate appDelegate].arrAddToBag])
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = NO;
    iRequest = 3;
    //[[AppDelegate appDelegate].arrFavourite addObject:[[AppDelegate appDelegate].dataArray objectAtIndex:[sender tag]]];
    
    for (NSMutableDictionary *mDictBag in [AppDelegate appDelegate].arrAddToBag)
    {
        if([[mDictBag valueForKey:@"prd_id"]isEqualToString:[mutDictProductDetail valueForKeyPath:@"prd_id"]])
        {
            NSString *jsonString = [mDictBag valueForKey:@"option_json_value"];
            //NSMutableArray *optionArray = [jsonString JSONValue];
            NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
           
            if (allIndex!=0)
            {
                for(NSMutableDictionary *mDict in arrWeight)
                {
                    //                NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
                    //                // //NSLog(@"prd_Attribute_Title =%@",[mDict valueForKey:@"prd_Attribute_Title"]);
                    //
                    //                [jsonDict setValue:[mDict valueForKey:@"prd_Attribute_Title"] forKey:@"option_value"];
                    //                [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
                    //                [jsonDict setValue:[mDict valueForKey:@"prd_option_id"] forKey:@"option_id"];
                    //                [jsonDict setValue:[mDict valueForKey:@"prd_option_type_id"] forKey:@"option_type_id"];
                    //                if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
                    //                {
                    //                    [jsonArray addObject:jsonDict];
                    //                }
                    
                    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
                    [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:allIndex-1] valueForKey:@"title"] forKey:@"option_value"];
                    [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
                    [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:allIndex-1] valueForKey:@"option_id"] forKey:@"option_id"];
                    [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:allIndex-1] valueForKey:@"option_type_id"] forKey:@"option_type_id"];
                    if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
                    {
                        [jsonArray addObject:jsonDict];
                    }
                }
            }
            
            NSError *writeError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&writeError];
            
            NSString *jsonString1 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            if([jsonString1 isEqualToString:jsonString])
            {
                int qty = [[mDictBag valueForKey:@"prd_qty"] intValue];
                qty = qty + [[mutDictProductDetail valueForKey:@"prd_qty"] intValue];
                
                NSString *strQty = [NSString stringWithFormat:@"%d",qty];
                
                NSString *strUniqID = @"";
                
                for (NSMutableDictionary *mDictPrdDetail in [CartParam objectForKey:@"ProductDetails"])
                {
                    if([[mDictPrdDetail valueForKey:@"ProductId"] isEqualToString:product_id])
                    {
                        if([[mDictPrdDetail valueForKey:@"ItemId"] isEqualToString:[mDictBag valueForKey:@"uniq_id"]])
                        {
                            strUniqID = [mDictPrdDetail valueForKey:@"ItemId"];
                        }
                    }
                }
                isUpdateQty = YES;
                NSString *strPrice = [lblProductPrice.text substringFromIndex:1];

                //DIPESH WADEKAR.
//                NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":strQty,@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":strUniqID,@"prd_default_price":[mutDictProductDetail valueForKey:@"prd_price"],@"prd_update_price":strPrice,@"get":@"1"};
                
                               NSDictionary *parameters = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"], @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[mutDictProductDetail objectForKey:@"prd_qty"],@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":strUniqID, @"prd_default_price":[mutDictProductDetail valueForKey:@"prd_price"],@"prd_update_price":strPrice, @"weight":strweight, @"get":@"1"};
                
                 // NSDictionary *parameters = @{@"cart_id": @"300", @"customer_id": @"332",@"prd_qty":@"1",@"product_id":@"860",@"option_json_value":@"[\n  {\n    \"option_id\" : \"486\",\n    \"option_type_id\" : \"686\",\n    \"option_name\" : \"Weight\",\n    \"option_value\" : \"10 oz \"\n  }\n]",@"uniq_id":@"1085", @"prd_default_price":@"2.49",@"prd_update_price":@"2.49", @"weight":@"3", @"get":@"1"};
                
        //check out histroy 1
                [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
                 {
                     // //NSLog(@"Response = %@",[response JSONValue]);
                     // //NSLog(@"jsonString = %@",jsonString);
                 
                     popupViewSave.hidden = YES;
                     popupView.frame = CGRectMake(10, self.viewPrdAttributes.frame.origin.y - 63, 300, 93);
                     popupView.hidden = NO;
                     [self.scrollViewProductDetail addSubview:popupView];
                     [self.view bringSubviewToFront:popupView];
                     
                     [AppDelegate appDelegate].requestFor = ADDPRODUCT;
                     [[AppDelegate appDelegate] getCheckOutHistory];
                     //self.arrAddToBag = [response JSONValue];
                 } failure:^(NSError *error)
                 {
                     //NSLog(@"Error =%@",[error description]);
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }];
            }
            
        }
    }
    if(!isUpdateQty)
    {
        NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
        if (allIndex !=0)
        {
            for(NSMutableDictionary *mDict in arrWeight)
            {
                //            NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
                //            // //NSLog(@"prd_Attribute_Title =%@",[mDict valueForKey:@"prd_Attribute_Title"]);
                //            [jsonDict setValue:[mDict valueForKey:@"prd_Attribute_Title"] forKey:@"option_value"];
                //            [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
                //            [jsonDict setValue:[mDict valueForKey:@"prd_option_id"] forKey:@"option_id"];
                //            [jsonDict setValue:[mDict valueForKey:@"prd_option_type_id"] forKey:@"option_type_id"];
                //            if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
                //            {
                //                [jsonArray addObject:jsonDict];
                //            }
                
                NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
                
                [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:allIndex-1] valueForKey:@"title"] forKey:@"option_value"];
                [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
                [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:allIndex-1] valueForKey:@"option_id"] forKey:@"option_id"];
                [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:allIndex-1] valueForKey:@"option_type_id"] forKey:@"option_type_id"];
                if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
                {
                    [jsonArray addObject:jsonDict];
                    
                }
            }
        }
        
        NSError *writeError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&writeError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //  //NSLog(@"JSON Output: %@", jsonString);
        
        NSString *strPrice = [lblProductPrice.text substringFromIndex:1];
        
        for (NSMutableDictionary *mDictPrdDetail in [CartParam objectForKey:@"ProductDetails"])
        {
            // item id and product id match with
            //NSLog(@"%@",[NSString stringWithFormat:@"p_id==%@\ni_id==%@",[mDictPrdDetail objectForKey:@"ProductId"],[mDictPrdDetail objectForKey:@"ItemId"]]);
            BOOL CheckIfMatch =NO;
            BOOL notmatch;
            for(NSMutableDictionary *mDictBag in [AppDelegate appDelegate].arrAddToBag)
            {
                //NSLog(@"%@",[NSString stringWithFormat:@"p_id==%@\ni_id==%@",[mDictBag valueForKey:@"prd_id"],[mDictBag valueForKey:@"uniq_id"]]);
                
                if ([[mDictPrdDetail objectForKey:@"ProductId"]isEqualToString:[mDictBag valueForKey:@"prd_id"]]&&[[mDictPrdDetail objectForKey:@"ItemId"]isEqualToString:[mDictBag valueForKey:@"uniq_id"]])
                {
                    //NSLog(@"found one item");
                    CheckIfMatch=YES;
                    notmatch=NO;
                    break;
                }
                else if ([[mDictPrdDetail objectForKey:@"ProductId"]isEqualToString:[mDictBag valueForKey:@"prd_id"]]&&![[mDictPrdDetail objectForKey:@"ItemId"]isEqualToString:[mDictBag valueForKey:@"uniq_id"]])
                {
                    //NSLog(@"product_id same but item id deffrent");
                    if (CheckIfMatch==YES)
                    {
                        notmatch=NO;
                    }
                    else
                    {
                        notmatch=YES;
                    }
                }
            }
            if (CheckIfMatch==YES&&notmatch==NO)
            {
                //NSLog(@"Finaly Found once more a object");
                // dont upload this item in add to bag;
                
                NSLog(@"Item already exist in the Bag");
            }
            else
            {
                 NSLog(@"Item doesnot exist in the Bag");
                //DIPESH.++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                // arr add object
                //NSLog(@"After round 1 to match array no found object");
                // we can add this object
//                NSDictionary *parameters = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"], @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[mutDictProductDetail objectForKey:@"prd_qty"],@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":[mDictPrdDetail valueForKey:@"ItemId"],@"prd_default_price":[mutDictProductDetail valueForKey:@"prd_price"],@"prd_update_price":strPrice, @"weight":[[CartParam valueForKey:@"ProductDetails"] valueForKey:@"getRowWeight"], @"get":@"1"};
                
                //@Uday Parameters
                  NSDictionary *parameters = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"], @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[mutDictProductDetail  objectForKey:@"prd_qty"],@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":[mDictPrdDetail valueForKey:@"ItemId"],@"prd_default_price":strPrice,@"prd_update_price":strPrice, @"weight":strweight, @"get":@"1",@"updated_at":[mutDictProductDetail valueForKey:@"product_update_date"]};
                
              //  NSDictionary *parameters = @{@"cart_id": @"300", @"customer_id": @"332",@"prd_qty":@"1",@"product_id":@"860",@"option_json_value":@"[\n  {\n    \"option_id\" : \"486\",\n    \"option_type_id\" : \"686\",\n    \"option_name\" : \"Weight\",\n    \"option_value\" : \"10 oz \"\n  }\n]",@"uniq_id":@"1085", @"prd_default_price":@"2.49",@"prd_update_price":@"2.49", @"weight":@"3", @"get":@"1"};
  //usercheckout histroy 2
                
                [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
                 {
                     // //NSLog(@"Response = %@",[response JSONValue]);
                     // //NSLog(@"jsonString = %@",jsonString);
                     
                     popupViewSave.hidden = YES;
                     popupView.frame = CGRectMake(10, self.viewPrdAttributes.frame.origin.y - 63, 300, 93);
                     popupView.hidden = NO;
                     [self.scrollViewProductDetail addSubview:popupView];
                     [self.view bringSubviewToFront:popupView];
                     
                     
                     [AppDelegate appDelegate].requestFor = ADDPRODUCT;
                     [[AppDelegate appDelegate] getCheckOutHistory];
                     
                 } failure:^(NSError *error)
                 {
                     //NSLog(@"Error =%@",[error description]);
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }];
            }
             break;
        }
    }
}

- (IBAction) btnViewBagAction:(id)sender
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

- (IBAction) btnSaveLaterAction:(id)sender
{
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"] isEqualToString:@""])
    {
        BOOL isUpdateQty = NO;
        for (NSMutableDictionary *mDictFav in [AppDelegate appDelegate].arrFavourite)
        {
            if([[mDictFav valueForKey:@"prd_id"]isEqualToString:[mutDictProductDetail valueForKeyPath:@"prd_id"]])
            {
                NSString *jsonString = [mDictFav valueForKey:@"option_json_value"];
                
                //NSMutableArray *optionArray = [jsonString JSONValue];
                
                NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
                
                for(NSMutableDictionary *mDict in arrProductColorAndSize)
                {
                    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
                    // //NSLog(@"prd_Attribute_Title =%@",[mDict valueForKey:@"prd_Attribute_Title"]);
                    [jsonDict setValue:[mDict valueForKey:@"prd_Attribute_Title"] forKey:@"option_value"];
                    [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
                    [jsonDict setValue:[mDict valueForKey:@"prd_option_id"] forKey:@"option_id"];
                    [jsonDict setValue:[mDict valueForKey:@"prd_option_type_id"] forKey:@"option_type_id"];
                    if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
                    {
                        [jsonArray addObject:jsonDict];
                    }
                }
                
                if (allIndex !=0)
                {
                    for(NSMutableDictionary *mDict in arrWeight)
                    {
                        //            NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
                        //                // //NSLog(@"prd_Attribute_Title =%@",[mDict valueForKey:@"prd_Attribute_Title"]);
                        //            [jsonDict setValue:[mDict valueForKey:@"prd_Attribute_Title"] forKey:@"option_value"];
                        //            [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
                        //            [jsonDict setValue:[mDict valueForKey:@"prd_option_id"] forKey:@"option_id"];
                        //            [jsonDict setValue:[mDict valueForKey:@"prd_option_type_id"] forKey:@"option_type_id"];
                        //            if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
                        //                {
                        //                [jsonArray addObject:jsonDict];
                        //                }
                        NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
                        [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:allIndex-1] valueForKey:@"title"] forKey:@"option_value"];
                        [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
                        [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:allIndex-1] valueForKey:@"option_id"] forKey:@"option_id"];
                        [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:allIndex-1] valueForKey:@"option_type_id"] forKey:@"option_type_id"];
                        if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
                        {
                            [jsonArray addObject:jsonDict];
                        }
                    }
                }
                NSError *writeError = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&writeError];
                NSString *jsonString1 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                if([jsonString1 isEqualToString:jsonString])
                {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.labelText = @"Please wait...";
                    hud.dimBackground = NO;
                    
                    int qty = [[mDictFav valueForKey:@"prd_qty"] intValue];
                    qty = qty + [[mutDictProductDetail valueForKey:@"prd_qty"] intValue];
                    NSString *strQty = [NSString stringWithFormat:@"%d",qty];
                    
                    isUpdateQty = YES;
                    NSString *strPrice = [lblProductPrice.text substringFromIndex:1];
                    NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":strQty,@"product_id":[mutDictProductDetail valueForKey:@"prd_id"],@"option_json_value":jsonString,@"uniq_id":[mDictFav valueForKey:@"uniq_id"],@"prd_default_price":[mutDictProductDetail valueForKey:@"prd_price"],@"prd_update_price":strPrice,@"get":@"1"};
                                        [CartrizeWebservices PostMethodWithApiMethod:@"GetUserFavoriteHistory" Withparms:parameters WithSuccess:^(id response)
                     {
                         // //NSLog(@"Response = %@",[response JSONValue]);
                         [AppDelegate appDelegate].requestFor = ADDFAVORITES;
                         [[AppDelegate appDelegate] getFavoriteHistory];
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         popupViewSave.frame = CGRectMake(10, self.viewPrdAttributes.frame.origin.y - 30, 300, 93);
                         popupViewSave.hidden = NO;
                         [self.scrollViewProductDetail addSubview:popupViewSave];
                         [self.view bringSubviewToFront:popupViewSave];
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         //self.arrAddToBag = [response JSONValue];
                     } failure:^(NSError *error)
                     {
                         //NSLog(@"Error =%@",[error description]);
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                     }];
                }
            }
        }
        
        if(!isUpdateQty)
        {
            NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
            
            for(NSMutableDictionary *mDict in arrProductColorAndSize)
            {
                NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
                // //NSLog(@"prd_Attribute_Title =%@",[mDict valueForKey:@"prd_Attribute_Title"]);
                [jsonDict setValue:[mDict valueForKey:@"prd_Attribute_Title"] forKey:@"option_value"];
                [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
                [jsonDict setValue:[mDict valueForKey:@"prd_option_id"] forKey:@"option_id"];
                [jsonDict setValue:[mDict valueForKey:@"prd_option_type_id"] forKey:@"option_type_id"];
                if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
                {
                    [jsonArray addObject:jsonDict];
                }
            }
           
            if (allIndex !=0)
            {
                for(NSMutableDictionary *mDict in arrWeight)
                {
                    //            NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
                    //                // //NSLog(@"prd_Attribute_Title =%@",[mDict valueForKey:@"prd_Attribute_Title"]);
                    //            [jsonDict setValue:[mDict valueForKey:@"prd_Attribute_Title"] forKey:@"option_value"];
                    //            [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
                    //            [jsonDict setValue:[mDict valueForKey:@"prd_option_id"] forKey:@"option_id"];
                    //            [jsonDict setValue:[mDict valueForKey:@"prd_option_type_id"] forKey:@"option_type_id"];
                    //            if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
                    //                {
                    //                [jsonArray addObject:jsonDict];
                    //                }
                    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
                    [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:allIndex-1] valueForKey:@"title"] forKey:@"option_value"];
                    [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
                    [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:allIndex-1] valueForKey:@"option_id"] forKey:@"option_id"];
                    [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:allIndex-1] valueForKey:@"option_type_id"] forKey:@"option_type_id"];
                    if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
                    {
                        [jsonArray addObject:jsonDict];
                    }
                }
                
            }

            
            
            NSError *writeError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&writeError];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            //  //NSLog(@"JSON Output: %@", jsonString);
            
            int randomNumber = arc4random() % 999999;
            
            // //NSLog(@"Random No = %d",randomNumber);
            NSString *strPrice = [lblProductPrice.text substringFromIndex:1];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Please wait...";
            hud.dimBackground = NO;
            
            NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[mutDictProductDetail objectForKey:@"prd_qty"],@"product_id":[mutDictProductDetail objectForKey:@"prd_id"],@"option_json_value":jsonString,@"uniq_id":[NSString stringWithFormat:@"%d",randomNumber],@"prd_default_price":[mutDictProductDetail valueForKey:@"prd_price"],@"prd_update_price":strPrice,@"get":@"1"};
            
            [CartrizeWebservices PostMethodWithApiMethod:@"GetUserFavoriteHistory" Withparms:parameters WithSuccess:^(id response)
             {
                 NSLog(@"Response = %@",[response JSONValue]);
                 [AppDelegate appDelegate].requestFor = ADDFAVORITES;
                 [[AppDelegate appDelegate] getFavoriteHistory];
                 //self.arrAddToBag = [response JSONValue];
             } failure:^(NSError *error)
             {
                 //NSLog(@"Error =%@",[error description]);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign in to save" message:@"To save this and other items, please sign in or join iShop now." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Sign in",@"Join",@"Cancel", nil];
        alert.tag = 102;
        [alert show];
    }
}

-(void)addFavoriteProduct:(NSNotification *)notification
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    popupViewSave.frame = CGRectMake(10, self.viewPrdAttributes.frame.origin.y - 30, 300, 93);
    popupViewSave.hidden = NO;
    [self.scrollViewProductDetail addSubview:popupViewSave];
    [self.view bringSubviewToFront:popupViewSave];
}


- (IBAction) btnViewSavedItemAction:(id)sender
{
    FavouriteViewController *objFavouriteViewController = [[FavouriteViewController alloc]initWithNibName:@"FavouriteViewController" bundle:nil];
   // [self presentViewController:objFavouriteViewController animated:YES completion:nil];
    [self.navigationController pushViewController:objFavouriteViewController animated:NO];
}

- (BOOL)matchFoundForEventId:(NSString *)eventId WithArray:(NSMutableArray *)ConditionArray
{
    index = 0;
    for (NSDictionary *dataDict in ConditionArray)
    {
        NSString *createId = [dataDict objectForKey:@"prd_id"];
        if ([eventId isEqualToString:createId])
        {
            return YES;
        }
        index++;
    }
    return NO;
}

-(BOOL)matchFoundForProductId:(NSString *)productId
{
    index1 = 0;
    for (NSDictionary *dataDict in [AppDelegate appDelegate].arrFavourite)
    {
        NSString *createId = [dataDict objectForKey:@"prd_id"];
        if ([productId isEqualToString:createId])
        {
            return YES;
        }
        index1++;
    }
    return NO;
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
              [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cart_id"];//fbuserid
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"fbuserid"];
             [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"email"];
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"firstname"];
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"lastname"];
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

#pragma mark --ALERT DELEGATE
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == 101 || alertView.tag == 102)
    {
        if (buttonIndex == 0)
        {
            [self Logout];
           
           
        }
        else if(buttonIndex == 1)
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
    }
    else if (alertView.tag == 1000)
    {
        if(buttonIndex == 0)
        {
            BillingAddressViewController *objBillingAddressViewController;
            if (IS_IPHONE5)
            {
                objBillingAddressViewController = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController" bundle:nil];
            }
            else
            {
                objBillingAddressViewController = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController1" bundle:nil];
            }
            
            objBillingAddressViewController.requestFor = ADDTOCARTPAYMENT;
            
            objBillingAddressViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:objBillingAddressViewController animated:YES];
        }
        if(buttonIndex == 1)
        {
            if([self Trim:txtFieldCoupon.text].length == 0 )
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter coupon code" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Please wait...";
            hud.dimBackground = NO;
            NSDictionary *parameters = @{@"CartId":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],@"coupon":txtFieldCoupon.text};
            
            [CartrizeWebservices PostMethodWithApiMethod:@"ApplyCouponAdd" Withparms:parameters WithSuccess:^(id response)
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coupon Applied" message:@"You can cancel coupon or continue." delegate:self cancelButtonTitle:@"Cancel Coupon" otherButtonTitles:@"Continue", nil];
                 alert.tag = 8888;
                 alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                 txtFieldCoupon = [alert textFieldAtIndex:0];
                 [alert show];
                 
             } failure:^(NSError *error)
             {
                 //NSLog(@"Error = %@",[error description]);
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter valid coupon code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 alert.tag = 9999;
                 [alert show];
                 
             }];
        }
    }
    else if (alertView.tag == 9999)
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Discount Codes" message:@"Enter your coupon code if you have one." delegate:self cancelButtonTitle:@"Skip" otherButtonTitles:@"Apply Coupon", nil];
        av.tag = 1000;
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        txtFieldCoupon = [av textFieldAtIndex:0];
        txtFieldCoupon.delegate = self;
        [av show];
    }
    else if(alertView.tag==6789)
    {
    
        GridViewController *listGridViewController =[[GridViewController alloc]initWithNibName:@"GridViewController" bundle:nil];
        [self.navigationController pushViewController:listGridViewController animated:YES];
    
    }
    else if (alertView.tag == 8888)
    {
        if(buttonIndex == 0)
        {
            if([self Trim:txtFieldCoupon.text].length == 0 )
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter coupon code" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Please wait...";
            hud.dimBackground = NO;
            
            NSDictionary *parameters = @{@"CartId":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],@"coupon":txtFieldCoupon.text};
            
            [CartrizeWebservices PostMethodWithApiMethod:@"RemoveCouponAdd" Withparms:parameters WithSuccess:^(id response)
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 BillingAddressViewController *objBillingAddressViewController;
                 if (IS_IPHONE5)
                 {
                     objBillingAddressViewController = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController" bundle:nil];
                 }
                 else
                 {
                     objBillingAddressViewController = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController1" bundle:nil];
                 }
                 objBillingAddressViewController.requestFor = ADDTOCARTPAYMENT;
                 objBillingAddressViewController.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:objBillingAddressViewController animated:YES];
             } failure:^(NSError *error)
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 //NSLog(@"Error = %@",[error description]);
             }];
        }
        else if(buttonIndex == 1)
        {
            BillingAddressViewController *objBillingAddressViewController;
            if (IS_IPHONE5)
            {
                objBillingAddressViewController = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController" bundle:nil];
            }
            else
            {
                objBillingAddressViewController = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController1" bundle:nil];
            }
            objBillingAddressViewController.requestFor = ADDTOCARTPAYMENT;
            objBillingAddressViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:objBillingAddressViewController animated:YES];
        }
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
            objRegistrationViewController.strCheckViewControler = @"ProducatDetail";
            [self.navigationController pushViewController:objRegistrationViewController animated:YES];
        }
        else if(buttonIndex==0)
        {
            LoginView *objLoginView;
                            objLoginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
             objLoginView.strCheckViewControler = @"ProducatDetail";
            [self.navigationController pushViewController:objLoginView animated:YES];
        
        
        }
        else
        {
            [alertView dismissWithClickedButtonIndex:2 animated:YES];

        
        }
    
    }
    else
    {   //MANOJ
        if(buttonIndex == 1)
        {
            [AppDelegate appDelegate].isUserLogin = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRemember"];
            
            [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
            [self getYourBagItem];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"customer_id"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"firstname"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"lastname"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"email"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cart_id"];

            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"RememberEmail"];
              [[NSUserDefaults standardUserDefaults] synchronize];
            
            
//            [AppDelegate appDelegate].isUserLogin = NO;
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRemember"];
//            [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
//            [self getYourBagItem];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"customer_id"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"firstname"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"lastname"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"email"];
//            
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"RememberEmail"];
//            [[NSUserDefaults standardUserDefaults] synchronize];

            
            
            
            
            
            self.btnSignIn.hidden = YES;
            self.btnSignOut.hidden = YES;
            self.btnJoin.hidden = YES;
            self.btnMyAccount.hidden = YES;
            lblWelcomeuser.text = @"Welcome to CardRize";
            
            
            if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[LoginView class]]) {
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
            else
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }

            
        }
    }
}

/************************************************
 Method				:	Trim
 Purpose			:	Trim ANy String from front and back
 Parameters			:	restult String
 Return Value		:	String
 Default			:	NO
 ************************************************/
-(NSString*)Trim:(NSString*)value
{
	value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return value;
}


- (IBAction) btnCheckOutAction:(id)sender
{
     if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"] isEqualToString:@""]){
        isCheckOut = YES;
        [self setCustomerToCart];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"customer_id"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"subtotal"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        LoginView *gridObj=[[LoginView alloc] init];
        [self.navigationController pushViewController:gridObj animated:YES];
    }
}

//NEW TASK START

- (void) setCustomerToCart
{
    
    
    // by me
    

   float Price_Product=[[[NSUserDefaults standardUserDefaults]valueForKey:@"subtotal"]floatValue ];
    
       if(Price_Product>=50)
    {
        BillingAddressViewController *objBillingAddressViewController;
        if (IS_IPHONE_4)
        {
            objBillingAddressViewController = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController1" bundle:nil];
        }else
        {
            objBillingAddressViewController = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController" bundle:nil];
        }
        objBillingAddressViewController.requestFor = ADDTOCARTPAYMENT;
        objBillingAddressViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:objBillingAddressViewController animated:YES];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Message" message:[NSString stringWithFormat:@"The delivery can not be done for the order below $50, your order amount is %@ %.02f",[AppDelegate appDelegate].currencySymbol,[[mutDictProductDetail valueForKey:@"prd_price"] floatValue]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];

    }
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"Please wait...";
//    hud.dimBackground = NO;
//    [AppDelegate appDelegate].strCustomerPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordSave"];
//    
//    //  //NSLog(@"strCustomerPassword -- %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"passwordSave"]);
//    //[AppDelegate appDelegate].strCartId = @"625";
//     NSDictionary *parameters = @{@"customer_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"],@"email":[[NSUserDefaults standardUserDefaults] objectForKey:@"email"],@"firstname":[[NSUserDefaults standardUserDefaults] valueForKey:@"firstname"],@"lastname":[[NSUserDefaults standardUserDefaults] valueForKey:@"lastname"],@"password":[AppDelegate appDelegate].strCustomerPassword,@"CartId":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
//    
//    [CartrizeWebservices PostMethodWithApiMethod:@"SetCustomerIntoCart" Withparms:parameters WithSuccess:^(id response)
//     {
//         // //NSLog(@"Add Product Response= %@",[response JSONValue]);
//         NSMutableDictionary *mDict = [response JSONValue];
//         // strCartId = [mDict valueForKey:@"CartId"];
//         // [self setCustomerToCart];
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//     
//        NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
//        [userDefualt setObject:[mDict objectForKey:@"value"] forKey:@"cart_id"];
//        [userDefualt synchronize];
//     
//         UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Discount Codes" message:@"Enter your coupon code if you have one." delegate:self cancelButtonTitle:@"Skip" otherButtonTitles:@"Apply Coupon", nil];
//         av.tag = 1000;
//         av.alertViewStyle = UIAlertViewStylePlainTextInput;
//         txtFieldCoupon = [av textFieldAtIndex:0];
//         txtFieldCoupon.delegate = self;
//         [av show];
//         
//     } failure:^(NSError *error)
//     {
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//         
//         //NSLog(@"Error = %@",[error description]);
//         
//     }];
}

- (void) setProductToCart
{
    NSMutableArray *arrayProducts = [[NSMutableArray alloc] init];
    
    //for (NSDictionary *dictProduct in [AppDelegate appDelegate].arrAddToBag)
    {
        NSString *strProducts = [[mutDictProductDetail objectForKey:@"prd_id"]  stringByAppendingFormat:@"~%@",[[mutDictProductDetail objectForKey:@"prd_qty"] stringByAppendingFormat:@"~%@", [mutDictProductDetail objectForKey:@"prd_sku"]]];
        [arrayProducts addObject:strProducts];
    }
    
    NSString *productOnCart  = [arrayProducts componentsJoinedByString:@"|"];
    
        //[AppDelegate appDelegate].strCartId = [dictCartToCustomerResponse objectForKey:@"value"];
    
    NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
    [userDefualt setObject:[dictCartToCustomerResponse objectForKey:@"value"] forKey:@"cart_id"];
    [userDefualt synchronize];
    
    iRequest = 1;
    NSURL *url = [NSURL URLWithString:set_cart_product];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:productOnCart forKey:@"products"];
    [request setPostValue:[dictCartToCustomerResponse objectForKey:@"value"] forKey:@"CartId"];
    [request setDidFinishSelector:@selector(requestFinishedForService:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark - ASIHTTP Response

-(void)requestFinishedForService:(ASIHTTPRequest *)request
{
    if (iRequest == 0)
    {
        NSData *data = [request responseData];
        dictCartToCustomerResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        [self setProductToCart];
    }
    else if (iRequest == 1)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData *data = [request responseData];
        
        NSDictionary *dictResponce = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        BOOL checkResponse = [[dictResponce objectForKey:@"value"] boolValue];
        
        if (checkResponse)
        {
            BillingAddressViewController *objBillingAddressViewController;
            if (IS_IPHONE5)
            {
                objBillingAddressViewController = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController" bundle:nil];
            }
            else
            {
                objBillingAddressViewController = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController1" bundle:nil];
            }
            
            objBillingAddressViewController.requestFor = FINALPAYMENT;
            objBillingAddressViewController.mDictProductDetail = mutDictProductDetail;
            objBillingAddressViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:objBillingAddressViewController animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (iRequest == 2)
    {
        //SAVE FOR LATER
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       // NSData *data = [request responseData];
        // //NSLog(@"data -- %@",data);
        [[AppDelegate appDelegate] getFavoriteHistory];
    }
    else if (iRequest == 3)
    {
        [AppDelegate appDelegate].requestFor = ADDPRODUCT;
        [[AppDelegate appDelegate] getCheckOutHistory];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Check your network connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
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
}

- (IBAction)funcProfile:(id)sender {
    
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
                       objLoginView.strCheckViewControler = @"ProducatDetail";
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
                       objRegistrationViewController.strCheckViewControler = @"ProducatDetail";
                       [self.navigationController pushViewController:objRegistrationViewController animated:YES];
                       
                   }];
    }
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
    

    
}

- (IBAction)btnColorAndSizeAction:(id)sender
{
    isSelectedPicker  = [sender tag];
    
    
    self.tableViewPrdAttributes.userInteractionEnabled = NO;
    
  if(isSelectedPicker==0)
  {
    _mArrayProductAttributes = [[arrWeight objectAtIndex:isSelectedPicker] valueForKey:@"custome_values"];
       [self.pickerViewColorandSize reloadAllComponents];
  }
    else
    {
        [self.pickerViewColorandSize reloadAllComponents];

    
    }
    
   
    
    self.pickerViewColorandSize.hidden = NO;
    self.pickerToolbar1.hidden = NO;
    self.pickerToolbar1.barTintColor = [UIColor redColor];
    self.pickerToolbar1.backgroundColor=[UIColor greenColor];
    self.btnPickerDone.hidden = NO;
    self.btnPickerCancel.hidden = NO;
    self.viewBackGround.hidden=NO;
    [self.view bringSubviewToFront:self.viewBackGround];
   // self.viewBackGround.tintColor=[UIColor redColor];
}

- (IBAction) btnMoreInfoAction:(id)sender
{
    viewMoreInfo.hidden = NO;
    txtViewMoreInfo.text = [mutDictProductDetail objectForKey:@"prd_longdesc"];
    [self.view bringSubviewToFront:viewMoreInfo];
    CATransition* transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.duration = .50f;
    transition.type =  @"moveIn";
    transition.subtype = @"fromTop";
    [viewMoreInfo.layer removeAllAnimations];
    [self.view addSubview:viewMoreInfo];
    [viewMoreInfo.layer addAnimation:transition forKey:kCATransition];
}

- (IBAction) btnCloseMoreInfoAction:(id)sender
{
    [UIView beginAnimations:@"animationOff" context:NULL];
    [UIView setAnimationDuration:0.5f];
    viewMoreInfo.hidden = YES;
    [UIView commitAnimations];
}

#pragma mark - Image Sharing From Face Book

-(IBAction)btnActionFaceBookSharing:(id)sender
{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        
    {
        
        strFacebook=[NSString stringWithFormat:@"What do you think? Should i buy this ?%@ \n%@",lblProductName.text,lblProductProductDiscription.text];
        NSString *str=[mutDictProductDetail valueForKey:@"product_url"];
        
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
        
        {
            if (result == SLComposeViewControllerResultCancelled)
                
            {
                
                NSLog(@"Cancelled");
                
            }
            
            else
                
            {
                NSLog(@"Done");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Successfully shared on facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
              //  Alert1(@"Alert", @"Successfully shared on facebook");
                
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
            
        };
        
        controller.completionHandler =myBlock;
        
        //Adding the Text to the facebook post value from iOS
        [controller setInitialText:strFacebook];
        
        //Adding the URL to the facebook post value from iOS
        
        [controller addURL:[NSURL URLWithString:str]];
        
        //Adding the Image to the facebook post value from iOS
        
        //  [controller addImage:[UIImage imageNamed:@"fb.png"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    else
        
    {
        NSLog(@"UnAvailable");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please goto settings and login facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
   
}


-(void)shared_ON_Facebook
{
    
  /*  if(imgViewProducts.image==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Images can not null" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
       // Alert1(@"Alert",@"Images can not null");
    }else
    {
        strFacebook=[NSString stringWithFormat:@"What do you think? Should i buy this ?%@ \n%@",lblProductName.text,lblProductProductDiscription.text];
        
        //        [SCFacebook feedPostWithPhoto:imgViewProducts.image caption:strFacebook callBack:^(BOOL success, id result) {
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //            Alert1(@"Message", @"successfully shared.");
        //                // Alert(@"Alert", [result description]);
        //        }];
        
        
        NSString *str=[mutDictProductDetail valueForKey:@"product_url"];
        
        [SCFacebook feedPostWithLinkPath:str caption:strFacebook Photo:imgViewProducts.image callBack:^(BOOL success,id result)
         {
             NSLog(@"result-------%@",result);
             NSLog(@"success-------%hhd",success);
             
             Alert1(@"Alert", @"Successfully facebook sharing");
         }];
        
    }*/
}

#pragma mark - Image Sharing From Twitter

-(IBAction)btnActionTwitterSharing:(id)sender
{
    
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork)
    {
            //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
    }else
    {

        [[FHSTwitterEngine sharedEngine]showOAuthLoginControllerFromViewController:self withCompletion:^(BOOL success)
        {
            [self postDataOnTwitter];
            //NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
        }];
    }
}


#pragma mark - twitter methods

-(void)postDataOnTwitter
{
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        @autoreleasepool
        {
            NSData *data = UIImagePNGRepresentation(imgViewProducts.image);
            
           
            
            NSString *strTwitterShare=[NSString stringWithFormat:@"What do you think? should i buy this ?\n%@\n%@",lblProductName.text,[mutDictProductDetail valueForKey:@"product_url"]];
            
            id returned ;
            
            if ([strTwitterShare isKindOfClass:[NSString class]])
            {
                NSString *str = [[NSString alloc]initWithString:strTwitterShare];
                if (str.length>120)
                {
                    NSString *subStr = [str substringWithRange:NSMakeRange(0,120)];
                    returned = [[FHSTwitterEngine sharedEngine]postTweet:subStr withImageData:data];;
                }
                else
                {
                    returned = [[FHSTwitterEngine sharedEngine]postTweet:str withImageData:data];;
                }
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            NSString *title = nil;
            NSString *message = nil;
            
            if ([returned isKindOfClass:[NSError class]])
            {
                NSError *error = (NSError *)returned;
                title = [NSString stringWithFormat:@"Error %ld",(long)error.code];
                message = error.localizedDescription;
            }
            else
            {
                message=@"Successfully shared on twitter";
            }
            dispatch_sync(dispatch_get_main_queue(), ^
            {
            @autoreleasepool
            {
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
            }
        });
    }
});
}

-(IBAction)btnActionMailSharing1:(id)sender{
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    NSArray *toRecipients=[[NSArray alloc]initWithObjects:@"hupendra",nil];
    
    [controller setToRecipients:toRecipients];
    [controller setSubject:@"Social checkin App"];
    [controller setMessageBody:@"Check out this social checkin app.  Just download the free app on your iphone." isHTML:YES];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor blackColor],NSForegroundColorAttributeName,
                                    [UIColor blackColor],NSBackgroundColorAttributeName,nil];
    
    controller.navigationBar.titleTextAttributes = textAttributes;
    
    [self presentViewController:controller animated:YES completion:nil];
}


-(IBAction)btnActionMailSharing:(id)sender
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init]  ;
	mailComposer.mailComposeDelegate = self;
	
	if ([MFMailComposeViewController canSendMail])
    {
		[mailComposer setToRecipients:nil];
        
//       [mailComposer d]
        
		[mailComposer setSubject:@"What do you think? Should I buy this?"];
        
        NSString *strMessage=[NSString stringWithFormat:@"Check it out at:\n%@\n%@",[mutDictProductDetail valueForKey:@"prd_name"],[mutDictProductDetail valueForKey:@"product_url"]];
        
        //NSString *message = [@"Check it out at:\n\n\n" stringByAppendingString:[mutDictProductDetail valueForKey:@"product_url"]];
		[mailComposer setMessageBody:strMessage isHTML:NO];
       // NSData *imageData = UIImagePNGRepresentation(imgViewProducts.image);
		//[mailComposer addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@""];
		
        [self presentViewController:mailComposer animated:YES completion:nil];
	}//if
}

-(IBAction)btnActionGooglePlus:(id)sender
{
    static NSString * const kClientID =@"586890710364-pbld9i8gsg7ma3qu54ahn6jdpfc734rr.apps.googleusercontent.com";
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.clientID = kClientID;
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    
    [GPPSignIn sharedInstance].actions = [NSArray arrayWithObjects:
                                          @"http://schemas.google.com/AddActivity",
                                          @"http://schemas.google.com/BuyActivity",
                                          @"http://schemas.google.com/CheckInActivity",
                                          @"http://schemas.google.com/CommentActivity",
                                          @"http://schemas.google.com/CreateActivity",
                                          @"http://schemas.google.com/ListenActivity",
                                          @"http://schemas.google.com/ReserveActivity",
                                          @"http://schemas.google.com/ReviewActivity",
                                          nil];
    signIn.delegate = self;
    [signIn authenticate];
    
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    
    // Set any prefilled text that you might want to suggest
    
    [shareBuilder setURLToShare:[NSURL URLWithString:[mutDictProductDetail valueForKey:@"product_url"]]];
    [shareBuilder setPrefillText:@"What do you think? Should I buy this?"];
    
    //[shareBuilder attachImage:imgViewProducts.image];
    [shareBuilder open];
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error
{
    if (error)
    {
        return;
    }
    [self reportAuthStatus];
}

#pragma mark - GPPShareDelegate

- (void)finishedSharing:(BOOL)shared {
    NSString *text = shared ? @"Success" : @"Canceled";
    //shareStatus_.text = [NSString stringWithFormat:@"Status: %@", text];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:text delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	if (result == MFMailComposeResultSent)
    {
		////NSLog(@"Mail Send");
	}// if
	[self dismissViewControllerAnimated:YES completion:nil];
}// mailComposeController

#pragma mark - UIPickerView Delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(isSelectedPicker==0)
    {
    return _mArrayProductAttributes.count+1;
    }
    else
    {
        return mArrayQuantity.count+1;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strValue;
   if(isSelectedPicker==0)
   {
  if (row==0)
   {
       strValue=strWeightSelect;
   }
   else
   {
    strValue = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"title"];
   }

 
    return strValue;
}
    else
    {
        if(row==0)
        {
            strValue=@"----Select Quantity----";
        
        }
        else
        {
            strValue = [mArrayQuantity objectAtIndex:row-1] ;
        
        
        }
    
        return strValue;
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    allIndex = (int)row;
    if(isSelectedPicker==0)
    {
    if (row==0)
    {
        Price=strDefaultPrice;
    }
    else
    {
     Price = 0.0;
    strAttributeTitile = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"title"];
    strPrdOptionId = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"option_id"];
    strPrdOptionTypeId = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"option_type_id"];

    lblProductColor.text = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"title"];
    
      Price = strDefaultPrice+ [[[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"price"] floatValue];
    strProductPrice = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"price"];
    
    //by me
    
    _btnOption.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [_btnOption setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    weightIndex = (int)row-1;
       
      //[_btnOption setTitle:[[_mArrayProductAttributes objectAtIndex:row] objectForKey:@"title"] forState:UIControlStateNormal];
   // lblProductPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,Price];
    //
    
   //  self.pickerViewColorandSize.hidden = YES;
    }
        
    }
    else
    {
        if (row==0)
        {
            //strprdqty=@"1";
        }
        else
        {
           weightIndex2 = (int)row-1;
          //strprdqty=[mArrayQuantity objectAtIndex:row-1];
        }
    
    }
}

-(NSString *)setProductPrice
{
    float newPrice = strDefaultPrice;
    
    for (NSMutableDictionary *mdict in arrProductColorAndSize)
    {
        newPrice = [[mdict valueForKey:@"prd_New_Price"]floatValue] + newPrice;
    }
    return [NSString stringWithFormat:@"%.2f",newPrice];
}

- (IBAction)btnCancelToolbarAction:(id)sender
{
    self.pickerViewColorandSize.hidden = YES;
    self.pickerToolbar1.hidden = YES;
    
    self.btnPickerDone.hidden = YES;
    self.btnPickerCancel.hidden = YES;
    self.viewBackGround.hidden=YES;
    self.tableViewPrdAttributes.userInteractionEnabled = YES;
    
//    NSMutableDictionary *mDict = [arrProductColorAndSize objectAtIndex:isSelectedPicker];
//    
//    if([[mDict valueForKey:@"prd_New_Price"] floatValue ] > 0)
//    {
//        [mDict setValue:[mDict valueForKey:@"prd_New_Price"] forKey:@"prd_New_Price"];
//    }
//    else
//    {
//        [mDict setValue:@"0" forKey:@"prd_New_Price"];
//    }
//    
//    lblProductPrice.text = [NSString stringWithFormat:@"%@%@",[AppDelegate appDelegate].currencySymbol,[self setProductPrice]];
//    
//    [self.tableViewPrdAttributes reloadData];
}

- (IBAction)btnDoneToolbarAction:(id)sender
{
    _btnOption.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _btncartietms.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    if(isSelectedPicker==0)
    {
    if (allIndex == 0)
    {
        NSString *str =[NSString stringWithFormat:@"%@",[[arrWeight objectAtIndex:0] valueForKey:@"isrequired"]];
        if ([str isEqualToString:@"1"]) {
            isSelectWeight = YES;
            if (isSelectWeight == YES) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Select option." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
        else
        {
            isSelectWeight = NO;
        }
        isSelectWeight = NO;

        strPriceFinal = [NSString stringWithFormat:@"%.02f",strDefaultPrice];
         lblProductPrice.text =[NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,strDefaultPrice];
        [mutDictProductDetail setValue:strPriceFinal forKey:@"prd_price"];
        [mutDictProductDetail setValue:strWeightSelect forKey:@"weight_title_word"];

        [_btnOption setTitle:strWeightSelect forState:UIControlStateNormal];
    }
    else
    {
        isSelectWeight = NO;
        strPriceFinal = [NSString stringWithFormat:@"%.02f",Price];
        lblProductPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,Price];
        NSString *strWeight = [[[_mArrayProductAttributes objectAtIndex:weightIndex] objectForKey:@"title"] stringByReplacingOccurrencesOfString:@" gms" withString:@""];
        float value = [strWeight floatValue];
        
        [mutDictProductDetail setValue:[NSString stringWithFormat:@"%.02f",value] forKey:@"product_weight_title"];

    [mutDictProductDetail setValue:strPriceFinal forKey:@"prd_price"];
        [_btnOption setTitle:[[_mArrayProductAttributes objectAtIndex:weightIndex] objectForKey:@"title"] forState:UIControlStateNormal];
    }
    
  
    
    }
    else
    {
        if (allIndex == 0)
        {
            strprdqty=@"1";
             [_btncartietms setTitle:@"----Select Quantity----" forState:UIControlStateNormal];
              [mutDictProductDetail setValue:strprdqty forKey:@"prd_qty"];
            
        }
        else
        {
            
            if([mArrayQuantity count]==0)
            {
             strprdqty=@"1";
            [mutDictProductDetail setValue:strprdqty forKey:@"prd_qty"];
            }
            else
            {
            strprdqty=[mArrayQuantity objectAtIndex:weightIndex2];
             [_btncartietms setTitle:[mArrayQuantity objectAtIndex:weightIndex2] forState:UIControlStateNormal];
//            NSString *strQty = [mutDictProductDetail valueForKey:@"prd_qty"];
//            int valQty = [strprdqty intValue]+[strQty intValue];
            
          [mutDictProductDetail setValue:[NSString stringWithFormat:@"%@",strprdqty] forKey:@"prd_qty"];
            }
        
        }
    
    
    }
    self.pickerViewColorandSize.hidden = YES;
    self.pickerToolbar1.hidden = YES;
    
    self.btnPickerDone.hidden = YES;
    self.btnPickerCancel.hidden = YES;
    self.viewBackGround.hidden=YES;
    
    self.tableViewPrdAttributes.userInteractionEnabled = YES;
    ////NSLog(@"After Chnage dict -- %@",mutDictProductDetail);
}

//#pragma mark - Response
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    [webData setLength: 0];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [webData appendData:data];
//}
//
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    ////NSLog(@"ERROR with theConenction");
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}
//
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    if (isWebserviceCount == 1)
//    {
//        [mutArrayProductImages removeAllObjects];
//        [imgViewProducts removeFromSuperview];
//        mutArrayProductImages = [NSJSONSerialization JSONObjectWithData:webData options:NSJSONReadingMutableContainers error:nil];
//        // //NSLog(@"Responce-- %@",mutArrayProductImages);
//        
//        self.scrolViewPrductImages.contentSize = CGSizeMake(320 * [mutArrayProductImages count], self.scrolViewPrductImages.frame.size.height);
//        self.scrolViewPrductImages.contentOffset = CGPointMake (self.scrolViewPrductImages.bounds.origin.x, self.scrollViewProductDetail.bounds.origin.y);
//        _pagecontroller.numberOfPages=mutArrayProductImages.count;
//        _pagecontroller.currentPage=0;
//        
//        for (int i = 0; i < [mutArrayProductImages count]; i++)
//        {
//            imgViewProducts = [[UIImageView alloc] initWithFrame:CGRectMake(10+(i * 300),10, 300,330)];
//            imgViewProducts.layer.masksToBounds=YES;
//            imgViewProducts.layer.borderColor=[[UIColor colorWithRed:150.0/255.0 green:175.0/255.0 blue:84.0/255.0 alpha:1.0]CGColor];
//            imgViewProducts.layer.borderWidth= 2.0f;
//            imgViewProducts.backgroundColor = [UIColor clearColor];
//            imgViewProducts.contentMode = UIViewContentModeScaleAspectFit;
//            
//            strURL = [[mutArrayProductImages objectAtIndex:i] objectForKey:@"prd_img"];
//            // Here we use the new provided setImageWithURL: method to load the web image
//            [imgViewProducts setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:CRplacehoderimage]];
//            
//            UITapGestureRecognizer *singleTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productGalleryFullView:)];
//            imgViewProducts.tag=i;
//            singleTap.view.tag=imgViewProducts.tag;
//            imgViewProducts.userInteractionEnabled=YES;
//            [imgViewProducts addGestureRecognizer:singleTap];
//            
//            [self.scrolViewPrductImages addSubview:imgViewProducts];
//        }
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        // Create Session Configuration
//        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        
//        // Configure Session Configuration
//        [sessionConfiguration setAllowsCellularAccess:YES];
//        [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
//        
//        // Create Session
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//        
//        // Send Request
//        NSURL *url = [NSURL URLWithString:@""];
//        [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//          {
//              // //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
//              arrProductColorAndSize = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//              // //NSLog(@"Responce-- %@",arrProductColorAndSize);
//              
//              [self.tableViewPrdAttributes reloadData];
//              if ([arrProductColorAndSize count] == 1)
//              {
//                  if ([[[arrProductColorAndSize objectAtIndex:0] objectForKey:@"custome_title"] isEqualToString:@"Color"])
//                  {
//                      self.arrProductColor = [[arrProductColorAndSize objectAtIndex:0] objectForKey:@"custome_values"];
//                      lblProductColor.text = [[arrProductColorAndSize objectAtIndex:0] objectForKey:@"custome_title"];
//                  }
//                  else
//                  {
//                      self.arrProductSize = [[arrProductColorAndSize objectAtIndex:0] objectForKey:@"custome_values"];
//                      lblProductSize.text = [[arrProductColorAndSize objectAtIndex:1] objectForKey:@"custome_title"];
//                  }
//              }
//              [self.pickerViewColorandSize reloadAllComponents];
//          }] resume];
//    }
//    else
//    {
//        arrProductColorAndSize = [NSJSONSerialization JSONObjectWithData:webData options:NSJSONReadingMutableContainers error:nil];
//        //  //NSLog(@"Responce-- %@",arrProductColorAndSize);
//        
//        [self.tableViewPrdAttributes reloadData];
//        
//        if ([arrProductColorAndSize count] == 1)
//        {
//            if ([[[arrProductColorAndSize objectAtIndex:0] objectForKey:@"custome_title"] isEqualToString:@"Color"])
//            {
//                self.arrProductColor = [[arrProductColorAndSize objectAtIndex:0] objectForKey:@"custome_values"];
//                lblProductColor.text = [[arrProductColorAndSize objectAtIndex:0] objectForKey:@"custome_title"];
//            }
//            else
//            {
//                self.arrProductSize = [[arrProductColorAndSize objectAtIndex:0] objectForKey:@"custome_values"];
//                lblProductSize.text = [[arrProductColorAndSize objectAtIndex:1] objectForKey:@"custome_title"];
//            }
//        }
//        
//        // //NSLog(@"self.arrProductColor-- %@",self.arrProductColor);
//        // //NSLog(@" self.arrProductSize-- %@", self.arrProductSize);
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self.pickerViewColorandSize reloadAllComponents];
//    }
//}

-(void)hideGuestView:(UITapGestureRecognizer *)gesture
{
    popupView.hidden = YES;
    popupViewSave.hidden = YES;
}

#pragma mark - ScrollView  Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat pageWidth = self.scrolViewPrductImages.frame.size.width;
//    int pageNo = floor((self.scrolViewPrductImages.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    _pagecontroller.currentPage=pageNo;
    
}// scrollViewDidScroll

#pragma mark - Collection And methods

- (IBAction)BuyTheLookMethod:(id)sender
{
    
    if([AppDelegate appDelegate].dataArray.count>0)
    {
        _lblButTheItems.text=[NSString stringWithFormat:@"%d items",(int)[AppDelegate appDelegate].dataArray.count];
    }
    else
    {
        _lblButTheItems.text=[NSString stringWithFormat:@"0 item"];
        
    }

    recent_is = NO;
    isRecomded = NO;
    
    [_CollectionMoreInfo reloadData];
    [_buttonBuythelook setBackgroundImage:[UIImage imageNamed:@"buythelook_w.png"] forState:UIControlStateNormal];
    [_buttonWeRecom setBackgroundImage:[UIImage imageNamed:@"green_trans.png"] forState:UIControlStateNormal];
    [_buttonRecentView setBackgroundImage:[UIImage imageNamed:@"green_trans.png"] forState:UIControlStateNormal];
    
    _buttonClearAll.hidden=YES;
    _lblRecentItems.hidden=YES;
}

- (IBAction)WeRecommendMethod:(id)sender
{
    
    //_lblButTheItems.text =[NSString stringWithFormat:@"%d items",[AppDelegate appDelegate].dataArray.count];
    recent_is=NO;
    isRecomded = YES;
    
    [_CollectionMoreInfo reloadData];
    
    [_buttonBuythelook setBackgroundImage:[UIImage imageNamed:@"green_trans.png"] forState:UIControlStateNormal];
    [_buttonWeRecom setBackgroundImage:[UIImage imageNamed:@"werecommend_w.png"] forState:UIControlStateNormal];
    [_buttonRecentView setBackgroundImage:[UIImage imageNamed:@"green_trans.png"] forState:UIControlStateNormal];
    
    _buttonClearAll.hidden=YES;
    _lblRecentItems.hidden=YES;
}

- (IBAction)RecentViewMethod:(id)sender
{
    
    if([AppDelegate appDelegate].MoreInfoarray_Recent.count>0)
    {
    _lblButTheItems.text=[NSString stringWithFormat:@"%d items",(int)[AppDelegate appDelegate].MoreInfoarray_Recent.count];
        [_CollectionMoreInfo reloadData];
        
    }
    else
    {
     _lblButTheItems.text=[NSString stringWithFormat:@"0 item"];
    
    }
    recent_is=YES;
    
    [_buttonBuythelook setBackgroundImage:[UIImage imageNamed:@"green_trans.png"] forState:UIControlStateNormal];
    [_buttonWeRecom setBackgroundImage:[UIImage imageNamed:@"green_trans.png"] forState:UIControlStateNormal];
    [_buttonRecentView setBackgroundImage:[UIImage imageNamed:@"recentlyviewed_w.png"] forState:UIControlStateNormal];
    
    _buttonClearAll.hidden=NO;
    _lblRecentItems.hidden=NO;
}

- (IBAction)ClearAllMethod:(id)sender
{
    
    if ([AppDelegate appDelegate].MoreInfoarray_Recent.count>0)
    {
        recent_is=YES;
        [_CollectionMoreInfo reloadData];
        [[AppDelegate appDelegate].MoreInfoarray_Recent removeAllObjects];
        _lblButTheItems.text=[NSString stringWithFormat:@"%d items",(int)[AppDelegate appDelegate].MoreInfoarray_Recent.count];
    }
}

- (IBAction)change_image_via_page:(id)sender
{
//    CGFloat x = _pagecontroller.currentPage * self.scrolViewPrductImages.frame.size.width;
//    [self.scrolViewPrductImages setContentOffset:CGPointMake(x, 0) animated:YES];
}
//========================================== Photo collection  method==================================//

#pragma mark - UICollectionViewDataSource
#pragma mark Collection view Data source and delegate method

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    
    if (recent_is==NO)
    {
        int count = 0;
        if(isRecomded)
        {
            for( NSMutableDictionary *mDict in [AppDelegate appDelegate].dataArray)
            {
                if([[mDict valueForKeyPath:@"product_recommended"] isEqualToString:@"1"])
                {
                    count = count +1;
                }
            }
            if([AppDelegate appDelegate].dataArray.count>0)
            {
                _lblButTheItems.text=[NSString stringWithFormat:@"%d items",count];
            }
            else
            {
                _lblButTheItems.text=[NSString stringWithFormat:@"0 item"];
                
            }

           // _lblButTheItems.text = [NSString stringWithFormat:@"%d items",count];
            return count;
        }
        else
        {
            return  [AppDelegate appDelegate].dataArray.count;
        }
    }
    else
    {
        return [AppDelegate appDelegate].MoreInfoarray_Recent.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MoreInfoCollectionCell *cell = (MoreInfoCollectionCell*)[cv dequeueReusableCellWithReuseIdentifier:@"MoreInfoCollectionCell" forIndexPath:indexPath];
    
    if (recent_is==NO)
    {
        cell.lblName.text=[[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] objectForKey:@"prd_name"];
        cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] objectForKey:@"prd_price"]];
        
        if([[[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] objectForKey:@"prd_thumb"] isKindOfClass:[NSNull class]]||[[[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] objectForKey:@"prd_thumb"] isEqualToString:@""]){
            [cell.imageThumb setImage:[UIImage imageNamed:@"Place_holder.png"]];
            cell.imageThumb.loadingView.hidden=YES;
        }else if([[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] objectForKey:@"prd_thumb"]==nil){
            [cell.imageThumb setImage:[UIImage imageNamed:@"Place_holder.png"]];
            cell.imageThumb.loadingView.hidden=YES;
        }else if([[[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] objectForKey:@"prd_thumb"] length]==0){
            [cell.imageThumb setImage:[UIImage imageNamed:@"Place_holder.png"]];
            cell.imageThumb.loadingView.hidden=YES;
        }else{
            //NSLog(@"%@",[[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] objectForKey:@"prd_thumb"]);
             NSURL *url = [NSURL URLWithString:[[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] objectForKey:@"prd_thumb"] ];
            [cell.imageThumb setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Place_holder.png"]];
            cell.imageThumb.loadingView.hidden=YES;
            cell.imageThumb.clipsToBounds = YES;
             cell.imageThumb.layer.borderColor=[[UIColor colorWithRed:150.0/255.0 green:175.0/255.0 blue:84.0/255.0 alpha:1.0]CGColor];
            cell.imageThumb.layer.borderWidth=1.0f;
        }
   
        if ([[[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] valueForKey:@"QTY"] intValue] <= 0)
        {  cell.lbloutofstock.transform = CGAffineTransformMakeRotation(-M_PI/4);
            cell.layer.masksToBounds=YES;
            cell.lbloutofstock.hidden=NO;
        }
        if ([[[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] valueForKey:@"pro_stock"] intValue] <= 0)
        {  cell.lbloutofstock.transform = CGAffineTransformMakeRotation(-M_PI/4);
            cell.layer.masksToBounds=YES;
            cell.lbloutofstock.hidden=NO;
        }
        else
        {
            cell.lbloutofstock.hidden=YES;
            
        }

     //   cell.imageThumb.contentMode = UIViewContentModeScaleAspectFill;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap:)];
        singleTap.numberOfTapsRequired = 1;
        cell.imageThumb.tag = indexPath.row;
        [cell.imageThumb addGestureRecognizer:singleTap];
    }
    else
    {
        cell.lblName.text=[[[AppDelegate appDelegate].MoreInfoarray_Recent objectAtIndex:indexPath.row] objectForKey:@"prd_name"];
        cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[[[AppDelegate appDelegate].MoreInfoarray_Recent objectAtIndex:indexPath.row] objectForKey:@"prd_price"]];
        
        if([[[[AppDelegate appDelegate].MoreInfoarray_Recent objectAtIndex:indexPath.row] objectForKey:@"prd_thumb"] isKindOfClass:[NSNull class]]){
            [cell.imageThumb setImage:[UIImage imageNamed:@"Place_holder.png"]];
            cell.imageThumb.loadingView.hidden=YES;
        }else if([[[AppDelegate appDelegate].MoreInfoarray_Recent objectAtIndex:indexPath.row] objectForKey:@"prd_thumb"]==nil){
            [cell.imageThumb setImage:[UIImage imageNamed:@"Place_holder.png"]];
            cell.imageThumb.loadingView.hidden=YES;
        }else if([[[[AppDelegate appDelegate].MoreInfoarray_Recent objectAtIndex:indexPath.row] objectForKey:@"prd_thumb"] length]==0){
            [cell.imageThumb setImage:[UIImage imageNamed:@"Place_holder.png"]];
            cell.imageThumb.loadingView.hidden=YES;
        }else{
            
            
            //NSLog(@"%@",[[[AppDelegate appDelegate].dataArray objectAtIndex:indexPath.row] objectForKey:@"prd_thumb"]);
            NSURL *url = [NSURL URLWithString:[[[AppDelegate appDelegate].MoreInfoarray_Recent objectAtIndex:indexPath.row] objectForKey:@"prd_thumb"] ];
             [cell.imageThumb setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Place_holder.png"]];
            cell.imageThumb.loadingView.hidden=YES;
            
           // [cell.imageThumb loadImageFromURL:[[[AppDelegate appDelegate].MoreInfoarray_Recent objectAtIndex:indexPath.row] objectForKey:@"prd_thumb"]];
            cell.imageThumb.clipsToBounds = YES;
            cell.imageThumb.layer.borderColor=[[UIColor colorWithRed:150.0/255.0 green:175.0/255.0 blue:84.0/255.0 alpha:1.0]CGColor];
            cell.imageThumb.layer.borderWidth=1.0f;
        }
        if ([[[[AppDelegate appDelegate].MoreInfoarray_Recent objectAtIndex:indexPath.row] valueForKey:@"QTY"] intValue] <= 0)
        {  cell.lbloutofstock.transform = CGAffineTransformMakeRotation(-M_PI/4);
            cell.layer.masksToBounds=YES;
            cell.lbloutofstock.hidden=NO;
        }
        if ([[[[AppDelegate appDelegate].MoreInfoarray_Recent objectAtIndex:indexPath.row] valueForKey:@"pro_stock"] intValue] <= 0)
        {  cell.lbloutofstock.transform = CGAffineTransformMakeRotation(-M_PI/4);
            cell.layer.masksToBounds=YES;
            cell.lbloutofstock.hidden=NO;
        }

        else
        {
            cell.lbloutofstock.hidden=YES;
            
        }
        //cell.imageThumb.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap:)];
        singleTap.numberOfTapsRequired = 1;
        cell.imageThumb.tag = indexPath.row;
        [cell.imageThumb addGestureRecognizer:singleTap];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    return CGSizeMake(90.0f, 177.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2; // This is the minimum inter item spacing, can be more
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //  //NSLog(@"[AppDelegate appDelegate].dataArray -- %@",[AppDelegate appDelegate].dataArray);
}

- (void) oneTap:(UIGestureRecognizer *)gesture
{
    
    if (recent_is==NO) {
        strRecent=@"0";
        UIImageView *selectedImageView = (UIImageView*)[gesture view];
        self.mutDictProductDetail = [[[AppDelegate appDelegate].dataArray objectAtIndex:selectedImageView.tag] mutableCopy];
        mArrayQuantity = [[NSMutableArray alloc] init];
        //NSNumber *num = ;
        int totalQty = [[NSString stringWithFormat:@"%@",[mutDictProductDetail objectForKey:@"pro_stock"]] intValue];
        
        if([[mutDictProductDetail objectForKey:@"pro_stock"]intValue]<=0)
        {
            _btnOption.userInteractionEnabled=NO;
            _btncartietms.userInteractionEnabled=NO;
            _btnOption.enabled=NO;
            _btncartietms.enabled=NO;
            [_btnOption setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_btncartietms setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            
        }
        else
        {
            _btnOption.userInteractionEnabled=YES;
            _btncartietms.userInteractionEnabled=YES;
            _btnOption.enabled=YES;
            _btncartietms.enabled=YES;
            [_btnOption setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_btncartietms setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }        for(int i=1;i <= totalQty;i++)
        {
            [mArrayQuantity addObject:[NSString stringWithFormat:@"%d",i]];
        }

        _strSelectValue = [NSString stringWithFormat:@"%ld",(long)selectedImageView.tag];
        NSLog(@"dataArray contents is %@",[[AppDelegate appDelegate].dataArray objectAtIndex:selectedImageView.tag]);
    }
    else{
         strRecent=@"1";
        UIImageView *selectedImageView = (UIImageView*)[gesture view];
        self.mutDictProductDetail = [[AppDelegate appDelegate].MoreInfoarray_Recent objectAtIndex:selectedImageView.tag];
        mArrayQuantity = [[NSMutableArray alloc] init];
        //NSNumber *num = ;
        int totalQty = [[NSString stringWithFormat:@"%@",[mutDictProductDetail objectForKey:@"pro_stock"]] intValue];
        
        if([[mutDictProductDetail objectForKey:@"pro_stock"]intValue]<=0)
        {
            _btnOption.userInteractionEnabled=NO;
            _btncartietms.userInteractionEnabled=NO;
            _btnOption.enabled=NO;
            _btncartietms.enabled=NO;
            [_btnOption setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_btncartietms setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            
        }
        else
        {
            _btnOption.userInteractionEnabled=YES;
            _btncartietms.userInteractionEnabled=YES;
            _btnOption.enabled=YES;
            _btncartietms.enabled=YES;
            [_btnOption setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_btncartietms setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
        for(int i=1;i <= totalQty;i++)
        {
            [mArrayQuantity addObject:[NSString stringWithFormat:@"%d",i]];
        }
        

           _strSelectValue = [NSString stringWithFormat:@"%ld",(long)selectedImageView.tag];
        NSLog(@"dataArray contents is %@",[[AppDelegate appDelegate].MoreInfoarray_Recent objectAtIndex:selectedImageView.tag]);
    }
    
     [self getWeightOptionWebService:[[mutDictProductDetail valueForKey:@"prd_id"] intValue]];
    [mutArrayProductImages removeAllObjects];
    isShowLoader = YES;
    [self setContentView];
    [self setScrollContent];
}

-(void)productGalleryFullView:(UITapGestureRecognizer *)gesture
{
    //gesture.view.tag
    NSString *strXIB = @"ViewFullSizeImageVC_iPhone3.5";
    if(IS_IPHONE5)
    {
        strXIB = @"ViewFullSizeImageVC";
    }
    ViewFullSizeImageVC *viewfullsizeimageview=[[ViewFullSizeImageVC alloc]initWithNibName:strXIB bundle:nil];
    viewfullsizeimageview.image_tag = gesture.view.tag;
    viewfullsizeimageview.imageDict = mutDictProductDetail;
    [self presentViewController:viewfullsizeimageview animated:YES completion:nil];
}

- (IBAction)btnChangeCurrency:(id)sender
{
    Currency_Size_VC *Currency_Size_view = [[Currency_Size_VC alloc] initWithNibName:@"Currency_Size_VC" bundle:nil];
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
    
    NSString *prod_price=[NSString stringWithFormat:@"%@",[mutDictProductDetail objectForKey:@"prd_price"]];
    
    CGFloat final_price = [prod_price floatValue] * [value floatValue];
    
    lblProductPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,final_price];
    //[mutDictProductDetail setValue:[NSNumber numberWithFloat:final_price] forKey:@"prd_price"];
}


@end
