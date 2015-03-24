//
//  EBCircleProgressBar.m
//  Isegoria
//
//  Created by Alan Gao on 24/03/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBCircleProgressBar.h"
#import "MyConstants.h"

@interface EBCircleProgressBar ()

@property (strong, nonatomic) CAShapeLayer *circle;
@end

@implementation EBCircleProgressBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat thickness = 5.0;
    
    float start_angle = 2*M_PI*0-M_PI_2;
    float end_angle = 2*M_PI*self.progress-M_PI_2;
    
    UIView *centerCircle = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + thickness,
                                                                    self.bounds.origin.y + thickness,
                                                                    self.bounds.size.width - 2 * thickness,
                                                                    self.bounds.size.height - 2 * thickness)];
    centerCircle.layer.cornerRadius = centerCircle.frame.size.width / 2;
    centerCircle.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:centerCircle];
    
    self.backgroundColor = ISEGORIA_CIRCLE_PROGRESS_GREY;
    self.layer.cornerRadius = self.frame.size.width / 2;
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)  radius:self.frame.size.width / 2 - thickness / 2 startAngle:start_angle endAngle:end_angle clockwise:YES].CGPath;
    
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = self.mainColor.CGColor;
    circle.lineWidth = thickness;
    circle.lineCap = kCALineCapRound;
    self.circle = circle;
    [self.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    drawAnimation.duration            = 1.0;
    drawAnimation.repeatCount         = 0.0;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];

}

- (void)animate
{

}

@end
