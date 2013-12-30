//
//  ProductDetailViewController.h
//  nehru
//
//  Created by shelly vashishth on 03/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTableViewPickerControl.h"
#import "CartViewController.h"
#import "DataProduct.h"
#import "DataWishlist.h"
#import "DataMyCart.h"
#import "WishListViewController.h"
#import "PageController.h"

@interface ProductDetailViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,LCItemPickerDelegate,UITextFieldDelegate>
{
        PageController *pageControllerView;
        UINavigationController *navController;
    NSMutableArray *arrofSize;
    NSMutableArray *arrofColor;
    
    IBOutlet UIView *mLoaderView;
    IBOutlet UIImageView *imgViewProduct;
    IBOutlet UILabel *productName;
    IBOutlet UILabel *productColor;
    IBOutlet UILabel *productSize;
    IBOutlet UILabel *lblproductDescription;
    IBOutlet UILabel *lblproductQuantity;
    IBOutlet UILabel *lblproductModelName;
    IBOutlet UIButton *btnMoreProdctImages;
    IBOutlet UIButton *btnCloseImagesView;
    BOOL isSize;
    BOOL isColour;
}
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *backgScroll;
@property (nonatomic, strong) UIView *maskView;
@property (weak) id pickValue;
@property(nonatomic,strong)DataProduct *dataproduct;
@property(nonatomic,strong)DataMyCart *datamyCart;
// UIViews on the page
@property(weak) IBOutlet UIView *itemNameView;
@property(weak) IBOutlet UIView *itemDescView;
@property(weak) IBOutlet UIView *itemColorView;
@property(weak) IBOutlet UIView *itemSizeView;
@property(weak) IBOutlet UIView *itemQuantityView;
-(IBAction)clickedShowCart:(id)sender;
-(IBAction)ClickedSelectSize:(id)sender;
-(IBAction)ClickedSelectColor:(id)sender;
-(IBAction)ClickedAddToCart:(id)sender;
-(IBAction)AddProducttoWishlist:(id)sender;
-(IBAction)viewMoreImages:(id)sender;
-(IBAction)CloseView:(id)sender;
-(void)displayDataOnscreen;
-(void)AddProductImages;
-(void)GetProductImagesFromParse;
@end