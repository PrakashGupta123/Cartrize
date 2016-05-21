
@protocol MHTabBarControllerDelegate;

/*
 * A custom tab bar container view controller. It works just like a regular
 * UITabBarController, except the tabs are at the top and look different.
 */
@interface ParentViewController : UIViewController

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak) id <MHTabBarControllerDelegate> delegate;
@property(nonatomic,retain)IBOutlet UIButton *tooglebutton;
@property(nonatomic,retain)IBOutlet UIButton *tooglebutton1;


- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

/*
 * The delegate protocol for MHTabBarController.
 */
@protocol MHTabBarControllerDelegate <NSObject>
@optional
- (BOOL)mh_tabBarController:(ParentViewController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)mh_tabBarController:(ParentViewController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;

-(IBAction)secondButtonPress:(id)sender;
-(IBAction)firstButtonPress:(id)sender;

@end
