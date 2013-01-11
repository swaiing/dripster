//
//  UINavigationBar+CustomImage.m
//  CoffeeShop
//
//  Created by Stephen Wai on 10/14/12.
//
//

#import "UINavigationBar+CustomImage.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar (CustomImage)

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed: @"navbarbg.png"];
    [image drawInRect:CGRectMake(0, 0, 320, 44)];
}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    [self applyDefaultStyle];
}

- (void)applyDefaultStyle
{
    // add the drop shadow
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0.0, 3);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
}

@end
