//
//  nSubCatCell.m
//  nehru
//
//  Created by ADMIN on 11/28/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "nSubCatCell.h"

@implementation nSubCatCell
@synthesize imgproduct;
@synthesize lblproductDescription;
@synthesize btnfavorites;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)ClickedAddProducttoWishlist:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddToWishlist" object:nil];
}

@end
