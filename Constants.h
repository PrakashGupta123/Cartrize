//
//  Constants.h
//  iShop
//
//
//

#import <Foundation/Foundation.h>

typedef enum 
{
    ADDPRODUCT = 1,
    DELETEPRODUCT = 2,
    ADDFAVORITES = 3,
    DELETEFAVORITES = 4,
    EDITPRODUCT = 5,
    ADDTOCARTPAYMENT = 6,
    FINALPAYMENT = 7,
    DELETEFAVORITEPRODUCT = 8,
    EDITFAVORITEPRODUCT = 9,
    MOVETOBAGPRODUCT = 10,
    DELETEPRODUCTFROMBAG = 11,

}requestfor;


#define PROXIMANOVA_REGULAR_22 [UIFont fontWithName:@"ProximaNova-Regular" size:22]

#if !defined(MIN)
#define MIN(A,B)((A) < (B) ? (A) : (B))
#endif

#if !defined(MAX)
#define MAX(A,B)((A) > (B) ? (A) : (B))
#endif

#define COLOR_COMPONENT_SCALE_FACTOR 255.0f

#define DEFAULT_RED_COLOR [UIColor colorWithRed:240 / COLOR_COMPONENT_SCALE_FACTOR green:67 / COLOR_COMPONENT_SCALE_FACTOR blue:50 / COLOR_COMPONENT_SCALE_FACTOR alpha:1.0f];

@interface Constants : NSObject {
    
}


@end
