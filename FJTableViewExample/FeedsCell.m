//
//  FeedsCell.m
//  baijie
//
//  Created by Fu Jie on 15/11/4.
//  Copyright © 2015年 Aichen. All rights reserved.
//

#import "FeedsCell.h"

@implementation FeedsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.iv_feeds.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataSource:(FJCellDataSource *)cellDataSource {
    [super setCellDataSource:cellDataSource];
    FeedsCellDataSource *ds = (FeedsCellDataSource*)cellDataSource;
    self.lb_name.text = ds.name;
}

- (IBAction)click:(id)sender {
    FeedsCellDataSource *ds = (FeedsCellDataSource*)self.cellDataSource;
    [self.delegate fjcell_actionRespond:ds from:self];
}

@end


@implementation FeedsCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tapEffect = FJ_CellTapEffect_Customized;
        self.cellHeight = 201;
        self.cellHeightExtended = 401;
        self.allowDeletion = YES;
        self.allowMoveCell = YES;
        self.fj_cell_bgColor = [UIColor clearColor];
        self.fj_cellContentView_bgColor = [UIColor clearColor];
        self.fj_tap_color_normal = [UIColor whiteColor];
        self.fj_tap_color_highlighted = [UIColor lightGrayColor];
    }
    return self;
}

@end
