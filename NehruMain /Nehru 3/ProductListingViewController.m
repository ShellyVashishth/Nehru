//
//  ProductListingViewController.m
//  nehru
//
//  Created by shelly vashishth on 21/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "ProductListingViewController.h"

@interface ProductListingViewController ()

@end

@implementation ProductListingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    self.useNavigationBarButtonItemsOfCurrentViewController = YES;
//    self.useToolbarItemsOfCurrentViewController = YES;
//    
//    NSMutableArray *initialViewController = [NSMutableArray array];
//    [initialViewController addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"FirstView"]];
////    [initialViewController addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"SecondView"]];
//    self.viewController = initialViewController;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // left swipe gesture
    
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(oneFingerSwipeLeft:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(oneFingerSwipeRight:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];

    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - mTableCasual.bounds.size.height, self.view.frame.size.width, mTableCasual.bounds.size.height)];
		view.delegate = self;
		[mTableCasual addSubview:view];
		_refreshHeaderView = view;
        //[view release];
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    //Refresh view on the second UITableView
    
    if(_refreshHeaderView1==nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - mTableFormal.bounds.size.height, self.view.frame.size.width, mTableFormal.bounds.size.height)];
		view.delegate = self;
		[mTableFormal addSubview:view];
		_refreshHeaderView1 = view;
        //[view release];
    }
    
    //update the last update date.
    [_refreshHeaderView1 refreshLastUpdatedDate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddProducttoWishlist) name:@"AddToWishlist" object:nil];
    
    [self getCategories];
//    [self uploadImages];
    [self GetProducts];
    
    
   }

-(void)AddProducttoWishlist
{
  NSInteger productIndexpath=[selectedIndex integerValue];
  DataProduct *dataproduct1= [arrayOfAllproducts objectAtIndex:productIndexpath];
//    NSLog(@"Data product %@",dataproduct1);
    
    
    //Clicked product added into the wishlist here in singleton class on the iphone itself.
    DataWishlist *wishlist=[DataWishlist sharedWishList];
    [wishlist.myWishlistArray addObject:dataproduct1];
    
    
    //Now time to add the product on the parse database.
    
    [self AddwishlistProductToParse:dataproduct1.ProductId];
}

-(void)AddwishlistProductToParse:(NSString*)strproductId
{
    PFObject *gameScore = [PFObject objectWithClassName:@"NehruWishlist"];
//    gameScore[@"productId"] = strproductId;
     [gameScore setObject:strproductId forKey:@"productId"];
    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The find succeeded.
            if(succeeded){
                NSLog(@"Successfull addition to wishlist.");
            }
            else{
                NSLog(@"Sorry we were not able to add product to wishlist.");
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//Adding products into the wishlist in parse database.
-(void)getCategories
{
    PFQuery *query = [PFQuery queryWithClassName:@"NehruCategories"];
    //    [query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
//            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
//                NSLog(@"%@", object.objectId);
                
                //getting the category Name and Object Id's
                
//                NSLog(@"%@",object[@"categoryName"]);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


-(void)GetProducts
{
    arrayOfAllproducts=[[NSMutableArray alloc]init];
    //getting all the products in the database.
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProducts"];
    //    [query whereKey:@"productName" equalTo:@"jacket 3"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            //calling casual
            
            [UIView beginAnimations:@"bucketsOff" context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationDelegate:self];
            
            //position off screen
            ViewCasual.frame=CGRectMake(484, 40  , 320 , 420);
            ViewFormal.frame=CGRectMake(0, 40, 320, 480);
            //animate off screen
            [UIView commitAnimations];

            [mTableCasual reloadData];
            
            // Do something with the found objects
            for (PFObject *object in objects) {
                //getting the category Name and Object Id's
                DataProduct *dataproduct=[[DataProduct alloc]init];
                dataproduct.ProductId=object.objectId;
                dataproduct.ProductImage=object[@"productImage"];
                dataproduct.ProductName=object[@"productName"];
                dataproduct.ProductModel=object[@"productModel"];
                NSString *strproductQty=object[@"productQty"];
                NSString *strProductPrice=object[@"productPrice"];
                dataproduct.productImages=object[@"ProductImages"];
                
                dataproduct.productquantity=[strproductQty integerValue];
                dataproduct.productUnitprice=[strProductPrice floatValue];
                dataproduct.CategoryId=object[@"categoryId"];
                [arrayOfAllproducts addObject:dataproduct];
            }
            [mTableCasual reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void)uploadImages
{
    //Running query for saving the images in the NehruProduct Table.
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProducts"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d products.", objects.count);
            int i=0;
            // Do something with the found objects
            for (PFObject *object in objects) {
                i++;
                NSLog(@"image100%d",i);
                UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"image100%d.jpg",i]];
                // Resize image
                UIGraphicsBeginImageContext(CGSizeMake(640,960));
                [image drawInRect: CGRectMake(0, 0, 640,960)];
                UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
                //first Image.
                
                PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"image100%d.jpg",i] data:imageData];
                [object setObject:imageFile forKey:@"productImage"];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        // The find succeeded.
                        if(succeeded){
                            NSLog(@"Successful UpLoading of photos");
                        }
                        else{
                            NSLog(@"Sorry we were not able to upload the photos.");
                        }
                    }
                    else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


//Left view controller

-(void)oneFingerSwipeLeft: (UITapGestureRecognizer *) recognizer {
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(0 , 40  , 320 , 420);
    ViewFormal.frame=CGRectMake(-484, 40, 320, 480);
    //animate off screen
    [UIView commitAnimations];
    
}

//Right View controller

-(void)oneFingerSwipeRight: (UITapGestureRecognizer *) recognizer {
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(484, 40  , 320 , 420);
    ViewFormal.frame=CGRectMake(0, 40, 320, 480);
    //animate off screen
    [UIView commitAnimations];
    
}

-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:YES];
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(484, 40  , 320 , 420);
    ViewFormal.frame=CGRectMake(0, 40, 320, 480);
    //animate off screen
    [UIView commitAnimations];
    [mTableCasual reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationRepeatCount:1e100f];  //coutless
    [UIView setAnimationRepeatCount:1];   // 1 time
    //[UIView setAnimationRepeatAutoreverses:YES];
    ViewFirst.frame = CGRectMake(0, -2, 320, 480);
    ViewFirst.transform = CGAffineTransformMakeRotation(0);
    //[ViewFirst setHidden:YES];
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    
}

-(IBAction)ClickedOnbtnFormal:(id)sender {
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(0 , 40  , 320 , 420);
    ViewFormal.frame=CGRectMake(-484, 40, 320, 480);
    //animate off screen
    [UIView commitAnimations];
    [mTableFormal reloadData];
}

-(IBAction)ClickedOnbtnCasual:(id)sender {
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(484, 40  , 320 , 420);
    ViewFormal.frame=CGRectMake(0, 40, 320, 480);
    //animate off screen
    [UIView commitAnimations];
    [mTableCasual reloadData];
}

-(IBAction)ActionRemoveView:(id)sender {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatCount:1];   // 1 time
    ViewFirstScreen.frame = CGRectMake(-100, 225, 10, 10);
    ViewFirstScreen.transform = CGAffineTransformMakeRotation(60);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayOfAllproducts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tableIdentifier=@"nSubProductTable";
    nSubCatCell *mainTableCell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(tableView.tag==1001)
    {
    if(mainTableCell==nil){
        mainTableCell=[[nSubCatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    DataProduct *dataproduct=[[DataProduct alloc]init];
    dataproduct=[arrayOfAllproducts objectAtIndex:indexPath.row];
    
    PFFile *theImage =dataproduct.ProductImage;
    
    [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        UIImage *image = [UIImage imageWithData:data];
        mainTableCell.imgproduct.image=image;
    }];
    mainTableCell.lblproductDescription.text=dataproduct.ProductName;
    mainTableCell.btnfavorites.imageView.image=[UIImage imageNamed:@"bookmark.png"];
    }
    else if(tableView.tag==1002)
    {
        if(mainTableCell==nil){
            mainTableCell=[[nSubCatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        }
        
        DataProduct *dataproduct=[[DataProduct alloc]init];
        dataproduct=[arrayOfAllproducts objectAtIndex:indexPath.row];
        
        PFFile *theImage =dataproduct.ProductImage;
        
        [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            UIImage *image = [UIImage imageWithData:data];
            mainTableCell.imgproduct.image=image;
        }];
        mainTableCell.lblproductDescription.text=dataproduct.ProductName;
        mainTableCell.btnfavorites.imageView.image=[UIImage imageNamed:@"bookmark.png"];
    }
    return mainTableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex=[NSString stringWithFormat:@"%d",indexPath.row];
    [self performSegueWithIdentifier:@"pushToProductDetail" sender:selectedIndex];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSInteger productIndexpath=[sender integerValue];
//    NSLog(@"prepareForSegue: %@", segue.identifier );
    if ([segue.identifier isEqualToString:@"pushToProductDetail"])
    {
        ProductDetailViewController *detailController = segue.destinationViewController;
        detailController.dataproduct = [arrayOfAllproducts objectAtIndex:productIndexpath];
    }    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:mTableCasual];
    [_refreshHeaderView1 egoRefreshScrollViewDataSourceDidFinishedLoading:mTableFormal];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_refreshHeaderView !=nil)
    {
	  [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    else if(_refreshHeaderView!=nil)
    {
      [_refreshHeaderView1 egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(_refreshHeaderView!=nil)
    {
	  [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else if(_refreshHeaderView1 !=nil)
    {
      [_refreshHeaderView1 egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
