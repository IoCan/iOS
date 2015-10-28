//
//  CircularProgressView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/20.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "CircularProgressView.h"


//最大的 121 211 202
@interface CircularProgressView ()

@property (nonatomic) NSTimer *timer;

@property (assign, nonatomic) CGFloat angle;//angle between two lines

@end

@implementation CircularProgressView

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth
          audioPath:(NSString *)path {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _progressColor = progressColor;
        _lineWidth = lineWidth;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //draw background circle
//    UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2)
//                                                              radius:(CGRectGetWidth(self.bounds) - self.lineWidth) / 2
//                                                          startAngle:(CGFloat) - M_PI_2
//                                                            endAngle:(CGFloat)(1.5 * M_PI)
//                                                           clockwise:YES];
//    [self.backColor setStroke];
//    backCircle.lineWidth = self.lineWidth;
//    [backCircle stroke];
    
    if (self.progress) {
        //draw progress circle
        CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2);
        CGFloat radius = (CGRectGetWidth(self.bounds) - self.lineWidth) / 2;
        CGFloat startAngle = (CGFloat) - M_PI_2;
        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:center
                                                                      radius:radius
                                                                  startAngle:startAngle
                                                                    endAngle:(CGFloat)(- M_PI_2 + self.progress * 2 * M_PI)
                                                                   clockwise:YES];
//        [self.progressColor setStroke];
        [RGBA(143, 245, 238, 0.45) setStroke];
        progressCircle.lineWidth = self.lineWidth;
        [progressCircle stroke];
        
        CGFloat lineWidth1 = 2;
        CGFloat radius2 = (CGRectGetWidth(self.bounds) - 2) / 2;
        UIBezierPath *progressCircle2 = [UIBezierPath bezierPathWithArcCenter:center
                                                                       radius:radius2
                                                                  startAngle:startAngle
                                                                    endAngle:(CGFloat)(- M_PI_2 + self.progress * 2 * M_PI)
                                                                   clockwise:YES];
        [RGBA(143, 245, 238, 0.8) setStroke];
        progressCircle2.lineWidth = lineWidth1;
        [progressCircle2 stroke];
//        UIImage *image = [self image:[UIImage imageNamed:@"zhizhen.png"] rotation:UIImageOrientationLeft];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhizhen2.png"]];
        imgView.frame = CGRectMake(self.height/2-74, self.width/2-74, 148, 148);
        imgView.tag = 22;
        
       
        [self addSubview:imgView];
        CGAffineTransform transform =CGAffineTransformMakeRotation((CGFloat)( self.progress * 2 * M_PI));
        imgView.transform = transform;
    }
}

-(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


#pragma mark AVAudioPlayerDelegate method
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        //invalid timer
        [self.timer invalidate];
        //restore progress value
        self.progress = 0;
        //self redraw
        [self setNeedsDisplay];
        [self.delegate playerDidFinishPlaying];
    }
}




//calculate angle between start to point
- (CGFloat)angleFromStartToPoint:(CGPoint)point{
    CGFloat angle = [self angleBetweenLinesWithLine1Start:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2) Line1End:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2 - 1) Line2Start:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2) Line2End:point];
    if (CGRectContainsPoint(CGRectMake(0, 0, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)), point)) {
        angle = 2 * M_PI - angle;
    }
    return angle;
}


//calculate angle between 2 lines
- (CGFloat)angleBetweenLinesWithLine1Start:(CGPoint)line1Start
                                  Line1End:(CGPoint)line1End
                                Line2Start:(CGPoint)line2Start
                                  Line2End:(CGPoint)line2End{
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    return acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
}


- (CAGradientLayer *)shadowAsInverse
{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = CGRectMake(0, 0, 320, self.frame.size.height);
    newShadow.frame = newShadowFrame;
    //添加渐变的颜色组合
    newShadow.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor blackColor].CGColor,nil];
    return newShadow;
}
@end
