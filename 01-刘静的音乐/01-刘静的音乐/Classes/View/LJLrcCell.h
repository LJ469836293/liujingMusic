//
//  LJLrcCell.h
//  01-刘静的音乐
//
//  Created by 刘静 on 15/11/6.
//  Copyright © 2015年 liujing.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJLrcLine.h"
@interface LJLrcCell : UITableViewCell

@property (nonatomic, strong) LJLrcLine  *lrcLine;

+(instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
