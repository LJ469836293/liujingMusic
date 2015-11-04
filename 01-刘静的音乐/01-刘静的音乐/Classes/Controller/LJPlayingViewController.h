//
//  LJPlayingViewController.h
//  01-刘静的音乐
//
//  Created by 刘静 on 15/11/2.
//  Copyright © 2015年 liujing.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LJMusic;

@interface LJPlayingViewController : UIViewController

@property(nonatomic,strong)LJMusic *music;

-(void)show;

@end
