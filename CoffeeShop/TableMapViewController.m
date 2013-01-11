//
//  ViewController.m
//  CoffeeShop
//
//  Created by Stephen Wai on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableMapViewController.h"
#import "LocationCell.h"
#import "Location.h"
#import "DetailStaticTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
 
@interface TableMapViewController ()

@end

@implementation TableMapViewController

@synthesize navigationBar;
@synthesize navigationItem;
@synthesize swappableView;
@synthesize mapView;
@synthesize tblView;
@synthesize locations;
@synthesize selectedLocation;
@synthesize refreshHeaderView;
@synthesize reloading;
@synthesize regionCenter;
@synthesize regionSpanDelta;
@synthesize VALID_RATINGS;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSInteger locCount = locations.count;
    if (locCount > 0) {
        NSLog(@"TableMapViewController: %u locations in memory", locCount);
    }
    else {
        NSLog(@"TableMapViewController: No locations in memory");
    }

    // set which acts as a static var
    VALID_RATINGS = [NSSet setWithObjects:[NSNumber numberWithDouble:1.0], [NSNumber numberWithDouble:1.5], [NSNumber numberWithDouble:2.0], [NSNumber numberWithDouble:2.5], [NSNumber numberWithDouble:3.0], [NSNumber numberWithDouble:3.5], [NSNumber numberWithDouble:4.0], [NSNumber numberWithDouble:4.5], [NSNumber numberWithDouble:5.0], nil];

    // init navigation bar
    [navigationBar setBackgroundImage:[UIImage imageNamed: @"navbarbg.png"] forBarMetrics:UIBarMetricsDefault];
    navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"title.png"]];
    
    // TODO: drop shadow on navigation bar
    //[navigationBar applyDefaultStyle];
    
    // yelp logo button
    navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self leftBarYelpButton]];
    
    // map/list button
    navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(swapViews:)];
    
    // TODO: change bar button background
    //UIImage *btnBg = [[UIImage imageNamed:@"barbuttonbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    //[[UIBarButtonItem appearance] setBackButtonBackgroundImage:btnBg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[navigationItem.rightBarButtonItem setBackButtonBackgroundImage:btnBg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // init EGORefreshTableHeaderView
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                CGRectMake(0.0f,0.0f - self.tblView.bounds.size.height, self.view.frame.size.width, self.tblView.bounds.size.height)];
    refreshHeaderView.delegate = self;
    
    // set autoresize for iOS6
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //swappableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //tblView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // needed to init views
    [tblView removeFromSuperview];
    [tblView addSubview:refreshHeaderView];
    [swappableView addSubview:tblView];
    mapView.hidden = YES;

    // get user location
    mapView.showsUserLocation = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger locCount = locations.count;
    if (locCount == 0) {
        return 1;
    }
    return locCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return refresh cell
    if (locations.count == 0) {
        UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        return emptyCell;
    }
    
    // get location
    Location *loc = [locations objectAtIndex:indexPath.row];
    
    // return prototype cell
    NSString *cellIdentifier = @"LocationCell";
    if (loc.artisan) {
        cellIdentifier = @"ArtisanLocationCell";
    }
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // set name
    cell.name.text = [NSString stringWithFormat:@"%@", loc.name];
    
    // set address
    NSString *addr;
    if ([loc.address count] > 0) {
        addr = [loc.address objectAtIndex:0];
    }
    if ([loc.neighborhoods count] > 0) {
        addr = [addr stringByAppendingFormat:@", %@", [loc.neighborhoods objectAtIndex:0]];
    }
    else {
        addr = [addr stringByAppendingFormat:@", %@", loc.city];
    }
    cell.address.text = addr;
    
    // set distance
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:0];
    [formatter setMaximumFractionDigits:2];
    NSNumber *mileDist = [NSNumber numberWithDouble: loc.distance.doubleValue / METERS_PER_MILE];
    cell.distance.text = [NSString stringWithFormat:@"%@ mi", [formatter stringFromNumber: mileDist]];
    
    // set main image
    [cell.img setImageWithURL:[NSURL URLWithString:loc.imageUrl] placeholderImage:[UIImage imageNamed:@"genericcup.png"]];
    cell.img.layer.cornerRadius = 2.0;
    cell.img.layer.masksToBounds = YES;
    cell.img.layer.borderColor = [DARK_SHADE CGColor];
    cell.img.layer.borderWidth = 1.0;
    
    // set review count
    cell.reviewCount.text = [NSString stringWithFormat:@"%@ Reviews", loc.reviewCount];
    
    // set rating image
    cell.ratingImg.image = [self imageForRating:loc.rating];
    
    return cell;
}

- (UIImage *)imageForRating:(NSNumber *)rating
{
    NSString *imgName = @"stars_3.png";
    
    // validate rating
    if ([VALID_RATINGS containsObject:rating]) {
        imgName = [NSString stringWithFormat:@"stars_%@.png", rating];
    }
    else {
        NSLog(@"imageForRating: invalid rating, %@", rating);
    }

    return [UIImage imageNamed:imgName];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // nothing here since using prepareForSegue
    // remove selection
    [tblView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailStaticTableViewControllerSegue"]) {
        NSIndexPath *indexPath = [self.tblView indexPathForSelectedRow];
        UINavigationController *nc = [segue destinationViewController];
        DetailStaticTableViewController *dvc = [[nc viewControllers] objectAtIndex:0];
        Location *loc = [locations objectAtIndex:indexPath.row];
        dvc.location = loc;
    }
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";   
    if ([annotation isKindOfClass:[Location class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mv dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    	
        // TODO: use custom pin image
        //annotationView.image = [UIimage imageNamed:@"pin.png"];
        
        return annotationView;
    }
    
    return nil;    
}

// send to detail view
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if([view.annotation isKindOfClass:[Location class]]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];        
        UINavigationController *nc = (UINavigationController *) [sb instantiateViewControllerWithIdentifier:@"NavigationController"];
        DetailStaticTableViewController *dvc = [[nc viewControllers] objectAtIndex:0];
        dvc.location = (Location *) view.annotation;
        [self presentViewController:nc animated:YES completion:^{}];
    }
}

# pragma mark - EGORefreshTableHeaderView delegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    self.reloading = YES;
    [self listLocations];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tblView];
    return self.reloading;
}

- (void)doneLoadingTableViewData
{	
    self.reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tblView];	
}


- (void)closeLoadingTableView
{
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{		
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];	
}

# pragma mark - IBAction methods

- (IBAction)swapViews:(id)sender
{
    // swap to list view
    if (tblView.hidden == YES) {
        //[mapView removeFromSuperview];
        //[self.view addSubview:tableView];

        // swap button to map button
        navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(swapViews:)];
        
        // swap view to table view
        [UIView transitionWithView:swappableView
                          duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [mapView removeFromSuperview];
                            [swappableView addSubview:tblView];
                        }
                        completion:NULL];
        
        tblView.hidden = NO;
        mapView.hidden = YES;
    }
    // swap to map view
    else if (mapView.hidden == YES) {
        //[tableView removeFromSuperview];
        //[self.view addSubview:mapView];

        // swap button to list button
        navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(swapViews:)];
        
        // swap view to map view
        [UIView transitionWithView:swappableView
                          duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [tblView removeFromSuperview];
                            [swappableView addSubview:mapView];
                        }
                        completion:NULL];
        
        tblView.hidden = YES;
        mapView.hidden = NO;
    }
    
}

- (void)showNoLocationAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

# pragma mark - Location Processing & View Updating

- (void)listLocations
{
    MKUserLocation *userLoc = [mapView userLocation];
    CLLocationCoordinate2D location;
    location.latitude = userLoc.coordinate.latitude;
    location.longitude = userLoc.coordinate.longitude;
    
    if (location.latitude == 0 && location.latitude == 0) {
        NSLog(@"listLocations: user location not found");
        [self closeLoadingTableView];
        [self showNoLocationAlert:@"Your location could not be determined. Please try again."];
        return;
    }
    else {
        NSLog(@"listLocations: %f, %f", location.latitude, location.longitude);
    }
        
    // hit webservice for JSON
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        NSString *url = [NSString stringWithFormat:@"http://dripsterapp.appspot.com/cs?ll=%f,%f", location.latitude, location.longitude];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        NSLog(@"listLocations: dispatch_async calling webservice");
        NSLog(@"listLocations: url: %@", url);
        [self performSelectorOnMainThread:@selector(updateViews:) 
                               withObject:data waitUntilDone:YES];
    }); 
    
}

- (void)updateViews:(NSData *)responseData
{
    [self processLocationData:responseData];
    [self updateTableView];
    [self closeLoadingTableView];   // release pull to refresh
    [self updateMapView];
}

- (void)processLocationData:(NSData *)responseData
{
    if (responseData == nil) {
        NSLog(@"processLocations: responseData is nil");
        [self closeLoadingTableView];
        [self showNoLocationAlert:@"No locations found.  Please try again."];
        return;
    }

    NSLog(@"processLocations: processing JSON response");
    NSError *error;
    NSDictionary *json = [NSJSONSerialization 
                          JSONObjectWithData:responseData
                          options:kNilOptions 
                          error:&error];

    // process locations
    NSArray *locs = [json objectForKey:@"locations"];
    
    if (locs.count == 0) {
        NSLog(@"processLocations: No locations returned in JSON");
        [self closeLoadingTableView];
        [self showNoLocationAlert:@"Could not find locations"];
        return;
    }
    else {
        NSLog(@"processLocations: %@", locs);
    }
    
    // init locations ivar
    locations = [NSMutableArray arrayWithCapacity:MAX_TABLE_CAPACITY];
        
    // iteration locations from JSON
    for (NSDictionary *loc in locs) {
        
        // init location object
        NSString *name = [loc objectForKey:@"name"];        
        NSString *address = [loc objectForKey:@"address"];
        NSNumber *latitude = [loc objectForKey:@"latitude"];
        NSNumber *longitude = [loc objectForKey:@"longitude"];
        CLLocationCoordinate2D coord;
        coord.latitude = latitude.doubleValue;
        coord.longitude = longitude.doubleValue;
        Location *location = [[Location alloc] initWithName:name address:address coordinate:coord];
        
        // set other fields
        location.closed = [[loc objectForKey:@"closed"] boolValue];
        location.artisan = [[loc objectForKey:@"artisan"] boolValue];
        location.mobileUrl = [loc objectForKey:@"mobileUrl"];
        location.yelpId = [loc objectForKey:@"id"];
        location.imageUrl = [loc objectForKey:@"imageUrl"];
        location.ratingImageUrl = [loc objectForKey:@"ratingImgUrl"];
        location.phone = [loc objectForKey:@"phone"];
        location.displayPhone = [loc objectForKey:@"displayPhone"];
        location.rating = [loc objectForKey:@"rating"];
        location.distance = [loc objectForKey:@"distance"];
        location.reviewCount = [loc objectForKey:@"reviewCount"];
        location.snippetText = [loc objectForKey:@"snippetText"];
        location.displayAddress = [loc objectForKey:@"displayAddress"];
        location.city = [loc objectForKey:@"city"];
        location.stateCode = [loc objectForKey:@"stateCode"];
        location.postalCode = [loc objectForKey:@"postalCode"];
        location.neighborhoods = [loc objectForKey:@"neighborhoods"];
        location.beanTags = [loc objectForKey:@"beanTags"];
        location.storeTags = [loc objectForKey:@"storeTags"];
        
        [locations addObject:location];
    }

    // process region center
    NSDictionary *center = [json objectForKey:@"regionCenter"];
    NSLog(@"processLocations: center: %@", center);
    regionCenter = [[Location alloc] initWithPoint:[center objectForKey:@"latitude"]
                                         longitude:[center objectForKey:@"longitude"]];
    
    // process region span delta
    NSDictionary *span = [json objectForKey:@"regionSpanDelta"];
    NSLog(@"processLocations: span: %@", span);
    regionSpanDelta = [[Location alloc] initWithPoint:[span objectForKey:@"latitude"]
                                            longitude:[span objectForKey:@"longitude"]];
}

- (void)updateTableView
{
    NSLog(@"updateTableView: reloading TableView");
    [tblView reloadData];
}

- (void)updateMapView
{
    NSLog(@"updateMapView: updating MapView");
    
    // remove existing annotations
    for (id<MKAnnotation> annotation in mapView.annotations)
        [mapView removeAnnotation:annotation];
    
    // adjust map region
    CLLocationCoordinate2D centerLoc;
    if ([regionCenter latitude] != nil && [regionCenter longitude] != nil) {
        centerLoc.latitude = [[regionCenter latitude] doubleValue];
        centerLoc.longitude = [[regionCenter longitude] doubleValue];
    }
    else
        centerLoc = [[mapView userLocation] coordinate];
    
    NSLog(@"updateMapView: center: %f, %f", centerLoc.latitude, centerLoc.longitude);
    
    // set span
    double latitudinalFraction = DEFAULT_FRACTION_DELTA;
    if ([regionSpanDelta latitude] != nil)
        latitudinalFraction = [[regionSpanDelta latitude] doubleValue];
    
    double longitudinalFraction = DEFAULT_FRACTION_DELTA;
    if ([regionSpanDelta longitude] != nil)
        longitudinalFraction = [[regionSpanDelta longitude] doubleValue];

    NSLog(@"updateMapView: regionSpanDelta:  %f, %f", latitudinalFraction, longitudinalFraction);
    
    double latitudinalMeters = latitudinalFraction * LATITUDE_METERS_PER_DEGREE;
    double longitudinalMeters = longitudinalFraction * LONGITUDE_METERS_PER_DEGREE;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerLoc, latitudinalMeters, longitudinalMeters);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:region];     
    [mapView setRegion:adjustedRegion animated:YES];

    // plot annotations in locations
    for (Location *loc in locations)
        [mapView addAnnotation:loc];
}

# pragma mark - Left Yelp button

+ (UIButton *)createLeftBarYelpButton
{
    UIImage *img = [UIImage imageNamed:@"yelp_logo.png"];
    CGRect btnFrame = CGRectMake(0, 0, 50, 25);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setFrame:btnFrame];
    return btn;
}

- (UIButton *)leftBarYelpButton
{
    UIButton *btn = [TableMapViewController createLeftBarYelpButton];
    [btn addTarget:self action:@selector(launchYelp:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (BOOL)isYelpInstalled
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"yelp:"]];
}

- (IBAction)launchYelp:(id)sender
{
	if ([TableMapViewController isYelpInstalled]) {
        
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"yelp:"]];
    }
    else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.yelp.com"]];
	}
}

@end
