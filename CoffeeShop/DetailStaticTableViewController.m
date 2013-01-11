//
//  DetailStaticTableViewController.m
//  CoffeeShop
//
//  Created by Stephen Wai on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailStaticTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailStaticTableViewController ()

@end

@implementation DetailStaticTableViewController

@synthesize location;
@synthesize mapCell;
@synthesize addressCell;
@synthesize phoneCell;
@synthesize featuresCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // custom init code
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // init navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"title.png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self leftBarYelpButton]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 3;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (location == nil)
        return nil;
    
    //NSLog(@"section: %@", indexPath.section);
    //NSLog(@"row: %@", indexPath.row);
    
    if (indexPath.section == 0) {
        
        // hide cell background
        mapCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // add pin
        [mapCell annotateMapRegion:location];
        
        return mapCell;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            // set name
            addressCell.name.text = location.name;
            
            // set address
            NSString *displayAddr = [NSString string];
            for (NSString *line in location.displayAddress)
                displayAddr = [displayAddr stringByAppendingFormat:@"%@\n",line];

            addressCell.address.text = displayAddr;
            
            // set image
            [addressCell.img setImageWithURL:[NSURL URLWithString:location.imageUrl] placeholderImage:[UIImage imageNamed:@"genericcup.png"]];
            addressCell.img.layer.cornerRadius = 2.0;
            addressCell.img.layer.masksToBounds = YES;
            addressCell.img.layer.borderColor = [DARK_SHADE CGColor];
            addressCell.img.layer.borderWidth = 1.0;
            
            return addressCell;
        }
        else if (indexPath.row == 1) {
            
            // set call button
            phoneCell.callBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            if (location.phone.length == 0) {
                [phoneCell.callBtn setTitle:@"Not Available" forState:UIControlStateNormal];
                [phoneCell.callBtn setEnabled: NO];
            }
            else {
                NSString *phoneBtnText = location.displayPhone;
                if (location.phone.length == 10) {
                    NSString *area = [location.phone substringToIndex:3];
                    NSRange range;
                    range.length = 3;
                    range.location = 3;
                    NSString *part1 = [location.phone substringWithRange:range];
                    NSString *part2 = [location.phone substringFromIndex:6];
                    phoneBtnText = [NSString stringWithFormat:@"(%@) %@-%@", area, part1, part2];
                }
                [phoneCell.callBtn setTitle:phoneBtnText forState:UIControlStateNormal];
                phoneCell.num = location.phone;
            }
            
            // set directions button
            NSString *addr = [location.address objectAtIndex:0];
            NSString *fullAddr = [addr stringByAppendingFormat:@", %@ %@ %@", location.city, location.postalCode, location.stateCode];
            [phoneCell.directionsBtn setTitle:fullAddr forState:UIControlStateNormal];
            phoneCell.directionsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            phoneCell.address = fullAddr;
            
            return phoneCell;
        }
        else if (indexPath.row == 2) {
            
            // set features from all tags
            NSString *tags = [NSString string];
            for (NSString *bt in location.beanTags)
                tags = [tags stringByAppendingFormat:@"%@, ",bt];
            
            for (NSString *st in location.storeTags)
                tags = [tags stringByAppendingFormat:@"%@, ",st];
            
            if (![tags isEqualToString:@""]) {
                featuresCell.featuresTitle.text = @"Features";
                NSString *tagsDisplay = [tags substringToIndex:tags.length-2];
                featuresCell.features.text = tagsDisplay;
                featuresCell.features.numberOfLines = 0;
                [featuresCell.features sizeToFit];
            }
            else {
                featuresCell.featuresTitle.text = nil;
                featuresCell.features.text = nil;
            }
            
            return featuresCell;
        }
    }
    return nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

# pragma mark - Left Yelp button

- (UIButton *)leftBarYelpButton
{
    UIButton *btn = [TableMapViewController createLeftBarYelpButton];
    [btn addTarget:self action:@selector(launchYelp:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (IBAction)launchYelp:(id)sender
{
    NSString *yelpId = @"";
    if (location != nil) {
        yelpId = location.yelpId;
    }
    NSString *bizUrl = nil;
	if ([TableMapViewController isYelpInstalled]) {
        bizUrl = [NSString stringWithFormat:@"yelp:///biz/%@", yelpId];
    }
    else {
         bizUrl = [NSString stringWithFormat:@"http://m.yelp.com/biz/%@", yelpId];
	}
    
    if (bizUrl != nil) {
        bizUrl = [bizUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:bizUrl]]) {
            NSLog(@"Opening URL resource:%@", bizUrl);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:bizUrl]];
        }
        else {
            NSLog(@"Cannot open URL resource:%@", bizUrl);
        }
    }
}

@end
