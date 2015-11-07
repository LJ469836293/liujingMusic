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
#import "LJLrcLine.h"
@interface LJLrcView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UITableView *tableView;
@property (nonatomic, copy) NSArray *lrcLines;
@property (nonatomic, assign) NSInteger currentIndex;
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
    
    self.currentIndex = -1;
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
    lrcCell.lrcLine = self.lrcLines[indexPath.row];
    
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
       //3.1分割字符串
    NSArray *lrcLinesStrs = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSString *lrcLineStr in lrcLinesStrs) {
        //3.2移除不需要的行
        if ([lrcLineStr hasPrefix:@"[ti"] || [lrcLineStr hasPrefix:@"[ar"] ||[lrcLineStr hasPrefix:@"al"] || ![lrcLineStr hasPrefix:@"["]) {
            continue;
        }
        //3.3 截取每一行歌词字符串
        NSArray *lrcLineStrParts = [lrcLineStr componentsSeparatedByString:@"]"];
        LJLrcLine *lrcLine = [[LJLrcLine alloc]init];
        lrcLine.text = [lrcLineStrParts lastObject];
        lrcLine.time = [[lrcLineStrParts firstObject]substringFromIndex:1];
        //3.4讲模型对象添加到数组中
        [tempArray addObject:lrcLine];
        
    }
    
    self.lrcLines = tempArray;
    // 4.刷新数据
    [self.tableView reloadData];
}

-(void)setCurrentTime:(NSTimeInterval)currentTime{
    _currentTime = currentTime;

    if (_currentTime > currentTime) {
        self.currentIndex = -1;
    }
//1.保持当前的时间
    _currentTime = currentTime;
    
    // 2.将传入的时间转化成字符串
    NSInteger minute = currentTime / 60;
    NSInteger second = (NSInteger)currentTime % 60;
    NSInteger millisecond = (currentTime - (NSInteger)currentTime) * 1000;
    NSString *currentTimeStr =[NSString stringWithFormat:@"%02ld:%02ld.%02ld",minute,second,millisecond];
    
    // 3.对比时间
    NSInteger count = self.lrcLines.count;
    for (NSInteger i = 0; i < count; ++i) {
        //1.取出当前的歌词类型
        LJLrcLine *lrcLine = self.lrcLines[i];
        
        //2.去除下一个歌词模型
        NSInteger nextIndex = i + 1;
        if (nextIndex < count) {
            LJLrcLine *nextLrcLine = self.lrcLines[nextIndex];
            //3.比较时间
            if ([currentTimeStr compare:lrcLine.time] != NSOrderedAscending && [currentTimeStr compare:nextLrcLine.time] != NSOrderedDescending && self.currentIndex != i) {
                
                NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                NSIndexPath *nextIndextPath = [NSIndexPath
                                               indexPathForRow:i inSection:0];
                
                self.currentIndex = i;
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[currentIndexPath,nextIndextPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                NSLog(@"%@---%@--%@",currentTimeStr,lrcLine.time,nextLrcLine.time);
            }
        }
    }
}




@end
