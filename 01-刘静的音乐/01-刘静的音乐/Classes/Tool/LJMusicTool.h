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
/**
 *  获取所有的音乐数据
 *
 *  @return 所有的音乐数据
 */
+(NSArray *)musics;
/**
 *  获取当前正在播放的音乐
 *
 *  @return 正在播放的音乐
 */

+(LJMusic *)playingMusic;
/**
 *  设置正在播放的音乐
 *
 *  @param playingMusic 正在播放的音乐
 */

+(void)setPlayingMusic:(LJMusic *)playingMusic;
/**
 *  获取下一首音乐
 *
 *  @return 下一首音乐
 */

+(LJMusic *)nextMusic;
/**
 *  获取上一首音乐
 *
 *  @return 上一首音乐
 */

+(LJMusic *)previousMusic;
@end
