//
//  FJCell.m
//  haitao
//
//  Created by Fu Jie on 15/7/22.
//  Copyright (c) 2015年 Jeff. All rights reserved.
//

#import "FJCell.h"

@implementation FJCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    // Initialization code
    // [self setSeparatorInset:UIEdgeInsetsZero];
    // [self setLayoutMargins:UIEdgeInsetsZero];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
}

- (void)setCellDataSource:(__kindof FJCellDataSource *)cellDataSource {
    _cellDataSource = cellDataSource;
}

- (void)extend {
    // implemented by subclass
}

- (void)collapse {
    // implemented by subclass
}

- (void)autoExtendAndCollapse {
    FJCellDataSource *ds = self.cellDataSource;
    if (ds.extended) {
        if ([self respondsToSelector:@selector(extend)]) {
            [self extend];
        }
    }else{
        if ([self respondsToSelector:@selector(collapse)]) {
            [self collapse];
        }
    }
}

@end


@interface FJCellDataSource()

@end

@implementation FJCellDataSource

- (void)setCellHeight:(float)cellHeight {
    _cellHeight = cellHeight;
}

- (void)setCellHeightExtended:(float)cellHeightExtended {
    _cellHeightExtended = cellHeightExtended;
}

- (void)extend {
    _extended = YES;
}

- (void)collapse {
    _extended = NO;
}

- (void)autoExtendAndCollapse {
    if (!self.extended) {
        [self extend];
        
    }else {
        [self collapse];
    }
}

@end
