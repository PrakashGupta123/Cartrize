//
//  ListGrid.m
//  IShop
//
//  Created by Hashim on 5/3/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "ListGrid.h"

@implementation ListGrid
@synthesize titlelalbe,img,priceLbl,btnFavourite;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ListGrid" owner:self options:nil];
        if ([arrayOfViews count] < 1)
        {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
