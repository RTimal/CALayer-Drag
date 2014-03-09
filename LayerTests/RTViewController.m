//
//  RTViewController.m
//  LayerTests
//
//  Created by Rajiev Timal on 3/7/14.
//  Copyright (c) 2014 Rajiev. All rights reserved.
//

#import "RTViewController.h"

typedef NS_ENUM(NSInteger, LayerState){
	LayerStateResting,
	LayerStatePickedUp,
};

@interface RTViewController ()

@property (nonatomic , strong) CALayer *topLayer;
@property (nonatomic, assign) LayerState currentLayerState;
@property (nonatomic, assign) CGPoint oldPoint;

@end

@implementation RTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.topLayer = [CALayer layer];
	UIImage *appleImage = [UIImage imageNamed:@"applications-internet_full.png"];
	self.topLayer.contents = (__bridge id)([appleImage CGImage]);
	CATransform3D perspectiveTransform = CATransform3DIdentity;
	perspectiveTransform.m34 = -1/500.f;
	self.view.layer.sublayerTransform = perspectiveTransform;
	self.topLayer.position = CGPointMake(130.f,250.f);
	self.topLayer.bounds = CGRectMake(0.f, 0.f, 200.f,200.f);
	[self.view.layer insertSublayer:self.topLayer above:self.view.layer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	CGPoint location = [[touches anyObject] locationInView:self.view];
	self.oldPoint = location;
	
	if(CGRectContainsPoint(self.topLayer.frame, location))
	{
		self.currentLayerState = LayerStatePickedUp;
		[CATransaction begin];
		[CATransaction setAnimationDuration:.5f];
		self.topLayer.zPosition = 40.f;
		self.topLayer.transform = CATransform3DRotate(self.topLayer.transform, .1, 0.f, 1.f,0.f);
		[CATransaction setCompletionBlock:^{
			self.topLayer.zPosition = 40.f;
			self.topLayer.transform = CATransform3DRotate(self.topLayer.transform, .1, 0.f, 1.f,0.f);
		}];
		
		[CATransaction commit];
				
		CABasicAnimation *spinningAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
		[spinningAnimation setFromValue:@0];
		[spinningAnimation setToValue:@30];
		
		CABasicAnimation *spinningAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
		[spinningAnimation2 setFromValue:@0];
		[spinningAnimation2 setToValue:@30];
		
		CABasicAnimation *spinningAnimation3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		[spinningAnimation2 setFromValue:@0];
		[spinningAnimation2 setToValue:@30];
		
		CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
		[animationGroup setAnimations:@[spinningAnimation,spinningAnimation2, spinningAnimation3]];
		animationGroup.duration = 5.f;
		animationGroup.repeatCount = 1000000;
		[self.topLayer addAnimation:animationGroup forKey:@"spinXandYZ"];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	if(self.currentLayerState == LayerStatePickedUp)
	{
		[CATransaction begin];
		[CATransaction setAnimationDuration:.5f];
		self.topLayer.zPosition = -40.f;
		[CATransaction setCompletionBlock:^{
			self.topLayer.zPosition = -40.f;
			self.topLayer.transform = CATransform3DIdentity;
		}];
		[CATransaction commit];
	}
	self.currentLayerState = LayerStateResting;
	[self.topLayer removeAllAnimations];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	CGPoint location = [[touches anyObject] locationInView:self.view];
	if((self.currentLayerState == LayerStatePickedUp) && CGRectContainsPoint(self.topLayer.frame, location))
	{
		[CATransaction begin];
		[CATransaction setAnimationDuration:0.f];
		self.topLayer.position =  CGPointMake(self.topLayer.position.x + (location.x - self.oldPoint.x), self.topLayer.position.y + (location.y - self.oldPoint.y));
		[CATransaction commit];
		self.oldPoint = location;
	}
}

@end
