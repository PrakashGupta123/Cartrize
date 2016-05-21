
#import "ParentViewController.h"

static const NSInteger TagOffset = 1000;
@implementation ParentViewController
{
	UIView *tabButtonsContainerView;
	UIView *contentContainerView;
	UIImageView *indicatorImageView;
}
@synthesize tooglebutton,tooglebutton1;


- (void)viewDidLoad
{
	[super viewDidLoad];
  //  self.navigationController.navigationBarHidden=YES;
    [self.tooglebutton setBackgroundImage:[UIImage imageNamed:@"Men_Hover.png"] forState:UIControlStateNormal];
    [self.tooglebutton setBackgroundImage:[UIImage imageNamed:@"Men.png"] forState:UIControlStateSelected];
    [self.tooglebutton1 setBackgroundImage:[UIImage imageNamed:@"Women_Hover.png"] forState:UIControlStateNormal];
    [self.tooglebutton1 setBackgroundImage:[UIImage imageNamed:@"Women.png"] forState:UIControlStateSelected];
    [self.tooglebutton setSelected:YES];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	CGRect rect = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.tabBarHeight);
	rect.origin.y = self.tabBarHeight+12;
	rect.size.height = self.view.bounds.size.height - self.tabBarHeight;
	contentContainerView = [[UIView alloc] initWithFrame:rect];
	contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:contentContainerView];
	[self reloadTabButtons];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
}

-(IBAction)firstButtonPress:(id)sender
{
    [self.tooglebutton1 setSelected:NO];
    [self.tooglebutton setSelected:YES];
    [self tabButtonPressed:sender];

}
-(IBAction)secondButtonPress:(id)sender
{
    [self.tooglebutton setSelected:NO];
    [self.tooglebutton1 setSelected:YES];
    [self tabButtonPressed:sender];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];

	if ([self isViewLoaded] && self.view.window == nil){
		self.view = nil;
		tabButtonsContainerView = nil;
		contentContainerView = nil;
		indicatorImageView = nil;
	}
}

- (void)reloadTabButtons
{
	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
    //NSLog(@"this is selected index%lu",(unsigned long)self.selectedIndex);
    //NSLog(@"this is last index%lu",(unsigned long)lastIndex);

	self.selectedIndex = lastIndex;
    
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
	NSAssert([newViewControllers count] >= 2, @"MHTabBarController requires at least two view controllers");

	UIViewController *oldSelectedViewController = self.selectedViewController;
	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}

	_viewControllers = [newViewControllers copy];

	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound)
		_selectedIndex = newIndex;
	else if (newIndex < [_viewControllers count])
		_selectedIndex = newIndex;
	else
		_selectedIndex = 0;

	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}

	if ([self isViewLoaded])
		[self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
    //NSLog(@"this is new selecetd index%lu",(unsigned long)newSelectedIndex);

    
	[self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{

    //NSLog(@"this is new selecetd index%lu",(unsigned long)newSelectedIndex);
    
	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");

	if ([self.delegate respondsToSelector:@selector(mh_tabBarController:shouldSelectViewController:atIndex:)])
	{
		UIViewController *toViewController = (self.viewControllers)[newSelectedIndex];
		if (![self.delegate mh_tabBarController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}

	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex)
	{
		UIViewController *fromViewController;
		UIViewController *toViewController;

		if (_selectedIndex != NSNotFound)
		{
			fromViewController = self.selectedViewController;
		}

		NSUInteger oldSelectedIndex = _selectedIndex;
		_selectedIndex = newSelectedIndex;

		if (_selectedIndex != NSNotFound)
		{
			toViewController = self.selectedViewController;
		}

		if (toViewController == nil)  // don't animate
		{
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil)  // don't animate
		{
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];

			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else if (animated)
		{
			CGRect rect = contentContainerView.bounds;
			if (oldSelectedIndex < newSelectedIndex)
				rect.origin.x = rect.size.width;
			else
				rect.origin.x = -rect.size.width;

			toViewController.view.frame = rect;
			self.tooglebutton1.userInteractionEnabled = NO;
			self.tooglebutton.userInteractionEnabled = NO;

			[self transitionFromViewController:fromViewController
				toViewController:toViewController
				duration:0.3f
				options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
				animations:^
				{
					CGRect rect = fromViewController.view.frame;
					if (oldSelectedIndex < newSelectedIndex)
						rect.origin.x = -rect.size.width;
					else
						rect.origin.x = rect.size.width;

					fromViewController.view.frame = rect;
					toViewController.view.frame = contentContainerView.bounds;
				}
				completion:^(BOOL finished)
				{
                    self.tooglebutton1.userInteractionEnabled = YES;
                    self.tooglebutton.userInteractionEnabled = YES;

					if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
						[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
				}];
		}
		else  // not animated
		{
			[fromViewController.view removeFromSuperview];

			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];

			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
	}
}

- (UIViewController *)selectedViewController
{
	if (self.selectedIndex != NSNotFound)
		return (self.viewControllers)[self.selectedIndex];
	else
		return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
	[self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated
{
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}

- (void)tabButtonPressed:(UIButton *)sender
{
    //NSLog(@"this is sender .tag%ld",(long)sender.tag);
    //NSLog(@"this is tagoffset%ld",(long)TagOffset);
    
	[self setSelectedIndex:sender.tag animated:YES];
}

#pragma mark - Change these methods to customize the look of the buttons
- (CGFloat)tabBarHeight
{
	return 44.0f;
}

@end
