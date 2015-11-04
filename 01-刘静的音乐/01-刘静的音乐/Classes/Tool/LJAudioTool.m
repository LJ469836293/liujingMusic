//
//  LJAudioTool.m
//  1-03播放音效
//
//  Created by 刘静 on 15/10/31.
//  Copyright © 2015年 liujing.cn. All rights reserved.
//

#import "LJAudioTool.h"
#import <AVFoundation/AVFoundation.h>
@implementation LJAudioTool

static NSMutableDictionary *_soundIDs;
static NSMutableDictionary *_musics;
+(void)initialize{

    _soundIDs = [NSMutableDictionary dictionary];
    _musics = [NSMutableDictionary dictionary];
}


#pragma mark - 播放音乐
+(void)playMusicWithName:(NSString *)musicName{

    // 0.判断musicName 是否为空
    assert(musicName);
    
    // 1.取出播放器
    AVAudioPlayer *player = _musics[musicName];
    
    // 2. 判断播放器是否为空
    if (player == nil) {
        // 2.0 获取资源的URL
        NSURL *url = [[NSBundle mainBundle]URLForResource:musicName withExtension:nil];
        
        // 2.1 创建播放器对象
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        // 2.2 准备播放
        [player prepareToPlay];
        
        // 2.3 存入字典中
        _musics[musicName] = player;
    }
    
    // 3. 播放音乐
    [player play];
    
}
+(void)pauseMusicWithName:(NSString *)musicName{

    // 0.判断musicName 是否为空
    assert(musicName);
    
    // 1.取出播放器
    AVAudioPlayer *player = _musics[musicName];
    
    if (player) {
        [player pause];
        
    }

}

+(void)stopMusicWithName:(NSString *)musicName{
    // 0.判断musicName 是否为空
    assert(musicName);
    
    // 1.取出播放器
    AVAudioPlayer *player = _musics[musicName];
    if (player) {
        [player stop];
        player = nil;
        [_musics removeObjectForKey:musicName];
        
    }

}


#pragma mark - 播放音效
+ (void)playSoundWithName:(NSString *)soundName{

    //1.从字典中取出音效的ID
    SystemSoundID soundID = [_soundIDs[soundName] unsignedIntValue];
    //2.如果现在取出来的值是0
    if (soundID == 0) {
        
        // 2.1.获取资源的URL
        
        NSURL *buyUrl = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        
        //2.2给soundID赋值
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(buyUrl), &soundID);
        //2.3放入字典中
        _soundIDs[soundName] = @(soundID);
        
    }
    // 3. 播放音效
    AudioServicesPlaySystemSound(soundID);
    
    



}
@end
