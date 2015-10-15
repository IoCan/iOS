//
//  CALayer+RuntimeAttribute.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/15.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//



@implementation CALayer (IBConfiguration)

-(void)setBorderIBColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderIBColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

-(void)setShadowIBColor:(UIColor*)color
{
    self.shadowColor = color.CGColor;
}

-(UIColor*)shadowIBColor
{
    return [UIColor colorWithCGColor:self.shadowColor];
}

@end
