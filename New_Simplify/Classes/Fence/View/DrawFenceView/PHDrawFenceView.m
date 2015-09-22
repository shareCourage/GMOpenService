//
//  PHDrawFenceView.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/7.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHDrawFenceView.h"

@interface PHDrawFenceView ()

@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, strong) NSMutableArray *points;

@end

@implementation PHDrawFenceView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (void)awakeFromNib
{
    //create a mutable path
    self.path = [[UIBezierPath alloc] init];
    //configure the layer
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = 3;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    //move the path drawing cursor to the starting point
    [self.path moveToPoint:point];
    if ([self.delegate respondsToSelector:@selector(drawFenceView:touchesBegan:)]) {
        [self.delegate drawFenceView:self touchesBegan:point];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the current point
    CGPoint point = [[touches anyObject] locationInView:self];
    //add a new line segment to our path
    [self.path addLineToPoint:point];
    //update the layer with a copy of the path
    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
    if ([self.delegate respondsToSelector:@selector(drawFenceView:touchesMoved:)]) {
        [self.delegate drawFenceView:self touchesMoved:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    if ([self.delegate respondsToSelector:@selector(drawFenceView:touchesEnded:)]) {
        [self.delegate drawFenceView:self touchesEnded:point];
    }
}
- (void)removeShapelayer {
    [self.path removeAllPoints];
    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
}

@end
