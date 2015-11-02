//
//  LJPlayingViewController.m
//  01-刘静的音乐
//
//  Created by 刘静 on 15/11/2.
//  Copyright © 2015年 liujing.cn. All rights reserved.
//

#import "LJPlayingViewController.h"
#import "UIView+AdjustFrame.h"
@interface LJPlayingViewController ()

@end

@implementation LJPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be ..recreated.
}

-(void)show{
// 1.拿到window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 2.设置view的frame
    self.view.frame = window.bounds;
    
    // 3.将自身的view添加到window上
    [window addSubview:self.view];

    // 4. 给self.view添加动画
    self.view.y =self.view.height;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = 0;
    }];

}
@end
