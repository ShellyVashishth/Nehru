//
//  ProductListingViewController.h
//  nehru
//
//  Created by shelly vashishth on 21/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "nSubCatCell.h"
#import "WishListViewController.h"
#import <Parse/Parse.h>
#import "DataProduct.h"
#import "DataCategory.h"
#import "ProductDetailViewController.h"
#import "DataWishlist.h"

@interface ProductListingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    NSMutableArray *arrcategories;
    NSMutableArray *arrayOfAllproducts;
    NSMutableArray *arrformalproducts;
    NSMutableArray *arrcasualProducts;
    
    IBOutlet UIView *ViewCasual;
    IBOutlet UIView *ViewFormal;
    IBOutlet UIView *ViewFirst;
    IBOutlet UIView *ViewFirstScreen;
    IBOutlet UITableView *mTableCasual;
    IBOutlet UITableView *mTableFormal;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    EGORefreshTableHeaderView *_refreshHeaderView1;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
    
    NSString *selectedIndex;
}
-(void)AddwishlistProductToParse:(NSString*)strproductId;
-(IBAction)ActionRemoveView:(id)sender;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
