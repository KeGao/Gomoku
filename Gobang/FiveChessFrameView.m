//
//  FiveChessFrameView.m
//  Gobang
//
//  Created by qianfeng on 14-8-27.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "FiveChessFrameView.h"

@implementation FiveChessFrameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //创建画布
    CGContextRef content = UIGraphicsGetCurrentContext();
    //设置连线颜色和填充颜色
    UIColor *colorLine = [UIColor blackColor];
    [colorLine setStroke];
    UIColor *colorFill = [UIColor blackColor];
    [colorFill setFill];
    //画棋盘
    for (int i = 0; i < 17; i++) {
        //横向画线
        CGContextMoveToPoint(content, 14.5*i, 0);
        CGContextAddLineToPoint(content, 14.5*i, 242);
        CGContextStrokePath(content);
        //纵向画线
        CGContextMoveToPoint(content, 0, 15.1*i);
        CGContextAddLineToPoint(content, 232, 15.1*i);
        CGContextStrokePath(content);
    }
    //标注四个角的点位
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            CGContextFillEllipseInRect(content, CGRectMake((2.8+10*j)*14.5, (2.8+10*i)*15.1, 14.5*0.4, 15.1*0.4));
        }
    }
    //标注中心点位(天元)
    CGContextFillEllipseInRect(content, CGRectMake(7.8*14.5, 7.8*15.1, 14.5*0.4, 15.1*0.4));
}


@end
