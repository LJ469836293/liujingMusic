//
//  LJLrcView.h
//  01-刘静的音乐
//
//  Created by 刘静 on 15/11/5.
//  Copyright © 2015年 liujing.cn. All rights reserved.
//

#import "DRNRealTimeBlurView.h"

@interface LJLrcView : DRNRealTimeBlurView

@property(nonatomic,copy)NSString *lrcname;

@property (nonatomic, assign) NSTimeInterval currentTime;

@end
