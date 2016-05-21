//
//  FavouriteViewController.m
//  IShop
//
//  Created by Avnish Sharma on 5/26/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "FavouriteViewController.h"
#import "FavouriteCell.h"
#import "UIImageView+WebCache.h"
#import "BillingAddressViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "ViewFullSizeImageVC.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <Social/Social.h>

#import "JSON.h"
#import "CustomCell.h"
#import "Constants.h"
#import "ProductDetailView.h"
#import "CartrizeWebservices.h"
#import "Reachability.h"

#import  "UITextField+PendingTextFieldWithImage.h"

#define kNotificationDeleteFavoriteProduct @"DeleteFavoriteProduct"
#define kNotificationEditFavoriteProduct @"EditFavoriteProduct"
#define kNotificationMoveToBagProduct @"MoveToBagProduct"


@interface FavouriteViewController ()<GPPSignInDelegate>
{
    NSString *strFacebook;
    int btnIndexOfEditQty;
}
@end

@implementation FavouriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark:-Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [txtWeight leftMargin:5];
    
    // Do any additional setup after loading the view from its nib.
    self.tblViewProductBag.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tblViewProductBag.bounds.size.width, 0.01f)];
    
    isEditProduct = NO;
    _mDictEditDetail = [[NSMutableDictionary alloc]init];
    [_mDictEditDetail setValue:@"" forKey:@"pro_size"];
    [_mDictEditDetail setValue:@"" forKey:@"pro_color"];
    
    selectedCellIndex = -1;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editFavoriteProduct:) name:kNotificationEditFavoriteProduct object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteProduct:) name:kNotificationDeleteFavoriteProduct object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveToBagProduct:) name:kNotificationMoveToBagProduct object:nil];
    
    
    //by me
    
         if (IS_IPHONE_4)
         {
             [_btnMoveAll setFrame:CGRectMake(10, 430, 300, 30)];
         }
    
    
    _btnMoveAll.backgroundColor = [UIColor clearColor];
    [_btnMoveAll setBackgroundColor:[UIColor colorWithRed:48/255.0f green:48/255.0f blue:48/255.0f alpha:1.0]];
   //[_btnMoveAll setTitle:@"MOVE ALL TO BAG" forState:UIControlStateNormal];
   // [_btnMoveAll.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_btnMoveAll addTarget:self action:@selector(btnMoveAllToBagAction:) forControlEvents:UIControlEventTouchUpInside];
   // [self.tblViewProductBag addSubview:btnPayment];
    [_btnMoveAll setHidden:NO];

    //
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    selectedIndexViewMore = -1;
    
    //NSLog(@"--Bool--%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"fav_array"]);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //  //NSLog(@"Cart arrary -- %@",objAppDelegate.arrFavourite);
    
    lblNavTitle.text = [NSString stringWithFormat:@"YOUR SAVED ITEMS : %i ITEMS" ,(int)[[AppDelegate appDelegate].arrFavourite count]];
    [self setTotalValue];
}

-(void)moveToBagProduct:(NSNotification *)notificatione
{
    
    NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrFavourite objectAtIndex:btnTag];
    NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"product_id":[mDict valueForKeyPath:@"prd_id"],@"prd_qty":[mDict objectForKey:@"prd_qty"],@"uniq_id":[mDict valueForKey:@"uniq_id"],@"get":@"0"};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"GetUserFavoriteHistory" Withparms:parameters WithSuccess:^(id response) {
        // self.arrAddToBag = [response JSONValue];
        [AppDelegate appDelegate].requestFor = DELETEFAVORITEPRODUCT;
        [[AppDelegate appDelegate] getFavoriteHistory];
        lblNavTitle.text = [NSString stringWithFormat:@"YOUR SAVED ITEMS : %i ITEMS" ,(int)[[AppDelegate appDelegate].arrFavourite count]];
        [self setTotalValue];
        [self.tableViewPrdAttributes reloadData];
    } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
    lblNavTitle.text = [NSString stringWithFormat:@"YOUR SAVED ITEMS : %i ITEMS" ,(int)[[AppDelegate appDelegate].arrFavourite count]];
}

-(void)editFavoriteProduct:(NSNotification *)notification
{
    [self setTotalValue];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(isProductEdit)
    {
        isProductEdit = NO;
        _viewProductDetail.hidden = YES;
        [UIView transitionFromView:_viewProductDetail toView:self.tblViewProductBag duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion: ^(BOOL inFinished)
                        {
                            //do any post animation actions here
                            
                            [self.btnMoveAll setHidden:NO];
                        }];
    }
    
    [self.tblViewProductBag reloadData];
}

-(void)deleteProduct:(NSNotification *)notification
{
    lblNavTitle.text = [NSString stringWithFormat:@"YOUR SAVED ITEMS : %i ITEMS" ,(int)[[AppDelegate appDelegate].arrFavourite count]];
    [self setTotalValue];
    [self.tblViewProductBag reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark-Action method
- (IBAction) btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnContinueAction
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Do you want to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}
-(void)DeleteAllProductsFromFav
{
    [self showLoader];
    for (int i=0; i<[AppDelegate appDelegate].arrFavourite.count; i++)
    {
        NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrFavourite objectAtIndex:i];
        NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"product_id":[mDict valueForKeyPath:@"prd_id"],@"uniq_id":[mDict valueForKey:@"uniq_id"],@"get":@"0"};
        
        [CartrizeWebservices PostMethodWithApiMethod:@"GetUserFavoriteHistory" Withparms:parameters WithSuccess:^(id response) {
            // self.arrAddToBag = [response JSONValue];
            [AppDelegate appDelegate].requestFor = DELETEFAVORITEPRODUCT;
            [[AppDelegate appDelegate] getFavoriteHistory];
            lblNavTitle.text = [NSString stringWithFormat:@"YOUR SAVED ITEMS : 0 ITEMS" ];
            [self.tableViewPrdAttributes reloadData];
            
        } failure:^(NSError *error)
         {
             //NSLog(@"Error =%@",[error description]);
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }];
    }
}

#pragma mark -- SHOW LOADER MBProgressHUD
-(void)showLoader
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = NO;
}

- (void)btnDeleteAction:(id)sender
{
   
    //NSLog(@"index -- %ld",(long)[sender tag]);
    [self showLoader];
    NSMutableDictionary *mDict = [[AppDelegate appDelegate].arrFavourite objectAtIndex:[sender tag]];
    NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"product_id":[mDict valueForKeyPath:@"prd_id"],@"uniq_id":[mDict valueForKey:@"uniq_id"],@"get":@"0"};
    [CartrizeWebservices PostMethodWithApiMethod:@"GetUserFavoriteHistory" Withparms:parameters WithSuccess:^(id response) {
        // self.arrAddToBag = [response JSONValue];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Removed successfully.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [AppDelegate appDelegate].requestFor = DELETEFAVORITEPRODUCT;
        [[AppDelegate appDelegate] getFavoriteHistory];
        
    } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

- (IBAction) btnMoveAllToBagAction:(id)sender
{
   [self showLoader];
  [self sendparameterforShopping:0];
}

-(void)sendparameterforShopping:( NSInteger)indexpath
{
    if (indexpath<[AppDelegate appDelegate].arrFavourite.count)
    {
        NSLog(@"MMMMMMMMM:-%ld",(long)indexpath);
        
        NSMutableDictionary *mDictProduct = [[AppDelegate appDelegate].arrFavourite objectAtIndex:indexpath];
        NSString *product_id = [mDictProduct objectForKey:@"prd_id"];
        NSString *jsonString1 = [mDictProduct valueForKeyPath:@"option_json_value"];
        NSString *strProductOptions = [NSString stringWithFormat:@""];
        NSMutableArray *optionArray = [jsonString1 JSONValue];
        for(int j = 0; j < [optionArray count]; j++)
        {
            NSMutableDictionary *dict = [optionArray objectAtIndex:j];
            if (j == 0)
            {
                strProductOptions = [strProductOptions stringByAppendingString:@"{"];
            }
            if(![[dict valueForKey:@"option_id"] isEqualToString:@""])
            {
                strProductOptions = [strProductOptions stringByAppendingFormat:@"\"%@\"",[dict valueForKey:@"option_id"]];
                
                strProductOptions = [strProductOptions stringByAppendingFormat:@":\"%@\"",[dict valueForKey:@"option_type_id"]];
                if(j != [optionArray count] - 1)
                {
                    strProductOptions = [strProductOptions stringByAppendingString:@","];
                }
            }
            if(j == [optionArray count] - 1)
            {
                strProductOptions = [strProductOptions stringByAppendingString:@"}"];
            }
        }
        NSData *data = [strProductOptions dataUsingEncoding:NSUTF8StringEncoding];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
//FAVOURATE_2
//        NSDictionary *parameters = @{@"prod_id":product_id,@"prod_qty":[mDictProduct valueForKey:@"prd_qty"],@"prod_options":jsonString};
        
       if ([[mDictProduct valueForKey:@"QTY"] intValue] <= 0)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Some product out of stock. can't move to bag" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else
        {
         NSDictionary *parameters = @{@"prod_id":product_id,@"prod_qty":[mDictProduct valueForKey:@"prd_qty"],@"customer_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"],@"prod_options":jsonString};
          
            [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsAdd" Withparms:parameters WithSuccess:^(id response)
             {
                 // //NSLog(@"Add Product Response= %@",[response JSONValue]);
                 
                 NSMutableDictionary *mDict = [response JSONValue];
                 NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
                 [userDefualt setObject:[[mDict valueForKey:@"customerdetails"] valueForKey:@"cartid"] forKey:@"cart_id"];
                 [userDefualt synchronize];
             
                 
                 
                 NSArray *arr=[[NSArray alloc]init];
                 arr=[[response JSONValue] valueForKey:@"ProductDetails"];
                 NSString  *strID= [[arr objectAtIndex:arr.count-1]valueForKey:@"ItemId"];
                 
                 
                 
                 
              //   [self moveAllProducts:mDict withArrayIndex:indexpath];
                 
                 
                 [self moveAllProducts:mDict withArrayIndex:indexpath andWithNew_Id:strID];
             } failure:^(NSError *error)
             {
                 //NSLog(@"Error = %@",[error description]);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }];
        }
    }
    else
    {
        [self performSelector:@selector(DeleteAllProductsFromFav) withObject:nil afterDelay:0.0];
    }
}

-(void)moveAllProducts :(NSMutableDictionary *)CartDictionary withArrayIndex :(int)counter andWithNew_Id:(NSString *)new_id
{
    NSMutableDictionary *mDictProduct = [[AppDelegate appDelegate].arrFavourite objectAtIndex:counter];
    NSString *product_id = [mDictProduct objectForKey:@"prd_id"];
    BOOL isUpdateQty = NO;
    
    // if (![self matchFoundForEventId:product_id WithArray:objAppDelegate.arrAddToBag])
    for (NSMutableDictionary *mDictBag in [AppDelegate appDelegate].arrFavourite)
    {
        if([[mDictBag valueForKey:@"prd_id"]isEqualToString:[mDictProduct valueForKeyPath:@"prd_id"]])
        {
            NSString *jsonString = [mDictBag valueForKey:@"option_json_value"];
            
            NSString *jsonString1 = [mDictProduct valueForKey:@"option_json_value"];
            
            if([jsonString1 isEqualToString:jsonString])
            {
                int qty = [[mDictBag valueForKey:@"prd_qty"] intValue];
                qty = qty + [[mDictProduct valueForKey:@"prd_qty"] intValue];
                
                NSString *strQty = [NSString stringWithFormat:@"%d",qty];
                
//                NSString *strUniqID = @"";
                
//                for (NSMutableDictionary *mDictPrdDetail in [CartDictionary objectForKey:@"ProductDetails"])
//                {
//                    if([[mDictPrdDetail valueForKey:@"ProductId"] isEqualToString:product_id])
//                    {
//                        if([[mDictPrdDetail valueForKey:@"ItemId"] isEqualToString:[mDictBag valueForKey:@"uniq_id"]])
//                        {
//                            strUniqID = [mDictPrdDetail valueForKey:@"ItemId"];
//                        }
//                    }
//                }
              
                isUpdateQty = YES;
                //NSString *strPrice = [lblProductPrice.text substringFromIndex:1];
                
                //DIPESH..
                
//                NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":strQty,@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":strUniqID,@"prd_default_price":[mDictProduct valueForKey:@"prd_price"],@"prd_update_price":[mDictProduct valueForKey:@"prd_update_price"],@"get":@"1"};
                
//                     NSDictionary *parameters = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"], @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[mDictProduct objectForKey:@"prd_qty"],@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":[mDictProduct valueForKey:@"uniq_id"],@"prd_default_price":[mDictProduct valueForKey:@"prd_price"],@"prd_update_price":[mDictProduct valueForKey:@"prd_update_price"], @"weight":[[CartDictionary valueForKey:@"ProductDetails"] valueForKey:@"getRowWeight"], @"get":@"1"};
                
                
                
                NSDictionary *parameters = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"], @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[mDictProduct objectForKey:@"prd_qty"],@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":new_id,@"prd_default_price":[mDictProduct valueForKey:@"prd_price"],@"prd_update_price":[mDictProduct valueForKey:@"prd_update_price"], @"weight":[[CartDictionary valueForKey:@"ProductDetails"] valueForKey:@"getRowWeight"], @"get":@"1"};
                
                [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
                 {
                     [self sendparameterforShopping:counter + 1];
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
        NSString *jsonString = [mDictProduct valueForKey:@"option_json_value"];
        
        //NSString *strPrice = [lblProductPrice.text substringFromIndex:1];
        
        for (NSMutableDictionary *mDictPrdDetail in [CartDictionary objectForKey:@"ProductDetails"])
        {
            // item id and product id match with
            //NSLog(@"%@",[NSString stringWithFormat:@"p_id==%@\ni_id==%@",[mDictPrdDetail objectForKey:@"ProductId"],[mDictPrdDetail objectForKey:@"ItemId"]]);
            BOOL CheckIfMatch =NO;
            BOOL notmatch;
            for(NSMutableDictionary *mDictBag in [AppDelegate appDelegate].arrFavourite)
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
                NSString *strItemID = [mDictPrdDetail valueForKey:@"ItemId"];
                // we can add this object
                
                //DIPESH.
                
//                NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[mDictProduct objectForKey:@"prd_qty"],@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":strItemID,@"prd_default_price":[mDictProduct valueForKey:@"prd_price"],@"prd_update_price":[mDictProduct valueForKey:@"prd_update_price"],@"get":@"1"};

//                 NSDictionary *parameters = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"], @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[mDictProduct objectForKey:@"prd_qty"],@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":strItemID,@"prd_default_price":[mDictProduct valueForKey:@"prd_price"],@"prd_update_price":[mDictProduct valueForKey:@"prd_update_price"], @"weight":[[CartDictionary valueForKey:@"ProductDetails"] valueForKey:@"getRowWeight"], @"get":@"1"};
                
                    NSDictionary *parameters = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"], @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[mDictProduct objectForKey:@"prd_qty"],@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":new_id,@"prd_default_price":[mDictProduct valueForKey:@"prd_price"],@"prd_update_price":[mDictProduct valueForKey:@"prd_update_price"], @"weight":[[CartDictionary valueForKey:@"ProductDetails"] valueForKey:@"getRowWeight"], @"get":@"1"};
                
                
                [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
                 {
                     [self sendparameterforShopping:counter + 1];
                     
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

#pragma mark - UIAlert Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

-(void) setTotalValue
{
    if([[AppDelegate appDelegate].arrFavourite count] != 0)
    {
        NSMutableDictionary *mDictRecord = [[NSMutableDictionary alloc] init];
        float totalPriceQty = 0;
        int qtyTotal = 0;
        for (int i = 0; i<[[AppDelegate appDelegate].arrFavourite count]; i++)
        {
            mDictRecord = [[AppDelegate appDelegate].arrFavourite objectAtIndex:i];
            NSString *strQty = [mDictRecord valueForKey:@"prd_qty"];
            NSString *strPrice = [mDictRecord valueForKey:@"prd_price"];
            float price = [strPrice floatValue];
           
//            if([strQty intValue]==0)
//            {
//                strQty=@"1";
//            }
            int qty = [strQty intValue];
            
            qtyTotal = qtyTotal+qty;
            float prceQty = price*qty;
            totalPriceQty = totalPriceQty+prceQty;
        }
        
        //NSLog(@"%f", totalPriceQty);
        totalPrice = totalPriceQty;
    }
}

-(IBAction)btnActionMoveToBag:(id)sender
{
    //MANOJ
    btnTag = (int)[sender tag];
    NSMutableDictionary *mDictProduct = [[AppDelegate appDelegate].arrFavourite objectAtIndex:[sender tag]];
   
//    NSString *strQUNTITY=[NSString stringWithFormat:@"%d",[[mDictProduct valueForKey:@"QTY"] intValue]];
    
    if ([[mDictProduct valueForKey:@"QTY"] intValue] <= 0)
    {
        UIAlertView *ale=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"This product is out of stock" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [ale show];
    }
    else
    {
        NSString *product_id = [mDictProduct objectForKey:@"prd_id"];
        [self showLoader];
        NSString *jsonString1 = [mDictProduct valueForKeyPath:@"option_json_value"];
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
        
        //FAVOURATE_1
        //    NSDictionary *parameters = @{@"prod_id":product_id,@"prod_qty":[mDictProduct valueForKey:@"prd_qty"],@"prod_options":jsonString};
        
        NSDictionary *parameters = @{@"prod_id":product_id,@"prod_qty":[mDictProduct valueForKey:@"prd_qty"],@"customer_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"],@"prod_options":jsonString};
        
        [CartrizeWebservices PostMethodWithApiMethod:@"ShoppingCartProductsAdd" Withparms:parameters WithSuccess:^(id response)
         {
             // //NSLog(@"Add Product Response= %@",[response JSONValue]);
             NSMutableDictionary *mDict = [response JSONValue];
             NSUserDefaults *userDefualt=[NSUserDefaults standardUserDefaults];
             [userDefualt setObject:[[mDict valueForKey:@"customerdetails"] valueForKey:@"cartid"] forKey:@"cart_id"];
             [userDefualt synchronize];
             
             
             
             NSArray *arr=[[NSArray alloc]init];
             arr=[[response JSONValue] valueForKey:@"ProductDetails"];
             NSString  *strID= [[arr objectAtIndex:arr.count-1]valueForKey:@"ItemId"];
             
         //    [self thirdServiceCall:dic newQty:strID];
             
             [self addToBagProduct:mDict and:strID];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         } failure:^(NSError *error)
         {
             //NSLog(@"Error = %@",[error description]);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];

    }
    
}

-(void)addToBagProduct :(NSMutableDictionary *)CartParam and:(NSString *)New_id
{
    
    NSMutableDictionary *mDictProduct = [[AppDelegate appDelegate].arrFavourite objectAtIndex:btnTag];
    NSString *product_id = [mDictProduct objectForKey:@"prd_id"];
    
    BOOL isUpdateQty = NO;
    
    // if (![self matchFoundForEventId:product_id WithArray:objAppDelegate.arrAddToBag])
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = NO;
    
    for (NSMutableDictionary *mDictBag in [AppDelegate appDelegate].arrAddToBag)
    {
        if([[mDictBag valueForKey:@"prd_id"]isEqualToString:[mDictProduct valueForKeyPath:@"prd_id"]])
        {
            NSString *jsonString = [mDictBag valueForKey:@"option_json_value"];
            
            NSString *jsonString1 = [mDictProduct valueForKey:@"option_json_value"];
            
            if([jsonString1 isEqualToString:jsonString])
            {
                int qty = [[mDictBag valueForKey:@"prd_qty"] intValue];
                qty = qty + [[mDictProduct valueForKey:@"prd_qty"] intValue];
                
                NSString *strQty = [NSString stringWithFormat:@"%d",qty];
                
                NSString *strUniqID = @"";
                
//                for (NSMutableDictionary *mDictPrdDetail in [CartParam objectForKey:@"ProductDetails"])
//                {
//                    if([[mDictPrdDetail valueForKey:@"ProductId"] isEqualToString:product_id])
//                    {
//                        if([[mDictPrdDetail valueForKey:@"ItemId"] isEqualToString:[mDictBag valueForKey:@"uniq_id"]])
//                        {
//                            strUniqID = [mDictPrdDetail valueForKey:@"ItemId"];
//                        }
//                    }
//                }

                
                
                isUpdateQty = YES;
                NSString *strPrice = [lblProductPrice.text substringFromIndex:1];

                //DIPESH.
                
//                NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":strQty,@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":strUniqID,@"prd_default_price":[mDictProduct valueForKey:@"prd_price"],@"prd_update_price":strPrice,@"get":@"1"};
                
//                NSDictionary *parameters = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"], @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":strQty,@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":strUniqID,@"prd_default_price":[mDictProduct valueForKey:@"prd_price"],@"prd_update_price":strPrice, @"weight":[[CartParam valueForKey:@"ProductDetails"] valueForKey:@"getRowWeight"], @"get":@"1"};

                
                  NSDictionary *parameters = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"], @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":strQty,@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":New_id,@"prd_default_price":[mDictProduct valueForKey:@"prd_price"],@"prd_update_price":strPrice, @"weight":[[CartParam valueForKey:@"ProductDetails"] valueForKey:@"getRowWeight"], @"get":@"1"};
                
                [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
                 {
                  //   [MBProgressHUD hideHUDForView:self.view animated:YES]; comment by hupendra
                    
                     
                     // //NSLog(@"Response = %@",[response JSONValue]);
                     // //NSLog(@"jsonString = %@",jsonString);
                     [AppDelegate appDelegate].requestFor = MOVETOBAGPRODUCT;
                     [[AppDelegate appDelegate] getCheckOutHistory];
                     [self.tblViewProductBag reloadData];
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
        NSString *jsonString = [mDictProduct valueForKey:@"option_json_value"];
        
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
                
                //DIPESH.
                
//                NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[mDictProduct objectForKey:@"prd_qty"],@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":[mDictPrdDetail valueForKey:@"ItemId"],@"prd_default_price":[mDictProduct valueForKey:@"prd_price"],@"prd_update_price":strPrice,@"get":@"1"};
                
//                NSString *strUniqID = @"";
//                
//                for (NSMutableDictionary *mDictPrdDetail in [CartParam objectForKey:@"ProductDetails"])
//                {
//                    if([[mDictPrdDetail valueForKey:@"ProductId"] isEqualToString:product_id])
//                    {
//                        if([[mDictPrdDetail valueForKey:@"ItemId"] isEqualToString:[CartParam valueForKey:@"uniq_id"]])
//                        {
//                            strUniqID = [mDictPrdDetail valueForKey:@"ItemId"];
//                        }
//                    }
//                }
                
//                NSDictionary *parameters = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
//                                             @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],
//                                             @"prd_qty":[mDictProduct objectForKey:@"prd_qty"],
//                                             @"product_id":product_id,
//                                             @"option_json_value":jsonString,
//                                             @"uniq_id":strUniqID,//dipesh- dic not containing any ItemId.
//                                             @"prd_default_price":[mDictProduct valueForKey:@"prd_price"],
//                                             @"prd_update_price":[mDictProduct valueForKey:@"prd_update_price"],
//                                             @"weight":[mDictProduct valueForKey:@"prd_weight"],
//                                             @"get":@"1"};

                
                NSDictionary *parameters = @{@"cart_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"cart_id"],
                                             @"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],
                                             @"prd_qty":[mDictProduct objectForKey:@"prd_qty"],
                                             @"product_id":product_id,
                                             @"option_json_value":jsonString,
                                             @"uniq_id":New_id,//dipesh- dic not containing any ItemId.
                                             @"prd_default_price":[mDictProduct valueForKey:@"prd_price"],
                                             @"prd_update_price":[mDictProduct valueForKey:@"prd_update_price"],
                                             @"weight":[mDictProduct valueForKey:@"prd_weight"],
                                             @"get":@"1"};

                
                
                [CartrizeWebservices PostMethodWithApiMethod:@"GetUserCheckoutHistory" Withparms:parameters WithSuccess:^(id response)
                 {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [AppDelegate appDelegate].requestFor = MOVETOBAGPRODUCT;
                     [[AppDelegate appDelegate] getCheckOutHistory];
                      [self.tblViewProductBag reloadData];
                 } failure:^(NSError *error)
                 {
                     //NSLog(@"Error =%@",[error description]);
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }];
            }
        }
    }
}

-(BOOL)matchFoundForProductId:(NSString *)productId
{
    index1 = 0;
    for (NSDictionary *dataDict in [AppDelegate appDelegate].arrAddToBag)
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

#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isProductEdit)
    {
        return [_arrProductColorAndSize count];
    }
    return [[AppDelegate appDelegate].arrFavourite count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

//    if(isProductEdit)
//    {
//        return nil;
//    }
//    else
//    {
//        if ([[AppDelegate appDelegate].arrFavourite  count] == 0)
//        {
//            return nil;
//        }
//        
//      //  UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//        
//        //by me
//        UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
//        //
//        viewFooter.backgroundColor = [UIColor clearColor];
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
//        imgView.image = [UIImage imageNamed:@"bg_shipbox.png"];
//        
//        [viewFooter addSubview:imgView];
//        
//        UIButton *btnPayment = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
//        btnPayment.backgroundColor = [UIColor clearColor];
////        [btnPayment setImage:[UIImage imageNamed:@"movetoallbag.png"] forState:UIControlStateNormal];
////        [btnPayment setImage:[UIImage imageNamed:@"movetoallbag.png"] forState:UIControlStateHighlighted];
//
//        [btnPayment setBackgroundColor:[UIColor colorWithRed:48/255.0f green:48/255.0f blue:48/255.0f alpha:1.0]];
//        [btnPayment setTitle:@"MOVE ALL TO BAG" forState:UIControlStateNormal];
//        [btnPayment.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//        
//        [btnPayment addTarget:self action:@selector(btnMoveAllToBagAction:) forControlEvents:UIControlEventTouchUpInside];
//        [viewFooter addSubview:btnPayment];
//        //NSLog(@"__FUCTION__");
//        return viewFooter;
//    }
    return 0;
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
        
        if([[[_arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"selecte"] isEqualToString:@"NO"])
        {
            cell.lblPrdAttibuteTitle.text = [[_arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"custome_title"];
        }
        else
        {
            if (IndexValue==0)
            {
                 cell.lblPrdAttibuteTitle.text = @"Weight";
            }
            else
            {
                 cell.lblPrdAttibuteTitle.text = [[_arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"selecte"];
            }
            
        }
        
//        if([[[_arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"custome_title"] isEqualToString:@""]){
//            cell.lblPrdAttibuteTitle.text = [[_arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"custome_title"];
//        }else{
//            cell.lblPrdAttibuteTitle.text = [[_arrProductColorAndSize objectAtIndex:indexPath.row]valueForKey:@"custome_title"];
//        }
        [cell.btnPicker addTarget:self action:@selector(btnColorAndSizeAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnPicker.tag = indexPath.row;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier;
        CellIdentifier = @"FavouriteCell";
        FavouriteCell *cell = (FavouriteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[FavouriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FavouriteCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.viewDetail.hidden = NO;
        
        NSMutableDictionary *dictCartProduct = [[AppDelegate appDelegate].arrFavourite objectAtIndex:indexPath.row];
        
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
        //NSLog(@"height %f",size.height);
        cell.lblProductName.frame=CGRectMake(127, 0, 138, height+20);
        cell.lblProductName.numberOfLines=0;
        cell.lblProductName.lineBreakMode=NSLineBreakByWordWrapping;
        cell.lblProductName.text = [dictCartProduct objectForKey:@"prd_name"];
        cell.lblProductName.lineBreakMode = NSLineBreakByWordWrapping;
        cell.lblProductName.numberOfLines = 0;
        cell.lblQty.text = [dictCartProduct objectForKey:@"prd_qty"];
       
//        if([cell.lblQty.text intValue]==0){
//            cell.lblQty.text=@"1";
//        }
        
        if([[dictCartProduct valueForKey:@"prd_update_price"] floatValue] < 0)
        {
            // productPrice = productPrice * [[dictCartProduct objectForKeky:@"prd_qty"] floatValue];
            cell.lblPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,[[dictCartProduct valueForKey:@"prd_price"] floatValue]];
        }else
        {
//            float priceValues=[[dictCartProduct valueForKey:@"prd_update_price"] floatValue] * [cell.lblQty.text intValue];
           float priceValues=[[dictCartProduct valueForKey:@"prd_update_price"] floatValue];
            cell.lblPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,priceValues];
        }
        
       // cell.imgViewProduct.contentMode = UIViewContentModeScaleAspectFit;
        
//         [cell.imgViewProduct setImageWithURL:[NSURL URLWithString:[dictCartProduct valueForKey:@"prd_thumb"]] placeholderImage:[UIImage imageNamed:@"green_sqrBlock"]];
    
        if([[dictCartProduct valueForKey:@"prd_thumb"]  isKindOfClass:[NSNull class]])
        {
            [cell.imgViewEditProduct setImage:[UIImage imageNamed:@"green_sqrBlock"]];
            cell.imgViewEditProduct.loadingView.hidden=YES;
        }
        else if([dictCartProduct valueForKey:@"prd_thumb"] ==nil){
            [cell.imgViewEditProduct setImage:[UIImage imageNamed:@"green_sqrBlock"]];
            cell.imgViewEditProduct.loadingView.hidden=YES;
            
        }
        else if([[dictCartProduct valueForKey:@"prd_thumb"] length]==0){
            [cell.imgViewEditProduct setImage:[UIImage imageNamed:@"green_sqrBlock"]];
            cell.imgViewEditProduct.loadingView.hidden=YES;
        }
        else{
            [cell.imgViewEditProduct loadImageFromURL:[dictCartProduct valueForKey:@"prd_thumb"]];
            cell.imgViewEditProduct.layer.masksToBounds=YES;
            cell.imgViewEditProduct.layer.borderColor=[[UIColor colorWithRed:150.0/255.0 green:175.0/255.0 blue:84.0/255.0 alpha:1.0]CGColor];
            cell.imgViewEditProduct.layer.borderWidth= 1.0f;
        }
        cell.imgViewEditProduct.contentMode = UIViewContentModeScaleAspectFit;
        //[cell.imgViewProduct setImageWithURL:[NSURL URLWithString:[dictCartProduct valueForKey:@"prd_thumb"]]];
        
        cell.btnMoveToBag.tag = indexPath.row;
        [cell.btnMoveToBag addTarget:self action:@selector(btnActionMoveToBag:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btn_Delete.tag = indexPath.row;
        [cell.btn_Delete addTarget:self action:@selector(btnDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btn_Edit.enabled = YES;
        
        if([[dictCartProduct valueForKey:@"product_options"] count]==0)
        {
            cell.btn_Edit.enabled = NO;
        }
        
        cell.btn_Edit.tag = indexPath.row ;
        [cell.btn_Edit addTarget:self action:@selector(btnEditActionFav:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnEditQty.tag = indexPath.row;
        [cell.btnEditQty addTarget:self action:@selector(btnEditQtyAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *jsonString = [dictCartProduct valueForKey:@"option_json_value"];
        
        NSMutableArray *optionArray = [jsonString JSONValue];
        
        float yPosition = 30 + height - 20;
        
        cell.lblViewMore.text = @"View More";
        
        for (int i = 0; i < [optionArray count]; i++)
        {
            if(selectedIndexViewMore == indexPath.row)
            {
                cell.lblViewMore.text = @"View Less";
                
                UILabel *lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(127, yPosition, 180, 18)];
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
                UILabel *lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(127, yPosition, 180, 18)];
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
        }
        //NSLog(@"selected index val %d",selectedIndexViewMore);
        if(selectedIndexViewMore == indexPath.row)
        {
            if (yPosition>32)
            {
                cell.btnEditQty.frame=CGRectMake(141, cell.bounds.size.height-62, 70, 23);
                cell.lblQty.frame=CGRectMake(163, cell.bounds.size.height-62, 25, 21);
  

                cell.btnViewMore.frame=CGRectMake(232, cell.bounds.size.height-62, 75, 23);
                cell.lblViewMore.frame=CGRectMake(239, cell.bounds.size.height-59, 61, 18);
            }
        }
        cell.btnViewMore.hidden = NO;
        cell.lblViewMore.hidden = NO;
        
        if([optionArray count] < 4)
        {
            cell.btnViewMore.hidden = YES;
            cell.lblViewMore.hidden = YES;
        }
        cell.btnViewMore.tag = indexPath.row;
        [cell.btnViewMore addTarget:self action:@selector(actionViewMore:) forControlEvents:UIControlEventTouchUpInside];
        [cell.imgBtn addTarget:self action:@selector(detailProductAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.imgBtn.tag=indexPath.row;
        return cell;
    }
}



-(void)detailProductAction:(UIButton *)btn {
   
    NSMutableDictionary *mDictProduct = [[AppDelegate appDelegate].arrFavourite objectAtIndex:btn.tag];
    ProductDetailView *objProductDetailView;
    if (IS_IPHONE5)
    {
        objProductDetailView = [[ProductDetailView alloc] initWithNibName:@"ProductDetailView" bundle:nil];
    }
    else
    {
        objProductDetailView = [[ProductDetailView alloc] initWithNibName:@"ProductDetailView_iphone3.5" bundle:nil];
    }
     objProductDetailView.mutDictProductDetail =mDictProduct;
    [self.navigationController pushViewController:objProductDetailView animated:YES];
}


-(void)detailAction:(id)sender
{
    
    NSMutableDictionary *mDictProduct = [[AppDelegate appDelegate].arrFavourite objectAtIndex:[sender tag]];
  //  //NSLog(@"detail action %@",mDictProduct);
    ProductDetailView *objProductDetailView;
    if (IS_IPHONE5)
    {
        objProductDetailView = [[ProductDetailView alloc] initWithNibName:@"ProductDetailView" bundle:nil];
    }
    else
    {
        objProductDetailView = [[ProductDetailView alloc] initWithNibName:@"ProductDetailView_iphone3.5" bundle:nil];
    }
    
    objProductDetailView.mutDictProductDetail =mDictProduct;
    [self.navigationController pushViewController:objProductDetailView animated
                                                 :YES];
    
    
    
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
    
    NSMutableDictionary *dictCartProduct = [[AppDelegate appDelegate].arrFavourite objectAtIndex:indexPath.row];
    NSString *str = [dictCartProduct objectForKey:@"prd_name"];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16],
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize size = [str boundingRectWithSize:(CGSize){138 - (10 * 2), 20000.0f}
                                    options:NSStringDrawingUsesFontLeading
                   |NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes
                                    context:nil].size;
    CGFloat height1 = MAX(size.height, 5);
    //NSLog(@"selected index %d",selectedIndexViewMore);
    
    if(selectedIndexViewMore != indexPath.row)
    {
        return  152;//130 + height1;
    }
    else
    {
        NSString *jsonString = [dictCartProduct valueForKey:@"option_json_value"];
        NSMutableArray *optionArray = [jsonString JSONValue];
        CGFloat ypos=28;
        for (int i=0; i<optionArray.count; i++)
        {
            ypos=ypos + 16;
        }
        int cunter = [optionArray count];
        if(cunter < 3)
        {
            return 152;
        }
        return   ypos + height1 + 54;
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
        if ([[AppDelegate appDelegate].arrFavourite  count] == 0)
        {
            return 0;
        }
        return 50.0;
    }
}

-(IBAction)btnEditQtyAction:(id)sender
{
    
    btnIndexOfEditQty=(int)[sender tag];
    
    
    NSDictionary *dicEdit=[[AppDelegate appDelegate].arrFavourite objectAtIndex:btnIndexOfEditQty];
    
  //  NSString *strQUNTITY=[dicEdit valueForKey:@"QTY"];
    
    
  if ([[dicEdit valueForKey:@"QTY"] intValue] <= 0)
    {
        UIAlertView *ale=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"This product out of stock" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [ale show];
    }

    else
    {
        if(IS_IPHONE_4){
            self.pickerToolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 274, 320, 44)];
            pickerViewQty = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 318, 320, 162)];
            pickerViewQty.delegate = self;
            pickerViewQty.showsSelectionIndicator = YES;
            pickerViewQty.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:pickerViewQty];
            
        }else
        {
            self.pickerToolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 362, 320, 44)];
            pickerViewQty = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 406, 320, 162)];
            pickerViewQty.delegate = self;
            pickerViewQty.showsSelectionIndicator = YES;
            pickerViewQty.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:pickerViewQty];
        }
        UIButton *done_Button = [UIButton buttonWithType:UIButtonTypeCustom];
        done_Button.frame=CGRectMake(0.0, 0, 60.0, 30.0);
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
        
        selectedItemIndex = 2;
        
     //   mArrayQuantity = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
        
//        MANOJ
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSMutableDictionary *mDictBag = [appDelegate.arrFavourite objectAtIndex:btnIndexOfEditQty];
        //Product Quantity
        mArrayQuantity = [[NSMutableArray alloc] init];
        NSNumber *num = [mDictBag objectForKey:@"QTY"];
        int totalQty = [num intValue];
        
        if (totalQty >= 10)
        {
            for(int i=1;i <= 10;i++)
            {
                [mArrayQuantity addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        else
        {
            for(int i=1;i <= totalQty;i++)
            {
                [mArrayQuantity addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
        }
        [pickerViewQty reloadAllComponents];
    }
    
}

-(IBAction)actionViewMore:(id)sender
{
    if(selectedIndexViewMore == -1 || selectedIndexViewMore != [sender tag])
    {
        selectedIndexViewMore = (int)[sender tag];
    }
    else
    {
        selectedIndexViewMore = -1;
    }
    
    [_tblViewProductBag reloadData];
}
-(IBAction)btnDoneToolbarAction:(id)sender
{
    [pickerViewQty removeFromSuperview];
    [self.pickerToolbar1 removeFromSuperview];
    NSMutableDictionary *mDictProduct = [[AppDelegate appDelegate].arrFavourite objectAtIndex:[sender tag]];
    NSString *product_id = [mDictProduct objectForKey:@"prd_id"];
    [self showLoader];
    
    if (_strQty==nil)
    {
        _strQty=@"1";
    }
    
    float default_Updated_price = [[mDictProduct valueForKey:@"prd_update_price"]floatValue] / [[mDictProduct valueForKey:@"prd_qty"] intValue];
    
    float updatePrice = [_strQty floatValue] * default_Updated_price;

    NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":_strQty,@"product_id":product_id,@"option_json_value":[mDictProduct valueForKey:@"option_json_value"],@"uniq_id":[mDictProduct valueForKey:@"uniq_id"],@"prd_default_price":[mDictProduct valueForKey:@"prd_price"],@"prd_update_price":[NSString stringWithFormat:@"%f",updatePrice],@"get":@"1"};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"GetUserFavoriteHistory" Withparms:parameters WithSuccess:^(id response)
     {
         
     //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         [AppDelegate appDelegate].requestFor = EDITFAVORITEPRODUCT;
         [[AppDelegate appDelegate] getFavoriteHistory];
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
     }];
}

- (IBAction)btnCancelToolbarAction:(id)sender
{
    [pickerViewQty removeFromSuperview];
    [self.pickerToolbar1 removeFromSuperview];
}

- (void)btnColorAndSizeAction:(id)sender
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
    _mArrayProductAttributes = [[_arrProductColorAndSize objectAtIndex:isSelectedPicker] objectForKey:@"custome_values"];
    pickerViewColor.hidden = NO;
    self.tableViewPrdAttributes.userInteractionEnabled = NO;
    [pickerViewColor reloadAllComponents];

}

-(void)btnEditActionFav:(id)sender
{
    _mutDictProductDetail = [[AppDelegate appDelegate].arrFavourite objectAtIndex:[sender tag]];
    
    indexTag=[sender tag];
    _viewProductDetail.hidden = NO;
    if(IS_IPHONE_4){
        _viewProductDetail.frame = CGRectMake(_viewProductDetail.frame.origin.x, _viewProductDetail.frame.origin.y, 320, 480);
    }else{
        _viewProductDetail.frame = CGRectMake(_viewProductDetail.frame.origin.x, _viewProductDetail.frame.origin.y, 320, 568);
    }
    
    [UIView transitionFromView:self.tblViewProductBag toView:_viewProductDetail duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight
                    completion: ^(BOOL inFinished) {
                        //do any post animation actions here
                        //NSLog(@"test");
                        isProductEdit = YES;
                        
                        IndexValue=0;
                        
                        [_btnMoveAll setHidden:YES];
                        [self setContentView];
                    }];
    
}

- (IBAction)btnEditCancelAction:(id)sender
{
    selectedCellIndex = -1 ;
    isEditProduct = NO;
    pickerViewColor.hidden = YES;
    _keyboardToolbar.hidden = YES;
    
    [self.tblViewProductBag reloadData];
}

- (IBAction)btnEditApplyAction:(id)sender
{
    
    if (IndexValue !=0)
    {
        pickerViewColor.hidden = YES;
        _keyboardToolbar.hidden = YES;
        
        NSString *product_id = [_mutDictProductDetail objectForKey:@"prd_id"];
        
        [self showLoader];
        
        iRequest = 3;
        
        NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
        
        //    for(NSMutableDictionary *mDict in _arrProductColorAndSize)
        //    {
        //        NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
        //        [jsonDict setValue:[mDict valueForKey:@"prd_Attribute_Title"] forKey:@"option_value"];
        //        [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
        //        [jsonDict setValue:[mDict valueForKey:@"prd_option_id"] forKey:@"option_id"];
        //        [jsonDict setValue:[mDict valueForKey:@"prd_option_type_id"] forKey:@"option_type_id"];
        //
        //        if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:[mDict valueForKey:@"custome_title"]] || [[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
        //        {
        //            [jsonArray addObject:jsonDict];
        //        }
        //    }
        
        
        if (IndexValue !=0)
        {
            
            for(NSMutableDictionary *mDict in _arrProductColorAndSize)
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
                [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:IndexValue-1] valueForKey:@"title"] forKey:@"option_value"];
                [jsonDict setValue:[mDict valueForKey:@"custome_title"] forKey:@"option_name"];
                [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:IndexValue-1] valueForKey:@"option_id"] forKey:@"option_id"];
                [jsonDict setValue:[[[mDict valueForKey:@"custome_values"] objectAtIndex:IndexValue-1] valueForKey:@"option_type_id"] forKey:@"option_type_id"];
                if(![[mDict valueForKey:@"prd_Attribute_Title"] isEqualToString:@""])
                {
                    [jsonArray addObject:jsonDict];
                }
            }
            
        }
        
        _copyarrProductColorAndSize = _arrProductColorAndSize;
        
        NSError *writeError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&writeError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //  //NSLog(@"JSON Output: %@", jsonString);
        
        NSString *strPrice = [lblProductPrice.text substringFromIndex:1];
        
        //    NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":[_mutDictProductDetail objectForKey:@"prd_qty"],@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":[_mutDictProductDetail valueForKey:@"uniq_id"],@"prd_default_price":[_mutDictProductDetail valueForKey:@"prd_price"],@"prd_update_price":strPrice,@"get":@"1"};
        
        NSDictionary *parameters = @{@"customer_id": [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],@"prd_qty":@"1",@"product_id":product_id,@"option_json_value":jsonString,@"uniq_id":[_mutDictProductDetail valueForKey:@"uniq_id"],@"prd_default_price":[_mutDictProductDetail valueForKey:@"prd_price"],@"prd_update_price":strPrice,@"get":@"1"};
        
        [CartrizeWebservices PostMethodWithApiMethod:@"GetUserFavoriteHistory" Withparms:parameters WithSuccess:^(id response)
         {
             // //NSLog(@"Response = %@",[response JSONValue]);
             [AppDelegate appDelegate].requestFor = EDITFAVORITEPRODUCT;
             [[AppDelegate appDelegate] getFavoriteHistory];
             //self.arrAddToBag = [response JSONValue];
         } failure:^(NSError *error)
         {
             //NSLog(@"Error =%@",[error description]);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];

    }
    else
    {
        NSLog(@"SORRY");
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
    
    [[AppDelegate appDelegate] getFavoriteHistory];
    selectedCellIndex = -1;
    isEditProduct = NO;
    [self.tblViewProductBag reloadData];
    
    [self performSelector:@selector(reloadAfterDelay) withObject:nil afterDelay:1.0];
}

-(void)reloadAfterDelay
{
    [self.tblViewProductBag reloadData];
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Check your network connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UIPickerView Delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag==1000)
    {
        return [_mArrayProductAttributes count]+1;
    }
    else
    {
        if(selectedItemIndex == 2)
        {
            return [mArrayQuantity count];
        }
        else
        {
            return [_mArrayProductAttributes count];
        }
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, pickerViewColor.frame.size.width, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    
    NSString *strValue;
    if (pickerView.tag==1000)
    {
        
        if (row==0)
        {
             strValue = @"Weight";
            
            
        }
        else
        {
             strValue = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"title"];
           
        }
       
    }
    else{
      
        if(selectedItemIndex == 2)
        {
            strValue = [mArrayQuantity objectAtIndex:row];
        }
        else
        {
            strValue = [[_mArrayProductAttributes objectAtIndex:row] objectForKey:@"title"];
        }
    }
    label.text = [NSString stringWithFormat:@"%@", strValue];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    IndexValue=(int)row;
 
    if (pickerView.tag==1000)
    {
        Price = 0.0;
        if (row==0)
        {
            Price=strDefaultPrice;
        }
        else
        {
       strAttributeTitile = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"title"];

       strPrdOptionId = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"option_id"];
       strPrdOptionTypeId = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"option_type_id"];

       Price = strDefaultPrice + [[[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"price"] floatValue];
       strProductPrice = [[_mArrayProductAttributes objectAtIndex:row-1] objectForKey:@"price"];
        }
    }
    else
    {
        if(selectedItemIndex == 2)
        {
            _strQty = [mArrayQuantity objectAtIndex:row];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 300;
}


-(NSString *)setProductPrice
{
    float newPrice = strDefaultPrice;
    for (NSMutableDictionary *mdict in _arrProductColorAndSize)
    {
        newPrice = [[mdict valueForKey:@"prd_New_Price"]floatValue] + newPrice;
    }
    return [NSString stringWithFormat:@"%.2f",newPrice];
}

-(void)setContentView
{
    
    viewMoreInfo.hidden = YES;
    isWebserviceCount = 1;
    viewMoreInfo.hidden = YES;
    //self.pickerViewColorandSize.hidden = YES;
    
    NSMutableString *request_gallery = [NSMutableString stringWithFormat:@"%@", [NSString stringWithFormat:product_gallery, [_mutDictProductDetail objectForKey:@"prd_id"]]];
    
    NSMutableString *request_options = [NSMutableString stringWithFormat:@"%@", [NSString stringWithFormat:product_option, [_mutDictProductDetail objectForKey:@"prd_id"]]];
    
    [self getResponce1:request_gallery :1];
    [self getResponce1:request_options :2];
    
    //NSLog(@"Dict -- %@",_mutDictProductDetail);

    lblProductName.text = [_mutDictProductDetail objectForKey:@"prd_name"];
    lblProductPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,[[_mutDictProductDetail objectForKey:@"prd_price"] floatValue]];
    
    NSNumber *numb = [_mutDictProductDetail objectForKey:@"prd_price"];
    strDefaultPrice=[numb floatValue];
    
    lblProductProductCode.text = [NSString stringWithFormat:@"Product Code %@",[_mutDictProductDetail objectForKey:@"prd_sku"]];
    //lblProductProductDiscription.text = [_mutDictProductDetail objectForKey:@"prd_desc"];
    
    
    NSString *str=[_mutDictProductDetail objectForKey:@"prd_desc"];
    CGSize constraint = CGSizeMake(295 - (10 * 2), 20000.0f);
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = MAX(size.height, 44.0);
    lblProductProductDiscription.text = [_mutDictProductDetail objectForKey:@"prd_desc"];
    
    
    //Manoj
    
     self.imgDescBackground.frame=CGRectMake(8,lblAboutMe.frame .origin.y+lblAboutMe.frame.size.height+10,300, height+10);
    
    //
    
    lblProductProductDiscription.frame = CGRectMake(12,lblAboutMe.frame .origin.y+lblAboutMe.frame.size.height+10,295, height+10);
    
   
    btnMoreInfo.frame = CGRectMake(5,lblProductProductDiscription.frame.origin.y+lblProductProductDiscription.frame.size.height+20, 310, 30);
    
    lblProductProductDiscription.numberOfLines = 0;
    //imageViewBG.frame = CGRectMake(0, 101, 320, lblProductProductDiscription.bounds.size.height + 408);

    if (IS_IPHONE_4){
       self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, btnMoreInfo.frame.origin.y+550);
    }else{
        self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width,btnMoreInfo.frame.origin.y+550);
    }
    self.scrollViewProductDetail.contentOffset = CGPointMake (self.scrollViewProductDetail.bounds.origin.x, 0);
    
    self.scrollViewProductDetail.contentOffset = CGPointMake (self.scrollViewProductDetail.bounds.origin.x, 0);
    stringHt=height;
}

- (void) getResponce1:(NSString *)strURL :(int)service_count
{
    
    if (service_count == 1){
    
        
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
     
        if(_arrProductColorAndSize.count!=0){
            [_arrProductColorAndSize removeAllObjects];
        }else{
            _arrProductColorAndSize=[[NSMutableArray alloc] init];
        }
        
            NSMutableArray *optionArray = [_mutDictProductDetail valueForKey:@"product_options"] ;
            for (int i = 0; i < [optionArray count]; i++)
            {
                NSMutableDictionary *mDict1=[[NSMutableDictionary alloc] init];
                [mDict1 setValue:@"NO"  forKey:@"selecte"];
                [mDict1 setValue:[[optionArray objectAtIndex:i] valueForKey:@"custome_title"]  forKey:@"custome_title"];
                [mDict1 setValue:[[optionArray objectAtIndex:i] valueForKey:@"product_id"]  forKey:@"product_id"];
                [mDict1 setValue:[[optionArray objectAtIndex:i] valueForKey:@"product_title"]  forKey:@"product_title"];
                [mDict1 setValue:[[optionArray objectAtIndex:i] valueForKey:@"product_price"]  forKey:@"product_price"];
                [mDict1 setObject:[[optionArray objectAtIndex:i] valueForKey:@"custome_values"] forKey:@"custome_values"];
                     [_arrProductColorAndSize addObject:mDict1];
                }
        
        //NSLog(@"Responce-- %@",_arrProductColorAndSize);
        
        CGRect newTableFrame = self.tableViewPrdAttributes.frame;
        
        newTableFrame.size.height = [_arrProductColorAndSize count] * 36;
        self.tableViewPrdAttributes.frame = newTableFrame;
        
        CGRect viewProductFrame = self.viewPrdAttributes.frame;
        
        viewProductFrame.origin.y = self.tableViewPrdAttributes.frame.origin.y + self.tableViewPrdAttributes.frame.size.height - 14;
        
        self.viewPrdAttributes.frame = viewProductFrame;
        
      //  float heightScroll = 891 + ([_arrProductColorAndSize count]-1) * 36; old code
       
         float heightScroll = 10 + ([_arrProductColorAndSize count]-1) * 36; //hupendra code
        
        //NSLog(@"%f",heightScroll);
        
        self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, heightScroll+stringHt - 170);
        
        [self.tableViewPrdAttributes reloadData];
    }

}

- (void) getResponce:(NSString *)strURL :(int)service_count
{
    if (service_count == 1)
    {
    
    }else if(service_count == 2) {
        
    }
    
    
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
                               else
                               {
                                   NSMutableArray *mArrayResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   _arrProductColorAndSize = [[NSMutableArray alloc]init];
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
                                                   //[mDict setValue:strText forKey:@"prd_Attribute_Title"];
                                                   
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
                                       [_arrProductColorAndSize addObject:mDict];
                                   }
                                   
                                   //NSLog(@"Responce-- %@",_arrProductColorAndSize);
                                   
                                   CGRect newTableFrame = self.tableViewPrdAttributes.frame;
                                   
                                   newTableFrame.size.height = [_arrProductColorAndSize count] * 36;
                                   self.tableViewPrdAttributes.frame = newTableFrame;
                                   
                                   CGRect viewProductFrame = self.viewPrdAttributes.frame;
                                   
                                   viewProductFrame.origin.y = self.tableViewPrdAttributes.frame.origin.y + self.tableViewPrdAttributes.frame.size.height - 14;
                                   
                                   self.viewPrdAttributes.frame = viewProductFrame;
                                   
                                   float heightScroll = 891 + ([_arrProductColorAndSize count]-1) * 36;
                                   self.scrollViewProductDetail.contentSize = CGSizeMake(self.scrollViewProductDetail.frame.size.width, heightScroll+stringHt - 170);
                                   
                                   [self.tableViewPrdAttributes reloadData];
                               }
                           }];
}

-(void)productGalleryFullView:(UITapGestureRecognizer *)gesture
{
//    NSString *strXIB = @"ViewFullSizeImageVC_iPhone3.5";
//    if(IS_IPHONE5)
//    {
//        strXIB = @"ViewFullSizeImageVC";
//    }
//    
//    ViewFullSizeImageVC *viewfullsizeimageview=[[ViewFullSizeImageVC alloc]initWithNibName:strXIB bundle:nil];
//    viewfullsizeimageview.image_tag = gesture.view.tag;
//    viewfullsizeimageview.imageArray = mutArrayProductImages;
//    [self presentViewController:viewfullsizeimageview animated:YES completion:nil];
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
    _viewProductDetail.hidden = YES;
    //pickerViewDetail.hidden = YES;
    
    [UIView transitionFromView:_viewProductDetail toView:self.tblViewProductBag duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion: ^(BOOL inFinished)
                    {
                        //do any post animation actions here
                        
                        [_btnMoveAll setHidden:NO];
                    }];
    [self.tblViewProductBag reloadData];
}

- (IBAction)CancelButtonPressed:(id)sender
{
    
    self.tableViewPrdAttributes.userInteractionEnabled = YES;
    NSMutableDictionary *mDict = [_arrProductColorAndSize objectAtIndex:isSelectedPicker];
    
     NSMutableDictionary *mDict2=[[AppDelegate appDelegate].arrFavourite objectAtIndex:indexTag];
    
    if([[mDict valueForKey:@"prd_New_Price"] floatValue ] > 0)
    {
        [mDict setValue:[mDict valueForKey:@"prd_New_Price"] forKey:@"prd_New_Price"];
    }
    else
    {
        [mDict setValue:[mDict2 valueForKey:@"Prd_Price"] forKey:@"prd_New_Price"];
    }
    
    lblProductPrice.text = [NSString stringWithFormat:@"%@%@",[AppDelegate appDelegate].currencySymbol,[self setProductPrice]];
    
    pickerViewColor.hidden = YES;
    [self.pickerToolbar1 removeFromSuperview];
}

- (IBAction)doneBtnPressToGetValue:(id)sender
{
    
    NSString *strUpdated_Price;
    self.tableViewPrdAttributes.userInteractionEnabled = YES;
    
    pickerViewColor.hidden = YES;
    
    [self.pickerToolbar1 removeFromSuperview];
    
    NSMutableDictionary *mDict = [_arrProductColorAndSize objectAtIndex:isSelectedPicker];
    lblProductPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,Price];
    strProductPrice = @"0";
    ////MMMMMMMMMMMMMMM
    
    if (IndexValue == 0)
    {
        Price = strDefaultPrice;
        [self.btnApply setEnabled:NO];
        
        NSDictionary *dic=[[AppDelegate appDelegate].arrFavourite objectAtIndex:indexTag];
        strUpdated_Price=[NSString stringWithFormat:@"%@",[dic valueForKey:@"prd_update_price"]];
    }
    else
    {
        [self.btnApply setEnabled:YES];
        strAttributeTitile = [[_mArrayProductAttributes objectAtIndex:IndexValue-1] objectForKey:@"title"];
        strPrdOptionId = [[_mArrayProductAttributes objectAtIndex:IndexValue-1] objectForKey:@"option_id"];
        strPrdOptionTypeId = [[_mArrayProductAttributes objectAtIndex:IndexValue-1] objectForKey:@"option_type_id"];
        Price = strDefaultPrice + [[[_mArrayProductAttributes objectAtIndex:IndexValue-1] objectForKey:@"price"] floatValue];
        strUpdated_Price=[NSString stringWithFormat:@"%f",Price];
    }
    
    [mDict setValue:strAttributeTitile forKey:@"selecte"];
    
    ///hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
    NSMutableDictionary *dictCart = [[AppDelegate appDelegate].arrFavourite objectAtIndex:indexTag];
    [dictCart setValue:strUpdated_Price forKey:@"prd_update_price"];
    [[AppDelegate appDelegate].arrFavourite replaceObjectAtIndex:indexTag withObject:dictCart];
    //hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
    
    [_arrProductColorAndSize replaceObjectAtIndex:isSelectedPicker withObject:mDict];
    //===============================
    
    lblProductPrice.text = [NSString stringWithFormat:@"%@%.02f",[AppDelegate appDelegate].currencySymbol,Price];
    
    
    ////MMMMMMMMMMMMMMMM
 /* 
  [mDict setValue:strProductPrice forKey:@"prd_New_Price"];
  [[_arrProductColorAndSize objectAtIndex:isSelectedPicker]setValue:strAttributeTitile forKey:@"prd_Attribute_Title"];
    
    //NSLog(@"strAttributeTitile =%@",strAttributeTitile);
    [[_arrProductColorAndSize objectAtIndex:isSelectedPicker]setValue:strPrdOptionId forKey:@"prd_option_id"];
    
    [[_arrProductColorAndSize objectAtIndex:isSelectedPicker]setValue:strPrdOptionTypeId forKey:@"prd_option_type_id"]; */  //Hupendra
    
//    [mDict setValue:strAttributeTitile forKey:@"selecte"];
//    
//    [_arrProductColorAndSize replaceObjectAtIndex:isSelectedPicker withObject:mDict];
    
    [self.tableViewPrdAttributes reloadData];
}

#pragma mark - Image Sharing From Face Book

-(IBAction)btnActionFaceBookSharing:(id)sender
{
  /*  if([SCFacebook isSessionValid])
    {
        [self shared_ON_Facebook];
        
    }else
    {
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
   /* if(imgViewProducts.image==nil)
    {
        Alert1(@"Alert",@"Images can not null");
    }else
    {
         strFacebook=[NSString stringWithFormat:@"What do you think? Should i buy this ?%@\n%@",lblProductName.text,lblProductProductDiscription.text];
        
        
//          [[SCFacebook shared] feedPostWithLinkPath:nil caption:caption message:nil photo:photo video:nil callBack:callBack];
  
        
//        NSURL *url=[NSURL URLWithString:[_mutDictProductDetail valueForKey:@"product_url"]];
        
        
       NSString *str=[_mutDictProductDetail valueForKey:@"product_url"];
        
        [SCFacebook feedPostWithLinkPath:str caption:strFacebook Photo:imgViewProducts.image callBack:^(BOOL success,id result)
         {
             Alert1(@"Alert", @"Successfully facebook sharing");
         }];

    }
    */
    
}


-(IBAction)btnActionTwitterSharing:(id)sender
{
    [self twitter_login];
//    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//    
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
            [self postDataOnTwitter];
            //NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
        }];
    }
}


-(void)postDataOnTwitter
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            
                //UIImage *imaData=[UIImage imageNamed:@"movetobag.png"];
            
            NSData *data = UIImagePNGRepresentation(imgViewProducts.image);
            
          //  id returned = [[FHSTwitterEngine sharedEngine]postTweet:lblProductName.text withImageData:data];
                // id returned = [[FHSTwitterEngine sharedEngine]postTweet:strURL];
        
            //by me
            
            
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

            //
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSString *title = nil;
            NSString *message = nil;
            
            if ([returned isKindOfClass:[NSError class]])
            {
                NSError *error = (NSError *)returned;
                title = [NSString stringWithFormat:@"Error %d",error.code];
                message = error.localizedDescription;
            } else
            {
                message=@"Successfully twitter sharing";
            }           dispatch_sync(dispatch_get_main_queue(), ^
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



-(IBAction)btnActionMailSharing:(id)sender
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init]  ;
	mailComposer.mailComposeDelegate = self;
	
	if ([MFMailComposeViewController canSendMail])
    {
		[mailComposer setToRecipients:nil];
		[mailComposer setSubject:@"What do you think? Should I buy this?"];
        //NSString *message = [@"Check it out at:\n\n\n" stringByAppendingString:[_mutDictProductDetail valueForKey:@"product_url"]];
        
          NSString *strMessage=[NSString stringWithFormat:@"Check it out at:\n%@\n%@",[_mutDictProductDetail valueForKey:@"prd_name"],[_mutDictProductDetail valueForKey:@"product_url"]];
        
		[mailComposer setMessageBody:strMessage isHTML:NO];
        
      //  NSData *imageData = UIImagePNGRepresentation(imgViewProducts.image);
        
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
    
    [shareBuilder setURLToShare:[NSURL URLWithString:[_mutDictProductDetail valueForKey:@"product_url"]]];
    [shareBuilder setPrefillText:@"What do you think? Should I buy this?"];
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

- (IBAction) btnMoreInfoAction:(id)sender {
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

#pragma mark:-Hupendra 

- (IBAction)DropDownWeithList:(id)sender {
    
}

@end
