//
//  IndexesHeaderView.m
//  FJTableView
//
//  Created by Jeff on 2017/4/24.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "IndexesHeaderView.h"

@interface IndexesHeaderView()

@property (nonatomic, weak) IBOutlet UILabel *lb_index;

@end

@implementation IndexesHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setHeaderDataSource:(__kindof FJHeaderViewDataSource *)headerDataSource {
    [super setHeaderDataSource:headerDataSource];
    IndexesHeaderViewDataSource *ds = headerDataSource;
    self.lb_index.text = ds.index;
}

@end

@implementation IndexesHeaderViewDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewHeight = 20.0;
    }
    return self;
}

@end
