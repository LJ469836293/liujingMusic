//
//  LJPlayingViewController.m
//  01-刘静的音乐
//
//  Created by 刘静 on 15/11/2.
//  Copyright © 2015年 liujing.cn. All rights reserved.
//

#import "LJPlayingViewController.h"
#import "UIView+AdjustFrame.h"
#import "LJMusicTool.h"
#import "LJMusic.h"
@interface LJPlayingViewController ()

//记录正在播放的音乐
@property(nonatomic, strong)LJMusic *playingMusic;

- (IBAction)exit;
// 音乐的lable
@property (weak, nonatomic) IBOutlet UILabel *songLable;
// 歌手的lable
@property (weak, nonatomic) IBOutlet UILabel *singerLable;
// 歌手的封面
@property (weak, nonatomic) IBOutlet UIImageView *singerIcon;

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

#pragma mark - 对控制器的操作
/**
 *  显示控制器
 */
-(void)show{
    // 0.判断音乐是否发生改变
    if (self.playingMusic && self.playingMusic != [LJMusicTool playingMusic]) {
        [self stopPlayingMusic];
    }
    
// 1.拿到window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    window.userInteractionEnabled = NO;
    
    // 2.设置view的frame
    self.view.frame = window.bounds;
    
    // 3.将自身的view添加到window上
    [window addSubview:self.view];

    // 4. 给self.view添加动画
    self.view.y =self.view.height;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = 0;
    }completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        
        // 开始播放音乐并且展示数据
        [self startPlayingMusic];
    }];

}
/**
 *  退出控制器
 */
- (IBAction)exit {
    // 1.拿到window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;

    // 2.执行动画退出
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = self.view.height;
    }completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
    
    
    
}

#pragma mark - 对音乐播放的控制
/**
 *  开始播放音乐
 */
-(void)startPlayingMusic{
// 1. 拿到正在播放的音乐
    LJMusic *playingMusic = [LJMusicTool playingMusic];
    
    if (playingMusic != self.playingMusic) {
        
        self.playingMusic = playingMusic;
        // 2. 设置界面数据
        
        self.songLable.text = playingMusic.name;
        self.singerLable.text = playingMusic.singer;
        self.singerIcon.image = [UIImage imageNamed:playingMusic.icon];
    }
    
}
/**
 *  停止播放音乐
 */
-(void)stopPlayingMusic{
// 1.清除界面数据
    self.songLable.text = nil;
    self.singerLable.text = nil;
    self.singerIcon.image = [UIImage imageNamed:@"play_cover_pic_bg"];


}

@end
