//
//  ProductDetailViewController.m
//  nehru
//
//  Created by shelly vashishth on 03/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation ProductDetailViewController
@synthesize dataproduct,datamyCart;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
//    [self.navigationController.navigationBar setHidden:YES];

    // Load the initial set of pages that are on screen
//    [self loadVisiblePages];
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)importViewController {
    pageControllerView = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewImages"];
//    navController = [[UINavigationController alloc] initWithRootViewController:pageControllerView];
    //    [navController pushViewController:howwewrk animated:YES];
//    [navController setNavigationBarHidden:YES];
    
    
//    [self.view addSubview:mLoaderView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Dataproduct %@",self.dataproduct);
    self.backgScroll.contentSize=CGSizeMake(320, 520);
    self.itemColorView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.itemColorView.layer.borderWidth=1.0f;
    
    self.itemSizeView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.itemSizeView.layer.borderWidth=1.0f;
    
    arrofSize=[[NSMutableArray alloc]initWithObjects:@"Size 1",@"Size 2", nil];
    arrofColor=[[NSMutableArray alloc]initWithObjects:@"Color 1",@"Color 2", nil];
    
//    [self GetProductImagesFromParse];
    
//    // Set up the image we want to scroll & zoom and add it to the scroll view
//    self.pageImages = [NSArray arrayWithObjects:
//                       [UIImage imageNamed:@"photo1.png"],
//                       [UIImage imageNamed:@"photo2.png"],
//                       [UIImage imageNamed:@"photo3.png"],
//                       [UIImage imageNamed:@"photo4.png"],
//                       [UIImage imageNamed:@"photo5.png"],
//                       nil];
//    
//    NSInteger pageCount = self.pageImages.count;
//    
//    // Set up the page control
//    self.pageControl.currentPage = 0;
//    self.pageControl.numberOfPages = pageCount;
//    
//    // Set up the array to hold the views for each page
//    self.pageViews = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < pageCount; ++i) {
//        [self.pageViews addObject:[NSNull null]];
//    }
    
    isSize=YES;
    
    [self displayDataOnscreen];
    
//    [self AddProductImages];
    
//    [self GetProductImagesFromParse];
}

-(IBAction)viewMoreImages:(id)sender {
    mLoaderView.frame = CGRectMake(0, 200, 306, 308);
    [self importViewController];
}
-(IBAction)CloseView:(id)sender {
    mLoaderView.frame = CGRectMake(0, 1200, 306, 308);
}

-(void)GetProductImagesFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProducts"];
    NSLog(@"Data product Id %@",self.dataproduct.ProductId);
    [query getObjectInBackgroundWithId:self.dataproduct.ProductId block:^(PFObject *objProduct, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        NSLog(@"OBJProduct %@", objProduct);
        NSString *strOfImageFile=[objProduct objectForKey:@"ProductImages"];
        NSLog(@"Str of image file %@",strOfImageFile);
        self.pageImages=[[NSMutableArray alloc]init];
        self.pageImages=[strOfImageFile componentsSeparatedByString:@","];
    }];
    NSLog(@"Page images %@",self.pageImages);
}

//Adding six images to the product on parse.

-(void)AddProductImages
{
    NSMutableArray *arrofImages=[[NSMutableArray alloc]init];
    for(int i=1;i<=6;i++)
    {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"images%d.jpeg",i]];
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(640,960));
        [image drawInRect: CGRectMake(0, 0, 640,960)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
        //first Image.
        
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"images%d.jpeg",i] data:imageData];
        [arrofImages addObject:imageFile];

    }
        NSLog(@"Images of the product %@",arrofImages);
        PFQuery *query = [PFQuery queryWithClassName:@"NehruProducts"];
        NSLog(@"Data product Id %@",self.dataproduct.ProductId);
        [query getObjectInBackgroundWithId:self.dataproduct.ProductId block:^(PFObject *objProduct, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            NSLog(@"Object Product %@",objProduct);
            [objProduct setObject:arrofImages forKey:@"ProductImages"];
            [objProduct saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    if(succeeded){
                        NSLog(@"Successfull loading of image array in parse.");
                    }
                    else{
                        NSLog(@"Sorry we were not able upload PFFile in parse.");
                    }
                }
                else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];

            NSLog(@"OBJProduct %@", objProduct);
        }];
        // Do something with the returned PFObject in the gameScore variable.
}

-(void)displayDataOnscreen
{
    NSLog(@"Dataproduct %@",self.dataproduct);
//    PFFile *theImage =self.dataproduct.ProductImage;
//    NSData *imageData = [theImage getData];
//    UIImage *image = [UIImage imageWithData:imageData];
//    imgViewProduct.image=image;
    
    lblproductModelName.text=dataproduct.ProductModel;
    lblproductQuantity.text=[NSString stringWithFormat:@"%d",dataproduct.productquantity];
    productName.text=dataproduct.ProductName;
    
    PFFile *theImage =self.dataproduct.ProductImage;
    
    [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        UIImage *image = [UIImage imageWithData:data];
        imgViewProduct.image=image;
    }];
}
//adding product to wishlist in singleton and to the wishlist in parse database.


-(IBAction)AddProducttoWishlist:(id)sender
{
    //Clicked product added into the wishlist here in singleton class on the iphone itself.
    DataWishlist *wishlist=[DataWishlist sharedWishList];
    [wishlist addProduct:self.dataproduct];
    
    //Now time to add the product on the parse database.
    [self AddwishlistProductToParse:self.dataproduct.ProductId];
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

-(IBAction)ShowMyWishlist:(id)sender
{
    [self performSegueWithIdentifier:@"pushToWishlist" sender:0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToWishlist"])
    {
     WishListViewController *detailController = segue.destinationViewController;
        NSLog(@"Detail View controller %@",detailController);
    }
    else if([segue.identifier isEqualToString:@"pushToCart"])
    {
    CartViewController *detailController = segue.destinationViewController;
        NSLog(@"Detail View controller %@",detailController);

    }
}

-(IBAction)ClickedSelectSize:(id)sender
{
//    isSize=YES;
//    [tblselectSize reloadData];
    isSize=YES;
    isColour=NO;
    LCTableViewPickerControl *pickerView = [[LCTableViewPickerControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, kPickerControlWidth, kPickerControlAgeHeight) title:@"Please select the color" value:_pickValue items:@[@"item1",@"item2",@"item3",@"item4",@"item5",@"item6"]];
    [pickerView setDelegate:self];
    [pickerView setTag:0];
    
    [self.view addSubview:pickerView];
    [pickerView show];
}

-(IBAction)ClickedSelectColor:(id)sender
{
//    isColour=YES;
//    [tblSelectColor reloadData];
    isSize=NO;
    isColour=YES;
    LCTableViewPickerControl *pickerView = [[LCTableViewPickerControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, kPickerControlWidth, kPickerControlAgeHeight) title:@"Please select the color" value:_pickValue items:@[@"Color1",@"Color2",@"Color3",@"Color4",@"Color5",@"Color6"]];
    [pickerView setDelegate:self];
    [pickerView setTag:0];
    
    [self.view addSubview:pickerView];
    [pickerView show];
}

- (void)dismissPickerControl:(LCTableViewPickerControl*)view
{
    [view dismiss];
}

#pragma mark - LCTableViewPickerDelegate
- (void)selectControl:(LCTableViewPickerControl*)view didSelectWithItem:(id)item
{
    /*Check item is NSString or NSNumber , if it is necessary */
    if(isSize)
    {
    if (view.tag == 0)
    {
        if ([item isKindOfClass:[NSString class]])
        {
            
        }
        else if ([item isKindOfClass:[NSNumber class]])
        {
            
        }
    }
    self.pickValue = item;
//    [btnSelectColor setTitle:[NSString stringWithFormat:@"%@",item] forState:UIControlStateNormal];
    
    [self dismissPickerControl:view];
    }
    else
    {
        if (view.tag == 0)
        {
            if ([item isKindOfClass:[NSString class]])
            {
                
            }
            else if ([item isKindOfClass:[NSNumber class]])
            {
                
            }
        }
        self.pickValue = item;
//        [btnSelectColor setTitle:[NSString stringWithFormat:@"%@",item] forState:UIControlStateNormal];
        [self dismissPickerControl:view];
    }
}

- (void)selectControl:(LCTableViewPickerControl *)view didCancelWithItem:(id)item
{
    [self dismissPickerControl:view];
}

-(IBAction)ClickedAddToCart:(id)sender
{
    self.datamyCart=[DataMyCart sharedCart];
  
    [self.datamyCart addProduct:self.dataproduct];

    NSLog(@"Data my Cart %@",self.datamyCart);
}

-(IBAction)clickedShowCart:(id)sender
{
    [self performSegueWithIdentifier:@"pushToCart" sender:0];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen
    [self loadVisiblePages];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
