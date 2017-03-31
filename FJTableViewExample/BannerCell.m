//
//  BannerCell.m
//  FJCustomizedView
//
//  Created by Jeff on 2017/3/28.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "BannerCell.h"

@implementation BannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation BannerCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellHeight = 200.0;
    }
    return self;
}

@end
