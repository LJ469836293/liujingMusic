
//
//  LJLrcCell.m
//  01-刘静的音乐
//
//  Created by 刘静 on 15/11/6.
//  Copyright © 2015年 liujing.cn. All rights reserved.
//

#import "LJLrcCell.h"
#import "LJLrcLine.h"
@implementation LJLrcCell

+(instancetype)lrcCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"LrcCell";
    LJLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[LJLrcCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
      
    //      //1.去除cell的背景
    cell.backgroundColor = [UIColor clearColor];
    //    //2.设置cell的文字为白色
    cell.textLabel.textColor = [UIColor whiteColor];
    //    //3.设置cell的文字居中
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //    //4.设置cell的样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    



}
-(void)setLrcLine:(LJLrcLine *)lrcLine{
    _lrcLine = lrcLine;
    self.textLabel.text = lrcLine.text;

}

@end
