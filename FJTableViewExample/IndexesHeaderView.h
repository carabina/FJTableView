//
//  IndexesHeaderView.h
//  FJTableView
//
//  Created by Jeff on 2017/4/24.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "FJHeaderView.h"

@interface IndexesHeaderView : FJHeaderView

@end

@interface IndexesHeaderViewDataSource : FJHeaderViewDataSource

@property (nonatomic, copy) NSString *index;

@end
