//
//  IndexesCell.m
//  FJTableView
//
//  Created by Jeff on 2017/4/24.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "IndexesCell.h"

@interface IndexesCell()

@property (nonatomic, weak) IBOutlet UILabel *lb_name;

@end

@implementation IndexesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataSource:(__kindof FJCellDataSource *)cellDataSource {
    [super setCellDataSource:cellDataSource];
    
    IndexesCellDataSource *ds = cellDataSource;
    self.lb_name.text = ds.name;
}

@end

@implementation IndexesCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellHeight = 44.0;
    }
    return self;
}

@end
