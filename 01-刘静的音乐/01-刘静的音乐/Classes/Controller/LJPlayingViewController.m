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
#import "LJAudioTool.h"
#import "LJLrcView.h"
@interface LJPlayingViewController ()<AVAudioPlayerDelegate>
//进度的定时器
@property(nonatomic,strong)NSTimer *progressTimer;
//歌词的定时器
@property(nonatomic,strong)CADisplayLink *lrcTimer;

//记录正在播放的音乐
@property(nonatomic, strong)LJMusic *playingMusic;

@property(nonatomic,strong)AVAudioPlayer *player;


// 音乐的lable
@property (weak, nonatomic) IBOutlet UILabel *songLable;
// 歌手的lable
@property (weak, nonatomic) IBOutlet UILabel *singerLable;
// 歌手的封面
@property (weak, nonatomic) IBOutlet UIImageView *singerIcon;
// 音乐总时长
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

//拖拽按钮
@property (weak, nonatomic) IBOutlet UIButton *sliderButton;

//拖拽按钮与左边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *silderLeftConstraint;

// 显示时间的Label
@property (weak, nonatomic) IBOutlet UILabel *showTimeLable;

//播放或暂停的按钮
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet LJLrcView *LrcView;

/**
 *  进度条背景点击
 */
- (IBAction)tapProgressBackground:(UITapGestureRecognizer *)sender;
/**
 *  拖拽滑块按钮
 */
- (IBAction)panSliderButton:(UIPanGestureRecognizer *)sender;
/**
 *  播放或暂停按钮的点击
 */
- (IBAction)playOrPauseButtonClick;
/**
 *  上一首按钮的点击
 */
- (IBAction)previousButtonClick;
/**
 *  下一首按钮的点击
 */
- (IBAction)nextButtoClick;

/**
 *  歌词或者图片按钮的点击
 */
- (IBAction)lrcOrPicButtonClick:(UIButton *)sender;

- (IBAction)exit;
@end

@implementation LJPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showTimeLable.layer.cornerRadius = 5.0;
    self.showTimeLable.layer.masksToBounds = YES;

//    self.showTimeLable.clipsToBounds = YES;
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
        
        //移除定时器
        [self removeProgressTimer];
        [self removeLrcTimer];
    }];
    
    
    
}

#pragma mark - 对音乐播放的控制
/**
 *  开始播放音乐
 */
-(void)startPlayingMusic{
// 1. 拿到正在播放的音乐
    LJMusic *playingMusic = [LJMusicTool playingMusic];
    
    if (playingMusic == self.playingMusic) {
        [self addProgressTimer];
  
        [self addLrcTimer];
        
        return;
    }
        self.playingMusic = playingMusic;
        // 2. 设置界面数据
        // 2.1 设置基本界面数据
        self.songLable.text = playingMusic.name;
        self.singerLable.text = playingMusic.singer;
        self.singerIcon.image = [UIImage imageNamed:playingMusic.icon];
        // 2.2设置歌词文件名称
    self.LrcView.lrcname = playingMusic.lrcname;
    
        // 3.播放音乐
       self.player = [LJAudioTool playMusicWithName:playingMusic.filename];
        self.totalTimeLabel.text = [self stringWithTime:self.player.duration];
        self.player.delegate = self;
    
        //4.添加定时器
        [self addProgressTimer];
        [self updateInfo];
    [self addLrcTimer];
    // 5.改变按钮的状态
         self.playOrPauseButton.selected = NO;
    
}
/**
 *  停止播放音乐
 */
-(void)stopPlayingMusic{
// 1.清除界面数据
    self.songLable.text = nil;
    self.singerLable.text = nil;
    self.singerIcon.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.totalTimeLabel.text = nil;
   // 2.停止播放音乐
    [LJAudioTool stopMusicWithName:self.playingMusic.filename];
    
    //3.移除定时器
    [self removeProgressTimer];
    [self removeLrcTimer];
}

#pragma mark - 对定时器的操作
/**
 *  添加进度条的定时器
 */
-(void)addProgressTimer{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
}

/**
 *  移除进度条的定时器
 */
-(void)removeProgressTimer{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

/**
 *  添加歌词的定时器
 */
-(void)addLrcTimer{
    if (self.LrcView.hidden) {
        return;
    }
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcTime)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self updateLrcTime];
}
/**
 *  移除歌词的定时器
 */
-(void)removeLrcTimer{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;

}

#pragma mark - 更新进度条的内容
/**
 *  随着播放进度更新进度条
 */
-(void)updateInfo{
    // 0.计算播放比例
    CGFloat progressRatio = self .player.currentTime/self.player.duration;
    
    
    // 1.更新滑块的位置
    self.silderLeftConstraint.constant = progressRatio * (self.view.width - self.sliderButton.width);
    
    
    // 2.更新滑块的文字
    NSString *currentTimerStr = [self stringWithTime:self.player.currentTime];
    [self.sliderButton setTitle:currentTimerStr forState:UIControlStateNormal];

    // 3.设置正在播放的时间
//    self.LrcView.currentTime = self.player.currentTime;
}

-(void)updateLrcTime{


    NSLog(@"更新歌词。。。");
}


/**
 *  点击进度条时更新
 */
- (IBAction)tapProgressBackground:(UITapGestureRecognizer *)sender {
      // 1.获取用户点击位置
    CGPoint point = [sender locationInView:sender.view];
    
    // 2.改变silderBtton的约束
    if (point.x <= self.sliderButton.width * 0.5) {
        self.silderLeftConstraint.constant = 0;
    }else if (point.x >= self.view.width - self.sliderButton.width * 0.5){
        self.silderLeftConstraint.constant = self.view.width - self.sliderButton.width - 1;
    
    }else{
    
        self.silderLeftConstraint.constant = point.x - self.sliderButton.width * 0.5;
    
    }
    
    // 3.改变当前播放时间
    CGFloat progressRatio = self.silderLeftConstraint.constant / (self.view.width - self.sliderButton.width);
    CGFloat currentTime = progressRatio *self.player.duration;
    self.player.currentTime = currentTime;
    
    //  更新文字
    [self updateInfo];
    
    
    
    
}
/**
 *  拖拽滑块按钮时更新
 */
- (IBAction)panSliderButton:(UIPanGestureRecognizer *)sender {
//    // 1.获取用户点击位置
//    CGPoint point = [sender locationInView:sender.view];
//    
//    // 2.改变sliderButton的约束
//    if (point.x <= self.sliderButton.width * 0.5) {
//        self.silderLeftConstraint.constant = 0;
//    }else if(point.x >= self.view.width - self.sliderButton.width * 0.5){
//    
//        self.silderLeftConstraint.constant = self.view.width - self.sliderButton.width - 1;
//    
//    }else{
//     
//        self.silderLeftConstraint.constant = point.x - self.sliderButton.width * 0.5;
//    
//    }
    
  // 1.获取用户拖拽位移
    CGPoint point = [sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    // 2.改变sliderButton的约束
    if (self.silderLeftConstraint.constant + point.x <= 0) {
        self.silderLeftConstraint.constant = 0;
    }else if(self.silderLeftConstraint.constant + point.x >= self.view.width - self.sliderButton.width){
        self.silderLeftConstraint.constant = self.view.width - self.sliderButton.width - 1;
    }else{
    
        self.silderLeftConstraint.constant += point.x;
    
    }
    
    // 3.获取拖拽进度对应的播放时间
    CGFloat progressRatio = self.silderLeftConstraint.constant / (self.view.width - self.sliderButton.width);
    CGFloat currentTime = progressRatio *self.player.duration;
    
    // 4.更新文字
    NSString *currentTimeStr = [self stringWithTime:currentTime];
    [self.sliderButton setTitle:currentTimeStr forState:UIControlStateNormal];
    self.showTimeLable.text = currentTimeStr;
    
    
    // 5.监听拖拽手势状态
    if (sender.state == UIGestureRecognizerStateBegan) {
        // 5.1 移除定时器
        [self removeProgressTimer];
        //5.2让显示时间的lable取消隐藏
        self.showTimeLable.hidden = NO;
        
    }else if(sender.state == UIGestureRecognizerStateEnded){
          // 5.1更新播放时间
        self.player.currentTime = currentTime;
        // 5.2 添加定时器
        [self addProgressTimer];
        //5.3让显示时间的lable取消隐藏
        self.showTimeLable.hidden = YES;
        
    }
    

}
#pragma mark - 播放控制按钮
/**
 *  播放货暂停的点击
 */
- (IBAction)playOrPauseButtonClick {
    self.playOrPauseButton.selected = !self.playOrPauseButton.selected;
    if (self.player.playing) {
        [self.player pause];
        [self removeProgressTimer];
        [self removeLrcTimer];
    }else{
        [self.player play];
        [self addProgressTimer];
        [self addLrcTimer];
    }
    
    
}
/**
 *  上一首按钮点击
 */
- (IBAction)previousButtonClick {
    
    [self stopPlayingMusic];
    [LJMusicTool previousMusic];
    [self startPlayingMusic];
    
    
    
}
/**
 *  下一首按钮点击
 */
- (IBAction)nextButtoClick {
    
    [self stopPlayingMusic];
    [LJMusicTool nextMusic];
    [self startPlayingMusic];
}
/**
 *  歌词或者图片按钮的点击
 */
- (IBAction)lrcOrPicButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.LrcView.hidden = !self.LrcView.hidden;
    
    if (self.LrcView.hidden) {
        [self removeLrcTimer];
    }else{
        [self addLrcTimer];
    
    }
    
}

#pragma mark - AVAudioPlayerDelegate的代理方法
/**
 *  当音乐播放完成时调用
 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{

    if (flag) {
        [self nextButtoClick];
    }

}
/**
 *  当音乐播放打断开始时调用
 */
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{

    [self playOrPauseButtonClick];
}
/**
 *  当音乐播放打断结束时调用
 */
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player{

    [self playOrPauseButtonClick];
}



#pragma mark -私有方法
-(NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger minute = time / 60;
    NSInteger second = (NSInteger)time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
    
    
}

@end
