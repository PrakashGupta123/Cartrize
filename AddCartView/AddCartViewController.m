

//
    //  AddCartViewController.m
    //  IShop
    //
    //  Created by Hashim on 5/1/14.
    //  Copyright (c) 2014 Syscraft. All rights reserved.
    //

#import "AddCartViewController.h"
#import "AddToBagCell.h"
    //#import <SDWebImage/UIImageView+WebCache.h>
#import "BillingAddressViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "CartrizeWebservices.h"
#import "JSON.h"
#import "Constants.h"
#import "MoreInfoCollectionCell.h"
#import "CustomCell.h"
#import "ViewFullSizeImageVC.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <Social/Social.h>
#import "ProductDetailView.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "LoginView.h"
#import "FHSTwitterEngine.h"
#define kNotificationRefreshProductItem @"RefreshProductItem"
#define kNotificationDeleteProduct @"DeleteProduct"
#define kNotificationEditProduct @"EditProduct"
#define kNotificationAddProduct @"AddProduct"
#define kNotificationDeleteProductFromBag @"DeleteProductFromBag"



@interface AddCartViewController ()<GPPSignInDelegate>
{
    NSString *strFacebook;
    NSMutableArray *arrWeight;
    NSArray *arrPickerSelect;
    NSMutableDictionary *dictEdit;
    int btnIndexOfEdit;
}
@end

@implementation AddCartViewController

@synthesize arrProducts,tblViewProductBag, pickerViewDetail, dataSize, arrProductColor, arrProductColorAndSize, arrProductSize,  strQty, mDictEditDetail,strPrices;

@synthesize requestFor;

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
    prdtotalAddqty=0;
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReloadCartData:) name:@"kNotificationReloadCartData" object:nil];
     strQty2=@"";
   spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]; [self.view addSubview:spinner];

   
    
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"subtotal"]!=nil)
    {
        //float lblPrice=[[[NSUserDefaults standardUserDefaults]valueForKey:@"subtotal"]floatValue];
         self.lbl_Price.text=[NSString stringWithFormat:@"%@ %.02f",[AppDelegate appDelegate].currencySymbol,[[[NSUserDefaults standardUserDefaults]valueForKey:@"subtotal"]floatValue]];
    }
    else
    {
         self.lbl_Price.text=[NSString stringWithFormat:@"%@ %@",[AppDelegate appDelegate].currencySymbol,@"0"];
    
    }
    if (IS_IPHONE_4)
    {
        [self.lbl_TOTAL setFrame:CGRectMake(10, 406, 161, 21)];
        [self.lbl_Price setFrame:CGRectMake(261, 406, 46, 21)];
        [self.btnPAY_SECURELY setFrame:CGRectMake(10, 431, 300, 30)];
        
       
        
        [_btnPAY_SECURELY addTarget:self action:@selector(btnContinueActions) forControlEvents:UIControlEventTouchUpInside];
    }
    
    AppDelegate *app= (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.PricePayment=totalPrice;
       [_btnPAY_SECURELY addTarget:self action:@selector(btnContinueActions) forControlEvents:UIControlEventTouchUpInside];
    
    //[[NSUserDefaults standardUserDefaults]setObject:arrayCartData forKey:@"arrayCartData"]
          // Do any additional setup after loading the view from its nib.
    isProductEdit = NO;
    self.tblViewProductBag.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tblViewProductBag.bounds.size.width, 0.01f)];
    
    selectedColorIndex = selectedQuantityIndex = selectedSizeIndex = -1;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteProduct:) name:kNotificationDeleteProduct object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editProduct:) name:kNotificationEditProduct object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteProductFromBag:) name:kNotificationDeleteProductFromBag object:nil];
    
//    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"] isEqualToString:@""]) {
//        
//        if([[AppDelegate appDelegate].strCartId isEqualToString:@"<null>"] || [AppDelegate appDelegate].strCartId == nil)
//            {
//            
//            [self getCartId];
//            
//            
//            }
//    }
    
    
}

-(void)GetCartItemms
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]!=nil) {
        NSDictionary *param=@{@"cartid":[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"],@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
        [CartrizeWebservices PostMethodWithApiMethod:@"getitembyshopping" Withparms:param WithSuccess:^(id response)
         {
            // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [spinner stopAnimating];
             NSMutableDictionary *mDict=[response JSONValue];
             arrayCartData=[[NSMutableArray alloc]init];
             [arrayCartData removeAllObjects];
             arrayCartData =[mDict valueForKey:@"data"];
             [[NSUserDefaults standardUserDefaults]setObject:[mDict valueForKey:@"subtotal"] forKey:@"subtotal"];
             //[[NSUserDefaults standardUserDefaults]setObject:arrayCartData forKey:@"arrayCartData"];
             [AppDelegate appDelegate].arrAddToBag=[[NSMutableArray alloc]init];
             [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
             [AppDelegate appDelegate].arrAddToBag=[arrayCartData mutableCopy];
              arraycontent=[arrayCartData mutableCopy];
            //[tblViewProductBag reloadData];
             //[self addToBagProduct:mDict];
             if([[AppDelegate appDelegate].arrAddToBag count]<=0)
             {
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your Cart is empty! add items to its now?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 alert.tag=123321;
                // [alert show] ;
                 lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %@ ITEM" ,@"0"];
                 _lbl_Price.text=@"$ 0.0";
                 
             }
             else
             {
                 
                // subtotal
                 lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %lu ITEMS" ,(unsigned long)[[AppDelegate appDelegate].arrAddToBag count]];
                 tblViewProductBag.hidden=NO;
                 _lbl_Price.text=[NSString stringWithFormat:@"$ %0.2f",[[mDict valueForKey:@"subtotal"]floatValue ]];
                 Priceafter=[[mDict valueForKey:@"subtotal"]floatValue];
                 [self.tblViewProductBag reloadData];
             }
             [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationRefreshProductItem object:nil];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
         } failure:^(NSError *error)
         {
             //NSLog(@"Error = %@",[error description]);
             [spinner stopAnimating];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
    }
    else{
        [spinner stopAnimating];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    
}

#pragma mark -- SHOW LOADER
-(void)showLoader
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor clearColor];
   // hud.dimBackground = YES;
}

-(void)getCartId
{
        //getCartId
    [CartrizeWebservices GetMethodWithApiMethod:@"getCartId" WithSuccess:^(id response)
     {
     
    // //NSLog(@"%@",[[response JSONValue] valueForKey:@"CartId"]);
         //HUpendra
     [AppDelegate appDelegate].strCartId=[[response JSONValue] valueForKey:@"CartId"];
         // //NSLog(@"Response Cart id = %@",[response JSONValue]);
     
     } failure:^(NSError *error)
     {
     //NSLog(@"Error = %@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
   
    [super viewWillAppear:YES];
    strprdqty=@"1";
     Priceafter=[[[NSUserDefaults standardUserDefaults] valueForKey:@"subtotal"]floatValue];
 selectedColorIndex = selectedQuantityIndex = selectedSizeIndex = -1;
    arraycontent=[[NSMutableArray alloc]init];
    [arraycontent removeAllObjects];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
   // [self.tblViewProductBag setHidden:YES];
    [self.tblViewProductBag setBackgroundColor:[UIColor clearColor]];
    //[self getYourBagItem];
   // [self setTotalValue];
    selectedIndexViewMore = -1;
    _btnPAY_SECURELY.userInteractionEnabled=YES;
    arraycontent=[AppDelegate appDelegate].arrAddToBag;
    [self arrDataCountfrom:arraycontent];
 // [self GetCartItemms];
//    arraycontent=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrayCartData"];
    
    if([[AppDelegate appDelegate].arrAddToBag count]<=0)
    {
        _lbl_Price.hidden=YES;
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your Cart is empty! add items to its now?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        alert.tag=123321;
//        [alert show] ;
    lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %@ ITEM" ,@"0"];
        tblViewProductBag.hidden=YES;
    
    }
    else
    {
        _lbl_Price.hidden=NO;
        _lbl_Price.text=[NSString stringWithFormat:@"$%0.2f",Priceafter];
     lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %lu ITEMS" ,(unsigned long)[[AppDelegate appDelegate].arrAddToBag count]];
        tblViewProductBag.hidden=NO;
    [self.tblViewProductBag reloadData];
    }
}

-(void)arrDataCountfrom:(NSMutableArray *)array

{
     //   NSString *strId = [[array objectAtIndex:i] valueForKey:@"prd_sku"];
        //  NSString *strQty = [[array objectAtIndex:i] valueForKey:@"prd_qty"];
        NSMutableArray *TableData = [[NSMutableArray alloc] init];
        [TableData removeAllObjects];
    
    
        array = [arraycontent mutableCopy];
        //        NSCountedSet *countedSet = [[NSCountedSet alloc] initWithArray:array];
        NSMutableArray *arrayData = [[NSMutableArray alloc] init];
        [arrayData removeAllObjects];
    
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        for(int i=0; i < [array count]; i++) {
            NSString *s = [[array objectAtIndex:i] valueForKey:@"prd_sku"];
            if (![dictionary objectForKey:s]) {
                NSDictionary *dict = @{s:[NSNumber numberWithInt:1],@"QTY_Added":[[array objectAtIndex:i] valueForKey:@"prd_qty"]};
                [dictionary setObject:dict forKey:s];
                
                [arrayData addObject:[array objectAtIndex:i]];
                
            } else {
            
                
               int  value = [[[array objectAtIndex:i] valueForKey:@"prd_qty"] intValue]+[[[dictionary objectForKey:s] valueForKey:@"QTY_Added"] intValue];
            
                 NSDictionary *dict = @{s:[NSNumber numberWithInt:[[[dictionary objectForKey:s] valueForKey:s] intValue]+1],@"QTY_Added":[NSNumber numberWithInt:value]};
                
                [dictionary setObject:dict forKey:s];
            }
        }
        
        NSMutableArray *arrraNumaber = [[NSMutableArray alloc] init];
        [arrraNumaber removeAllObjects];
        
        for(NSString *k in [dictionary keyEnumerator]) {
            NSNumber *number = [[dictionary objectForKey:k] valueForKey:@"QTY_Added"];
            NSDictionary *dict = @{@"prd_sku":k,@"count":number};
            [arrraNumaber addObject:dict];
            
            NSLog(@"Value of %@",dict);
        }
        
    
    for (int i = 0; i<array.count; i++) {
        
        for (int j = 0; j<arrraNumaber.count; j++) {
            
            if ([[[arrraNumaber objectAtIndex:j] valueForKey:@"prd_sku"] isEqualToString:[[array objectAtIndex:i] valueForKey:@"prd_sku"]]) {
                
                NSMutableDictionary *dictData = [NSMutableDictionary new];
                dictData =[array objectAtIndex:i];
                [dictData setObject:[NSString stringWithFormat:@"%@",[[arrraNumaber objectAtIndex:j] valueForKey:@"count"]] forKey:@"QTY_Added"];
                
                [TableData addObject:dictData];
                
            }
        }
    }
    
    NSLog(@"TableData --->%@",TableData);
    arraycontent = [NSMutableArray new];
    arraycontent =[TableData mutableCopy];
      [self.tblViewProductBag reloadData];
}


-(void)setContentView
{
    
    viewMoreInfo.hidden = YES;
    isWebserviceCount = 1;
    [imgViewProducts removeFromSuperview];
    viewMoreInfo.hidden = YES;
    imgViewProducts = [[UIImageView alloc] initWithFrame:CGRectMake(0,10, self.scrolViewPrductImages.frame.size.width,330)];
    imgViewProducts.layer.masksToBounds=YES;
    imgViewProducts.layer.borderColor=[[UIColor colorWithRed:150.0/255.0 green:175.0/255.0 blue:84.0/255.0 alpha:1.0]CGColor];
    imgViewProducts.layer.borderWidth= 1.0f;
    imgViewProducts.backgroundColor = [UIColor clearColor];
    imgViewProducts.contentMode = UIViewContentModeScaleAspectFit;
  
    NSString *strURL = [_mutDictProductDetail objectForKey:@"prd_thumb"];
    if (strURL == nil || strURL == (id)[NSNull null])
        // nil branch

    {
        [imgViewProducts setImage:[UIImage imageNamed:@"Product_no_image.png"]];

    
    }
    else
    {
    // Here we use the new provided setImageWithURL: method to load the web image
    imgViewProducts.image=nil;
    [imgViewProducts setImage:[UIImage imageNamed:@""]];
    //lblNavTitle.hidden=NO;
   // lblNavTitle.text=[_mutDictProductDetail objectForKey:@"prd_name"];
    
    [imgViewProducts sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:CRplacehoderimage] ];
    [imgViewProducts sd_setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:CRplacehoderimage] ];
    }
    
//    __block UIActivityIndicatorView *activityIndicatorForImage = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activityIndicatorForImage.center = imgViewProducts.center;
//    activityIndicatorForImage.hidesWhenStopped = YES;
    
       
    
    [self.scrolViewPrductImages addSubview:imgViewProducts];
        //self.pickerToolbar1.hidden = YES;
    //self.pickerViewColorandSize.hidden = YES;
    
    //NSMutableString *request_gallery = [NSMutableString stringWithFormat:@"%@", [NSString stringWithFormat:product_gallery, [_mutDictProductDetail objectForKey:@"prd_id"]]];
    
   // NSMutableString *request_options = [NSMutableString stringWithFormat:@"%@", [NSString stringWithFormat:product_option, [_mutDictProductDetail objectForKey:@"prd_id"]]];
    
    //[self getResponce12:request_gallery :1];
   // [self getResponce12:request_options :2];
    
    //NSLog(@"Dict -- %@",_mutDictProductDetail);
                                                                                                                                                                //by me 891  //
    //self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, 891+50);
    
    
    self.scrollViewProductDetail.contentOffset = CGPointMake (self.scrollViewProductDetail.bounds.origin.x, 0);
    
    lblProductName.text = [_mutDictProductDetail objectForKey:@"prd_name"];
  
    lblProductPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,[[_mutDictProductDetail objectForKey:@"prd_price"] floatValue]];
    
    
    NSNumber *nub = [_mutDictProductDetail objectForKey:@"prd_price"];
    strDefaultPrice = [nub floatValue];
    lblProductProductCode.text = [NSString stringWithFormat:@"SKU %@",[_mutDictProductDetail objectForKey:@"prd_sku"]];
    lblProductProductDiscription.text = [_mutDictProductDetail objectForKey:@"prd_desc"];
    [self frameSizeSet];
    
   

}

-(void)frameSizeSet
{
    NSString *str=[_mutDictProductDetail objectForKey:@"prd_desc"];
    CGSize constraint = CGSizeMake(295 - (10 * 2), 20000.0f);
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = MAX(size.height, 44.0);
    lblProductProductDiscription.text = [_mutDictProductDetail objectForKey:@"prd_desc"];
    
    lblProductProductDiscription.frame = CGRectMake(12,lblAboutMe.frame .origin.y+lblAboutMe.frame.size.height+10,295, height+10);
    
    self.imgDescBackGround.frame=CGRectMake(10,lblAboutMe.frame .origin.y+lblAboutMe.frame.size.height+10,300, height+10);
    
    
    btnMoreInfo.frame = CGRectMake(5,lblProductProductDiscription.frame.origin.y+lblProductProductDiscription.frame.size.height+20, 310, 30);
    
    lblProductProductDiscription.numberOfLines = 0;
    //imageViewBG.frame = CGRectMake(0, 101, 320, lblProductProductDiscription.bounds.size.height + 408);
    
    if (IS_IPHONE_4)
    {
       // self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, btnMoreInfo.frame.origin.y+550);
         self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width,553);
    }else{
       // self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width,btnMoreInfo.frame.origin.y+550);
        self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width,553);
    }
    self.scrollViewProductDetail.contentOffset = CGPointMake (self.scrollViewProductDetail.bounds.origin.x, 0);
    
    self.scrollViewProductDetail.contentOffset = CGPointMake (self.scrollViewProductDetail.bounds.origin.x, 0);
    stringHt=height;

}

- (void) getResponce12:(NSString *)strURL :(int)service_count
{
    
    if (service_count == 1)
    {
        NSURL *url = [NSURL URLWithString:strURL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data,NSError *connectionError){
                                   
                                  
                                   if (data==nil) {
                                       
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                       [alert show];
                                       return ;
                                       
                                   }
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
        
        NSMutableArray *optionArray = [_mutDictProductDetail valueForKey:@"product_options"] ;
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


- (void) getResponce:(NSString *)strURL :(int)service_count
{
    
    NSURL *url = [NSURL URLWithString:strURL];
        
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data,NSError *connectionError){
                                   
                                   if (data==nil) {
                                       
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                       [alert show];
                                       return ;
                                       
                                   }
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
                                           imgViewProducts = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0, 320,350)];
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
                                   else
                                       {
                                       NSMutableArray *mArrayResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                       arrProductColorAndSize = [[NSMutableArray alloc]init];
                                       for(NSMutableDictionary *mDict in mArrayResponse)
                                           {
                                           NSString *jsonString = [_mutDictProductDetail valueForKey:@"option_json_value"];
                                           
                                           BOOL isOption = NO;
                                           NSMutableArray *optionArray = [jsonString JSONValue];
                                           
                                           for (int i = 0; i < [optionArray count]; i++)
                                               {
                                               NSString *strText = @"";
                                               id obj = [[optionArray objectAtIndex:i]valueForKey:@"option_value"];
                                               if (obj != nil)
                                                   {
                                                   strText = [strText stringByAppendingString:[[optionArray objectAtIndex:i]valueForKey:@"option_value"]];
                                                   }
                                               
                                               for (NSMutableDictionary *dict in [mDict valueForKey:@"custome_values"])
                                                   {
                                                   if([[dict valueForKey:@"title"] isEqualToString:strText])
                                                       {
                                                       isOption = YES;
                                                       [mDict setValue:@"" forKey:@"prd_Attribute_Title"];
                                                       [mDict setValue:@"" forKey:@"prd_option_id"];
                                                       [mDict setValue:@"" forKey:@"prd_option_type_id"];
                                                       [mDict setValue:@"0" forKey:@"prd_New_Price"];
                                                       break;
                                                       }
                                                   }
                                               }
                                           if(!isOption)
                                               {
                                               [mDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"prd_Attribute_Title"];
                                               }
                                           [arrProductColorAndSize addObject:mDict];
                                           }
                                       
                                       //NSLog(@"Responce-- %@",arrProductColorAndSize);
                                       
                                       CGRect newTableFrame = self.tableViewPrdAttributes.frame;
                                       
                                       newTableFrame.size.height = [arrProductColorAndSize count] * 36;
                                       self.tableViewPrdAttributes.frame = newTableFrame;
                                       
                                       CGRect viewProductFrame = self.viewPrdAttributes.frame;
                                       
                                       viewProductFrame.origin.y = self.tableViewPrdAttributes.frame.origin.y + self.tableViewPrdAttributes.frame.size.height ;
                                       
                                       self.viewPrdAttributes.frame = viewProductFrame;
                                       
                                       float heightScroll = 891 + ([arrProductColorAndSize count]-1) * 36;
                                       self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, heightScroll+50);
                                       
                                       [self.tableViewPrdAttributes reloadData];
                                       }
                               }];
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

- (IBAction)change_image_via_page:(id)sender
{
    CGFloat x = _pagecontroller.currentPage * self.scrolViewPrductImages.frame.size.width;
    [self.scrolViewPrductImages setContentOffset:CGPointMake(x, 0) animated:YES];
}

#pragma mark - ScrollView  Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrolViewPrductImages.frame.size.width;
    int pageNo = floor((self.scrolViewPrductImages.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pagecontroller.currentPage=pageNo;
}

-(IBAction)actionHideProductDetail:(id)sender
{
    isProductEdit = NO;
    tblViewProductBag.hidden=NO;
    _viewProductDetail.hidden = YES;
    pickerViewDetail.hidden = YES;
     lblEditprotitle.hidden=YES;
    
    
    
    
  /*  NSMutableDictionary *mDict = [arrProductColorAndSize objectAtIndex:isSelectedPicker];
    
    NSMutableDictionary *mDict2=[[AppDelegate appDelegate].arrAddToBag objectAtIndex:indexTag];
    
    if([[mDict valueForKey:@"prd_New_Price"] floatValue ] > 0)
    {
        [mDict setValue:[mDict valueForKey:@"prd_New_Price"] forKey:@"prd_New_Price"];
    }
    else
    {
        [mDict setValue:[mDict2 valueForKey:@"prd_price"] forKey:@"prd_New_Price"];
    }
    
    lblProductPrice.text = [NSString stringWithFormat:@"%@%@",[AppDelegate appDelegate].currencySymbol,[self setProductPrice]];*/
    
    self.pickerViewColorandSize.hidden = YES;
    [self.pickerToolbar1 removeFromSuperview];
    
    
    [UIView transitionFromView:_viewProductDetail toView:self.tblViewProductBag duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion: ^(BOOL inFinished)
                     {
                            //do any post animation actions here
                         [self.lbl_Price setHidden:NO];
                         [self.lbl_TOTAL setHidden:NO];
                         [self.btnPAY_SECURELY setHidden:NO];
                        
                         
                    }];
    [self.tblViewProductBag reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark-Action method

- (IBAction) btnBackAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnContinueActions
{
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"] isEqualToString:@""])
        {
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

-(IBAction)btnEditAction:(id)sender
{
      [_btnEditdisplay setTitle:@"---Select Quantity---" forState:UIControlStateNormal];
    strprdqty=@"1";
    
   
    //tblViewProductBag.userInteractionEnabled=NO;
    dictEdit =[NSMutableDictionary new];
    _mutDictProductDetail= [NSMutableDictionary new];
 _mutDictProductDetail = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:[sender tag]];
    dictEdit =[[AppDelegate appDelegate].arrAddToBag objectAtIndex:[sender tag]];
    mArrayQuantity = [[NSMutableArray alloc] init];
    //NSNumber *num = ;
    if([[dictEdit objectForKey:@"pro_stock"]isKindOfClass:[NSNull class]]||[[dictEdit objectForKey:@"pro_stock"]isEqualToString:@"<null>"]||[dictEdit objectForKey:@"pro_stock"]==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Can't update this product right now!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    
    }
    tblViewProductBag.hidden=YES;
    int totalQty = [[NSString stringWithFormat:@"%@",[dictEdit objectForKey:@"pro_stock"]] intValue];
    
    
    for(int i=1;i <= totalQty;i++)
    {
        [mArrayQuantity addObject:[NSString stringWithFormat:@"%d",i]];
    }

    
    _viewProductDetail.hidden = NO;

    if(IS_IPHONE5)
        {
        _viewProductDetail.frame = CGRectMake(_viewProductDetail.frame.origin.x, _viewProductDetail.frame.origin.y, 320, 568);
        }
    else
        {
        _viewProductDetail.frame = CGRectMake(_viewProductDetail.frame.origin.x, _viewProductDetail.frame.origin.y, 320, 480);
        }
    [UIView transitionFromView:self.tblViewProductBag toView:_viewProductDetail duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight
                    completion: ^(BOOL inFinished) {
                            //do any post animation actions here
                        //NSLog(@"test");
                        isProductEdit = YES;
                        lblEditprotitle=[[UILabel alloc]init];
                        lblEditprotitle.frame=CGRectMake(40, 25, 250, 21);
                        lblEditprotitle.textColor=[UIColor whiteColor];
                        lblEditprotitle.textAlignment=NSTextAlignmentCenter;
                        lblEditprotitle.text=[_mutDictProductDetail valueForKey:@"prd_name"];
                        [self.view bringSubviewToFront:lblEditprotitle];
                      
                        [self.view addSubview:lblEditprotitle];
                        isPickerIndex=0;
                        [self.lbl_Price setHidden:YES];
                        [self.lbl_TOTAL setHidden:YES];
                        [self.btnPAY_SECURELY setHidden:YES];
                        
                        [self setContentView];
                    }];
}

- (IBAction)btnEditApplyAction:(id)sender
{
   
     [self showLoader];
   
    NSLog(@"dict is %@",dictEdit);
    NSDictionary *params=@{@"optionid":[dictEdit valueForKey:@"optionid"],@"optionvalue":[dictEdit valueForKey:@"optionval"],@"sku":[dictEdit valueForKey:@"prd_sku"],@"product_id":[dictEdit valueForKey:@"prd_id"],@"qty":strprdqty,@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"],@"cart_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsupdate" Withparms:params WithSuccess:^(id response)
     {
         
         //[self mySecondMethod:mDict];
         NSDictionary *editresponse=[response JSONValue];
         
         
         [AppDelegate appDelegate].arrAddToBag=[[NSMutableArray alloc]init];
         [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
         [AppDelegate appDelegate].arrAddToBag=[editresponse valueForKey:@"data"];
         arraycontent = [editresponse valueForKey:@"data"];
         _btnPAY_SECURELY.userInteractionEnabled=YES;
         [self arrDataCountfrom:arraycontent];
          [[NSUserDefaults standardUserDefaults]setObject:[editresponse valueForKey:@"subtotal"] forKey:@"subtotal"];
         
         _lbl_Price.text=[NSString stringWithFormat:@"$ %0.2f",[[editresponse valueForKey:@"subtotal"]floatValue ]];
         
         
         if([[AppDelegate appDelegate].arrAddToBag count]>0)
         {
             
             lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %lu ITEMS" ,(unsigned long)[[AppDelegate appDelegate].arrAddToBag count]];
         }
         else
         {
             lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %@ ITEM" ,@"0"];
             
             
         }
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         isProductEdit = NO;
         tblViewProductBag.hidden=NO;
         _viewProductDetail.hidden = YES;
         pickerViewDetail.hidden = YES;
         self.pickerViewColorandSize.hidden = YES;
         [self.pickerToolbar1 removeFromSuperview];
         
         
         [UIView transitionFromView:_viewProductDetail toView:self.tblViewProductBag duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                         completion: ^(BOOL inFinished)
          {
              //do any post animation actions here
              [self.lbl_Price setHidden:NO];
              [self.lbl_TOTAL setHidden:NO];
              [self.btnPAY_SECURELY setHidden:NO];
              [lblEditprotitle removeFromSuperview];
              
          }];
         
         [self.tblViewProductBag reloadData];

         //[self GetProductsAgain];
         
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
     }];
    

    
  /*  if (isPickerIndex !=0)
    {
         NSLog(@"Picerindex is greater than zero");
        [self showLoader];
        [self myfirstMethod:indexTag];
        
        self.pickerViewColorandSize.hidden = YES;
        [self.pickerToolbar1 removeFromSuperview];
       }
    else
    {
      
        NSLog(@"Picerindex is zero");
        [self showLoader];
        [self myfirstMethod:indexTag];
        
        self.pickerViewColorandSize.hidden = YES;
        [self.pickerToolbar1 removeFromSuperview];

    }*/
    
}

-(void)getWeightOptionWebService:(int)prdID
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor clearColor];
    hud.dimBackground = NO;
    
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
         [hud hide:YES];
         if (data==nil) {
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             return ;
             
         }
         
         
         arrWeight=[[NSMutableArray alloc]init];
         arrWeight= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         if (arrWeight == nil)
         {
            // [_btnOption setHidden:YES];
          
         }         // //NSLog(@"this is data --- %@",[AppDelegate appDelegate].dataArray);
         
         //arrWeight=[NSMutableArray arrayWithArray:[arrResponse valueForKey:@"custome_values"]];
         
         [hud hide:YES];
         
       
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




-(void)myfirstMethod:(NSInteger) indexx{

    NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:indexx];

   
     //[self getWeightOptionWebService:[[mDict valueForKey:@"prd_id"] intValue]];
    
//    NSDictionary *parameters1 = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
//                                  @"qty":[mDict valueForKey:@"prd_qty"],
//                                  @"product_id":[mDict valueForKeyPath:@"prd_id"],
//                                  @"sku":[mDict valueForKey:@"prd_sku"],
//                                  };
    
    //ShoppingCartProductsupdate
    
    NSDictionary *parameters1 = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
                                  @"qty":[mDict valueForKey:@"prd_qty"],
                                  @"product_id":[mDict valueForKeyPath:@"prd_id"],
                                  @"sku":[mDict valueForKey:@"prd_sku"],
                                  };
    //[CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters1 WithSuccess:^(id response)
    [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsupdate" Withparms:parameters1 WithSuccess:^(id response)
     {
         
         //[self mySecondMethod:mDict];
         
         
         [UIView transitionFromView:_viewProductDetail toView:self.tblViewProductBag duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                         completion: ^(BOOL inFinished)
          {
              //do any post animation actions here
              [self.lbl_Price setHidden:NO];
              [self.lbl_TOTAL setHidden:NO];
              [self.btnPAY_SECURELY setHidden:NO];
              
              
          }];
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self GetProductsAgain];
         
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
     }];
    
}
-(void)GetProductsAgain
{
    NSDictionary *parameters1 = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
    [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsget" Withparms:parameters1 WithSuccess:^(id response)
     {
         NSMutableDictionary *mDict=[response JSONValue];
        
         [AppDelegate appDelegate].arrAddToBag=[[NSMutableArray alloc]init];
         [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
         [AppDelegate appDelegate].arrAddToBag=[mDict valueForKey:@"data"];
         
         if([[AppDelegate appDelegate].arrAddToBag count]>0)
         {
             
            lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %lu ITEMS" ,(unsigned long)[[AppDelegate appDelegate].arrAddToBag count]];
         }
         else
         {
             lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %@ ITEM" ,@"0"];
         
         
         }
                [AppDelegate appDelegate].requestFor = ADDPRODUCT;
         //[self addToBagProduct:mDict];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         //[self mySecondMethod:mDict];
         isProductEdit = NO;
         _viewProductDetail.hidden = YES;
         pickerViewDetail.hidden = YES;
         
         [UIView transitionFromView:_viewProductDetail toView:self.tblViewProductBag duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                         completion: ^(BOOL inFinished)
          {
              //do any post animation actions here
              [self.lbl_Price setHidden:NO];
              [self.lbl_TOTAL setHidden:NO];
              [self.btnPAY_SECURELY setHidden:NO];
              
          }];
         [self.tblViewProductBag reloadData];
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
     }];


}

-(void)mySecondMethod:(NSMutableDictionary*) dic
{
    NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
    
    if (isPickerIndex !=0)
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
            [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:isPickerIndex-1] valueForKey:@"title"] forKey:@"option_value"];
            [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
            [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:isPickerIndex-1] valueForKey:@"option_id"] forKey:@"option_id"];
            [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:isPickerIndex-1] valueForKey:@"option_type_id"] forKey:@"option_type_id"];
            if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
            {
                [jsonArray addObject:jsonDict];
            }
        }
    }
    // [jsonDict setValue:[mDict valueForKey:@"prd_Attribute_Title"] forKey:@"option_value"];
    
    
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString1 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //  //NSLog(@"JSON Output: %@", jsonString);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor clearColor];
    hud.dimBackground = NO;
    NSString *strProductOptions = [NSString stringWithFormat:@""];
    NSMutableArray *optionArray = [jsonString1 JSONValue];
    for(int i = 0; i < [optionArray count]; i++)
    {
        NSMutableDictionary *dict = [optionArray objectAtIndex:i];
        if (i == 0)
        {
            strProductOptions = [strProductOptions stringByAppendingString:@"{"];
        }
        
        if(![[dict valueForKey:@"option_id"] isEqualToString:@""])
        {
            strProductOptions = [strProductOptions stringByAppendingFormat:@"\"%@\"",[dict valueForKey:@"option_id"]];
            
            strProductOptions = [strProductOptions stringByAppendingFormat:@":\"%@\"",[dict valueForKey:@"option_type_id"]];
            if(i != [optionArray count] - 1)
            {
                strProductOptions = [strProductOptions stringByAppendingString:@","];
            }
        }
        if(i == [optionArray count] - 1)
        {
            strProductOptions = [strProductOptions stringByAppendingString:@"}"];
        }
    }
    NSData *data = [strProductOptions dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    
    NSString *strProduct=[dic valueForKey:@"prd_id"];
    
    NSDictionary *parameters = @{@"prod_id":[dic valueForKey:@"prd_id"],
                                 @"customer_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"],
                                 @"prod_qty":@"1",@"prod_options":jsonString};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsAdd" Withparms:parameters WithSuccess:^(id response)
     {
//         NSString *newID=@"";
//         
//         NSArray *arrResponse=[[NSArray alloc]init];
//         arrResponse=[[response JSONValue]valueForKey:@"ProductDetails"];
//         
//         
//         for (int i=0; i<arrResponse.count; i++)
//         {
//            NSDictionary *d2= [[arrResponse objectAtIndex:i]valueForKey:@"product_id"];
//             
//             if ([strProduct isEqualToString:[d2 valueForKey:@"product_id"]])
//             {
//                 newID=[d2 valueForKey:@"ItemId"];
//             }
//         }
       
         NSArray *arr=[[NSArray alloc]init];
         NSMutableArray *arrUpdate=[[NSMutableArray alloc]init];
         
         arr=[[response JSONValue] valueForKey:@"ProductDetails"];
         
         
//         for (int i=0; i<arr.count; i++)
//         {
//             NSString  *strID= [[arr objectAtIndex:i]valueForKey:@"ItemId"];
//             [arrUpdate addObject:strID];
//         }
//         
//         NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
//         NSArray *descriptors=[NSArray arrayWithObject: descriptor];
//         NSArray *reverseOrder=[arrUpdate sortedArrayUsingDescriptors:descriptors];
         
       //  NSString *newID = [[[[response JSONValue] valueForKey:@"ProductDetails"] objectAtIndex:0] valueForKey:@"ItemId"];
         
        // NSString *newID=[reverseOrder objectAtIndex:reverseOrder.count-1];
         
            NSString  *strID= [[arr objectAtIndex:arr.count-1]valueForKey:@"ItemId"];
        
         [self myThirdMethod:dic newQty:strID];
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error = %@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

-(void)myThirdMethod:(NSMutableDictionary*)mDict newQty:(NSString*)qty
{
    NSString *jsonString = [mDict valueForKey:@"option_json_value"];
    //NSMutableArray *optionArray = [jsonString JSONValue];
    NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
    
    if (isPickerIndex == 0)
    {
        isPickerIndex=1;
    }
    
    for(NSMutableDictionary *mDict in arrProductColorAndSize)
    {
        NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
       
        [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:isPickerIndex-1] valueForKey:@"title"] forKey:@"option_value"];
        [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
        [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:isPickerIndex-1] valueForKey:@"option_id"] forKey:@"option_id"];
        [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:isPickerIndex-1] valueForKey:@"option_type_id"] forKey:@"option_type_id"];
        if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
        {
            [jsonArray addObject:jsonDict];
            
        }
    }
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&writeError];
    
    NSString *jsonString1 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
   // float updatePrice = [qty floatValue] * [[mDict valueForKey:@"prd_update_price"] floatValue];
      float updatePrice =  [[mDict valueForKey:@"prd_update_price"] floatValue];
    
    NSDictionary *parameters1 = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
                                  @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],
                                  @"prd_qty":@"1",
                                  @"option_json_value": jsonString1,
                                  @"product_id":[mDict valueForKeyPath:@"prd_id"],
                                  @"prd_default_price":[mDict valueForKey:@"prd_price"],
                                  @"uniq_id":qty,
                                  @"weight":[mDict valueForKey:@"prd_weight"],
                                  @"prd_update_price":[NSString stringWithFormat:@"%f",updatePrice],
                                  @"get":@"1",@"updated_at":[_mutDictProductDetail valueForKey:@"product_update_date"]};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters1 WithSuccess:^(id response)
     {
         
         [self myFourthMethod];
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];

}

-(void)myFourthMethod
{

//    isPickerIndex=0;
    NSString *customer_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"];
    if(customer_id == nil)
    {
        customer_id = @"";
    }
    
    if(![customer_id isEqualToString:@""])
    {
        NSDictionary *parameters = @{@"customer_id": customer_id, @"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
        
        [CartrizeWebservices PostMethodWithApiMethod:@"GetUserAllCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
             [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
             [AppDelegate appDelegate].arrAddToBag = [response JSONValue];
             
             [self setTotalValue];
             
             isProductEdit = NO;
             _viewProductDetail.hidden = YES;
             pickerViewDetail.hidden = YES;
             
             [UIView transitionFromView:_viewProductDetail toView:self.tblViewProductBag duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                             completion: ^(BOOL inFinished)
              {
                  //do any post animation actions here
                  [self.lbl_Price setHidden:NO];
                  [self.lbl_TOTAL setHidden:NO];
                  [self.btnPAY_SECURELY setHidden:NO];
                  
              }];
             [self.tblViewProductBag reloadData];
             
         } failure:^(NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             //NSLog(@"Error =%@",[error description]);
         }];
    }
}


-(void)deleteProductFromBag:(NSNotification *)notification
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
    
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString1 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //  //NSLog(@"JSON Output: %@", jsonString);
    
    NSString *strProductOptions = [NSString stringWithFormat:@""];
    NSMutableArray *optionArray = [jsonString1 JSONValue];
    for(int i = 0; i < [optionArray count]; i++)
        {
        NSMutableDictionary *dict = [optionArray objectAtIndex:i];
        if (i == 0)
            {
            strProductOptions = [strProductOptions stringByAppendingString:@"{"];
            }
        
        if(![[dict valueForKey:@"option_id"] isEqualToString:@""])
            {
            strProductOptions = [strProductOptions stringByAppendingFormat:@"\"%@\"",[dict valueForKey:@"option_id"]];
            
            strProductOptions = [strProductOptions stringByAppendingFormat:@":\"%@\"",[dict valueForKey:@"option_type_id"]];
            if(i != [optionArray count] - 1)
                {
                strProductOptions = [strProductOptions stringByAppendingString:@","];
                }
            }
        if(i == [optionArray count] - 1)
            {
            strProductOptions = [strProductOptions stringByAppendingString:@"}"];
            }
        }
    
    NSData *data = [strProductOptions dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //DIPESH.
//    NSDictionary *parameters = @{@"prod_id":[_mutDictProductDetail valueForKey:@"prd_id"],@"prod_qty":[_mutDictProductDetail valueForKey:@"prd_qty"],@"prod_options":jsonString};
    
     NSDictionary *parameters = @{@"prod_id":[_mutDictProductDetail valueForKey:@"prd_id"],@"customer_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"],@"prod_qty":[_mutDictProductDetail valueForKey:@"prd_qty"],@"prod_options":jsonString};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsAdd" Withparms:parameters WithSuccess:^(id response)
     {
         // //NSLog(@"Add Product Response= %@",[response JSONValue]);
     NSMutableDictionary *mDict = [response JSONValue];

     NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
     [userDefualt setObject:[mDict valueForKey:@"cartid"] forKey:@"cart_id"];
     [userDefualt synchronize];
     
     
     [self addToBagProduct:mDict];
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     } failure:^(NSError *error)
     {
     //NSLog(@"Error = %@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

-(void)addToBagProduct :(NSMutableDictionary *)CartParam
{
    NSString *product_id = [_mutDictProductDetail objectForKey:@"prd_id"];
    BOOL isUpdateQty = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor clearColor];
   // hud.dimBackground = YES;
    
    for (NSMutableDictionary *mDictBag in [AppDelegate appDelegate].arrAddToBag)
        {
        if([[mDictBag valueForKey:@"prd_id"]isEqualToString:[_mutDictProductDetail valueForKeyPath:@"prd_id"]])
            {
            NSString *jsonString = [mDictBag valueForKey:@"option_json_value"];
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
            NSError *writeError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&writeError];
            
            NSString *jsonString1 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            if([jsonString1 isEqualToString:jsonString])
                {
                int qty = [[mDictBag valueForKey:@"prd_qty"] intValue];
                qty = qty + [[_mutDictProductDetail valueForKey:@"prd_qty"] intValue];
                
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
            
                    NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":strQty,@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":strUniqID,@"prd_default_price":[_mutDictProductDetail valueForKey:@"prd_price"],@"prd_update_price":strPrice,@"get":@"1",@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],@"updated_at":[_mutDictProductDetail valueForKey:@"product_update_date"]};
                
                [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
                 {
                     // //NSLog(@"Response = %@",[response JSONValue]);
                     // //NSLog(@"jsonString = %@",jsonString);
                 [AppDelegate appDelegate].requestFor = EDITPRODUCT;
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
                }
            else
                {
                    // arr add object
                //NSLog(@"After round 1 to match array no found object");
                    // we can add this object
                NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[_mutDictProductDetail objectForKey:@"prd_qty"],@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":[mDictPrdDetail valueForKey:@"ItemId"],@"prd_default_price":[_mutDictProductDetail valueForKey:@"prd_price"],@"prd_update_price":strPrice,@"get":@"1",@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],@"updated_at":[_mutDictProductDetail valueForKey:@"product_update_date"]};
                [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
                 {
                
                     // //NSLog(@"Response = %@",[response JSONValue]);
                 [AppDelegate appDelegate].requestFor = EDITPRODUCT;
                 [[AppDelegate appDelegate] getCheckOutHistory];
                 } failure:^(NSError *error)
                 {
                 //NSLog(@"Error =%@",[error description]);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }];
                }
            }
        }
}


-(void) getYourBagItem
{
    int bagCount = 0;
    for(int i = 0; i < [[AppDelegate appDelegate].arrAddToBag count]; i++)
        {
        NSString *strQutanty = [[[AppDelegate appDelegate].arrAddToBag objectAtIndex:i] valueForKey:@"prd_qty"];
        bagCount = bagCount+[strQutanty intValue];
        }
    lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %lu ITEMS" ,(unsigned long)[[AppDelegate appDelegate].arrAddToBag count]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:bagCount forKey:@"bag_count"];
}

-(IBAction)btnEditQtyActi:(id)sender
{
    deleteIndex = [sender tag];

    UIAlertView *editalert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure, you want to edit this product ? As this action will delete the existing item in your cart" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    editalert.tag=456321;
    //[editalert show];

  /*  [self.pickerViewDetail removeFromSuperview];
    [self.pickerToolbar1 removeFromSuperview];

    strQty2=@"1";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *mDictBag = [appDelegate.arrAddToBag objectAtIndex:[sender tag]];
    
    
    //Product Quantity
    mArrayQuantity = [[NSMutableArray alloc] init];
    //NSNumber *num = ;
    int totalQty = [[NSString stringWithFormat:@"%@",[mDictBag objectForKey:@"pro_stock"]] intValue];
    
    
    for(int i=1;i <= totalQty;i++)
    {
        [mArrayQuantity addObject:[NSString stringWithFormat:@"%d",i]];
    }

       btnIndexOfEdit= (int)[sender tag];
    
    if(IS_IPHONE5)
        {
        self.pickerToolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 362, 320, 44)];
        self.pickerViewDetail = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 406, 320, 162)];
        self.pickerViewDetail.delegate = self;
        self.pickerViewDetail.showsSelectionIndicator = YES;
        self.pickerViewDetail.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.pickerViewDetail];
        }
    else
        {
        self.pickerToolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 274, 320, 44)];
        self.pickerViewDetail = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 318, 320, 162)];
        self.pickerViewDetail.delegate = self;
        self.pickerViewDetail.showsSelectionIndicator = YES;
        self.pickerViewDetail.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.pickerViewDetail];
        }
    selectedItemIndex = 2;
    
    UIButton *done_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    done_Button.frame=CGRectMake(0.0, 0, 60.0, 30.0);
    if([mArrayQuantity count]==0)
    {
        done_Button.userInteractionEnabled=NO;
    }
    else
    {
    done_Button.userInteractionEnabled=YES;
    
    }
    [done_Button setTitle:@"Done" forState:UIControlStateNormal];
    [done_Button addTarget:self action:@selector(btnDoneToolbarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    done_Button.tag = [sender tag];
    
    UIButton *cancel_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel_Button.frame=CGRectMake(0.0, 0, 60.0, 30.0);
    [cancel_Button setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel_Button addTarget:self action:@selector(btnCancelToolbarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithCustomView:done_Button];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithCustomView:cancel_Button];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIView *toolBarNa = [[UIView alloc]initWithFrame:_pickerToolbar1.bounds];
    [toolBarNa setBackgroundColor:[UIColor colorWithRed:166/255.0f green:187/255.0f blue:94/255.0f alpha:1.0]];

    
    [self.pickerToolbar1 insertSubview:toolBarNa atIndex:0];
    
    CALayer *l=self.pickerToolbar1.layer;
    [l setCornerRadius:0.5];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
    [l setBorderWidth:0.5];
    [self.pickerToolbar1 setItems:[NSArray arrayWithObjects:btnCancel, flex, myButton, nil]];
    [self.view addSubview:self.pickerToolbar1];
    
   // mArrayQuantity = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
    
    
    

//    int totalQty = [num intValue];
//    
//    if (totalQty >= 10)
//    {
//        for(int i=1;i <= 10;i++)
//       {
//            [mArrayQuantity addObject:[NSString stringWithFormat:@"%d",i]];
//        }
//    }
//    else
//    {
//        for(int i=1;i <= totalQty;i++)
//        {
//            [mArrayQuantity addObject:[NSString stringWithFormat:@"%d",i]];
//        }
//
//    }
//
    [self.pickerViewDetail reloadAllComponents];*/
}

- (IBAction)btnCancelToolbarAction:(id)sender
{
    [self.pickerViewDetail removeFromSuperview];
    [self.pickerToolbar1 removeFromSuperview];
    self.pickerViewDetail.hidden=YES;
    self.pickerViewDetail.hidden=YES;
}

- (IBAction)CancelButtonPressed:(id)sender
{
    NSMutableDictionary *mDict = [arrProductColorAndSize objectAtIndex:isSelectedPicker];
    
    NSMutableDictionary *mDict2=[[AppDelegate appDelegate].arrAddToBag objectAtIndex:indexTag];
    
    
    if([[mDict valueForKey:@"prd_New_Price"] floatValue ] > 0)
        {
        [mDict setValue:[mDict valueForKey:@"prd_New_Price"] forKey:@"prd_New_Price"];
        }
    else
        {
        [mDict setValue:[mDict2 valueForKey:@"prd_price"] forKey:@"prd_New_Price"];
        }
    
    lblProductPrice.text = [NSString stringWithFormat:@"%@%@",[AppDelegate appDelegate].currencySymbol,[self setProductPrice]];
    
    self.pickerViewColorandSize.hidden = YES;
    [self.pickerToolbar1 removeFromSuperview];
}


- (IBAction)doneBtnPressToGetValue:(id)sender
 {
     
     NSString *strUpdated_Price;
    self.tableViewPrdAttributes.userInteractionEnabled = YES;
    
   self.pickerViewColorandSize.hidden = YES;
    [self.pickerToolbar1 removeFromSuperview];
    
    NSMutableDictionary *mDict = [arrProductColorAndSize objectAtIndex:isSelectedPicker];
    
     arrPickerSelect=[mDict valueForKey:@"custome_values"];
//     //custome_values
//     NSLog(@"%@",[arrPickerSelect objectAtIndex:isPickerIndex]);
//      NSLog(@"%@",[[arrPickerSelect objectAtIndex:isPickerIndex] valueForKey:@"price"]);
    
     //===============================
       Price = 0.0;
     
     if (isPickerIndex == 0)
     {
         Price = strDefaultPrice;
       //  strUpdated_Price=[NSString stringWithFormat:@"%f",Price];
         [self.btnApply setEnabled:NO];
         NSDictionary *dic=[[AppDelegate appDelegate].arrAddToBag objectAtIndex:indexTag];
         strUpdated_Price=[NSString stringWithFormat:@"%@",[dic valueForKey:@"prd_update_price"]];
     }
     else
     {
         [self.btnApply setEnabled:YES];
         strAttributeTitile = [[_mArrayProductAttributes objectAtIndex:isPickerIndex-1] objectForKey:@"title"];
         strPrdOptionId = [[_mArrayProductAttributes objectAtIndex:isPickerIndex-1] objectForKey:@"option_id"];
         strPrdOptionTypeId = [[_mArrayProductAttributes objectAtIndex:isPickerIndex-1] objectForKey:@"option_type_id"];
         Price = strDefaultPrice + [[[_mArrayProductAttributes objectAtIndex:isPickerIndex-1] objectForKey:@"price"] floatValue];
         strUpdated_Price=[NSString stringWithFormat:@"%f",Price];
     }
   
     [mDict setValue:strAttributeTitile forKey:@"selecte"];
     
     ///hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
      NSMutableDictionary *dictCart = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:indexTag];
     [dictCart setValue:strUpdated_Price forKey:@"prd_update_price"];
     [[AppDelegate appDelegate].arrAddToBag replaceObjectAtIndex:indexTag withObject:dictCart];
     //hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
     
     [arrProductColorAndSize replaceObjectAtIndex:isSelectedPicker withObject:mDict];
     //===============================
     
    lblProductPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,Price];
    
  //  strProductPrice = @"0";
    /*
     [mDict setValue:strProductPrice forKey:@"prd_New_Price"];
     [[_arrProductColorAndSize objectAtIndex:isSelectedPicker]setValue:strAttributeTitile forKey:@"prd_Attribute_Title"];
     
     //NSLog(@"strAttributeTitile =%@",strAttributeTitile);
     [[_arrProductColorAndSize objectAtIndex:isSelectedPicker]setValue:strPrdOptionId forKey:@"prd_option_id"];
     
     [[_arrProductColorAndSize objectAtIndex:isSelectedPicker]setValue:strPrdOptionTypeId forKey:@"prd_option_type_id"]; */  //Hupendra
    
    [self.tableViewPrdAttributes reloadData];

}

//-(void)getWeightOptionWebService
//{
//    int prdID = [[_mutDictProductDetail objectForKey:@"prd_id"] intValue];
//    
//    NSString *jsonString = [NSString stringWithFormat:@"http://cartrize.com/iosapi_cartrize.php?methodName=getAllProductsOptions&prd_id=%d",prdID];
//    
//    NSString* encodedUrl = [jsonString stringByAddingPercentEscapesUsingEncoding:
//                            NSASCIIStringEncoding];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]];
//    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response,
//                                               NSData *data,
//                                               NSError *connectionError)
//     {
//
//         id weight = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//         
//         }];
//}

- (IBAction)doneBtnPressToGetValue1:(id)sender
{
    self.pickerViewColorandSize.hidden = YES;
    [self.pickerToolbar1 removeFromSuperview];
    [[arrProductColorAndSize objectAtIndex:isSelectedPicker]setValue:strAttributeTitile forKey:@"prd_Attribute_Title"];
    
    NSMutableDictionary *mDict = [arrProductColorAndSize objectAtIndex:isSelectedPicker];
    
    [mDict setValue:strProductPrice forKey:@"prd_New_Price"];
    
    lblProductPrice.text = [NSString stringWithFormat:@"%@%@",[AppDelegate appDelegate].currencySymbol,[self setProductPrice]];
    
    strProductPrice = @"0";
    [[arrProductColorAndSize objectAtIndex:isSelectedPicker]setValue:strAttributeTitile forKey:@"prd_Attribute_Title"];
    
    [[arrProductColorAndSize objectAtIndex:isSelectedPicker]setValue:strPrdOptionId forKey:@"prd_option_id"];
    
    [[arrProductColorAndSize objectAtIndex:isSelectedPicker]setValue:strPrdOptionTypeId forKey:@"prd_option_type_id"];
    
    [self.tableViewPrdAttributes reloadData];
}

-(NSString *)setProductPrice
{
    float newPrice = strDefaultPrice ;
    
    for (NSMutableDictionary *mdict in arrProductColorAndSize)
        {
           
         NSLog(@"%@",[mdict valueForKey:@"price"]);
        newPrice = [[mdict valueForKey:@"price"]floatValue] + newPrice;
        }
    return [NSString stringWithFormat:@"%.2f",newPrice];
}

- (IBAction)btnDoneToolbarAction:(id)sender
{
    
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
        
    }
    
    NSLog(@"Called");
    // NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:btnIndexOfEdit];
    
  /*  pickerViewDetail.hidden = YES;
    self.pickerToolbar.hidden = YES;
   
    
    if(selectedItemIndex == 2)
        {
        [self.pickerViewDetail removeFromSuperview];
        [self.pickerToolbar1 removeFromSuperview];
        [self showLoader];
        
        NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:btnIndexOfEdit];
        
//            [[mDict valueForKey:@"customerdetails"]valueForKey:@"cartid"] forKey:@"cart_id"]
        
//            NSMutableArray *jsonArray=[[NSMutableArray alloc]init];
//            
//            for(NSMutableDictionary *mDict in arrProductColorAndSize)
//            {
//                NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
//                
//                [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:indexTag] valueForKey:@"title"] forKey:@"option_value"];
//                [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
//                [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:indexTag] valueForKey:@"option_id"] forKey:@"option_id"];
//                [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:indexTag] valueForKey:@"option_type_id"] forKey:@"option_type_id"];
//                if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
//                {
//                    [jsonArray addObject:jsonDict];
//                    
//                }
//            }
//            NSError *writeError = nil;
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&writeError];
//            
//            NSString *jsonString1 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            //  @"option_json_value":jsonString1
            
           // NSString *jsonString1 = [mDict valueForKey:@"option_json_value"];
            
//        NSDictionary *parameters1 = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
//                                      @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],
//                                      @"prd_qty":[mDict objectForKey:@"prd_qty"],
//                                      @"product_id":[mDict valueForKeyPath:@"prd_id"],
//                                      @"prd_default_price":[mDict valueForKey:@"prd_price"],
//                                      @"option_json_value":jsonString1,
//                                      @"uniq_id":[mDict valueForKey:@"uniq_id"],
//                                      @"weight":[mDict valueForKey:@"prd_weight"],
//                                      @"prd_update_price":[mDict valueForKey:@"prd_update_price"],
//                                      @"get":@"0"};
            
            
           // float updatePrice = [strQty floatValue] * [[mDict valueForKey:@"prd_update_price"] floatValue];
        
//          NSDictionary *parameters1 = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
//                                        @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],
//                                        @"prd_qty":strQty,
//                                        @"product_id":[mDict valueForKeyPath:@"prd_id"],
//                                        @"prd_default_price":[mDict valueForKey:@"prd_price"],
//                                        @"uniq_id":[mDict valueForKey:@"uniq_id"],
//                                        @"weight":[mDict valueForKey:@"prd_weight"],
//                                        @"prd_update_price":[mDict valueForKey:@"prd_update_price"],
//                                        @"get":@"0"};
            
//            NSDictionary *parameters1 = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
//                                          @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],
//                                          @"uniq_id":[mDict valueForKey:@"uniq_id"],
//                                          @"product_id":[mDict valueForKey:@"prd_id"],
//                                          @"get":@"0"};
            
          /*  NSDictionary *parameters1 = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"product_id":[mDict valueForKeyPath:@"prd_id"],@"uniq_id":[mDict valueForKey:@"uniq_id"],@"get":@"0",@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};*/

    
//    if([strQty2 isEqualToString:@""])
//    {
//        strQty2=@"1";
//    
//    }
    //strQty2=[NSString stringWithFormat:@"%d",[strQty2 integerValue]+1];
//            NSDictionary *parameters1 = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
//                                          @"qty":strQty2,
//                                          @"product_id":[mDict valueForKeyPath:@"prd_id"],
//                                          @"sku":[mDict valueForKey:@"prd_sku"],
//                                          };
//
//
//            //DELETE_1===================================
//            [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsupdate" Withparms:parameters1 WithSuccess:^(id response)
//             {
//             
//                 //[self secondServiceCall:mDict];
//                 NSDictionary *dict=[response JSONValue];
//                 if([[dict valueForKey:@"update"]isEqualToString:@"success"])
//                 {
//                 [self getAllProducts];
//                 }
//                //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                 
//                 
//             } failure:^(NSError *error)
//             {
//                 //NSLog(@"Error =%@",[error description]);
//                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                 [alert show];
//             }];
//
//            
            /*
        NSDictionary *parameters = @{@"item_id":[mDict valueForKey:@"uniq_id"]};
        
        [CartrizeWebservices PostMethodWithApiMethod:@"CartAllItemsDelete" Withparms:parameters WithSuccess:^(id response)
         {
        
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         //NSLog(@"Cart Items Delete =%@",[response JSONValue]);
             //Hupendra
         if([[response JSONValue]isKindOfClass:[NSString class]]){
             UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Title" message:[response JSONValue] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alertView show];
       
         }
//         else if([response JSONValue]==nil){
//             UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Title" message:response delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//             [alertView show];
//         }
         else
         {
            [self editQtyWithProductDetail:mDict];
         }
             //End Hupendra
         
             //Old[self editQtyWithProductDetail:mDict];
         
         } failure:^(NSError *error)
         {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
            
    
        }*/
    
   
    if (isPickerIndex == 0)
    {
        strprdqty=@"1";
              [_btnEditdisplay setTitle:strprdqty forState:UIControlStateNormal];
        
    }
    else
    {
        strprdqty=[mArrayQuantity objectAtIndex:editQty];
        [_btnEditdisplay setTitle:[mArrayQuantity objectAtIndex:editQty] forState:UIControlStateNormal];
    }

    [self.pickerViewDetail removeFromSuperview];
    [self.pickerToolbar1 removeFromSuperview];
    self.pickerViewDetail.hidden=YES;
    self.pickerViewDetail.hidden=YES;
    

}

-(void)getAllProducts
{
    //[self showLoader];
     if ([[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]!=nil) {
         
         NSDictionary *param=@{@"cartid":[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"],@"email":[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]};
    
    
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
            
             //[[NSUserDefaults standardUserDefaults]setObject:arrayCartData forKey:@"arrayCartData"];
             [AppDelegate appDelegate].arrAddToBag=[[NSMutableArray alloc]init];
             [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
             [AppDelegate appDelegate].arrAddToBag=[mDict valueForKey:@"data"];
             if([[AppDelegate appDelegate].arrAddToBag count]>0)
             {
                 
                 lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %lu ITEMS" ,(unsigned long)[[AppDelegate appDelegate].arrAddToBag count]];
             }
             else
             {
                 lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %@ ITEM" ,@"0"];
                 
                 
             }

             [[NSUserDefaults standardUserDefaults ]setObject:[mDict valueForKey:@"subtotal"] forKey:@"subtotal"];
             if([[NSUserDefaults standardUserDefaults]valueForKey:@"subtotal"]!=nil)
             {
                 self.lbl_Price.text=[NSString stringWithFormat:@"%@ %.02f",[AppDelegate appDelegate].currencySymbol,[[[NSUserDefaults standardUserDefaults]valueForKey:@"subtotal"]floatValue]];
             }
             else
             {
                 self.lbl_Price.text=[NSString stringWithFormat:@"%@ %@",[AppDelegate appDelegate].currencySymbol,@"0"];
                 
             }
             arraycontent=[mDict valueForKey:@"data"];
             [MBProgressHUD hideHUDForView:self.view animated:YES];

             dispatch_async(dispatch_get_main_queue(), ^{
                 [tblViewProductBag reloadData];
             });
            
            
             //[self addToBagProduct:mDict];
             
         } failure:^(NSError *error)
         {
             //NSLog(@"Error = %@",[error description]);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
     }
     else{
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }
    
}

//DELETE_2===================================
-(void)secondServiceCall:(NSMutableDictionary*)dic
{
    NSString *jsonString1 = [dic valueForKey:@"option_json_value"];
    NSString *strProductOptions = [NSString stringWithFormat:@""];
    NSMutableArray *optionArray = [jsonString1 JSONValue];
    for(int i = 0; i < [optionArray count]; i++)
    {
//        NSMutableDictionary *dict = [optionArray objectAtIndex:i];
//        if (i == 0)
//        {
//            strProductOptions = [strProductOptions stringByAppendingString:@"{"];
//        }
//        
//        if(![[dict valueForKey:@"option_id"] isEqualToString:@""])
//        {
//            strProductOptions = [strProductOptions stringByAppendingFormat:@"%@",[dict valueForKey:@"option_id"]];
//            
//            strProductOptions = [strProductOptions stringByAppendingFormat:@":%@",[dict valueForKey:@"option_type_id"]];
//            if(i != [optionArray count] - 1)
//            {
//                strProductOptions = [strProductOptions stringByAppendingString:@","];
//            }
//        }
//        if(i == [optionArray count] - 1)
//        {
//            strProductOptions = [strProductOptions stringByAppendingString:@"}"];
//        }
//    }

        NSMutableDictionary *dict = [optionArray objectAtIndex:i];
        if (i == 0)
        {
            strProductOptions = [strProductOptions stringByAppendingString:@"{"];
        }
        
        if(![[dict valueForKey:@"option_id"] isEqualToString:@""])
        {
            strProductOptions = [strProductOptions stringByAppendingFormat:@"\"%@\"",[dict valueForKey:@"option_id"]];
            
            strProductOptions = [strProductOptions stringByAppendingFormat:@":\"%@\"",[dict valueForKey:@"option_type_id"]];
            if(i != [optionArray count] - 1)
            {
                strProductOptions = [strProductOptions stringByAppendingString:@","];
            }
        }
        if(i == [optionArray count] - 1)
        {
            strProductOptions = [strProductOptions stringByAppendingString:@"}"];
        }
    }

        NSData *data = [strProductOptions dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    if(strQty == nil)
    {
        strQty=@"1";
    }
  
    NSString *strSKU=[[NSString alloc] init];
    strSKU  = [dic valueForKey:@"prd_sku"];
    
    
    NSDictionary *parameters = @{@"prod_id":[dic valueForKey:@"prd_id"],
                                 @"customer_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"],
                                 @"prod_qty":strQty,
                                 @"prod_options":jsonString,@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsAdd" Withparms:parameters WithSuccess:^(id response)
     {
        // NSString *newID = [[[[response JSONValue] valueForKey:@"ProductDetails"] objectAtIndex:0] valueForKey:@"ItemId"];
         
         
         NSArray *arr=[[NSArray alloc]init];
         NSMutableArray *arrUpdate=[[NSMutableArray alloc]init];
         
         arr=[[response JSONValue] valueForKey:@"ProductDetails"];
         
//         for (int i=0; i<arr.count; i++)
//         {
//             NSString  *strID= [[arr objectAtIndex:i]valueForKey:@"ItemId"];
//             [arrUpdate addObject:strID];
//         }
//         
//         NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
//         NSArray *descriptors=[NSArray arrayWithObject: descriptor];
//         NSArray *reverseOrder=[arrUpdate sortedArrayUsingDescriptors:descriptors];
         
         //  NSString *newID = [[[[response JSONValue] valueForKey:@"ProductDetails"] objectAtIndex:0] valueForKey:@"ItemId"];
         
       //  NSString *newID=[reverseOrder objectAtIndex:reverseOrder.count-1];
         
        
         
         NSString  *strID= [[arr objectAtIndex:arr.count-1]valueForKey:@"ItemId"];

         [self thirdServiceCall:dic newQty:strID];
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error = %@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

//DELETE_3===================================
-(void)thirdServiceCall:(NSMutableDictionary*)dic newQty:(NSString*)qty{
    
//  NSDictionary *parameters1 = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"product_id":[dic valueForKeyPath:@"prd_id"],@"uniq_id":[dic valueForKey:@"uniq_id"],@"get":@"1"};

    
    NSString *str11=[dic valueForKey:@"option_json_value"];
    
    if([strQty isEqualToString:@"1"])
    {
        
    }
    
    float default_Updated_price = [[dic valueForKey:@"prd_update_price"]floatValue] / [[dic valueForKey:@"prd_qty"] intValue];
    
    float updatePrice = [strQty floatValue] * default_Updated_price;
    
    NSDictionary *parameters1 = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
                                  @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],
                                  @"prd_qty":strQty,
                                  @"product_id":[dic valueForKeyPath:@"prd_id"],
                                  @"prd_default_price":[dic valueForKey:@"prd_price"],
                                  @"option_json_value":str11,
                                  @"uniq_id":qty,
                                  @"weight":[dic valueForKey:@"prd_weight"],
                                  @"prd_update_price":[NSString stringWithFormat:@"%f",updatePrice],
                                  @"get":@"1",@"updated_at":[_mutDictProductDetail valueForKey:@"product_update_date"]};

    [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters1 WithSuccess:^(id response)
     {
         [self fourthServiceCall];
         
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

//DELETE_4===================================
-(void)fourthServiceCall{
    
    NSString *customer_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"];
    if(customer_id == nil)
    {
        customer_id = @"";
    }
    
    if(![customer_id isEqualToString:@""])
    {
        NSDictionary *parameters = @{@"customer_id": customer_id, @"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
        
        [CartrizeWebservices PostMethodWithApiMethod:@"GetUserAllCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
             [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
             [AppDelegate appDelegate].arrAddToBag = [response JSONValue];

             [self setTotalValue];
             
             [tblViewProductBag reloadData];

         } failure:^(NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             //NSLog(@"Error =%@",[error description]);
         }];
    }
}

-(void)editQtyWithProductDetail :(NSMutableDictionary *)ProductDetail
{
    NSString *jsonString1 = [ProductDetail valueForKey:@"option_json_value"];
    NSString *strProductOptions = [NSString stringWithFormat:@""];
    NSMutableArray *optionArray = [jsonString1 JSONValue];
    for(int i = 0; i < [optionArray count]; i++)
        {
        NSMutableDictionary *dict = [optionArray objectAtIndex:i];
        if (i == 0)
            {
            strProductOptions = [strProductOptions stringByAppendingString:@"{"];
            }
        
        if(![[dict valueForKey:@"option_id"] isEqualToString:@""])
            {
            strProductOptions = [strProductOptions stringByAppendingFormat:@"\"%@\"",[dict valueForKey:@"option_id"]];
            
            strProductOptions = [strProductOptions stringByAppendingFormat:@":\"%@\"",[dict valueForKey:@"option_type_id"]];
            if(i != [optionArray count] - 1)
                {
                strProductOptions = [strProductOptions stringByAppendingString:@","];
                }
            }
        if(i == [optionArray count] - 1)
            {
            strProductOptions = [strProductOptions stringByAppendingString:@"}"];
            }
        }
    NSData *data = [strProductOptions dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //DIPESH.
    //NSDictionary *parameters = @{@"prod_id":[ProductDetail valueForKey:@"prd_id"],@"prod_qty":strQty,@"prod_options":jsonString};
    
    NSDictionary *parameters = @{@"prod_id":[ProductDetail valueForKey:@"prd_id"],@"customer_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"],@"prod_qty":strQty,@"prod_options":jsonString,@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};

    
    [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsAdd" Withparms:parameters WithSuccess:^(id response)
     {
         // //NSLog(@"Add Product Response= %@",[response JSONValue]);
     
     NSMutableDictionary *mDict = [response JSONValue];
     
     NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
     [userDefualt setObject:[[mDict valueForKey:@"customerdetails"]valueForKey:@"cartid"] forKey:@"cart_id"];
     [userDefualt synchronize];
         // [self addToBagProduct:mDict];
     [self editProductWithCartDetail:mDict andProductDetail:ProductDetail];
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     } failure:^(NSError *error)
     {
     NSLog(@"Error = %@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

-(void)editProductWithCartDetail :(NSMutableDictionary *)CartDetail andProductDetail :(NSMutableDictionary *)productDetail
{
    NSString *product_id = [productDetail objectForKey:@"prd_id"];
    BOOL isUpdateQty = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   hud.color = [UIColor clearColor];
   // hud.dimBackground = YES;
    for (NSMutableDictionary *mDictBag in [AppDelegate appDelegate].arrAddToBag)
        {
        if([[mDictBag valueForKey:@"prd_id"]isEqualToString:[productDetail valueForKeyPath:@"prd_id"]])
            {
            NSString *jsonString = [mDictBag valueForKey:@"option_json_value"];
            
            NSString *jsonString1 = [productDetail valueForKey:@"option_json_value"];
            if([jsonString1 isEqualToString:jsonString])
                {
                int qty = [[mDictBag valueForKey:@"prd_qty"] intValue];
                qty = qty + [[_mutDictProductDetail valueForKey:@"prd_qty"] intValue];
                
                    //NSString *strQty = [NSString stringWithFormat:@"%d",qty];
                
                NSString *strUniqID = @"";
                
                for (NSMutableDictionary *mDictPrdDetail in [CartDetail objectForKey:@"ProductDetails"])
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
                NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":strQty,@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":strUniqID,@"prd_default_price":[productDetail valueForKey:@"prd_price"],@"prd_update_price":[productDetail valueForKey:@"prd_update_price"],@"get":@"1",@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],@"updated_at":[_mutDictProductDetail valueForKey:@"product_update_date"]};
                
                [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
                 {
                     // //NSLog(@"Response = %@",[response JSONValue]);
                 [AppDelegate appDelegate].requestFor = EDITPRODUCT;
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
        NSString *jsonString =  [productDetail valueForKey:@"option_json_value"];
        for (NSMutableDictionary *mDictPrdDetail in [CartDetail objectForKey:@"ProductDetails"])
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
                }
            else
                {
                    // arr add object
                //NSLog(@"After round 1 to match array no found object");
                    // we can add this object
                NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":strQty,@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":[mDictPrdDetail valueForKey:@"ItemId"],@"prd_default_price":[productDetail valueForKey:@"prd_price"],@"prd_update_price":[productDetail valueForKey:@"prd_update_price"],@"get":@"1",@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],@"updated_at":[_mutDictProductDetail valueForKey:@"product_update_date"]};
                [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
                 {
                     // //NSLog(@"Response = %@",[response JSONValue]);
                 [AppDelegate appDelegate].requestFor = EDITPRODUCT;
                 [[AppDelegate appDelegate] getCheckOutHistory];
                 } failure:^(NSError *error)
                 {
                 //NSLog(@"Error =%@",[error description]);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }];
                }
            }
        }
}




- (IBAction)btnDeleteAction:(id)sender
{
//    [self.pickerViewDetail removeFromSuperview];
//    [self.pickerToolbar1 removeFromSuperview];
//    self.pickerViewDetail.hidden=YES;
//    self.pickerViewDetail.hidden=YES;
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
        
    }
    //NSLog(@"index -- %li",(long)[sender tag]);
    //[self showLoader];
  /*  NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:[sender tag]];
    
    NSDictionary *parameters = @{@"item_id":[mDict valueForKey:@"uniq_id"]};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"CartAllItemsDelete" Withparms:parameters WithSuccess:^(id response)
     {
    
     //NSLog(@"Cart Items Delete =%@",[response JSONValue]);
         if ([response JSONValue] == NULL)
         {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Removed successfully.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [av show];
             
          //   [self FoterValues];
         }
     } failure:^(NSError *error)
     {
     //NSLog(@"Error =%@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
    NSDictionary *parameters1 = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"product_id":[mDict valueForKeyPath:@"prd_id"],@"uniq_id":[mDict valueForKey:@"uniq_id"],@"get":@"0",@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};
    
    
    [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters1 WithSuccess:^(id response) {
            //self.arrAddToBag = [response JSONValue];
        
        [AppDelegate appDelegate].requestFor = DELETEPRODUCT;
        [[AppDelegate appDelegate] getCheckOutHistory];
        
      //  [self FoterValues];
        
    } failure:^(NSError *error)
     {
     //NSLog(@"Error =%@",[error description]);
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];*/
    deleteIndex = [sender tag];
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Do you want to remove product from cart?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    av.tag = 101;
    [av show];
    
    NSLog(@"Called");
    
   
    /*  pickerViewDetail.hidden = YES;
     self.pickerToolbar.hidden = YES;
     
     
     if(selectedItemIndex == 2)
     {
     [self.pickerViewDetail removeFromSuperview];
     [self.pickerToolbar1 removeFromSuperview];
     [self showLoader];
     
     NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:btnIndexOfEdit];
     
     //            [[mDict valueForKey:@"customerdetails"]valueForKey:@"cartid"] forKey:@"cart_id"]
     
     //            NSMutableArray *jsonArray=[[NSMutableArray alloc]init];
     //
     //            for(NSMutableDictionary *mDict in arrProductColorAndSize)
     //            {
     //                NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
     //
     //                [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:indexTag] valueForKey:@"title"] forKey:@"option_value"];
     //                [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
     //                [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:indexTag] valueForKey:@"option_id"] forKey:@"option_id"];
     //                [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:indexTag] valueForKey:@"option_type_id"] forKey:@"option_type_id"];
     //                if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
     //                {
     //                    [jsonArray addObject:jsonDict];
     //
     //                }
     //            }
     //            NSError *writeError = nil;
     //            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&writeError];
     //
     //            NSString *jsonString1 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     //  @"option_json_value":jsonString1
     
     // NSString *jsonString1 = [mDict valueForKey:@"option_json_value"];
     
     //        NSDictionary *parameters1 = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
     //                                      @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],
     //                                      @"prd_qty":[mDict objectForKey:@"prd_qty"],
     //                                      @"product_id":[mDict valueForKeyPath:@"prd_id"],
     //                                      @"prd_default_price":[mDict valueForKey:@"prd_price"],
     //                                      @"option_json_value":jsonString1,
     //                                      @"uniq_id":[mDict valueForKey:@"uniq_id"],
     //                                      @"weight":[mDict valueForKey:@"prd_weight"],
     //                                      @"prd_update_price":[mDict valueForKey:@"prd_update_price"],
     //                                      @"get":@"0"};
     
     
     // float updatePrice = [strQty floatValue] * [[mDict valueForKey:@"prd_update_price"] floatValue];
     
     //          NSDictionary *parameters1 = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
     //                                        @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],
     //                                        @"prd_qty":strQty,
     //                                        @"product_id":[mDict valueForKeyPath:@"prd_id"],
     //                                        @"prd_default_price":[mDict valueForKey:@"prd_price"],
     //                                        @"uniq_id":[mDict valueForKey:@"uniq_id"],
     //                                        @"weight":[mDict valueForKey:@"prd_weight"],
     //                                        @"prd_update_price":[mDict valueForKey:@"prd_update_price"],
     //                                        @"get":@"0"};
     
     //            NSDictionary *parameters1 = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
     //                                          @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],
     //                                          @"uniq_id":[mDict valueForKey:@"uniq_id"],
     //                                          @"product_id":[mDict valueForKey:@"prd_id"],
     //                                          @"get":@"0"};
     
       NSDictionary *parameters1 = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"product_id":[mDict valueForKeyPath:@"prd_id"],@"uniq_id":[mDict valueForKey:@"uniq_id"],@"get":@"0",@"cart_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]};*/
    
  //  [self showLoader];
    
    
    //DELETE_1===================================
   }

-(void)deleteProduct:(NSNotification *)notification
{
    [self setTotalValue];
    [self getYourBagItem];
    [self.tblViewProductBag reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)editProduct:(NSNotification *)notification
{
    [self getYourBagItem];
    [self setTotalValue];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(isProductEdit)
        {
        isProductEdit = NO;
        _viewProductDetail.hidden = YES;
        pickerViewDetail.hidden = YES;
        [UIView transitionFromView:_viewProductDetail toView:self.tblViewProductBag duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion: ^(BOOL inFinished)
         {
             //do any post animation actions here
         }];
        }
    [self.tblViewProductBag reloadData];
}

#pragma mark - UIPicker Delegate Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == 1000)
        {
        return [_mArrayProductAttributes count]+1;
        }
    else
        {
        return [mArrayQuantity count];
        }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strValue;
    NSLog(@"row is %ld",(long)row);
 
    if (pickerView.tag==1000)
        {
            if (row == 0) {
                //strValue =@"Weight";
                strValue=@"0";

            }
            else {
            
                strValue = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"title"];
            }
        }
    else
        {
        if(selectedItemIndex == 2)
            {
               // NSLog(@"Qty at index is%@",[mArrayQuantity objectAtIndex:row]);
            return [mArrayQuantity objectAtIndex:row];
            }
        else
            {
            strValue = [[_mArrayProductAttributes objectAtIndex:row] objectForKey:@"title"];
            }
        }
    return strValue;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    isPickerIndex=(int)row;
    
   
    if (pickerView.tag==1000)
        {
            if (row==0)
            {
                Price = strDefaultPrice;
            }
            else
            {
                                   editQty = (int)row;
                   // strprdqty=[mArrayQuantity objectAtIndex:row-1];
                

            
                strAttributeTitile = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"title"];
                strPrdOptionId = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"option_id"];
                strPrdOptionTypeId = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"option_type_id"];
                
                Price = 0.0;
                
                Price = strDefaultPrice + [[[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"price"] floatValue];
                
                strProductPrice = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"price"];
            }
        }
    else
        {
            
            
        //if(selectedItemIndex == 2)
         //   {
//                        strQty = [mArrayQuantity objectAtIndex:row];
//                strQty2=strQty;
            
             editQty = (int)row;
           // selectedQuantityIndex = row;
                // selectedQuantityIndex = strQty;
            //}
        }
    
    

}

#pragma mark - UIAlert Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    
    if (alertView.tag == 1000)
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
            
            [self showLoader];
            
            
            NSMutableDictionary *parameters=[NSMutableDictionary alloc];
            [parameters setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] forKey:@"CartId"];
           
            [parameters setValue:txtFieldCoupon.text forKey:@"coupon"];
            
            
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
            
            [self showLoader];
            
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
    else if (alertView.tag == 101) {
        
        if (buttonIndex == 0) {
            
            [self showLoader];
            NSLog(@"Called");
            NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:deleteIndex];
            NSDictionary *parameters1 = @{@"email": [[NSUserDefaults standardUserDefaults] valueForKey:@"email"],@"item_id":[mDict valueForKey:@"item_id"],@"cart_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"cart_id"]
                                          };
            
            
            //DELETE_1===================================
            [CartrizeWebservices PostMethodWithApiMethod:@"deletebyitemid" Withparms:parameters1 WithSuccess:^(id response)
             {
                 
                 //[self secondServiceCall:mDict];
                 NSDictionary *dict=[response JSONValue];
                 
                 if([[dict valueForKey:@"delete"]isEqualToString:@"Sucsess"])
                 {
                     if([[dict valueForKey:@"data"]isEqual:[NSNull null]])
                     {
                         arrayCartData=[[NSMutableArray alloc]init];
                         [arrayCartData removeAllObjects];
                         tblViewProductBag.hidden=YES;
                         _lbl_Price.hidden=YES;
                           lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %@ ITEM" ,@"0"];
                         [AppDelegate appDelegate].arrAddToBag=[[NSMutableArray alloc]init];
                         [[AppDelegate appDelegate].arrAddToBag removeAllObjects];

                         [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationRefreshProductItem object:nil];
                         
                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        return ;
                     
                     }
                     
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     NSMutableDictionary *mDict=[response JSONValue];
                     arrayCartData=[[NSMutableArray alloc]init];
                     [arrayCartData removeAllObjects];
                     arrayCartData =[mDict valueForKey:@"data"];
                     [[NSUserDefaults standardUserDefaults]setObject:[mDict valueForKey:@"subtotal"] forKey:@"subtotal"];
                     //[[NSUserDefaults standardUserDefaults]setObject:arrayCartData forKey:@"arrayCartData"];
                     [AppDelegate appDelegate].arrAddToBag=[[NSMutableArray alloc]init];
                     [[AppDelegate appDelegate].arrAddToBag removeAllObjects];
                     [AppDelegate appDelegate].arrAddToBag=[arrayCartData mutableCopy];
                     arraycontent=[arrayCartData mutableCopy];
                     _btnPAY_SECURELY.userInteractionEnabled=YES;
                     [self arrDataCountfrom:arraycontent];
                     
                     if([arraycontent count]<=0)
                     {
                         lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %@ ITEM" ,@"0"];
                         _lbl_Price.text=@"$0.0";
                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                         tblViewProductBag.hidden=YES;
                         
                     }
                     else
                     {
                         tblViewProductBag.hidden=NO;
                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                         
                         lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %lu ITEMS" ,(unsigned long)[[AppDelegate appDelegate].arrAddToBag count]];
                         
                         _lbl_Price.text=[NSString stringWithFormat:@"$%0.2f",[[mDict valueForKey:@"subtotal"]floatValue ]];
                         Priceafter=[[mDict valueForKey:@"subtotal"]floatValue];
                         [self.tblViewProductBag reloadData];
                     }
                     //[tblViewProductBag reloadData];
                     //[self addToBagProduct:mDict];
                     if([[AppDelegate appDelegate].arrAddToBag count]<=0)
                     {
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your Cart is empty! add items to its now?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         alert.tag=123321;
                         // [alert show] ;
                         lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %@ ITEM" ,@"0"];
                         _lbl_Price.text=@"$ 0.0";
                         
                     }
                     else
                     {
                         // subtotal
                         lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %lu ITEMS" ,(unsigned long)[[AppDelegate appDelegate].arrAddToBag count]];
                         tblViewProductBag.hidden=NO;
                         _lbl_Price.text=[NSString stringWithFormat:@"$ %0.2f",[[mDict valueForKey:@"subtotal"]floatValue ]];
                         Priceafter=[[mDict valueForKey:@"subtotal"]floatValue];
                         [self.tblViewProductBag reloadData];
                     }
                     [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationRefreshProductItem object:nil];
                   /*  if ([[AppDelegate appDelegate].arrAddToBag count]>deleteIndex) {
                         NSDictionary *dictatindex=[[AppDelegate appDelegate].arrAddToBag objectAtIndex:deleteIndex];
                         
                         float deductprice=[[dictatindex valueForKey:@"prd_price"]floatValue]*[[dictatindex valueForKey:@"prd_qty"]integerValue];
                         Priceafter=Priceafter-deductprice;
                         _lbl_Price.text=[NSString stringWithFormat:@"$ %0.2f",Priceafter];
                         NSString *priceupdate=[NSString stringWithFormat:@"%f",Priceafter];
                         [[NSUserDefaults standardUserDefaults]setObject:priceupdate forKey:@"subtotal"] ;
                        [[AppDelegate appDelegate].arrAddToBag removeObjectAtIndex:deleteIndex];
                       
                         if([[AppDelegate appDelegate].arrAddToBag count]<=0)
                         {
                             //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your Cart is empty! add items to its now?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                             //        alert.tag=123321;
                             //        [alert show] ;
                             lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %@ ITEM" ,@"0"];
                             tblViewProductBag.hidden=YES;
                             
                         }
                         else
                         {
                             
                             lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %lu ITEMS" ,(unsigned long)[[AppDelegate appDelegate].arrAddToBag count]];
                             tblViewProductBag.hidden=NO;
                             [self.tblViewProductBag reloadData];
                         }

                         
                        
                    } else {
                         [self getAllProducts];
                     }*/
                     
                     
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                 }
                 else
                 {
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 }
                 
                 
             } failure:^(NSError *error)
             {
                 //NSLog(@"Error =%@",[error description]);
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
             }];
            
            
        }
    }
    else if (alertView.tag == 456321) {
        
        if (buttonIndex == 0) {
            
            [self showLoader];
            NSLog(@"Called");
            if ([AppDelegate appDelegate].arrAddToBag.count == 0) {
                
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                return;
            }
            
            NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:deleteIndex];
            NSDictionary *parameters1 = @{@"email": [[NSUserDefaults standardUserDefaults] valueForKey:@"email"],@"item_id":[mDict valueForKey:@"item_id"],
                                          };
            
            
            //DELETE_1===================================
            [CartrizeWebservices PostMethodWithApiMethod:@"deletebyitemid" Withparms:parameters1 WithSuccess:^(id response)
             {
                 
                 //[self secondServiceCall:mDict];
                 NSDictionary *dict=[response JSONValue];
                 
                 if([[dict valueForKey:@"delete"]isEqualToString:@"success"])
                 {
                     
                     ProductDetailView *objProductDetailView;
                     if (IS_IPHONE5)
                     {
                         objProductDetailView = [[ProductDetailView alloc] initWithNibName:@"ProductDetailView" bundle:nil];
                     }
                     else
                     {
                         objProductDetailView = [[ProductDetailView alloc] initWithNibName:@"ProductDetailView_iphone3.5" bundle:nil];
                     }
                     objProductDetailView.mutDictProductDetail = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:deleteIndex];
                     [self.navigationController pushViewController:objProductDetailView animated:YES];
//                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                        
                         [self GetCartItemms];
                         
                     //});
                 }
                 else
                 {
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 }
                 
               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             } failure:^(NSError *error)
             {
                 //NSLog(@"Error =%@",[error description]);
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
             }];
            
            
        }
    }
    else if (alertView.tag==123321)
    {
    if(buttonIndex==0)
    {
        GridViewController *objBillingAddressViewController=[[GridViewController alloc]init];
        objBillingAddressViewController = [[GridViewController alloc] initWithNibName:@"GridViewController" bundle:nil];
        [self.navigationController pushViewController:objBillingAddressViewController animated:YES];
    
    
    }
    
    }
}

-(NSString*)Trim:(NSString*)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return value;
}

-(void) setTotalValue
{
    if([[AppDelegate appDelegate].arrAddToBag count] != 0)
        {
        NSMutableDictionary *mDictRecord = [[NSMutableDictionary alloc] init];
        float totalPriceQty = 0;
        int qtyTotal = 0;
        for (int i = 0; i < [[AppDelegate appDelegate].arrAddToBag count]; i++)
            {
            mDictRecord = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:i];
            NSString *strQtyy = [mDictRecord valueForKey:@"prd_qty"];
                // NSString *strPrice = [mDictRecord valueForKey:@"prd_price"];
            
            float productPrice = [[mDictRecord valueForKey:@"prd_price"] floatValue];
            float updatedProductPrice = [[mDictRecord valueForKey:@"prd_update_price"] floatValue];
            
            float price ;//= [strPrice floatValue];
               
//                if( [strQtyy intValue]==0)
//                {
//                    strQtyy=@"1";
//                }
                
                if( [strQtyy isEqual:nil])
                {
                    strQtyy=@"1";
                }

                
                int qty = [strQtyy intValue];
            
            if(updatedProductPrice == 0)
                {
                price = productPrice; //productPrice = productPrice * [[dictCartProduct objectForKey:@"prd_qty"] floatValue];
                }
            else
                {
                price =  updatedProductPrice ;// = updatedProductPrice * [[dictCartProduct objectForKey:@"prd_qty"] floatValue];
                }
            
            qtyTotal = qtyTotal + qty;
            
                float prceQty = price ;
            totalPriceQty = totalPriceQty + prceQty;
            }
        //NSLog(@"%f", totalPriceQty);
        totalPrice = totalPriceQty;
        }
    if([[AppDelegate appDelegate].arrAddToBag count] == 0)
        {
        totalPrice = 0.0;
        }
}


-(void)setCustomerToCart
{
// UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Discount Codes" message:@"Enter your coupon code if you have one." delegate:self cancelButtonTitle:@"Skip" otherButtonTitles:@"Apply Coupon", nil];
//    av.tag = 1000;
//    av.alertViewStyle = UIAlertViewStylePlainTextInput;
//    txtFieldCoupon = [av textFieldAtIndex:0];
//    txtFieldCoupon.delegate = self;
//    [av show];
    float valueForGreatertherFifty=0.0;
    
    valueForGreatertherFifty=[[[NSUserDefaults standardUserDefaults]valueForKey:@"subtotal"]floatValue];
    //    for (int i=0; i<[AppDelegate appDelegate].arrAddToBag.count; i++)
//    {
//    float values=[[[[AppDelegate appDelegate].arrAddToBag objectAtIndex:i] valueForKey:@"prd_price"] floatValue]*[[[[AppDelegate appDelegate].arrAddToBag objectAtIndex:i] valueForKey:@"QTY"] intValue];
//         valueForGreatertherFifty=valueForGreatertherFifty+values;
//    }
    
    if(valueForGreatertherFifty>=50)
    {
        BillingAddressViewController *objBillingAddressViewController;
        if (IS_IPHONE_4)
        {
           objBillingAddressViewController = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController1" bundle:nil];
        }
        else
        {
            objBillingAddressViewController = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController" bundle:nil];
        }
        objBillingAddressViewController.requestFor = ADDTOCARTPAYMENT;
        objBillingAddressViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:objBillingAddressViewController animated:YES];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Message" message:[NSString stringWithFormat:@"The delivery can not be done for the order below $50"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
//        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Message" message:@"The delivery can not be done for the order below $50." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];

//    }
    
}

- (void) setCustomerToCart1
{
    [self showLoader];
    [AppDelegate appDelegate].strCustomerPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordSave"];
    //NSLog(@"customer_id = %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"]);
    //NSLog(@"email = %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"email"]);
    //NSLog(@"firstname = %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"firstname"]);
    //NSLog(@"lastname = %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lastname"]);
    //NSLog(@"[AppDelegate appDelegate].strCartId = %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]);
    //NSLog(@"passwordSave = %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"passwordSave"]);
    
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"] forKey:@"customer_id"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"email"] forKey:@"email"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"firstname"] forKey:@"firstname"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"lastname"] forKey:@"lastname"];
    [parameters setObject:[AppDelegate appDelegate].strCustomerPassword forKey:@"password"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] forKey:@"CartId"];
    
    
    
    [CartrizeWebservices PostMethodWithApiMethod:@"SetCustomerIntoCart" Withparms:parameters WithSuccess:^(id response)
     {
     //NSLog(@"Add Product Response= %@",[response JSONValue]);
     NSMutableDictionary *mDict = [response JSONValue];
         // strCartId = [mDict valueForKey:@"CartId"];
         // [self setCustomerToCart];
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     
     if([[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"]==nil ||[[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"] isEqualToString:@""]){
         NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
         [userDefualt setObject:[mDict objectForKey:@"value"] forKey:@"cart_id"];
         [userDefualt synchronize];
     }
   
     UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Discount Codes" message:@"Enter your coupon code if you have one." delegate:self cancelButtonTitle:@"Skip" otherButtonTitles:@"Apply Coupon", nil];
     av.tag = 1000;
     av.alertViewStyle = UIAlertViewStylePlainTextInput;
     txtFieldCoupon = [av textFieldAtIndex:0];
     txtFieldCoupon.delegate = self;
     [av show];
     
     } failure:^(NSError *error)
     {
     //NSLog(@"Error = %@",[error description]);
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(isProductEdit)
        {
        return [arrProductColorAndSize count];
        }
    
    //NSLog(@"%d",[[AppDelegate appDelegate].arrAddToBag count]);
    
    //[self FoterValues];
    return [arraycontent count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if(isProductEdit)
        {
        return nil;
        }
    else
        {
        if([arraycontent count] == 0)
            {
            return nil;
            }
            
            // (0,0,320,100)
        UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,10)];
        viewFooter.backgroundColor = [UIColor clearColor];
//        
//        UIImageView *imgBag = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 90)];
//        imgBag.image = [UIImage imageNamed:@"probg1.png"];
//        [viewFooter addSubview:imgBag];
//        
//        UILabel *lblTotal = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 35, 20)];
//        lblTotal.text = @"Total";
//        lblTotal.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
//        lblTotal.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0];
//        lblTotal.backgroundColor = [UIColor clearColor];
//        [viewFooter addSubview:lblTotal];
//        
//        UILabel *lblWithoutDelivery = [[UILabel alloc] initWithFrame:CGRectMake(42, 10, 130, 20)];
//        lblWithoutDelivery.text = @"(without delivery):";
//        lblWithoutDelivery.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
//        lblWithoutDelivery.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0];
//        lblWithoutDelivery.backgroundColor = [UIColor clearColor];
//        [viewFooter addSubview:lblWithoutDelivery];
//        
//        UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 105, 20)];
//        lblPrice.text = @"Price";
//        lblPrice.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
//        lblPrice.font = [UIFont boldSystemFontOfSize:14.0f];
//        lblPrice.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0];
//        lblPrice.textAlignment = NSTextAlignmentRight;
//            //NSString *str = [NSString stringWithFormat:@""]
//        lblPrice.text = [NSString stringWithFormat:@"%@ %.02f",[AppDelegate appDelegate].currencySymbol,totalPrice];
//        lblPrice.backgroundColor = [UIColor clearColor];
//        [viewFooter addSubview:lblPrice];
            
         //by me
            
//            if (IS_IPHONE_4)
//            {
//                [self.lbl_TOTAL setFrame:CGRectMake(10, 406, 161, 21)];
//                [self.lbl_Price setFrame:CGRectMake(261, 406, 46, 21)];
//                [self.btnPAY_SECURELY setFrame:CGRectMake(10, 431, 300, 30)];
//            }
//          
//          self.lbl_Price.text=[NSString stringWithFormat:@"%@ %.02f",[AppDelegate appDelegate].currencySymbol,totalPrice];
//          [_btnPAY_SECURELY addTarget:self action:@selector(btnContinueAction) forControlEvents:UIControlEventTouchUpInside];
            
            
            
          //
        
//        UIButton *btnPayment = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, 300, 30)];
//        btnPayment.backgroundColor = [UIColor clearColor];
////        [btnPayment setImage:[UIImage imageNamed:@"btn_Pay_Securely_Now.png"] forState:UIControlStateNormal];
////        [btnPayment setImage:[UIImage imageNamed:@"btn_Pay_Securely Now_hover.png"] forState:UIControlStateHighlighted];
//            [btnPayment setBackgroundColor:[UIColor colorWithRed:48/255.0f green:48/255.0f blue:48/255.0f alpha:1.0]];
//            [btnPayment setTitle:@"PAY SECURELY NOW" forState:UIControlStateNormal];
//            [btnPayment.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//            
//            [btnPayment addTarget:self action:@selector(btnContinueAction) forControlEvents:UIControlEventTouchUpInside];
//        [viewFooter addSubview:btnPayment];
        
        return viewFooter;
        }
}
-(void)FoterValues
{
    if (IS_IPHONE_4)
    {
        [self.lbl_TOTAL setFrame:CGRectMake(10, 406, 161, 21)];
        [self.lbl_Price setFrame:CGRectMake(261, 406, 46, 21)];
        [self.btnPAY_SECURELY setFrame:CGRectMake(10, 431, 300, 30)];
        
        self.lbl_Price.text=[NSString stringWithFormat:@"%@ %@",[AppDelegate appDelegate].currencySymbol,[[NSUserDefaults standardUserDefaults]valueForKey:@"subtotal"]];
      
        [_btnPAY_SECURELY addTarget:self action:@selector(btnContinueActions) forControlEvents:UIControlEventTouchUpInside];
    }
   
    AppDelegate *app= (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.PricePayment=totalPrice;
    self.lbl_Price.text=[NSString stringWithFormat:@"%@ %.02f",[AppDelegate appDelegate].currencySymbol,totalPrice];
    [_btnPAY_SECURELY addTarget:self action:@selector(btnContinueActions) forControlEvents:UIControlEventTouchUpInside];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(isProductEdit)
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
            
//        if([[[arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
//            {
//            cell.lblPrdAttibuteTitle.text = [[arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"custome_title"];
//            }
//        else
//            {
//            cell.lblPrdAttibuteTitle.text = [[arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"prd_Attribute_Title"];
//             } comment hupendra
            
            //Write hupendra
            if([[[arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"selecte"] isEqualToString:@"NO"])
            {
               cell.lblPrdAttibuteTitle.text = [[arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"custome_title"];
            
            }else
            {
                if (isPickerIndex == 0)
                {
                    cell.lblPrdAttibuteTitle.text = @"Weight";
                }
                else
                {
                    cell.lblPrdAttibuteTitle.text = [[arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"selecte"];
                }
            }
            
            btnRef = cell.lblPrdAttibuteTitle;
             cell.btnPicker.tag = indexPath.row;
            [cell.btnPicker addTarget:self action:@selector(btnColorAndSizeAction:) forControlEvents:UIControlEventTouchUpInside];
           
        
            //[self FoterValues];
            //[self setTotalValue];
            
        return cell;
        }
    else
        {
        static NSString *CellIdentifier;
        CellIdentifier = @"AddToBagCell";
        AddToBagCell *cell = (AddToBagCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
            //if (cell == nil)
            //  {
        cell = [[AddToBagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddToBagCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
            // }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.viewDetail.hidden = NO;
        cell.viewEdit.hidden = YES;
        
       // NSMutableDictionary *dictCartProduct = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:indexPath.row];
            NSMutableDictionary *dictCartProduct =[arraycontent objectAtIndex:indexPath.row];
        NSString *str=[dictCartProduct objectForKey:@"prd_name"];
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSDictionary * attributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16],
                                      NSParagraphStyleAttributeName : paragraphStyle};
        
        CGSize size = [str boundingRectWithSize:(CGSize){138 - (10 * 2), 20000.0f}
                                        options:NSStringDrawingUsesFontLeading
                       |NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil].size;
        
        CGFloat height = MAX(size.height, 10.0);
        cell.lblProductName.frame=CGRectMake(141, 0, 138, height+20);
        cell.lblProductName.numberOfLines=0;
        cell.lblProductName.lineBreakMode=NSLineBreakByWordWrapping;
        //cell.lblProductName.text = [dictCartProduct objectForKey:@"prd_name"];
        cell.lblProductName.lineBreakMode = NSLineBreakByWordWrapping;
        cell.lblProductName.numberOfLines = 0;
        
        cell.lblProductName.text = [dictCartProduct objectForKey:@"prd_name"];
        
//            [cell.imgViewProduct setImageWithURL:[NSURL URLWithString:[dictCartProduct valueForKey:@"prd_thumb"]] placeholderImage:[UIImage imageNamed:CRplacehoderimage]];
        
        if([[dictCartProduct valueForKey:@"prd_thumb"]  isKindOfClass:[NSNull class]]){
                [cell.imgViewEditProduct setImage:[UIImage imageNamed:@"green_sqrBlock"]];
                cell.imgViewEditProduct.loadingView.hidden=YES;
            }else if([dictCartProduct valueForKey:@"prd_thumb"] ==nil){
                [cell.imgViewEditProduct setImage:[UIImage imageNamed:@"green_sqrBlock"]];
                cell.imgViewEditProduct.loadingView.hidden=YES;
                
            }else if([[dictCartProduct valueForKey:@"prd_thumb"] length]==0){
                [cell.imgViewEditProduct setImage:[UIImage imageNamed:@"green_sqrBlock"]];
                cell.imgViewEditProduct.loadingView.hidden=YES;
            }else{
                [cell.imgViewEditProduct loadImageFromURL:[dictCartProduct valueForKey:@"prd_thumb"]];
                cell.imgViewEditProduct.layer.masksToBounds=YES;
                cell.imgViewEditProduct.layer.borderColor=[[UIColor colorWithRed:150.0/255.0 green:175.0/255.0 blue:84.0/255.0 alpha:1.0]CGColor];
                cell.imgViewEditProduct.layer.borderWidth= 1.0f;
            }

           cell.lblViewMore.hidden = YES;
            cell.btnViewMore.hidden=YES;
        cell.imgViewEditProduct.contentMode = UIViewContentModeScaleAspectFit;
        
       // NSString *jsonString = [dictCartProduct valueForKey:@"option_json_value"];
        
      //  NSMutableArray *optionArray = [jsonString JSONValue];
        
        float yPosition = 30 + height - 20;
        
        //cell.lblViewMore.text = @"View More";
        
      /*  for (int i = 0; i < [optionArray count]; i++)
            {
            if(selectedIndexViewMore == indexPath.row)
                {
               // cell.lblViewMore.text = @"View Less";
                UILabel *lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(141, yPosition, 160, 18)];
                NSString *strText = [[optionArray objectAtIndex:i]valueForKey:@"option_name"];
                strText = [strText stringByAppendingString:@": "];
                
                id obj = [[optionArray objectAtIndex:i]valueForKey:@"option_value"];
                if (obj != nil)
                    {
                    strText = [strText stringByAppendingString:[[optionArray objectAtIndex:i]valueForKey:@"option_value"]];
                    lblMessage.text = strText;
                    yPosition = yPosition + 16;
                    [lblMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
                    [cell.contentView addSubview:lblMessage];
                    }
                }
            else if (i < 3)
                {
                UILabel *lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(141, yPosition, 160, 18)];
                NSString *strText = [[optionArray objectAtIndex:i]valueForKey:@"option_name"];
                strText = [strText stringByAppendingString:@": "];
                
                id obj = [[optionArray objectAtIndex:i]valueForKey:@"option_value"];
                if (obj != nil)
                    {
                    strText = [strText stringByAppendingString:[[optionArray objectAtIndex:i]valueForKey:@"option_value"]];
                    lblMessage.text = strText;
                    yPosition = yPosition + 16;
                    [lblMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
                    [cell.contentView addSubview:lblMessage];
                    }
                }
            }*/
        if(selectedIndexViewMore == indexPath.row)
            {
            if (yPosition > 32)
                {
                cell.btnEditQty.frame=CGRectMake(141, cell.bounds.size.height - 62, 70, 23);
                cell.lblQty.frame=CGRectMake(163, cell.bounds.size.height - 62, 25, 21);

                cell.btnViewMore.frame=CGRectMake(232, cell.bounds.size.height - 62, 75, 23);
                cell.lblViewMore.frame=CGRectMake(239, cell.bounds.size.height - 59, 61, 18);
                }
            else
                {
               
                }
            }
          
            if([[dictCartProduct objectForKey:@"product_weight_title"]isKindOfClass:[NSNull class]]||[dictCartProduct objectForKey:@"product_weight_title"] == nil ||            [[dictCartProduct objectForKey:@"product_weight_title"] isEqualToString:@"null"] || [dictCartProduct objectForKey:@"product_weight_title"] == (id)[NSNull null])
            {
            cell.lblWeight.text=@"";
            }
            else
            {
                
            cell.lblWeight.text=[dictCartProduct objectForKey:@"product_weight_title"];
            
            }
            
          
            cell.lblQty.text =[NSString stringWithFormat:@"QTY:%@",[dictCartProduct objectForKey:@"prd_qty"]];
            
            NSString *strProductQty =[dictCartProduct objectForKey:@"QTY_Added"];
            
             NSString *strProductQtyTtl =[dictCartProduct objectForKey:@"pro_stock"];
            
            if([[dictCartProduct objectForKey:@"pro_stock"]isKindOfClass:[NSNull class]]||[[dictCartProduct objectForKey:@"pro_stock"]isEqualToString:@"<null>"]||[dictCartProduct objectForKey:@"pro_stock"]==nil)
            {
               cell.lbloutofStock.hidden=YES;
                 NSLog(@"Hide Expire Label");
                
            }
            
            else{
            
            if ([strProductQty intValue]>[strProductQtyTtl intValue]) {
                NSLog(@"Show Expire Label");
                _btnPAY_SECURELY.userInteractionEnabled=NO;
                cell.lbloutofStock.hidden=NO;

            }
            else
            {
                NSLog(@"Hide Expire Label");
                cell.lbloutofStock.hidden=YES;

            
            }
            }
        
            prdtotalAddqty=0;
            
    
            float prices=[[dictCartProduct objectForKey:@"prd_qty"] intValue]*[[dictCartProduct valueForKey:@"prd_price"] floatValue];
                cell.lblPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,prices];
            
            
            
//        if([[dictCartProduct valueForKey:@"prd_update_price"] floatValue] < 0)
//            {
           // productPrice = productPrice * [[dictCartProduct objectForKey:@"prd_qty"] floatValue];
            
//            }
//        else
//            {
//            float priceValues=[[dictCartProduct valueForKey:@"prd_update_price"] floatValue];
//            cell.lblPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,priceValues];
//            }
        
//            if([[dictCartProduct valueForKey:@"product_options"] count]==0)
//            {
//                cell.btn_Edit.enabled = NO;
//            }
//            else
//            {//Manoj
//                float priceValues=[[[[dictCartProduct valueForKey:@"product_options"] valueForKey:@"custome_values"] valueForKey:@"default_price"]floatValue]*[cell.lblQty.text intValue];
//                cell.lblPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,priceValues];
//            }
   
         cell.btn_Edit.tag = indexPath.row;
        [cell.btn_Edit addTarget:self action:@selector(btnEditAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btn_Delete.tag = indexPath.row;
        [cell.btn_Delete addTarget:self action:@selector(btnDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnProductDetail.tag = indexPath.row;
       // [cell.btnProductDetail addTarget:self action:@selector(actionProductDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnProductDetail addTarget:self action:@selector(btnEditQtyActi:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnEditQty.tag = indexPath.row;
            [cell.btnEditQty addTarget:self action:@selector(btnEditQtyActi:) forControlEvents:UIControlEventTouchUpInside];
           
        
        cell.btnViewMore.hidden = YES;
        cell.lblViewMore.hidden = YES;
        
     /*   if([optionArray count] < 4)
            {
            cell.btnViewMore.hidden = YES;
            cell.lblViewMore.hidden = YES;
            }
        cell.btnViewMore.tag = indexPath.row;
        [cell.btnViewMore addTarget:self action:@selector(actionViewMore:) forControlEvents:UIControlEventTouchUpInside];*/
            // [self FoterValues];
           // [self setTotalValue];
        return cell;
        }
    
   
}

#pragma mark - UITableView Delegates

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(isProductEdit)
        {
        return 36;
        }
//    NSMutableDictionary *dictCartProduct = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:indexPath.row];
//    NSString *str=[dictCartProduct objectForKey:@"prd_name"];
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    
//    NSDictionary * attributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16],
//                                  NSParagraphStyleAttributeName : paragraphStyle};
//    
//    CGSize size = [str boundingRectWithSize:(CGSize){138 - (10 * 2), 20000.0f}
//                                    options:NSStringDrawingUsesFontLeading
//                   |NSStringDrawingUsesLineFragmentOrigin
//                                 attributes:attributes
//                                    context:nil].size;
//    
//    CGFloat height1 = MAX(size.height, 5);
    
    if(selectedIndexViewMore != indexPath.row)
        {
        return  162;//125+height1;
        }
    else
        {
//        NSString *jsonString = [dictCartProduct valueForKey:@"option_json_value"];
//        
//        NSMutableArray *optionArray = [jsonString JSONValue];
//        
//            //hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
//            CGFloat ypos=28;
//        for (int i=0; i<optionArray.count; i++)
//            {
//            ypos=ypos+16;
//            }
//        
//        int cunter = [optionArray count];
//        
//        if(cunter < 3)
//            {
            return 150;
//            }
//        return   ypos+height1+54;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(isProductEdit)
        {
        return 0;
        }
    else
        {
        
        if([arraycontent count] == 0)
            {
            return 0;
            }
        }
    return 10.0;
}

-(IBAction)actionViewMore:(id)sender
{
    if(selectedIndexViewMore == -1 || selectedIndexViewMore != [sender tag])
        {
        selectedIndexViewMore = [sender tag];
        }
    else
        {
        selectedIndexViewMore = -1;
        }
    
    [tblViewProductBag reloadData];
}


- (IBAction)btnColorAndSizeAction:(id)sender
{
    
    if(IS_IPHONE_4){
        self.pickerToolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 274, 320, 44)];
    }else{
        self.pickerToolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 362, 320, 44)];
    }
    
    UIButton *done_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    done_Button.frame=CGRectMake(0.0, 0, 60.0, 30.0);
    [done_Button setTitle:@"Done" forState:UIControlStateNormal];
    [done_Button addTarget:self action:@selector(doneBtnPressToGetValue:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancel_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel_Button.frame=CGRectMake(0.0, 0, 60.0, 30.0);
    [cancel_Button setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel_Button addTarget:self action:@selector(CancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithCustomView:done_Button];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithCustomView:cancel_Button];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIView *toolBarNa = [[UIView alloc]initWithFrame:_pickerToolbar1.bounds];
    [toolBarNa setBackgroundColor:[UIColor colorWithRed:166/255.0f green:187/255.0f blue:94/255.0f alpha:1.0]];
    
    [self.pickerToolbar1 insertSubview:toolBarNa atIndex:0];
    
    CALayer *l=self.pickerToolbar1.layer;
    [l setCornerRadius:0.5];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
    [l setBorderWidth:0.5];
    [self.pickerToolbar1 setItems:[NSArray arrayWithObjects:btnCancel, flex, myButton, nil]];
    [self.viewProductDetail addSubview:self.pickerToolbar1];
    
    isSelectedPicker  = (int)[sender tag];
    
    _mArrayProductAttributes = [[arrProductColorAndSize objectAtIndex:isSelectedPicker] objectForKey:@"custome_values"];
    
  // pickerViewColor.hidden = NO;
    self.pickerViewColorandSize.hidden = NO;
    self.tableViewPrdAttributes.userInteractionEnabled = NO;
    
   // [pickerViewColor reloadAllComponents];
     [self.pickerViewColorandSize reloadAllComponents];
}
- (IBAction)btnColorAndSizeAction1:(id)sender
{
    if(IS_IPHONE_4){
        self.pickerToolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 274, 320, 44)];
    }else{
        self.pickerToolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 362, 320, 44)];
    }
  
    UIButton *done_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    done_Button.frame=CGRectMake(0.0, 0, 60.0, 30.0);
    [done_Button setTitle:@"Done" forState:UIControlStateNormal];
    [done_Button addTarget:self action:@selector(doneBtnPressToGetValue:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancel_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel_Button.frame=CGRectMake(0.0, 0, 60.0, 30.0);
    [cancel_Button setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel_Button addTarget:self action:@selector(CancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithCustomView:done_Button];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithCustomView:cancel_Button];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIImageView *imgView=[[UIImageView alloc]init];
    imgView.backgroundColor=[UIColor colorWithRed:166/255.0f green:187/255.0f blue:94/255.0f alpha:1.0];
    [self.pickerToolbar1 insertSubview:imgView atIndex:0];
 
//    UIView *toolBarNa = [[UIView alloc]initWithFrame:_pickerToolbar1.bounds];
//    [toolBarNa setBackgroundColor:[UIColor colorWithRed:166/255.0f green:187/255.0f blue:94/255.0f alpha:1.0]];
//    [self.pickerToolbar1 insertSubview:toolBarNa atIndex:0];
    
    CALayer *l=self.pickerToolbar1.layer;
    [l setCornerRadius:0.5];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
    [l setBorderWidth:0.5];
    self.pickerToolbar1.backgroundColor=[UIColor colorWithRed:166/255.0f green:187/255.0f blue:94/255.0f alpha:1.0];
    [self.pickerToolbar1 setItems:[NSArray arrayWithObjects:btnCancel, flex, myButton, nil]];
   
    [self.viewProductDetail addSubview:self.pickerToolbar1];
  
    
    isSelectedPicker  = [sender tag];
    _mArrayProductAttributes = [[arrProductColorAndSize objectAtIndex:isSelectedPicker] objectForKey:@"custome_values"];
    self.pickerViewColorandSize.hidden = NO;
    [self.pickerViewColorandSize reloadAllComponents];
}

-(IBAction)actionProductDetail:(id)sender
{
    
    ProductDetailView *objProductDetailView;
    if (IS_IPHONE5)
        {
        objProductDetailView = [[ProductDetailView alloc] initWithNibName:@"ProductDetailView" bundle:nil];
        }
    else
        {
        objProductDetailView = [[ProductDetailView alloc] initWithNibName:@"ProductDetailView_iphone3.5" bundle:nil];
        }
    objProductDetailView.mutDictProductDetail = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:objProductDetailView animated:YES];
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
    viewfullsizeimageview.imageArray = mutArrayProductImages;
    [self presentViewController:viewfullsizeimageview animated:YES completion:nil];
}

#pragma mark - Image Sharing From Face Book

-(IBAction)btnActionFaceBookSharing:(id)sender
{
    /*
    NSLog(@"%hhd",[SCFacebook isSessionValid]);
    if([SCFacebook isSessionValid]){
        [self shared_ON_Facebook];
        
    }else{
        
        [AppDelegate appDelegate].isFBCheck=YES;
        [SCFacebook loginCallBack:^(BOOL success, id result) {
            //NSLog(@"%d",success);
            if (success) {
                [self shared_ON_Facebook];
                    //Alert(@"Alert", @"Success");
            }else{
                Alert1(@"Alert", [result description]);
            }
        }];
    }*/
}


-(void)shared_ON_Facebook
{
   /* if(imgViewProducts.image==nil){
        Alert1(@"Alert",@"Images can not null");
    }else
    {
       //
          strFacebook=[NSString stringWithFormat:@"What do you think? Should i buy this ?%@\n%@",lblProductName.text,lblProductProductDiscription.text];
        
//        [SCFacebook feedPostWithPhoto:imgViewProducts.image caption:lblProductName.text  callBack:^(BOOL success, id result)
//        {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            Alert1(@"Alert", @"Successfully facebook sharing");
//                // Alert(@"Alert", [result description]);
//        }];
        
        
        NSString *str=[_mutDictProductDetail valueForKey:@"product_url"];
     
       [SCFacebook feedPostWithLinkPath:str caption:strFacebook Photo:imgViewProducts.image callBack:^(BOOL success,id result)
        {
            Alert1(@"Alert", @"Successfully facebook sharing");
        }];

    }*/
}


#pragma mark - Twitter sharing methods

-(IBAction)btnActionTwitterSharing:(id)sender
{
    
    [self twitter_login];
    
//    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//    [controller setInitialText:@"What do you think? Should I buy this?"];
//    [controller addURL:[NSURL URLWithString:[_mutDictProductDetail valueForKey:@"product_url"]]];
//    [controller addImage:imgViewProducts.image];
//    [self presentViewController:controller animated:YES completion:Nil];
}

#pragma mark - twitter sharing methods

-(void)twitter_login{
    
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
            //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
    }else {
        [[FHSTwitterEngine sharedEngine]showOAuthLoginControllerFromViewController:self withCompletion:^(BOOL success) {
            //NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
           [self postDataOnTwitter];
          //  [self postTWWWWWW];
        }];
    }
}


-(void)postDataOnTwitter
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            
            NSData *data = UIImagePNGRepresentation(imgViewProducts.image);
         
            
           // id returned = [[FHSTwitterEngine sharedEngine]postTweet:lblProductName.text withImageData:data];
            NSString *strTwitterShare=[NSString stringWithFormat:@"What do you think? should i buy this ?\n%@\n%@",lblProductName.text,[_mutDictProductDetail valueForKey:@"product_url"]];
            
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

        
                // id returned = [[FHSTwitterEngine sharedEngine]postTweet:strURL];
            //by me
         //   NSString *strTwitter=[NSString stringWithFormat:@"%@\n%@",lblProductName.text,lblProductProductDiscription.text];
            
           // id returned = [[FHSTwitterEngine sharedEngine]postTweet:strTwitter withImageData:data];

            //
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSString *title = nil;
            NSString *message = nil;
            
            if ([returned isKindOfClass:[NSError class]])
            {
                NSError *error = (NSError *)returned;
                title = [NSString stringWithFormat:@"Error %ld",(long)error.code];
                message = error.localizedDescription;
            } else
            {
                message=@"Successfully twitter sharing";
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }
            });
        }
    });
}


#pragma mark:- MailSharing

-(IBAction)btnActionMailSharing:(id)sender
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init]  ;
    mailComposer.mailComposeDelegate = self;
    
    if ([MFMailComposeViewController canSendMail])
        {
        [mailComposer setToRecipients:nil];
        [mailComposer setSubject:@"What do you think? Should I buy this?"];
      //  NSString *message = [@"Check it out at:\n\n\n" stringByAppendingString:[_mutDictProductDetail valueForKey:@"product_url"]];
            
        NSString *strMessage=[NSString stringWithFormat:@"Check it out at:\n%@\n%@",[_mutDictProductDetail valueForKey:@"prd_name"],[_mutDictProductDetail valueForKey:@"product_url"]];
    
        [mailComposer setMessageBody:strMessage isHTML:NO];
  //      NSData *imageData = UIImagePNGRepresentation(imgViewProducts.image);
  //      [mailComposer addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@""];
        [self presentViewController:mailComposer animated:YES completion:nil];
        }
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
    [shareBuilder setURLToShare:[NSURL URLWithString:[_mutDictProductDetail valueForKey:@"product_url"]]];
    [shareBuilder setPrefillText:@"What do you think? Should I buy this?"];
        //[shareBuilder attachImage:imgViewProducts.image];
    [shareBuilder open];
}

#pragma mark MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result == MFMailComposeResultSent)
        {
        //NSLog(@"Mail Send");
        }
    [self dismissViewControllerAnimated:YES completion:nil];
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
- (void)finishedSharing:(BOOL)shared
{
    NSString *text = shared ? @"Success" : @"Canceled";
        //shareStatus_.text = [NSString stringWithFormat:@"Status: %@", text];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:text delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)reportAuthStatus
{
    if ([GPPSignIn sharedInstance].authentication)
        {
            // signInAuthStatus_.text = @"Status: Authenticated";
            //[self retrieveUserInfo];
            //[self enableSignInSettings:NO];
        }
    else
        {
            // To authenticate, use Google+ sign-in button.
            // signInAuthStatus_.text = @"Status: Not authenticated";
            //[self enableSignInSettings:YES];
        }
}

- (IBAction) btnMoreInfoAction:(id)sender
{
    viewMoreInfo.hidden = NO;
    txtViewMoreInfo.text = [_mutDictProductDetail objectForKey:@"prd_longdesc"];
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
    CATransition* transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.duration = .50f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
        //[viewMoreInfo.layer removeAllAnimations];
    viewMoreInfo.hidden = YES;
    [viewMoreInfo.layer addAnimation:transition forKey:kCATransition];
}

- (IBAction)funcOpenPicker:(id)sender
{
//    dictEdit = [[AppDelegate appDelegate].arrAddToBag objectAtIndex:[sender tag]];
    indexTag = [sender tag];
    [self.pickerViewDetail removeFromSuperview];
    [self.pickerToolbar1 removeFromSuperview];
    
    strQty2=@"1";
    //    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //    NSMutableDictionary *mDictBag = [appDelegate.arrAddToBag objectAtIndex:[sender tag]];
    
   
    //Product Quantity
   // mArrayQuantity = [[NSMutableArray alloc] init];
    //NSNumber *num = ;
  // int totalQty = [[NSString stringWithFormat:@"%@",[dictEdit objectForKey:@"pro_stock"]] intValue];
    
    
//    for(int i=1;i <= totalQty;i++)
//    {
//        [mArrayQuantity addObject:[NSString stringWithFormat:@"%d",i]];
//    }
//    
    btnIndexOfEdit= (int)[sender tag];
    
    if(IS_IPHONE5)
    {
        self.pickerToolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 362, 320, 44)];
        self.pickerViewDetail = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 406, 320, 162)];
        self.pickerViewDetail.delegate = self;
        self.pickerViewDetail.showsSelectionIndicator = YES;
        self.pickerViewDetail.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.pickerViewDetail];
    }
    else
    {
        self.pickerToolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 274, 320, 44)];
        self.pickerViewDetail = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 318, 320, 162)];
        self.pickerViewDetail.delegate = self;
        self.pickerViewDetail.showsSelectionIndicator = YES;
        self.pickerViewDetail.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.pickerViewDetail];
    }
    selectedItemIndex = 2;
    
    UIButton *done_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    done_Button.frame=CGRectMake(0.0, 0, 60.0, 30.0);
    if([mArrayQuantity count]==0)
    {
        done_Button.userInteractionEnabled=NO;
    }
    else
    {
        done_Button.userInteractionEnabled=YES;
        
    }
    [done_Button setTitle:@"Done" forState:UIControlStateNormal];
    [done_Button addTarget:self action:@selector(btnDoneToolbarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    done_Button.tag = [sender tag];
    
    UIButton *cancel_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel_Button.frame=CGRectMake(0.0, 0, 60.0, 30.0);
    [cancel_Button setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel_Button addTarget:self action:@selector(btnCancelToolbarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithCustomView:done_Button];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithCustomView:cancel_Button];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIView *toolBarNa = [[UIView alloc]initWithFrame:_pickerToolbar1.bounds];
    [toolBarNa setBackgroundColor:[UIColor colorWithRed:166/255.0f green:187/255.0f blue:94/255.0f alpha:1.0]];
    
    
    [self.pickerToolbar1 insertSubview:toolBarNa atIndex:0];
    
    CALayer *l=self.pickerToolbar1.layer;
    [l setCornerRadius:0.5];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
    [l setBorderWidth:0.5];
    [self.pickerToolbar1 setItems:[NSArray arrayWithObjects:btnCancel, flex, myButton, nil]];
    [self.view addSubview:self.pickerToolbar1];
    
    
    [self.pickerViewDetail reloadAllComponents];


}


-(void)ReloadCartData:(NSNotification *)notification
{
    arraycontent=[[NSMutableArray alloc]init];
    [arraycontent removeAllObjects];
    arraycontent=[[AppDelegate appDelegate].arrAddToBag mutableCopy];
    [self arrDataCountfrom:arraycontent];

    lblNavTitle.text = [NSString stringWithFormat:@"YOUR BAG : %lu ITEMS" ,(unsigned long)[[AppDelegate appDelegate].arrAddToBag count]];
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"subtotal"]!=nil)
    {
        //float lblPrice=[[[NSUserDefaults standardUserDefaults]valueForKey:@"subtotal"]floatValue];
        self.lbl_Price.text=[NSString stringWithFormat:@"%@ %.02f",[AppDelegate appDelegate].currencySymbol,[[[NSUserDefaults standardUserDefaults]valueForKey:@"subtotal"]floatValue]];
    }
    else
    {
        self.lbl_Price.text=[NSString stringWithFormat:@"%@ %@",[AppDelegate appDelegate].currencySymbol,@"0"];
        
    }

    [tblViewProductBag reloadData];
}
@end
