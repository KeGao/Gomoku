//
//  ChessPiece.m
//  Gobang
//
//  Created by qianfeng on 14-8-27.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "ChessPiece.h"

@implementation ChessPiece

- (id)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(13, 13);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _myLayer = self.layer;
        _myLayer.cornerRadius = 6.5;
        _myLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _myLayer.borderWidth = 1.2;
        _myLayer.borderColor = [UIColor blackColor].CGColor;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
//    CGContextRef content = UIGraphicsGetCurrentContext();
//    
//    UIColor *colorFill = [UIColor whiteColor];
//    [colorFill setFill];
//    UIColor *colorLine = [UIColor blackColor];
//    [colorLine setStroke];
//    
//    CGContextStrokeEllipseInRect(content, CGRectMake(0, 0, 13, 13));
//    CGContextFillEllipseInRect(content, CGRectMake(0, 0, 13, 13));
}


@end
