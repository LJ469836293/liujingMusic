//
//  LJMusicTool.h
//  01-刘静的音乐
//
//  Created by 刘静 on 15/11/4.
//  Copyright © 2015年 liujing.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LJMusic;
@interface LJMusicTool : NSObject

+(NSArray *)musics;

+(LJMusic *)playingMusic;

+(void)setPlayingMusic:(LJMusic *)playingMusic;

+(LJMusic *)nextMusic;

+(LJMusic *)previousMusic;
@end
