//
//  RefineViewController.m
//  IShop
//
//  Created by Hashim on 5/2/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "RefineViewController.h"
#import "MBProgressHUD.h"
#import "CartrizeWebservices.h"
#import "JSON.h"
#import "ListGridViewController.h"
#import "Reachability.h"

@interface RefineViewController ()
{
    BOOL ChangeCenter;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonDone;
- (IBAction)clearAction1:(id)sender;
- (IBAction)doneAction1:(id)sender;


@end

@implementation RefineViewController

@synthesize tblViewCategory,mArrayCategoryList,arForIPs,arForIPs1,arForIPs2,arForIPs3,mArrayContain,delegate,window,progressHud;

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

    arrRefine=[[NSMutableArray alloc] init];
  //  [_buttonCancel setTitle:@"Clear" forState:UIControlStateNormal];
   // [_buttonDone setTitle:@"Apply" forState:UIControlStateNormal];
  //  _buttonCancel.backgroundColor=button_bg_color
  //  _buttonDone.backgroundColor=button_bg_color
    viewSliderPrice.hidden=YES;
    
    
    iCount = 0;
    viewSliderPrice.hidden = YES;
    
    mArrayCategoryList = [[NSMutableArray alloc] initWithObjects:@"Gender >", @"Size >", @"Current Price >", @"Color >", nil];
    
    self.arForIPs = [[NSMutableArray alloc] init];
    self.arForIPs1 = [[NSMutableArray alloc] init];
    self.arForIPs2 = [[NSMutableArray alloc] init];
    self.arForIPs3 = [[NSMutableArray alloc] init];
    self.mArrayContain = [[NSMutableArray alloc] init];
    
    strGender = @"";
    strSize = @"";
    strColor = @"";
    strCurrentPrice = @"";
    
    taxArray=[[NSMutableArray alloc] initWithObjects:@"Taxable Goods",@"Shipping", nil];
    
    //toolbar for NumberPad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [numberToolbar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:CRtoolBarNavimage]] atIndex:0];
    UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad:)];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)];
    [cancelBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    numberToolbar.items = [NSArray arrayWithObjects:cancelBtn
                           ,
   [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],doneBtn
                           ,
                           nil];
    [numberToolbar sizeToFit];
    UIColor *color = [UIColor grayColor];
    nametf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color}];
    descTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Description" attributes:@{NSForegroundColorAttributeName: color}];
    shortdescTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Short Description" attributes:@{NSForegroundColorAttributeName: color}];
    skuTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"SKU" attributes:@{NSForegroundColorAttributeName: color}];
    minPriceTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Price(USD)(MIN)" attributes:@{NSForegroundColorAttributeName: color}];
    maxPricetf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"(MAX)" attributes:@{NSForegroundColorAttributeName: color}];

    minPriceTf.inputAccessoryView = numberToolbar;
    maxPricetf.inputAccessoryView = numberToolbar;
    minSel=NO;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    nametf.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
    descTf.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"Desc"];
    shortdescTf.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"ShortDesc"];
    skuTf.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"Sku"];
    minPriceTf.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"MinPrice"];
    maxPricetf.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"MaxPrice"];

}
-(IBAction)cancelNumberPad:(id)sender{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:CGRectMake(0 , 0, 320 , [UIScreen mainScreen].bounds.size.height)];
    [UIView commitAnimations];
    if (minSel) {
        [minPriceTf resignFirstResponder];
        minPriceTf.text = @"";
    }else {
        [maxPricetf resignFirstResponder];
        maxPricetf.text = @"";
    }
}

-(IBAction)doneWithNumberPad:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:CGRectMake(0 , 0, 320 , [UIScreen mainScreen].bounds.size.height)];
    [UIView commitAnimations];
    if (minSel) {
        [minPriceTf resignFirstResponder];
    }else{
        [maxPricetf resignFirstResponder];
    }
}

#pragma mark - UIPickrViewDatasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return taxArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [taxArray objectAtIndex:row];
}
#pragma mark - UIPickrViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedTax=[taxArray objectAtIndex:row];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    if ([UIScreen mainScreen].bounds.size.height==568) {
//        if (textField==skuTf) {
//            [self.view setFrame:CGRectMake(0,-50,320,568)];
//        }else if (textField==minPriceTf || textField==maxPricetf){
//            [self.view setFrame:CGRectMake(0,-160,320,568)];
//        }
//
//    }else
//    {
//    if (textField==skuTf) {
//        [self.view setFrame:CGRectMake(0,-100,320,480)];
//    }else if (textField==minPriceTf || textField==maxPricetf){
//        [self.view setFrame:CGRectMake(0,-180,320,480)];
//
//    }
//    }
    
    if (textField==minPriceTf) {
        minSel=YES;
    }else{
        minSel=NO;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if ([UIScreen mainScreen].bounds.size.height==568) {
//        [self.view setFrame:CGRectMake(0,0,320,568)];
//
//    }else
//    [self.view setFrame:CGRectMake(0,0,320,480)];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSInteger nextTag = textField.tag +1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.25];
    
    if (nextResponder) {
        if(nextTag==3){
            [shortdescTf becomeFirstResponder];
        }
        [nextResponder becomeFirstResponder];
    } else {
        if(IS_IPHONE_4){
        
        }
        
        [textField resignFirstResponder];
    }
    [UIView commitAnimations];
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
     if(IS_IPHONE_4){
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:CGRectMake(0 , 0, 320 , [UIScreen mainScreen].bounds.size.height)];
    [UIView commitAnimations];
    [textField resignFirstResponder];
       if(textField ==minPriceTf || textField == maxPricetf)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
            [self.view setFrame:CGRectMake(0 , -50, 320 , [UIScreen mainScreen].bounds.size.height)];
        [UIView commitAnimations];
    }
    
     }
    return YES;
}


- (void)actionStatuChange:(NSNumber*)number
{
    NSIndexPath *path = [NSIndexPath indexPathForItem:[number intValue] inSection:0];
    UITableViewCell *cell = (UITableViewCell *)[self.tblViewCategory cellForRowAtIndexPath:path];
    
    if ([strRefineBy isEqualToString:@"Gender"])
    {
        if([arForIPs containsObject:path])
        {
            //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [cell.imageView setImage:[UIImage imageNamed:@"checked_cb.png"]];
        }
        else
        {
            //[cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.imageView setImage:[UIImage imageNamed:@"cb.png"]];
        }
    }
    else if ([strRefineBy isEqualToString:@"Size"])
    {
        if([arForIPs1 containsObject:path])
        {
            //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [cell.imageView setImage:[UIImage imageNamed:@"checked_cb.png"]];
        }
        else
        {
            //[cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.imageView setImage:[UIImage imageNamed:@"cb.png"]];
            
        }
    }
    else if ([strRefineBy isEqualToString:@"Color"])
    {
        if([arForIPs2 containsObject:path])
        {
            //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [cell.imageView setImage:[UIImage imageNamed:@"checked_cb.png"]];
        }
        else
        {
            //[cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.imageView setImage:[UIImage imageNamed:@"cb.png"]];
            
        }
    }
    else if ([strRefineBy isEqualToString:@"Price"])
    {
        if([arForIPs3 containsObject:path])
        {
            //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [cell.imageView setImage:[UIImage imageNamed:@"checked_cb.png"]];
        }
        else
        {
            //[cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.imageView setImage:[UIImage imageNamed:@"cb.png"]];
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [nsDataResult setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [nsDataResult appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"ERROR with theConenction");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   
    //NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[nsDataResult length]);
    self.mArrayCategoryList = [NSJSONSerialization JSONObjectWithData:nsDataResult options:NSJSONReadingMutableContainers error:nil];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //NSLog(@"Array -- %@",self.mArrayCategoryList);
    if (iCount == 2)
    {
        [AppDelegate appDelegate].isCheck = YES;
        [AppDelegate appDelegate].dataArray = self.mArrayCategoryList;
        //[self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        if (![strRefineBy isEqualToString:@"Current Price"])
        {
            [self.tblViewCategory reloadData];
        }
        else
        {
            NSMutableDictionary *dictprice = [self.mArrayCategoryList objectAtIndex:0];
            
            if ([strCurrentPrice isEqualToString:@""])
            {
                strMaxPrice = [dictprice objectForKey:@"Max"];
                strMinPrice = [dictprice objectForKey:@"Min"];
            }
            hold_max = [dictprice objectForKey:@"Max"];
            hold_min = [dictprice objectForKey:@"Min"];
           [self priceView];
        }
    }
}

#pragma mark - Action method

- (IBAction) backButtonPress:(id)sender
{
    if ([delegate respondsToSelector:@selector(setRefinedArray:)]) {
        [delegate setRefinedArray:arrRefine];
    }
    if ([delegate respondsToSelector:@selector(setIsRefined:)]) {
        [delegate setIsRefined:status];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
   // [self.navigationController popViewControllerAnimated:YES];
    /*
    if (viewSliderPrice.hidden==NO)
    {
        viewSliderPrice.hidden=YES;
        
        [self ReloadThisPage];
    }
    else
    {
        if (iCount == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (iCount == 1)
        {
            [self ReloadThisPage];
        }
        else if (iCount == 2)
        {
        }
    }
     */
}
-(void)ReloadThisPage
{
   // [_buttonCancel setTitle:@"Clear" forState:UIControlStateNormal];
   // [_buttonDone setTitle:@"Apply" forState:UIControlStateNormal];
    
    iCount = 0;
    mArrayCategoryList = [[NSMutableArray alloc] initWithObjects:@"Gender >", @"Size >", @"Current Price >", @"Color >", nil];
    
    [self.tblViewCategory reloadData];
}
- (NSString *) selectedItems
{
    NSString *strRespose = @"";
    [self.mArrayContain removeAllObjects];
    
    for (int i = 0; i < [self.mArrayCategoryList count]; i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
        UITableViewCell *cell = (UITableViewCell *)[self.tblViewCategory cellForRowAtIndexPath:path];
        
        if (cell.imageView.image == [UIImage imageNamed:@"checked_cb.png"] )
        {
            NSString *strResult = [[mArrayCategoryList objectAtIndex:i] objectAtIndex:0];
            
            if(![self.mArrayContain containsObject:strResult])
                [self.mArrayContain addObject:strResult];
        }
    }
    strRespose = [self.mArrayContain componentsJoinedByString:@","];
    
    return strRespose;
}
- (void) priceView
{
    
    lblRightSlider.text = strMaxPrice;
    lblLeftSlider.text = strMinPrice;
    self.labelSlider.minimumValue = [hold_min floatValue];
    self.labelSlider.maximumValue = [hold_max floatValue];
    
    self.labelSlider.lowerValue = [strMinPrice floatValue];
    self.labelSlider.upperValue = [strMaxPrice floatValue];
    
    self.labelSlider.minimumRange = 10;
   
        viewSliderPrice.hidden = NO;
    [self updateSliderLabels];
    
}

- (void)rangeSliderValueChanged:(id)sender
{
   [self updateSliderLabels];
}

- (void)updateSliderLabels
{
    
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
     CGPoint upperCenter;
    if (ChangeCenter==YES)
    {
        lowerCenter.x=31.5;
        lowerCenter.y=32.0;
        
        upperCenter.x=288.5;
        upperCenter.y=32.0;
        
        ChangeCenter=NO;
    }
    else
    {
        lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
        lowerCenter.y = (self.labelSlider.center.y - 30.0f);
        
        upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x);
        upperCenter.y = (self.labelSlider.center.y - 30.0f);
    }
   
    lblLeftSlider.center = lowerCenter;
    lblLeftSlider.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.lowerValue];
    
    lblRightSlider.center = upperCenter;
    lblRightSlider.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.upperValue];
    
    strMinPrice = lblLeftSlider.text;
    strMaxPrice = lblRightSlider.text;
 }
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateSliderLabels];
}

- (IBAction)clearAction1:(id)sender
{
    
    [[AppDelegate appDelegate].arrBackUp removeAllObjects];
    isREFINED = NO;
    
    [self.progressHud show:YES];
    nametf.text=@"";
    descTf.text=@"";
    shortdescTf.text=@"";
    skuTf.text=@"";
    minPriceTf.text=@"";
    maxPricetf.text=@"";
    status=NO;
    
    NSDictionary *parameters = @{@"name":nametf.text,@"short_description":shortdescTf.text
                                 ,@"long_description":descTf.text,@"sku":skuTf.text,@"min":minPriceTf.text,@"max":maxPricetf.text};
    
    [CartrizeWebservices PostMethodWithApiMethod:@"getSearchByName" Withparms:parameters WithSuccess:^(id response)
     {
         //NSLog(@"Response = %@",[response JSONValue]);
         [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"Refined"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         status=NO;
         [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Name"];
         [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Desc"];
         [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ShortDesc"];
         [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Sku"];
         [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MinPrice"];
         [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MaxPrice"];
         [[NSUserDefaults standardUserDefaults] synchronize];

         //         ListGridViewController *list=[[ListGridViewController alloc] initWithNibName:@"ListGridViewController" bundle:nil];
         //         list.isRefined=YES;
         //         list.refinedArray=[response JSONValue];
         //         [self.navigationController pushViewController:list animated:YES];
         arrRefine=[response JSONValue];
         [self.progressHud hide:YES];
     } failure:^(NSError *error)
     {
         [self.progressHud hide:YES];
         //NSLog(@"Error =%@",[error description]);
     }];

    /*
    if (iCount == 0)
    {
        self.arForIPs = [[NSMutableArray alloc] init];
        self.arForIPs1 = [[NSMutableArray alloc] init];
        self.arForIPs2 = [[NSMutableArray alloc] init];
        self.arForIPs3 = [[NSMutableArray alloc] init];
        
        strGender = @"";
        strSize = @"";
        strColor = @"";
        strCurrentPrice = @"";
        [self.tblViewCategory reloadData];
    }
    else
    {
        
        if ([strRefineBy isEqualToString:@"Gender"])
        {
            strGender = @"";
            arForIPs =[[NSMutableArray alloc]init];
            [self.tblViewCategory reloadData];
        }
        else if ([strRefineBy isEqualToString:@"Size"])
        {
            strSize = @"";
            self.arForIPs1 = [[NSMutableArray alloc] init];
            [self.tblViewCategory reloadData];
        }
        else if ([strRefineBy isEqualToString:@"Color"])
        {
            strColor = @"";
            self.arForIPs2 = [[NSMutableArray alloc] init];
            [self.tblViewCategory reloadData];
        }
        else if ([strRefineBy isEqualToString:@"Current Price"])
        {
            strMinPrice=hold_min;
            strMaxPrice=hold_max;
            strCurrentPrice=@"";
            
            ChangeCenter=YES;
            self.labelSlider.lowerValue=[strMinPrice floatValue];
            self.labelSlider.upperValue =[strMaxPrice floatValue];
            [self updateSliderLabels];
        }
    }
     */
}

- (IBAction)doneAction1:(id)sender
{
    
    if([[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaWiFiNetwork && [[Reachability sharedReachability] internetConnectionStatus] !=ReachableViaCarrierDataNetwork) {
        //        [self performSelector:@selector(killHUD)];
        UIAlertView*  alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
    }

    [nametf resignFirstResponder];
    [descTf resignFirstResponder]; 
    [shortdescTf resignFirstResponder];
     [skuTf resignFirstResponder];
    [minPriceTf resignFirstResponder];
    [maxPricetf resignFirstResponder];
    
   
    NSDictionary *parameters=[NSDictionary new];
//1_If
    
    BOOL isNoTextHere=YES;
    BOOL isminimamPrice=NO;
    
    if([nametf.text length]!=0)
    {
        isNoTextHere=NO;
    }else if([descTf.text length]!=0){
        isNoTextHere=NO;
    }else if([shortdescTf.text length]!=0){
       isNoTextHere=NO;
    }else if([skuTf.text length]!=0){
       isNoTextHere=NO;
    }else if([minPriceTf.text length]!=0){
        isminimamPrice=YES;
    }
        
    if([maxPricetf.text length]!=0){
        //minPriceTf.text=@"0";
        isNoTextHere=NO;
        isminimamPrice=YES;
     
    }
    
    
    
    
    if(isminimamPrice) {
        if([maxPricetf.text length]==0){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the maximum price." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self.progressHud hide:YES];
            return;
        }
        else if([minPriceTf.text length]==0){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the minimum price." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self.progressHud hide:YES];
            return;
        }
        else if([minPriceTf.text intValue]>=[maxPricetf.text intValue]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Maximum price must be greater than minimum price." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self.progressHud hide:YES];
            return;
        }
        
    }
   
    
    if(isNoTextHere){
        
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter atleast one field!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self.progressHud hide:YES];
        }else{
            
            if([skuTf.text length]!=0)
            {
                parameters = @{@"name":@"",@"short_description":@""
                               ,@"long_description":@"",@"sku":skuTf.text,@"min":@"",@"max":@""};
                callAPI=@"1";
                
            
            }
            else if ([minPriceTf.text isEqualToString:@""])
            {
                parameters = @{@"name":nametf.text,@"short_description":shortdescTf.text
                               ,@"long_description":descTf.text,@"sku":skuTf.text,@"min":@"0",@"max":maxPricetf.text};
                callAPI=@"1";
            }
            else if ([maxPricetf.text isEqualToString:@""])
            {
                parameters = @{@"name":nametf.text,@"short_description":shortdescTf.text
                               ,@"long_description":descTf.text,@"sku":skuTf.text,@"min":minPriceTf.text,@"max":@"0"};
                callAPI=@"1";
            }
            //1.1 else
           else if (minPriceTf.text.length>0 && maxPricetf.text.length>0 && nametf.text.length==0)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the name of the product for the given range." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                callAPI=@"0";
                [self.progressHud hide:YES];
            
            }

            else
            {
                parameters = @{@"name":nametf.text,@"short_description":shortdescTf.text
                               ,@"long_description":descTf.text,@"sku":skuTf.text,@"min":minPriceTf.text,@"max":maxPricetf.text};
                callAPI=@"1";
            }
            
        
            isREFINED = YES;
            
            if([callAPI isEqualToString:@"1"])
            {
                 [self.progressHud show:YES];

            [CartrizeWebservices PostMethodWithApiMethod:@"getSearchByName" Withparms:parameters WithSuccess:^(id response)
             {
                 [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"Refined"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 status=YES;
                 
                 arrRefine=[response JSONValue];
                 [AppDelegate appDelegate].arrBackUp = [NSMutableArray arrayWithArray:arrRefine];
                 
                 [[NSUserDefaults standardUserDefaults] setObject:nametf.text forKey:@"Name"];
                 [[NSUserDefaults standardUserDefaults] setObject:descTf.text forKey:@"Desc"];
                 [[NSUserDefaults standardUserDefaults] setObject:shortdescTf.text forKey:@"ShortDesc"];
                 [[NSUserDefaults standardUserDefaults] setObject:skuTf.text forKey:@"Sku"];
                 [[NSUserDefaults standardUserDefaults] setObject:minPriceTf.text forKey:@"MinPrice"];
                 [[NSUserDefaults standardUserDefaults] setObject:maxPricetf.text forKey:@"MaxPrice"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 
                 
                 if (arrRefine.count==0)
                 {
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"No product found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     
                      [self.progressHud hide:YES];
                     
                     return ;
                 }
                 [self.progressHud hide:YES];
                 if ([delegate respondsToSelector:@selector(setRefinedArray:)]) {
                     [delegate setRefinedArray:arrRefine];
                 }
                 if ([delegate respondsToSelector:@selector(setIsRefined:)]) {
                     [delegate setIsRefined:status];
                 }
                 //[self.navigationController popViewControllerAnimated:YES];
                 [self dismissViewControllerAnimated:YES completion:nil];
                  [self.progressHud hide:YES];
             } failure:^(NSError *error)
             {
                 [self.progressHud hide:YES];
                 //NSLog(@"Error =%@",[error description]);
             }];
            }
        }
}
    

@end
