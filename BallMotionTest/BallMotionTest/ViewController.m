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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.yuanView];
    [self.view addSubview:self.ballView];
    
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
                CGFloat pointX = self.view.center.x + accelerometerData.acceleration.x * _velocity;
                CGFloat pointY = self.view.center.y - accelerometerData.acceleration.y * _velocity;
                
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
                //更新眼睛位置
                self.ballView.center = CGPointMake(pointX, pointY);
                //半径
                CGFloat r = self.yuanView.frame.size.width / 2 - self.ballView.bounds.size.width / 2;
                //圆点
                CGPoint center = CGPointMake(self.yuanView.frame.size.width / 2, self.yuanView.frame.size.width / 2);
                //当前眼睛中心点
                CGPoint currentPoint = self.ballView.center;
                
                UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.ballView.bounds.size.width / 2, self.ballView.bounds.size.width / 2, self.yuanView.frame.size.width  - self.ballView.bounds.size.width , self.yuanView.frame.size.width - self.ballView.bounds.size.width)];
                //判断眼睛是否在圆内
                if (CGPathContainsPoint(path.CGPath, NULL, self.ballView.center, NO)) {
                    
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


- (UIView *)yuanView{
    if (!_yuanView) {
        _yuanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        _yuanView.center = self.view.center;
        _yuanView.backgroundColor = [UIColor whiteColor];
        _yuanView.layer.cornerRadius = 100;
        _yuanView.layer.masksToBounds = YES;
        _yuanView.layer.borderWidth = 5.0;
        _yuanView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _yuanView;
}

- (UIView *)ballView{
    if (!_ballView) {
        _ballView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _ballView.center = self.view.center;
        _ballView.layer.cornerRadius = 20;
        _ballView.layer.masksToBounds = YES;
        _ballView.backgroundColor = [UIColor greenColor];
    }
    return _ballView;
}

@end
