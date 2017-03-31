//
//  FJHeaderView.m
//  baijie
//
//  Created by Fu Jie on 16/1/25.
//  Copyright © 2016年 Jeff. All rights reserved.
//

#import "FJHeaderView.h"

@implementation FJHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setHeaderDataSource:(__kindof FJHeaderViewDataSource *)headerDataSource {
    _headerDataSource = headerDataSource;
}

@end


@implementation FJHeaderViewDataSource


@end