//
//  ViewController.m
//  BallMotionTest
//
//  Created by lingbao on 2017/7/12.
//  Copyright © 2017年 galaxy. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface ViewController ()
@property (nonatomic , strong) UIView *yuanView;
@property (nonatomic , strong) UIView *ballView;
@property (nonatomic, strong) CMMotionManager *motionManager;
//初始速度 默认为10 初始速度越大移动越快
@property (nonatomic, assign) CGFloat velocity;

@property (nonatomic , assign) BOOL isInside;
@property (nonatomic , strong) UIBezierPath *path;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.velocity = 20;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.yuanView];
    [self.yuanView addSubview:self.ballView];

    UIColor *color = [UIColor redColor];
    [color set];//设置线条颜色
    
    _path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.ballView.bounds.size.width / 2, self.ballView.bounds.size.width / 2, self.yuanView.frame.size.width  - self.ballView.bounds.size.width , self.yuanView.frame.size.width - self.ballView.bounds.size.width)];
    
    
    [self createMotion];
    
}

- (void)createMotion{
    _motionManager = [[CMMotionManager alloc]init];
    
    //加速计是否可用
    if ([_motionManager isAccelerometerAvailable]) {
        //设置更新频率0.01为100HZ
        _motionManager.accelerometerUpdateInterval = 0.01;

        //加速度计开始更新
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            if (!error) {
                CGFloat pointX = self.ballView.center.x + accelerometerData.acceleration.x * _velocity;
                CGFloat pointY = self.ballView.center.y - accelerometerData.acceleration.y * _velocity;
                
                if (pointX < self.ballView.bounds.size.width / 2) {
                    pointX = self.ballView.bounds.size.width / 2;
                } else if(pointX > self.yuanView.frame.size.width - self.ballView.bounds.size.width / 2){
                    pointX = self.yuanView.frame.size.width - self.ballView.bounds.size.width / 2;
                }
                if (pointY < self.ballView .bounds.size.height / 2) {
                    pointY = self.ballView.bounds.size.height / 2;
                }else if (pointY > self.yuanView.frame.size.height - self.ballView.bounds.size.height / 2){
                    pointY = self.yuanView.frame.size.height - self.ballView.bounds.size.height / 2;
                }
                //更新位置
                self.ballView.center = CGPointMake(pointX, pointY);
                //半径
                CGFloat r = self.yuanView.frame.size.width / 2 - self.ballView.bounds.size.width / 2;
                //圆点
                CGPoint center = CGPointMake(self.yuanView.frame.size.width / 2, self.yuanView.frame.size.width / 2);
                //当前中心点
                CGPoint currentPoint = self.ballView.center;
                
                //判断是否在圆内
                if (CGPathContainsPoint(_path.CGPath, NULL, self.ballView.center, NO)) {
                    
                }else{
                    //获取当前点与圆点之间的距离
                    CGFloat distance = sqrt(pow(center.x - currentPoint.x, 2) + pow(currentPoint.y - center.y, 2));
                    
                    CGFloat x = center.x - r / distance * (center.x - currentPoint.x);
                    CGFloat y = center.y + r / distance * (currentPoint.y - center.y);
                    
                    self.ballView.center = CGPointMake(x, y);
                }
            }
        }];
    }
}



#pragma mark ---------------touch ---------------------/
//上层调用。
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.yuanView];
    //将self中的点转换成myView上的点。进行一个坐标系统的转换。
    touchPoint = [self.yuanView convertPoint:touchPoint toView:self.ballView];
    // 判断一个点的坐标是否在myView上。
    _isInside = [self.ballView pointInside:touchPoint withEvent:event];
    if (_isInside) {
        [UIView animateWithDuration:.2 animations:^{
            self.ballView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_isInside) {

        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.yuanView];

        //获取到触摸移动前的点的坐标。
        CGPoint previousPoint = [touch previousLocationInView:self.yuanView];
        float moveX = point.x - previousPoint.x;
        float moveY = point.y - previousPoint.y;
        
        CGRect frame = self.ballView.frame;
        frame.origin.x += moveX;
        frame.origin.y += moveY;
        self.ballView.frame = frame;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:.3 animations:^{
        self.ballView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark ---------------lazy ---------------------/
- (UIView *)yuanView{
    if (!_yuanView) {
        _yuanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 260)];
        _yuanView.center = self.view.center;
        _yuanView.backgroundColor = [UIColor whiteColor];
        _yuanView.layer.cornerRadius = _yuanView.frame.size.width/2.0;
        _yuanView.layer.masksToBounds = YES;

    }
    return _yuanView;
}

- (UIView *)ballView{
    if (!_ballView) {
        _ballView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _ballView.center = self.view.center;
        _ballView.layer.cornerRadius = _ballView.frame.size.width/2.0;
        _ballView.layer.masksToBounds = YES;
        _ballView.backgroundColor = [UIColor greenColor];
        
    }
    return _ballView;
}



@end
