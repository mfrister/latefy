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
@synthesize sizeFactor;

- (void) setPercent:(CGFloat)value
{
	if (value != percent)
	{
		percent = value;
		
		[self setNeedsDisplay];
	}
}

- (void) setSizeFactor:(CGFloat)value
{
	if (value != sizeFactor)
	{
		sizeFactor = value;
		
		[self setNeedsDisplay];
	}
}

/* needs CALayer
 
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"percent"])
	{
        return YES;
    }

	return [super needsDisplayForKey:key];
}
*/

#define radians(degrees) ((degrees)*M_PI/180)

- (void)drawRect:(CGRect)rect
{
	//// General Declarations
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();

	//// Gradient Declarations
	NSArray *gradientColors = [NSArray arrayWithObjects: 
							   (id)[UIColor colorWithRed: 0.651 green: 0.0 blue: 0.051 alpha: 1].CGColor,
							   (id)[UIColor colorWithRed: 1.0 green: 0.0 blue: 0.0 alpha: 1].CGColor, nil];
	CGFloat gradientLocations[] = {0, 1};
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);

	//// Oval Drawing
	UIBezierPath *ovalPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width/2 - 40) * sizeFactor startAngle:radians(-90) endAngle:radians(percent*3.6-90) clockwise:YES];
	[ovalPath addLineToPoint:self.center];

	CGContextSaveGState(context);
	CGContextBeginTransparencyLayer(context, NULL);
	[ovalPath addClip];
	CGContextDrawRadialGradient(context, gradient, self.center, self.bounds.size.width/2, self.center, 0, 0);
//	LinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(self.bounds.size.width, self.bounds.size.height), 0);
	CGContextEndTransparencyLayer(context);
	CGContextRestoreGState(context);
	
	//// Cleanup
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);	
}

@end
