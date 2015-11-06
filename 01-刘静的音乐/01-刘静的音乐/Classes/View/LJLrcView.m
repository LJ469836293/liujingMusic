//
//  LJLrcView.m
//  01-刘静的音乐
//
//  Created by 刘静 on 15/11/5.
//  Copyright © 2015年 liujing.cn. All rights reserved.
//

#import "LJLrcView.h"
#import "UIView+AdjustFrame.h"
#import "LJLrcCell.h"
@interface LJLrcView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UITableView *tableView;
@property (nonatomic, copy) NSArray *lrcLines;

@end
@implementation LJLrcView

//-(id)initWithCoder:(NSCoder *)aDecoder{
//    if ([super initWithCoder:aDecoder]) {
//        [self setupTableView];
//    }
//    return self;
//
//}

- (void)awakeFromNib {
    [self setupTableView];
}

-(void)setupTableView{

    UITableView *tableView = [[UITableView alloc]init];
//    tableView.frame = self.bounds;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.allowsSelection = NO;
    
    [self addSubview:tableView];

    self.tableView = tableView;
    

}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0, self.tableView.height * 0.5, 0);
}

#pragma mark -tableView的代理和数据源 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrcLines.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //1.创建cell
    LJLrcCell *lrcCell = [LJLrcCell
                          lrcCellWithTableView:tableView];
    
    //2.给cell设置数据
    lrcCell.textLabel.text = @"歌词显示";
  
    return lrcCell;


}

-(void)setLrcname:(NSString *)lrcname{

    //1.保存歌词的文件名称
    _lrcname = lrcname;
    
    //2.加载对应歌词
    NSString *path =[[NSBundle mainBundle]pathForResource:lrcname ofType:nil];
 
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@",lrcString);

    // 3.解析歌词
    
    
    // 4.刷新数据
    [self.tableView reloadData];
}






@end
