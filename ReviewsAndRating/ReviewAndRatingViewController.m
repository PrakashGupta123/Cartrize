//
//  ReviewAndRatingViewController.m
//  IShop
//
//  Created by Avnish Sharma on 7/21/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "ReviewAndRatingViewController.h"
#import "StarRatingView.h"
#import "CartrizeWebservices.h"
#import "MBProgressHUD.h"
#import "CustomCell.h"
#import "JSON.h"

@interface ReviewAndRatingViewController ()
{
    StarRatingView *priceRatingView,*valueRatingView,*qualityRatingView;
    int priceRating,valueRating,qualityRating;
}
@end

@implementation ReviewAndRatingViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    _viewWriteReview.hidden = YES;
    _viewCustomerReview.hidden = NO;
    
    [self getReviewsAndRating];
    
    [self showRatingViews];
}

-(void)getReviewsAndRating
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    NSDictionary *parameters = @{@"product_id":_strProductID};
    [CartrizeWebservices PostMethodWithApiMethod:@"GetReviewsAndRating" Withparms:parameters WithSuccess:^(id response)
     {
         //NSLog(@"Rating Response =%@",[response JSONValue]);
         mArrayResponse = [response JSONValue];
         [_tableViewCustomerReviews reloadData];
         
         if([mArrayResponse count] == 0)
         {
             [[[UIAlertView alloc]initWithTitle:@"Message" message:@"No Reviews found!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
         }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     } failure:^(NSError *error)
     {
         //NSLog(@"Error = %@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

-(void)getAllRatingOptionForForm
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    [CartrizeWebservices GetMethodWithApiMethod:@"GetAllRatingOptionForForm" WithSuccess:^(id response)
     {
         _mArrayRating = [response JSONValue];
         //[self showRatingViews:_mArrayRating];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     } failure:^(NSError *error)
     {
         //NSLog(@"Error = %@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
}

-(void)showRatingViews
{
    float yPosPrice = 14,yPosValue = 43,yPosQuantity = 73;
    
    if(IS_IPHONE5)
    {
        yPosPrice = 23,yPosValue = 63,yPosQuantity = 103;
    }
    
    //Show  Price Rating view
    float rating = 0;
    priceRatingView = [[StarRatingView alloc]initWithFrame:CGRectMake(158, yPosPrice, 103, 18) andRating:rating withLabel:NO animated:YES withSetRating:YES];
    // userRatingView.delegate = self;
    priceRatingView.userInteractionEnabled = YES;
    priceRating = priceRatingView.userRating;
    // //NSLog(@"User Rating = %d",userRatingView.userRating);
    [_viewWriteReview addSubview:priceRatingView];
    
    //Show Value Rating view
    valueRatingView = [[StarRatingView alloc]initWithFrame:CGRectMake(158, yPosValue, 103, 18) andRating:rating withLabel:NO animated:YES withSetRating:YES];
    // userRatingView.delegate = self;
    valueRatingView.userInteractionEnabled = YES;
    valueRating = valueRatingView.userRating;
    // //NSLog(@"User Rating = %d",userRatingView.userRating);
    [_viewWriteReview addSubview:valueRatingView];
    
    //Show Quality Rating view
    qualityRatingView = [[StarRatingView alloc]initWithFrame:CGRectMake(158, yPosQuantity, 103, 18) andRating:rating withLabel:NO animated:YES withSetRating:YES];
    // userRatingView.delegate = self;
    qualityRatingView.userInteractionEnabled = YES;
    qualityRating = qualityRatingView.userRating;
    // //NSLog(@"User Rating = %d",userRatingView.userRating);
    [_viewWriteReview addSubview:qualityRatingView];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == _txtSummaryReview)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        self.view.frame = CGRectMake(0, -70, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    return TRUE;
}

//return Keyboard
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqual:@"\n"])
    {
        [textView resignFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView==_txtViewReview)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        self.view.frame = CGRectMake(0, -180, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    return TRUE;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == _txtSummaryReview)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    return YES;
}

#pragma mark -- BACK
-(IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/*
 chal rha hai
 isme Quality me 12345 tk values submit hoti hai
 value me 6,7,8,9,10 submit hoti hai
 and price me 11,12,13,14,15 submit hoti hai
 chal rha hai ky
 */


#pragma mark -- SUBMIT REVIEWS
-(IBAction)actionSubmitReview:(id)sender
{
    qualityRating = qualityRatingView.userRating;
    priceRating = priceRatingView.userRating;
    valueRating = valueRatingView.userRating;
    
    // //NSLog(@"qualityRating =%d\n priceRating = %d \n valueRating =%d",qualityRating,priceRating,valueRating);
    /*
     Quality -> 1 = 20, 2 = 40 ,3 = 60, 4 = 80, 5 = 100;
     
     value -> 6 = 20 ,7 = 40 ,8= 60,9= 80,10= 100,
     
     price -> 11 = 20, 12 = 40 ,13 = 60, 14 = 80, 15 = 100;
     
     */
    qualityRating = qualityRating / 20;
    priceRating = (priceRating / 20) + 10;
    valueRating = (valueRating / 20) + 5;
    
    NSDictionary *parameters = @{@"product_id":_strProductID,@"title":_txtSummaryReview.text,@"detail":_txtViewReview.text,@"nicname":_txtNickName.text,@"quality":[NSString stringWithFormat:@"%d",qualityRating],@"value":[NSString stringWithFormat:@"%d",valueRating],@"price":[NSString stringWithFormat:@"%d",priceRating]};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    [CartrizeWebservices PostMethodWithApiMethod:@"AddReviewsAndRating" Withparms:parameters WithSuccess:^(id response)
     {
         //NSLog(@"Rating Response =%@",response);
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Reviews and Rating submitted successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         alert.tag = 1111;
         [alert show];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     } failure:^(NSError *error)
     {
         //NSLog(@"Error = %@",[error description]);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *mDict = [mArrayResponse objectAtIndex:indexPath.row] ;
    CustomCell *cell = (CustomCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil]objectAtIndex:3];
    
    id displayNameTypeValue = [mDict valueForKey:@"detail"];
    NSString *displayNameType = @"";
    if (displayNameTypeValue != [NSNull null])
    {
        displayNameType = [mDict valueForKey:@"detail"];
    }
    
    NSString *strComment = [@"" stringByAppendingString:displayNameType];
    cell.lblDetail.text = strComment;
    
    CGRect labelFrame = cell.lblDetail.frame;
    
    CGRect expectedFrame = [cell.lblDetail.text boundingRectWithSize:CGSizeMake(cell.lblDetail.frame.size.width, 9999) options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:[NSDictionary dictionaryWithObjectsAndKeys: cell.lblDetail.font, NSFontAttributeName,nil] context:nil];
    
    labelFrame.size = expectedFrame.size;
    labelFrame.size.height = ceil(labelFrame.size.height);
    cell.lblDetail.frame = labelFrame;
    NSMutableArray *optionArray = [mDict objectForKey:@"rating"];
    CGFloat ypos = 28;
    for (int i=0; i<optionArray.count; i++)
    {
        ypos = ypos + 16;
    }
    return   ypos + cell.lblDetail.frame.size.height + 54;
    
    // return cell.lblDetail.frame.size.height + 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mArrayResponse count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Customerrating";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil )
    {
        NSArray *nibCell = [[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nibCell objectAtIndex:3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSMutableDictionary *mDict = [mArrayResponse objectAtIndex:indexPath.row];
    
    cell.lblNickName.text = [mDict valueForKey:@"nicname"];
    cell.lblTitle.text = [mDict valueForKey:@"title"];
    
    id displayNameTypeValue = [mDict valueForKey:@"detail"];
    NSString *displayNameType = @"";
    if (displayNameTypeValue != [NSNull null])
    {
        displayNameType = [mDict valueForKey:@"detail"];
    }
    cell.lblDetail.text = displayNameType;
    
    NSMutableArray *optionArray = [mDict valueForKey:@"rating"];
    
    float yPosition =55;
    
    for (int i = 0; i < [optionArray count]; i++)
    {
        UILabel *lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(20, yPosition, 96, 20)];
        lblMessage.text = [[optionArray objectAtIndex:i]valueForKey:@"rating_title"];
        yPosition = yPosition + 20;
        [lblMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        [cell addSubview:lblMessage];
        
        NSString *starRating = [[optionArray objectAtIndex:i]valueForKey:@"percent"];
        float rating = [starRating floatValue];
        StarRatingView* priceStarview = [[StarRatingView alloc]initWithFrame:CGRectMake(180, yPosition, 100, 15) andRating:rating withLabel:NO animated:YES withIndexPath:indexPath.row];
        // starview.delegate = self;
        priceStarview.userInteractionEnabled = NO;
        [cell addSubview:priceStarview];
    }
    
    return cell;
}

#pragma mark - Segment Control Method
- (IBAction)segmentAction:(id)sender
{
    // valuechanged connected function
    UISegmentedControl *segControll = (UISegmentedControl *)sender;
    if(segControll.selectedSegmentIndex == 0)
    {
        _viewWriteReview.hidden = YES;
        _viewCustomerReview.hidden = NO;
        [_tableViewCustomerReviews reloadData];
    }
    else
    {
        _viewWriteReview.hidden = NO;
        _viewCustomerReview.hidden = YES;
        //[self getAllRatingOptionForForm];
    }
}

#pragma mark --- ALERT DELEGATE
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1111)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
