//
//  FJHeaderView.h
//  baijie
//
//  Created by Fu Jie on 16/1/25.
//  Copyright © 2016年 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class    FJHeaderView;
@class    FJHeaderViewDataSource;
@protocol FJHeaderViewDelegate;
@protocol FJTableViewSectionDataSource;

@protocol FJHeaderViewDelegate <NSObject>

@optional
// 点击header view的事件
-(void)fjheader_actionRespond:(id)viewDataSource from:(id)fjHeaderView;

@end

@interface FJHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) __kindof FJHeaderViewDataSource *headerDataSource;
@property (nonatomic, assign) id <FJHeaderViewDelegate> delegate;

@end

@interface FJHeaderViewDataSource : NSObject

@property (nonatomic, assign) float viewHeight;   // header view的高度

@end
