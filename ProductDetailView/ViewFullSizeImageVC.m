//
//  ViewFullSizeImageVC.m
//  IShop
//
//  Created by Vivek  on 30/05/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "ViewFullSizeImageVC.h"
#import "UIImageView+WebCache.h"

@interface ViewFullSizeImageVC ()
{
    IBOutlet UIImageView *imgViewProducts;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollImageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

- (IBAction)pageControlAction:(id)sender;
- (IBAction)backAction:(id)sender;

@end

@implementation ViewFullSizeImageVC
@synthesize image_tag;

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
    
    self.scrollImageView.contentSize = CGSizeMake(320 * [_imageArray count], self.scrollImageView.frame.size.height);
    self.scrollImageView.contentOffset = CGPointMake (self.scrollImageView.bounds.origin.x, self.scrollImageView.bounds.origin.y);
   // _pageController.numberOfPages =_imageArray.count;
   // _pageController.currentPage = self.image_tag;

    // //NSLog(@"Image Tag = %d",self.image_tag);
    
//    for (int i = 0; i < [_imageArray count]; i++)
//    {
        imgViewProducts = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320,350)];
        imgViewProducts.backgroundColor = [UIColor clearColor];
        imgViewProducts.contentMode = UIViewContentModeScaleAspectFit;
        
       // NSString *strURL = [[_imageArray objectAtIndex:i] objectForKey:@"prd_img"];
        // Here we use the new provided setImageWithURL: method to load the web image
        [imgViewProducts setImageWithURL:[NSURL URLWithString:[_imageDict objectForKey:@"prd_thumb"]] placeholderImage:[UIImage imageNamed:CRplacehoderimage]];
        [self.scrollImageView addSubview:imgViewProducts];
    //}
    
    
   // CGFloat x = image_tag * 320;
    //[self.scrollImageView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pageControlAction:(id)sender
{
    CGFloat x = _pageController.currentPage * self.scrollImageView.frame.size.width;
    [self.scrollImageView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollImageView.frame.size.width;
    int pageNo = floor((self.scrollImageView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageController.currentPage=pageNo;
    
}// scrollViewDidScroll
@end
