//
//  VCRoot.m
//  Gobang
//
//  Created by Gao on 14-8-26.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#import "VCRoot.h"
#import "FiveChessFrameView.h"
#import "ChessPiece.h"

@interface VCRoot ()

@end

@implementation VCRoot

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    maxTime = -1; //最大游戏时间 -1表示无限制
    _isStart = NO; //游戏是否开始
    // _allChess中保存全部棋子的状态
    // 其中数据内容  0：表示这个点并没有棋子， 1：表示这个点是黑子， 2：表示这个点是白子
    _allChess = [[NSMutableArray alloc] init];
    for (int i = 0; i < 17; i++) {
        for (int j = 0; j < 17; j++) {
            [_allChess addObject:@0];
        }
    }
    
    //背景视图
    _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    _bgView.frame = CGRectMake(0, 0, 320, 320);
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
    
    //棋盘界面视图
    FiveChessFrameView *view = [[FiveChessFrameView alloc] init];
    view.frame = CGRectMake(7, 34, 232, 242);
    view.backgroundColor = [UIColor colorWithRed:0.465 green:0.961 blue:1.000 alpha:1.000];
    [_bgView addSubview:view];
    
    //顶部显示游戏信息
    _gameInfo = [[UILabel alloc] initWithFrame:CGRectMake(80, 3, 160, 30)];
    _gameInfo.backgroundColor = [UIColor clearColor];
    _gameInfo.text = @"游戏还未开始!";
    _gameInfo.font = [UIFont systemFontOfSize:16];
    _gameInfo.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_gameInfo];
    
    //中间游戏结束视图
    _winInfo = [[UILabel alloc] initWithFrame:CGRectMake(23, 120, 200, 50)];
    _winInfo.font = [UIFont systemFontOfSize:18];
    _winInfo.textAlignment = NSTextAlignmentCenter;
    
    //底部倒计时视图
    _blackTime = [[UILabel alloc] initWithFrame:CGRectMake(14, 285, 128, 27)];
    _blackTime.backgroundColor = [UIColor clearColor];
    _blackTime.text = @"黑方时间: 无限制";
    _blackTime.font = [UIFont systemFontOfSize:16];
    _blackTime.textAlignment = NSTextAlignmentCenter;
    _whiteTime = [[UILabel alloc] initWithFrame:CGRectMake(157, 285, 128, 27)];
    _whiteTime.text = @"白方时间: 无限制";
    _whiteTime.font = [UIFont systemFontOfSize:16];
    _whiteTime.textAlignment = NSTextAlignmentCenter;
    _whiteTime.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_blackTime];
    [_bgView addSubview:_whiteTime];
    
    
    //开始按钮
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startBtn.frame = CGRectMake(258, 34, 46, 20);
    [startBtn addTarget:self action:@selector(gameStart) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:startBtn];
    
    //游戏设置按钮
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setBtn.frame = CGRectMake(258, 68, 46, 20);
    [setBtn addTarget:self action:@selector(setMaxTime) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:setBtn];
    
    //游戏说明按钮
    UIButton *explainBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    explainBtn.frame = CGRectMake(258, 101, 46, 20);
    [explainBtn addTarget:self action:@selector(explainRule) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:explainBtn];
    
    //认输按钮
    UIButton *giveUpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    giveUpBtn.frame = CGRectMake(258, 170, 46, 20);
    [giveUpBtn addTarget:self action:@selector(giveUp) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:giveUpBtn];
    
    //关于按钮
    UIButton *aboutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    aboutBtn.frame = CGRectMake(258, 203, 46, 20);
    [aboutBtn addTarget:self action:@selector(aboutInfo) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:aboutBtn];
    
    //退出按钮
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exitBtn.frame = CGRectMake(258, 236, 46, 20);
    [exitBtn addTarget:self action:@selector(exitGame) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:exitBtn];
    
}
//游戏开始
- (void)gameStart
{
    if (!_isStart) {
        NSLog(@"GameStart!");
        _gameInfo.text = @"游戏开始:  黑方先行!";
        _isStart = YES;
        _isBlack = YES;
        _isWin = NO;
        
        //如果设置的时间为0 表示无限制
        if ([_TF.text intValue]==0) {
            maxTime = -1;
            _blackTime.text = @"黑方时间: 无限制";
            _whiteTime.text = @"白方时间: 无限制";
        }
        else
        {
            maxTime = [_TF.text intValue];
            _blackTime.text = [NSString stringWithFormat:@"黑方时间:  %02d:%02d",maxTime,0];
            _whiteTime.text = [NSString stringWithFormat:@"白方时间:  %02d:%02d",maxTime,0];
        }
        //还原棋子状态
        for (int i = 0; i < 17; i++) {
            for (int j = 0; j < 17; j++) {
                [_allChess replaceObjectAtIndex:17*i+j withObject:@0];
            }
        }
        //重新铺棋盘界面
        FiveChessFrameView *view = [[FiveChessFrameView alloc] init];
        view.frame = CGRectMake(7, 34, 232, 242);
        view.backgroundColor = [UIColor colorWithRed:0.465 green:0.961 blue:1.000 alpha:1.000];
        [_bgView addSubview:view];
        
        //如果时间不是无限制 开启定时器 黑方时间开始减少
        if (maxTime != -1) {
            //获得黑白方的剩余时间 初始为最大时间
            blackLeftTime = maxTime*60;
            whiteLeftTime = maxTime*60;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun:) userInfo:@"black" repeats:YES];
        }
    }
}
//定时器运行 时间减少
- (void)timeRun:(NSTimer *)timer
{
    if ([timer.userInfo isEqualToString:@"black"]) {
        blackLeftTime--;
    }
    else
        whiteLeftTime--;
    //实时显示时间
    _blackTime.text = [NSString stringWithFormat:@"黑方时间:  %02d:%02d",blackLeftTime/60,blackLeftTime-blackLeftTime/60*60];
    _whiteTime.text = [NSString stringWithFormat:@"白方时间:  %02d:%02d",whiteLeftTime/60,whiteLeftTime-whiteLeftTime/60*60];
    //当时间为0 游戏结束
    if (blackLeftTime == 0) {
        [_timer invalidate]; //关闭定时器
        //显示游戏结束信息
        _winInfo.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.600];
        _winInfo.text = @"黑方超时,白方获胜!";
        _gameInfo.text = @"游戏结束,白方获胜!";
        _isStart = NO;
        [_bgView addSubview:_winInfo];
    }
    else if (whiteLeftTime == 0) {
        [_timer invalidate];
        _winInfo.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.600];
        _winInfo.text = @"白方超时,黑方获胜!";
        _gameInfo.text = @"游戏结束,黑方获胜!";
        _isStart = NO;
        [_bgView addSubview:_winInfo];
    }
}
//设置最大时间
- (void)setMaxTime
{
    NSLog(@"setMaxTime!");
    _setTimeView = [[UIView alloc] init];
    _setTimeView.frame = CGRectMake(20, 70, 250, 110);
    _setTimeView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_setTimeView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 10, 220, 30);
    label.text = @"请输入游戏的最大时间(单位:分钟),如果输入0,表示没有时间限制!";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    [_setTimeView addSubview:label];
    
    _TF = [[UITextField alloc] init];
    _TF.frame = CGRectMake(15, 45, 220, 30);
    _TF.borderStyle = UITextBorderStyleBezel;
    _TF.placeholder = @"请输入游戏最大时间(0~10)";
    _TF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _TF.clearsOnBeginEditing = YES;
    _TF.returnKeyType = UIReturnKeyDone;
    _TF.delegate = self;
    [_setTimeView addSubview:_TF];
    //确定按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(140, 80, 50, 25);
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor colorWithWhite:0.799 alpha:1.000];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pressBtn) forControlEvents:UIControlEventTouchUpInside];
    [_setTimeView addSubview:btn];
    //取消按钮
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCancel.frame = CGRectMake(60, 80, 50, 25);
    btnCancel.layer.cornerRadius = 5;
    btnCancel.backgroundColor = [UIColor colorWithWhite:0.799 alpha:1.000];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(pressBtnCancel) forControlEvents:UIControlEventTouchUpInside];
    [_setTimeView addSubview:btnCancel];
}
//输入完成收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//点击确定按钮事件
- (void)pressBtn
{
    //收回键盘
    [_TF resignFirstResponder];
    //如果输入的是0到10的数
    if (_TF.text.length != 0 && [_TF.text intValue] >=0 && [_TF.text intValue] <= 10) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置时间完成,是否重新开始游戏!" delegate:self cancelButtonTitle:@"取消设置" otherButtonTitles:@"OK", nil];
        [alert show];
        //关闭设置时间界面
        [_setTimeView removeFromSuperview];
    }
    else {
        //输入错误
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"设置时间无效,请输入0~10的数!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
//点击取消按钮事件
- (void)pressBtnCancel
{
    //收回键盘
    [_TF resignFirstResponder];
    //关闭设置时间界面
    [_setTimeView removeFromSuperview];
}

//模态视图代理协议函数
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //cancelButton的索引值为0
    if (buttonIndex == 0) {
        
    }
    else //点击确定设置
    {
        //关闭定时器
        [_timer invalidate];
        if (alertView.tag == 101) {
            _winInfo.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.600];
            _winInfo.text = [NSString stringWithFormat:@"%@方认输,%@方获胜!",_isBlack?@"黑":@"白",_isBlack?@"白":@"黑"];
            _gameInfo.text = [NSString stringWithFormat:@"游戏结束,%@方获胜!",_isBlack?@"白":@"黑"];
            _isStart = NO;
            [_bgView addSubview:_winInfo];
        }
        else
        {
            //如果设置的时间为0 表示无限制
            if ([_TF.text intValue]==0) {
                maxTime = -1;
                _blackTime.text = @"黑方时间: 无限制";
                _whiteTime.text = @"白方时间: 无限制";
            }
            else
            {
                maxTime = [_TF.text intValue];
                _blackTime.text = [NSString stringWithFormat:@"黑方时间:  %02d:%02d",maxTime,0];
                _whiteTime.text = [NSString stringWithFormat:@"白方时间:  %02d:%02d",maxTime,0];
            }
            //还原棋子状态
            for (int i = 0; i < 17; i++) {
                for (int j = 0; j < 17; j++) {
                    [_allChess replaceObjectAtIndex:17*i+j withObject:@0];
                }
            }
            //重新铺棋盘界面
            FiveChessFrameView *view = [[FiveChessFrameView alloc] init];
            view.frame = CGRectMake(7, 34, 232, 242);
            view.backgroundColor = [UIColor colorWithRed:0.465 green:0.961 blue:1.000 alpha:1.000];
            [_bgView addSubview:view];
            _isStart = NO;
            _gameInfo.text = @"游戏还未开始!";
        }
    }
}
//游戏说明按钮事件函数
- (void)explainRule
{
    NSLog(@"explainRule!");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"游戏说明" message:@"黑白双方轮流下棋，当某一方连到五子或倒计时为0时，游戏结束。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
//认输按钮事件函数
- (void)giveUp
{
    NSLog(@"giveUp!");
    if (_isStart) {
        NSString *str = [NSString stringWithFormat:@"是否确定认输,认输后%@方将获得胜利。",_isBlack?@"白":@"黑"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 101;
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"游戏还未开始!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
//关于按钮事件函数
- (void)aboutInfo
{
    NSLog(@"aboutInfo!");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"关于" message:@"这是一个五子棋游戏程序。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
//退出按钮事件函数
- (void)exitGame
{
    NSLog(@"exitGame!");
    if (_isStart) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定要退出游戏!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"游戏还未开始!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
       
        //如果设置的时间为0 表示无限制
        if ([_TF.text intValue]==0) {
            maxTime = -1;
            _blackTime.text = @"黑方时间: 无限制";
            _whiteTime.text = @"白方时间: 无限制";
        }
        else
        {
            maxTime = [_TF.text intValue];
            _blackTime.text = [NSString stringWithFormat:@"黑方时间:  %02d:%02d",maxTime,0];
            _whiteTime.text = [NSString stringWithFormat:@"白方时间:  %02d:%02d",maxTime,0];
        }
        //还原棋子状态
        for (int i = 0; i < 17; i++) {
            for (int j = 0; j < 17; j++) {
                [_allChess replaceObjectAtIndex:17*i+j withObject:@0];
            }
        }
        //重新铺棋盘界面
        FiveChessFrameView *view = [[FiveChessFrameView alloc] init];
        view.frame = CGRectMake(7, 34, 232, 242);
        view.backgroundColor = [UIColor colorWithRed:0.465 green:0.961 blue:1.000 alpha:1.000];
        [_bgView addSubview:view];
        _isStart = NO;
        _gameInfo.text = @"游戏还未开始!";
    }
}

//画棋子
- (void)drawFrame
{
    for (int i = 0; i < 17; i++) {
        for (int j = 0; j < 17; j++) {
            int value = [_allChess[17*i+j] intValue];
            if (value != 0) {
                ChessPiece *cp = [[ChessPiece alloc] initWithFrame:CGRectMake(0.5+j*14.5, 27.5+i*15.1, 13, 13)];
                cp.myLayer.backgroundColor = (value==1?[UIColor blackColor].CGColor:[UIColor whiteColor].CGColor);
                [_bgView addSubview:cp];
            }
        }
    }
}

//当手指离开屏幕时触发此函数
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isStart) {
        //获得点击操作对象
        UITouch *touch = [touches anyObject];
        //获得鼠标点击的坐标
        CGPoint pt = [touch locationInView:_bgView];
        if (pt.x<7||pt.x>239||pt.y<34||pt.y>275.7) {
            return;
        }
//        NSLog(@"x = %f,y = %f",pt.x,pt.y);
        float x1 = (pt.x-7)/14.5;
        float y1 = (pt.y-34)/15.1;
        x = (pt.x-7)/14.5;
        y = (pt.y-34)/15.1;
        if (x1-x >= 0.5) {
            x++;
        }
        if (y1-y >= 0.5) {
            y++;
        }
        if ([_allChess[17*y+x] intValue]!=0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"当前位置已经有棋子，请重新落子！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else{
            if (_isBlack) {
                [_allChess replaceObjectAtIndex:17*y+x withObject:@1];
                if (maxTime != -1) {
                    [_timer invalidate];
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun:) userInfo:@"white" repeats:YES];
                }
                _gameInfo.text = @"游戏信息:  轮到白方!";
            }
            else{
                [_allChess replaceObjectAtIndex:17*y+x withObject:@2];
                if (maxTime != -1) {
                    [_timer invalidate];
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun:) userInfo:@"black" repeats:YES];
                }
                _gameInfo.text = @"游戏信息:  轮到黑方!";
            }
            //重绘棋盘上的棋子
            [self drawFrame];
            //每走一步判断是否可以胜利
            [self checkWin];
            if (_isWin) {
                [_timer invalidate];
                _winInfo.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.600];
                _winInfo.text = [NSString stringWithFormat:@"%@棋五子连珠,%@方获胜!",_isBlack?@"黑":@"白",_isBlack?@"黑":@"白"];
                _gameInfo.text = [NSString stringWithFormat:@"游戏结束,%@方获胜!",_isBlack?@"黑":@"白"];
                _isStart = NO;
                [_bgView addSubview:_winInfo];
            }
            //轮换下一方下子
            _isBlack = !_isBlack;
        }
    }
}
//判断是否胜利
- (void)checkWin
{
    //用来保存共有多少棋子相连
    int count = 1;
    //记录当前下的这个子的颜色 (1黑色 2白色)
    int color = _isBlack?1:2;
    
    //判断横向(x每次改变1)
    //参数一:x方向改变值
    //参数二:y方向改变值
    //参数三:当前落下的棋子的颜色
    //参数一和参数二用于控制遍历的方向
    count = [self checkCount:1 :0 :color];
    if (count >= 5) {
        _isWin = YES;
    }else{
        //判断纵向(y每次改变1)
        count = [self checkCount:0 :1 :color];
        if (count >= 5) {
            _isWin = YES;
        }else{
            //判断右上左下对角线(x每次改变1,y每次相对x反向改变1)  x加1 y就减1
            count = [self checkCount:1 :-1 :color];
            if (count >= 5) {
                _isWin = YES;
            }else{
                //判断右下左上对角线(x每次改变1,y每次相对x正向改变1) x加1 y也加1
                count = [self checkCount:1 :1 :color];
                if (count >= 5) {
                    _isWin = YES;
                }
            }
        }
    }
}
//返回相同颜色棋子相连的个数
- (int)checkCount:(int)xChange :(int)yChange :(int)color
{
    //相同颜色相连棋子个数 以当前落下的棋子为基准 起始为1(就是落下的那个棋子本身)
    int count = 1;
    //将传进来的值保存起来 用于控制方向的
    int tempX = xChange;
    int tempY = yChange;
    //以当前落下的棋子为起始点 往一个方向进行遍历(遇到边界或棋子颜色不同了停下)
    while (x+xChange >= 0 && x+xChange < 17 && y+yChange >= 0 && y+yChange < 17 && color == [_allChess[17*(y+yChange)+x+xChange] intValue]) {
        count++; //相同颜色相连计数加1
        //控制方向 每次遇到同色相连的棋子就往传入的方向加一个位置继续判断
        if (xChange != 0)
            xChange++;
        if (yChange != 0) {
            if (yChange > 0)
                yChange++;
            else
                yChange--;
        }
    }
    //还原传入的值,重新开始判断
    xChange = tempX;
    yChange = tempY;
    //以当前落下的棋子为起始点 往与之前相反方向进行遍历(遇到边界或棋子颜色不同了停下)
    while (x-xChange >= 0 && x-xChange < 17 && y-yChange >= 0 && y-yChange <17 && color == [_allChess[17*(y-yChange)+x-xChange] intValue]) {
        count++;
        if (xChange != 0)
            xChange++;
        if (yChange != 0) {
            if (yChange > 0)
                yChange++;
            else
                yChange--;
        }
    }
    //返回以当前棋子为中心往两边遍历累加的count值
    //使用两边分别遍历考虑到当前落下的子可能是五子连珠中的任意一个(不一定是边缘)
    return count;
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
