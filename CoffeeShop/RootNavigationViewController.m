//
//  RootNavigationViewController.m
//  CoffeeShop
//
//  Created by Stephen Wai on 9/29/12.
//
//

#import "RootNavigationViewController.h"

@interface RootNavigationViewController ()

@end

@implementation RootNavigationViewController

@synthesize navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [navigationBar setBackgroundImage:[UIImage imageNamed: @"navbarbg.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
