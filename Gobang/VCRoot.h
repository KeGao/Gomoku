//
//  VCRoot.h
//  Gobang
//
//  Created by Gao on 14-8-26.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCRoot : UIViewController <UIAlertViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *_allChess;
    UIImageView *_bgView;
    BOOL _isBlack;
    BOOL _isStart;
    BOOL _isWin;
    //保存当前棋子的坐标x,y值
    int x;
    int y;
    //保存设置游戏时间
    UITextField *_TF;
    //设置游戏时间界面
    UIView *_setTimeView;
    //设置的最大时间
    int maxTime;
    //黑,白方剩余时间
    int blackLeftTime;
    int whiteLeftTime;
    //定时器
    NSTimer *_timer;
}

@property (retain, nonatomic)UILabel *gameInfo;
@property (retain, nonatomic)UILabel *winInfo;
@property (retain, nonatomic)UILabel *blackTime;
@property (retain, nonatomic)UILabel *whiteTime;


@end
