//
//  FeedsHeaderView.m
//  baijie
//
//  Created by Fu Jie on 16/1/25.
//  Copyright © 2016年 Aichen. All rights reserved.
//

#import "FeedsHeaderView.h"

@interface FeedsHeaderView()

@end


@implementation FeedsHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setHeaderDataSource:(__kindof FJHeaderViewDataSource *)headerDataSource {
    [super setHeaderDataSource:headerDataSource];
}

- (IBAction)tap:(id)sender {
    FeedsHeaderViewDataSource *ds = self.headerDataSource;
    [self.delegate fjheader_actionRespond:ds from:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation FeedsHeaderViewDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewHeight = 60.0;
    }
    return self;
}

@end
