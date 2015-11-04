//
//  LJMusicsViewController.m
//  01-刘静的音乐
//
//  Created by 刘静 on 15/11/2.
//  Copyright © 2015年 liujing.cn. All rights reserved.
//

#import "LJMusicsViewController.h"
#import "LJMusic.h"
#import "UIImage+Circle.h"
#import "LJPlayingViewController.h"
#import "LJMusicTool.h"
@interface LJMusicsViewController ()
/**
 *  所有音乐的数组
 */
//@property(nonatomic,strong)NSArray *musics;
/**
 *  正在播放的控制器
 */
@property(nonatomic,strong)LJPlayingViewController *playingVc;

@end

@implementation LJMusicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 80;



}

#pragma mark - 懒加载
//-(NSArray *)musics{
//    if (_musics == nil) {
//        self.musics =[LJMusic objectArrayWithFilename:@"Musics.plist"];
//    }
//
//    return _musics;
//}

-(LJPlayingViewController *)playingVc{
    if (_playingVc == nil) {
        
        _playingVc = [[LJPlayingViewController alloc]init];
    }

    return _playingVc;

}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
// 1. 让cell变为不选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    LJMusic *music = [LJMusicTool musics][indexPath.row];
//    self.playingVc.music = music;
    
    [LJMusicTool setPlayingMusic:music];
    
    // 2. 弹出控制器
    [self.playingVc show];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [LJMusicTool musics].count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

static NSString *ID = @"MusicCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }

    // 1.取出模型对象
    LJMusic *music = [LJMusicTool musics][indexPath.row];
    
    // 2.给cell设置数据
    cell.imageView.image = [UIImage circleImageWithName:music.singerIcon borderWidth:3.0 borderColor:[UIColor purpleColor]];
    cell.textLabel.text = music.name;
    cell.detailTextLabel.text = music.singer;
    
    return cell;

}


@end
