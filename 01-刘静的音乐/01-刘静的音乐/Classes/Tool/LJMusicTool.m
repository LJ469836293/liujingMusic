//
//  LJMusicTool.m
//  01-刘静的音乐
//
//  Created by 刘静 on 15/11/4.
//  Copyright © 2015年 liujing.cn. All rights reserved.
//

#import "LJMusicTool.h"
#import "LJMusic.h"
#import "MJExtension.h"
@implementation LJMusicTool

static NSArray *_musics;
static LJMusic *_playingMusic;

+(void)initialize{

    _musics = [LJMusic objectArrayWithFilename:@"Musics.plist"];
    
}

+(NSArray *)musics{

    return _musics;
}


+(LJMusic *)playingMusic {
    return _playingMusic;
}

+(void)setPlayingMusic:(LJMusic *)playingMusic {

    assert(playingMusic);
    _playingMusic = playingMusic;
    
}

+(LJMusic *)nextMusic {
   
    // 1.获取当前正在播放的音乐
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    //2. 获取下一首音乐
    
    //2.1索引＋1
    currentIndex++;
    //2.2判断是否越界
    if (currentIndex > _musics.count - 1) {
        currentIndex = 0;
        
    }
    // 2.3 取出下一首音乐
    LJMusic *nextMusic = _musics[currentIndex];
    
    _playingMusic = nextMusic;
    
    return nextMusic;
    
}




+(LJMusic *)previousMusic {
    // 1.获取当前正在播放的音乐
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    //2. 获取上一首音乐
    
       //2.1索引－1
    currentIndex--;
       //2.2判断是否越界
    if (currentIndex < 0) {
        currentIndex = _musics.count - 1;
        
    }
    // 2.3 取出上一首音乐
    LJMusic *previousMusic = _musics[currentIndex];
    
    _playingMusic = previousMusic;
    
    return previousMusic;

}


@end
