//
//  FeedsCell.h
//  baijie
//
//  Created by Fu Jie on 15/11/4.
//  Copyright © 2015年 Aichen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJCell.h"

@interface FeedsCell : FJCell
@property (nonatomic, weak) IBOutlet UIImageView *iv_feeds;
@property (nonatomic, weak) IBOutlet UILabel *lb_name;

@end

@interface FeedsCellDataSource : FJCellDataSource
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cover_url;

@end
