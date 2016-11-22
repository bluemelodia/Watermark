//
//  UIImageBorder.m
//  Automark
//
//  Created by Melanie Hsu on 11/22/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//  Source: http://stackoverflow.com/questions/27395497/add-white-border-to-uiimage

#import "UIImageBorder.h"

@implementation UIImage (Bordered)

-(UIImage *)imageBorderedWithColor:(UIColor *)color borderWidth:(CGFloat)width
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawAtPoint:CGPointZero];
    [color setStroke];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    path.lineWidth = width;
    [path stroke];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
