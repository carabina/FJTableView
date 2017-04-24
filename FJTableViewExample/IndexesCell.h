//
//  IndexesCell.h
//  FJTableView
//
//  Created by Jeff on 2017/4/24.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJCell.h"

@interface IndexesCell : FJCell

@end

@interface IndexesCellDataSource : FJCellDataSource

@property (nonatomic, copy) NSString *name;

@end
