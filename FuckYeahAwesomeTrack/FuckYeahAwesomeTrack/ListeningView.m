//
//  ListeningView.m
//  FuckYeahAwesomeTrack
//
//  Created by Stefan Hintz on 07.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListeningView.h"
#import "CoreFoundation/CFArray.h"

@implementation ListeningView

@synthesize percent;

- (void) setPercent:(CGFloat)value
{
	if (value != percent)
	{
		percent = value;
		
		[self setNeedsDisplay];
	}
}

#define radians(degrees) ((degrees)*M_PI/180)

- (void)drawRect:(CGRect)rect
{
	//// General Declarations
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor *keyboardFocusIndicatorColor = [UIColor colorWithRed: 0.34 green: 0.62 blue: 0.83 alpha: 1];
	
	//// Gradient Declarations
	NSArray *gradientColors = [NSArray arrayWithObjects: 
							   (id)[UIColor whiteColor].CGColor, 
							   (id)[UIColor colorWithRed: 0.7 green: 0.81 blue: 0.92 alpha: 1].CGColor, 
							   (id)keyboardFocusIndicatorColor.CGColor, nil];
	CGFloat gradientLocations[] = {0, 0.36, 1};
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
	
	//// Shadow Declarations
	UIColor *shadow = [UIColor blackColor];
	CGSize shadowOffset = CGSizeMake(3, 3);
	CGFloat shadowBlurRadius = 7;
	
	//// Oval Drawing
//	UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 20, 20)];
	
	UIBezierPath *ovalPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.bounds.size.width/2 - 40 startAngle:0 endAngle:radians(percent) clockwise:YES];
	[ovalPath addLineToPoint:self.center];
	
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	CGContextBeginTransparencyLayer(context, NULL);
	[ovalPath addClip];
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(self.bounds.size.width, self.bounds.size.height), 0);
	CGContextEndTransparencyLayer(context);
	CGContextRestoreGState(context);
	
	//// Cleanup
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);	
}

@end
