//
//  DashboardDetail.m
//  IShop
//
//  Created by Admin on 16/07/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "DashboardDetail.h"
#import "JSON.h"
#import "DashboardDetailCell.h"
#import "DashboardCell.h"
#import "CartrizeWebservices.h"

@interface DashboardDetail ()

@end

@implementation DashboardDetail
@synthesize orderId,statusStr,window,progressHud;
@synthesize sagment;
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
    
   [self changeUISegmentFont:sagment];
    
    [self changeUISegmentFont1:sagment];
    
    //self.window=[UIApplication sharedApplication].keyWindow;
    self.navigationController.navigationBarHidden=YES;
    self.progressHud=[[MBProgressHUD alloc]init];
    self.progressHud.delegate=self;
    self.progressHud.labelText = @"Please wait...";
    [self.view addSubview:self.progressHud];
    [self.progressHud show:YES];
    itemArray=[[NSMutableArray alloc] init];

    paymentDetail=[[NSMutableArray alloc] init];

    shippingAdd.userInteractionEnabled=NO;
    billingAdd.userInteractionEnabled=NO;
    PaymentMethod.userInteractionEnabled=NO;
    scroll.contentSize=CGSizeMake(320, 1500);
    headerLbl.text=[NSString stringWithFormat:@"Order #%@ - %@",self.orderId,self.statusStr];
    titleArray=[[NSMutableArray alloc] initWithObjects:@"Product Name",@"SKU",@"Price",@"Qty",@"Subtotal",@"Shipping & Handling",@"Discount",@"Grand Total", nil];
    
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12], UITextAttributeFont, nil];
    [self.sagment setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [self getDashboardDetails];

      // Do any additional setup after loading the view from its nib.
}



-(void) changeUISegmentFont:(UIView*) myView
{
    if ([myView isKindOfClass:[UILabel class]]) {  // Getting the label subview of the passed view

        UILabel* label = (UILabel*)myView;
        //[label setTextAlignment:UITextAlignmentCenter];
       // [label setFont:[UIFont boldSystemFontOfSize:5]]; // Set the font size you want to change to
       // UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
       
        label.font=[UIFont boldSystemFontOfSize:12.0f];
        
      //  NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
      //                                                         forKey:UITextBorderStyleNone];
//        [sagment setTitleTextAttributes:attributes
//                               forState:UIControlStateNormal];

        
    }
    
    NSArray* subViewArray = [myView subviews]; // Getting the subview array
    NSEnumerator* iterator = [subViewArray objectEnumerator]; // For enumeration
        UIView* subView;
    while (subView = [iterator nextObject]) { // Iterating through the subviews of the view passed
        [self changeUISegmentFont:subView]; // Recursion
    }
    
   
}

-(void) changeUISegmentFont1:(UIView*) myView
{
    
    if ([myView isKindOfClass:[UILabel class]]) {  // Getting the label subview of the passed view
        
        UILabel* label = (UILabel*)myView;
        //[label setTextAlignment:UITextAlignmentCenter];
        // [label setFont:[UIFont boldSystemFontOfSize:5]]; // Set the font size you want to change to
        // UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
        
        label.font=[UIFont boldSystemFontOfSize:12.0f];
        
        //  NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
        //                                                         forKey:UITextBorderStyleNone];
        //        [sagment setTitleTextAttributes:attributes
        //                               forState:UIControlStateNormal];
        
        
    }
    
    NSArray* subViewArray = [myView subviews]; // Getting the subview array
    NSEnumerator* iterator = [subViewArray objectEnumerator]; // For enumeration
    UIView* subView;
    while (subView = [iterator nextObject]) { // Iterating through the subviews of the view passed
        [self changeUISegmentFont1:subView]; // Recursion
    }
    
    
}




-(void)getDashboardDetails
{
    NSDictionary *parameters = @{@"order_id":self.orderId};
    [CartrizeWebservices PostMethodWithApiMethod:@"GetCustomerOrdersByOrderId" Withparms:parameters WithSuccess:^(id response)
     {
         _responseArray=[response JSONValue];
         itemArray=[[_responseArray valueForKey:@"Item Order"]objectAtIndex:0];
         
         NSMutableDictionary *mDictItems = [itemArray objectAtIndex:0];

         NSMutableArray *mArrayItemOption = [[mDictItems objectForKey:@"products_options"] objectForKey:@"options"];
         //NSLog(@"mArrayItemOption = %@",mArrayItemOption);
         //for Shipping add
         NSArray *shiparray=[[[[[_responseArray valueForKeyPath:@"Address"] valueForKey:@"shipping address"] objectAtIndex:0] objectAtIndex:0] objectAtIndex:0];
         
         sh_namelbl.text=[NSString stringWithFormat:@"%@ %@",[shiparray valueForKey:@"firstname"],[shiparray valueForKey:@"lastname"]];
         sh_addLbl.text=[NSString stringWithFormat:@"%@",[shiparray valueForKey:@"street"]];
         sh_cityLbl.text=[NSString stringWithFormat:@"%@,%@,%@",[shiparray valueForKey:@"city"],[shiparray valueForKey:@"region"],[shiparray valueForKey:@"postcode"]];
         sh_countryLbl.text=[NSString stringWithFormat:@"%@",[shiparray valueForKey:@"country"]];
         sh_telLbl.text=@"";
         
         // for Payment
         //NSLog(@"Response = %@",[[[_responseArray valueForKey:@"Payment"] objectAtIndex:0] objectAtIndex:0]);
         paymentDetail=[[[_responseArray valueForKey:@"Payment"] objectAtIndex:0] objectAtIndex:0];
         
        lblDiscount.text =  [[[[_responseArray valueForKey:@"Payment"] objectAtIndex:0] objectAtIndex:0] valueForKey:@"Discount"];
         
         
         id displayNameTypeValue = [[[[_responseArray valueForKey:@"Payment"] objectAtIndex:0] objectAtIndex:0] valueForKey:@"DiscountCode"] ;
         NSString *displayNameType = @"";
         if (displayNameTypeValue != [NSNull null])
         {
             displayNameType = (NSString *)displayNameTypeValue;
         }
         
     //    lblDiscountCode.text = displayNameType;
         
      //   lblShippingAndHandling.text = [[[[_responseArray valueForKey:@"Payment"] objectAtIndex:0] objectAtIndex:0] valueForKey:@"Shipping & Handling"];
         float gtotal=[[[[[_responseArray valueForKey:@"Payment"] objectAtIndex:0] objectAtIndex:0] valueForKey:@"Subtotal"]floatValue]+7.99;
         
         lblSubTotal.text =[NSString stringWithFormat:@"$%0.2f",gtotal];
         
     //    lblgrandTotal.text = [[[[_responseArray valueForKey:@"Payment"] objectAtIndex:0] objectAtIndex:0] valueForKey:@"Grand Total"];
         
//         lblPayMentMethod.text = [[[[_responseArray valueForKey:@"PaymentMethod"] objectAtIndex:0] objectAtIndex:0] valueForKey:@"method"];
//         lblShippingMethod.text = [[[[_responseArray valueForKey:@"ShippingMethod"] objectAtIndex:0] objectAtIndex:0] valueForKey:@"shipping_description"];
         
        [_tableViewItemOrder reloadData];
        [self.progressHud hide:YES];
     } failure:^(NSError *error)
     {
         //NSLog(@"Error =%@",[error description]);
     }];
}

#pragma mark UITableViewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 101;
    NSMutableDictionary *mDictItems = [itemArray objectAtIndex:indexPath.row];
    
    height = height + ([[[mDictItems objectForKey:@"products_options"] objectForKey:@"options"] count] * 21);
    
    return height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid =@"ItemOrder";
    DashboardCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        NSArray *nibArr=[[NSBundle mainBundle] loadNibNamed:@"DashboardCell" owner:self options:nil];
        cell= (DashboardCell *)[nibArr objectAtIndex:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSMutableDictionary *mDictItems = [itemArray objectAtIndex:indexPath.row];
    cell.lblProductName.text = [mDictItems valueForKey:@"prod_name"];
    cell.lblPrice.text = [NSString stringWithFormat:@"$%@",[mDictItems valueForKey:@"prod_price"]];
    cell.lblQuantity.text = [mDictItems valueForKey:@"prod_qty"];
    cell.lblSKU.text = [mDictItems valueForKey:@"prod_sku"];
    
    float yPosition = 87;
    
    for(int i = 0; i < [[[mDictItems objectForKey:@"products_options"] objectForKey:@"options"] count];i++)
    {
        NSMutableDictionary *mDict = [[[mDictItems objectForKey:@"products_options"] objectForKey:@"options"] objectAtIndex:i];
       
        UILabel *lblOption = [[UILabel alloc]initWithFrame:CGRectMake(20, yPosition, 120, 20)];
        lblOption.text = [mDict valueForKey:@"label"];
        [lblOption setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [cell.contentView addSubview:lblOption];
        
        UILabel *lblOptionValue = [[UILabel alloc]initWithFrame:CGRectMake(166, yPosition, 120, 20)];
        lblOptionValue.text = [mDict valueForKey:@"value"];
        [lblOptionValue setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [cell.contentView addSubview:lblOptionValue];
        
        UIImageView *imgSeperator = [[UIImageView alloc]initWithFrame:CGRectMake(20, yPosition + 20, 284, 1)];
        [imgSeperator setImage:[UIImage imageNamed:@"bdr_itemblue.png"]];
        [cell.contentView addSubview:imgSeperator];
        yPosition = yPosition + 21;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Segment Control Method
- (IBAction)segmentAction:(id)sender
{
    // valuechanged connected function
    UISegmentedControl *segControll = (UISegmentedControl *)sender;
    if(segControll.selectedSegmentIndex == 0)
    {
        //Shipping Address
        _viewBilling.hidden = NO;
        _viewPayment.hidden = YES;
        
        CGRect theFrame = [_tableViewItemOrder frame];
        theFrame.origin.y = 256;
        theFrame.size.height = 127;
        if(IS_IPHONE5)
        {
            theFrame.size.height = 215;
        }

     //   _tableViewItemOrder.frame = theFrame;
        
        CGRect imgBGFrame = [imgTblBackground frame];
        imgBGFrame.origin.y = 256;
        imgBGFrame.size.height = 127;
        if(IS_IPHONE5)
        {
            imgBGFrame.size.height = 215;
        }
        
        imgTblBackground.frame = imgBGFrame ;

        CGRect lblFrame = [lblItemOrder frame];
        lblFrame.origin.y = 228;
        lblItemOrder.frame = lblFrame;
        
        CGRect imgFrame = [imgItemOrder frame];
        imgFrame.origin.y = 225;
        imgItemOrder.frame = imgFrame;
                                                                                                                                                 //shipping address
        NSArray *shiparray=[[[[[_responseArray valueForKeyPath:@"Address"] valueForKey:@"shipping address"] objectAtIndex:0] objectAtIndex:0] objectAtIndex:0];
        
        sh_namelbl.text=[NSString stringWithFormat:@"%@ %@",[shiparray valueForKey:@"firstname"],[shiparray valueForKey:@"lastname"]];
        sh_addLbl.text=[NSString stringWithFormat:@"%@",[shiparray valueForKey:@"street"]];
        sh_cityLbl.text=[NSString stringWithFormat:@"%@,%@,%@",[shiparray valueForKey:@"city"],[shiparray valueForKey:@"region"],[shiparray valueForKey:@"postcode"]];
        sh_countryLbl.text=[NSString stringWithFormat:@"%@",[shiparray valueForKey:@"country"]];
        sh_telLbl.text=@"";
    }
    else if (segControll.selectedSegmentIndex == 1)
    {
        //Billing Address
        _viewBilling.hidden = NO;
        _viewPayment.hidden = YES;
        
        CGRect theFrame = [_tableViewItemOrder frame];
        theFrame.origin.y = 256;
        
        theFrame.size.height = 127;
        if(IS_IPHONE5)
        {
            theFrame.size.height = 215;
        }
        
       // _tableViewItemOrder.frame = theFrame;
        
        CGRect imgBGFrame = [imgTblBackground frame];
        imgBGFrame.origin.y = 256;

        imgBGFrame.size.height = 127;
        if(IS_IPHONE5)
        {
            imgBGFrame.size.height = 215;
        }
        
        
        imgTblBackground.frame = imgBGFrame ;
        
        CGRect lblFrame = [lblItemOrder frame];
        lblFrame.origin.y = 228;
        lblItemOrder.frame = lblFrame;
        
        CGRect imgFrame = [imgItemOrder frame];
        imgFrame.origin.y = 225;
        imgItemOrder.frame = imgFrame;
        
        NSArray *billArray=[[[[[_responseArray valueForKeyPath:@"Address"] valueForKey:@"billing address"] objectAtIndex:0] objectAtIndex:0] objectAtIndex:0];
        sh_namelbl.text=[NSString stringWithFormat:@"%@ %@",[billArray valueForKey:@"firstname"],[billArray valueForKey:@"lastname"]];
        sh_addLbl.text=[NSString stringWithFormat:@"%@",[billArray valueForKey:@"street"]];
        sh_cityLbl.text=[NSString stringWithFormat:@"%@,%@,%@",[billArray valueForKey:@"city"],[billArray valueForKey:@"region"],[billArray valueForKey:@"postcode"]];
        sh_countryLbl.text=[NSString stringWithFormat:@"%@",[billArray valueForKey:@"country"]];
        sh_telLbl.text=@"";
    }
    else if (segControll.selectedSegmentIndex == 2)
    {
        @try {
            lblPayMentType1.text=[[[[_responseArray valueForKeyPath:@"PaymentMethod"] valueForKey:@"method"] objectAtIndex:0] objectAtIndex:0];
        }
        @catch (NSException *exception) {
            lblPayMentType1.text=@"Cash";
        }
        
        _viewBilling.hidden = YES;
        _viewPayment.hidden = NO;
        
        CGRect tblFrame = [_tableViewItemOrder frame];
        tblFrame.origin.y = 202;
        
        tblFrame.size.height = 181;
        if(IS_IPHONE5)
        {
            tblFrame.size.height = 269;
        }
        
        /*
        CGRect imgBGFrame = [imgTblBackground frame];
        imgBGFrame.origin.y = 202;

        imgBGFrame.size.height = 202;
        if(IS_IPHONE5)
        {
            imgBGFrame.size.height = 269;
        }
        imgTblBackground.frame = imgBGFrame;
*/
        CGRect imgBGFrame = [imgTblBackground frame];
        imgBGFrame.origin.y = 256;
        
        imgBGFrame.size.height = 127;
        if(IS_IPHONE5)
        {
            imgBGFrame.size.height = 215;
        }
        
        
        imgTblBackground.frame = imgBGFrame ;
        //_tableViewItemOrder.frame = tblFrame;
        
//        CGRect lblFrame = [lblItemOrder frame];
//        lblFrame.origin.y = 170;
//        lblItemOrder.frame = lblFrame;
        
        CGRect lblFrame = [lblItemOrder frame];
        lblFrame.origin.y = 228;
        lblItemOrder.frame = lblFrame;
        
        CGRect imgFrame = [imgItemOrder frame];
        imgFrame.origin.y = 225;
        imgItemOrder.frame = imgFrame;
        
        lblPayMentType1.hidden=NO;
        lblPayMentType2.hidden=YES;
        lblPayMentType3.hidden=YES;
        lblPayMentType4.hidden=YES;

        
    }
}


@end
