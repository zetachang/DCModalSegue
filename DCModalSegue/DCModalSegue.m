//
//  DCModalSegue.m
//  DCSemiModalSegue
//
//  Created by zeta on 13/3/1.
//  Copyright (c) 2013年 zeta. All rights reserved.
//

#import "DCModalSegue.h"
#import <QuartzCore/QuartzCore.h>
#define kModalSeguePushedBackAnimationDuration 0.1
#define kModalSegueBringForwardAnimationDuration 0.3

@interface DCModalViewController : UIViewController

@property (nonatomic, strong) UIImageView* screenshot;
@property (nonatomic, strong) UIViewController* destinationController;
@property (nonatomic, strong) UIViewController* sourceController;

@end

@implementation DCModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.screenshot];
    [self.screenshot.layer addAnimation:[self animationGroupPushedBackward] forKey:nil];
    
    [UIView animateWithDuration:kModalSeguePushedBackAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
     self.screenshot.alpha = 0.7;
     } completion:^(BOOL finished) {
     [self presentViewController:self.destinationController animated:YES completion:nil];
     }];
}

- (void)oldDismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self.screenshot.layer addAnimation:[self animationGroupBringForward] forKey:nil];
    [UIView animateWithDuration:kModalSegueBringForwardAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.screenshot.alpha = 1.0;
    } completion:^(BOOL finished) {
        // Dismiss the presented / destination controller
        [super dismissViewControllerAnimated:YES completion:^{
            // And then dismiss DCModalViewController
            [self oldDismissViewControllerAnimated:NO completion:nil];
        }];
    }];
}

- (IBAction) modalDonePresenting: (UIStoryboardSegue*) segue {
    
}

#pragma mark Animation Group

-(CAAnimationGroup*)animationGroupPushedBackward {
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0 / -900;
    t1 = CATransform3DScale(t1, 0.90, 0.90, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = 1.0 / -900;
    t2 = CATransform3DTranslate(t2, 0.0, -20.0, 0.0);
    t2 = CATransform3DScale(t2, 0.85, 0.85, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
    animation.duration = 2 * kModalSeguePushedBackAnimationDuration / 3;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:t2];
    animation2.beginTime = animation.duration;
    animation2.duration = kModalSeguePushedBackAnimationDuration / 3;
    animation2.fillMode = kCAFillModeForwards;
    [animation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration * 2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}

-(CAAnimationGroup*)animationGroupBringForward {
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0 / -900;
    t1 = CATransform3DScale(t1, 0.90, 0.90, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
    animation.duration = kModalSegueBringForwardAnimationDuration / 2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation2.beginTime = animation.duration;
    animation2.duration = kModalSegueBringForwardAnimationDuration / 2;
    animation2.fillMode = kCAFillModeForwards;
    [animation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration * 2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}

@end

@implementation DCModalSegue

- (void)perform {
    DCModalViewController* modalVC = [[DCModalViewController alloc] init];
    modalVC.wantsFullScreenLayout = YES;
    
    modalVC.screenshot = [self screenshot];
    modalVC.destinationController = self.destinationViewController;
    modalVC.sourceController = self.sourceViewController;
    
    [self.sourceViewController presentViewController:modalVC animated:NO completion:nil];
}

// The code below is derived from
// Apple's Technical Q&A QA1703 (https://developer.apple.com/library/ios/#qa/qa1703/_index.html)
// Copyright is belongs to Apple Inc. 

- (UIImageView *)screenshot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView* screenshot = [[UIImageView alloc] initWithImage:image];
    screenshot.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    return screenshot;
}

@end
