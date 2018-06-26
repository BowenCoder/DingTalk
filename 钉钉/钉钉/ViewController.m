//
//  ViewController.m
//  钉钉
//
//  Created by Bowen on 2017/8/22.
//  Copyright © 2017年 BowenCoder. All rights reserved.
//

#import "ViewController.h"
#import "CoordinateTransformation.h"

@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.title = @"钉钉打卡";
        
    //116.323035,39.975664
    CLLocationCoordinate2D coor = [CoordinateTransformation gcj02ToWgs84:CLLocationCoordinate2DMake(39.951145, 116.277982)];
    NSLog(@"转换坐标:(%f,%f)",coor.latitude,coor.longitude);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 300, 40)];
    label.backgroundColor = [UIColor grayColor];
    label.text = [NSString stringWithFormat:@"坐标:(%f,%f)",coor.latitude,coor.longitude];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = self.view.center;
    [self.view addSubview:label];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, 100, 100, 40)];
    [btn setTitle:@"定位" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(findMe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 150, self.view.frame.size.height - 150, 300, 40)];
    _label.backgroundColor = [UIColor grayColor];
    _label.text = @"位置(0,0)";
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
}

- (void)findMe
{
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"requestAlwaysAuthorization");
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
    NSLog(@"start gps");
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"定位坐标:(%f,%f)", coordinate.latitude, coordinate.longitude);
    _label.text = [NSString stringWithFormat:@"位置:(%f,%f)",coordinate.latitude,coordinate.longitude];

    // 2.停止定位
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}




@end
