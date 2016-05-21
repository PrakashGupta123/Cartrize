//
//  CurrencyViewController.m
//  IShop
//
//  Created by Avnish Sharma on 6/18/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "CurrencyViewController.h"

@interface CurrencyViewController ()

@end

@implementation CurrencyViewController
@synthesize tblView,arrCurrencyAndSize;

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
    
    NSURL *url = [NSURL URLWithString:currency_code];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data,NSError *connectionError){
                               
                               if (data==nil) {
                                   
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                   [alert show];
                                   return ;
                                   
                               }
                                   self.arrCurrencyAndSize = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   //NSLog(@"Responce-- %@",self.arrCurrencyAndSize);
                           }];
}
     

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-Action method

- (IBAction) btnBackAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrCurrencyAndSize count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //NSMutableDictionary *dictCartProduct = [self.arrCurrencyAndSize objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegates

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    height = 40;
    return  height;
}




@end
