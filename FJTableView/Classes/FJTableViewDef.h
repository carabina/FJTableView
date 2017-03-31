//
//  FJTableViewDef.h
//  baijie
//
//  Created by Fu Jie on 16/1/25.
//  Copyright © 2016年 Jeff. All rights reserved.
//

#ifndef FJTableViewDef_h
#define FJTableViewDef_h

/*****************
 *  Common Part  *
 *****************/

#define NOT_FOUND_INDEX (-1)

typedef NS_ENUM(NSInteger, FJ_CellEditingStyle)
{
    FJ_CellEditingStyle_None,
    FJ_CellEditingStyle_Deletion,
    FJ_CellEditingStyle_Insert,
    FJ_CellEditingStyle_MultiSelection
};

typedef NS_ENUM(NSInteger,FJ_CellDeletion_Policy)
{
    FJ_CellDeletion_Policy_Remove,   // (默认)删除数据源， removed from tbDataSource
    FJ_CellDeletion_Policy_Hidden,   // 隐藏，disableVisible = YES
};

typedef NS_ENUM(NSInteger,FJ_CellTapEffect)
{
    FJ_CellTapEffect_None,          // cell没有选中效果
    FJ_CellTapEffect_Customized     // cell的选中效果是自定义的
};

typedef void(^FJTableViewRefreshBlock)(void);

/********************
 *  Addtional Part  *
 ********************/

typedef NS_ENUM(NSInteger,FJ_CellBlockType)
{
    // Tap
    FJ_CellBlockType_CellTapped,
    FJ_CellBlockType_CellCustomizedTapped,
    FJ_CellBlockType_CellChecked,
    FJ_CellBlockType_CellDeleted,
    FJ_CellBlockType_CellInterted,
};

typedef NS_ENUM(NSInteger, FJ_ScrollBlockType) {
    // Scroll
    FJ_ScrollBlockType_Scroll,
    FJ_ScrollBlockType_Scroll_RefreshingView_Up_Height,
    FJ_ScrollBlockType_Scroll_LoadingView_Down_Height,
    FJ_ScrollBlockType_Scroll_Moving_Up_Height,
    FJ_ScrollBlockType_Scroll_Moving_Down_Height,
    FJ_ScrollBlockType_Scroll_Drag_Will_Begin,
    FJ_ScrollBlockType_Scroll_Drag_Did_End,
    FJ_ScrollBlockType_Scroll_Decelerating_Will_Begin,
    FJ_ScrollBlockType_Scroll_Decelerating_Did_End,
};

@class FJCellDataSource;

@protocol FJTableViewDelegate<NSObject>

@optional
#pragma mark - Cell Action (代理)
- (void)fj_tableViewDidSelect:(NSInteger)row section:(NSInteger)section cellData:(__kindof FJCellDataSource*)cellData;       // cell的点击事件
- (void)fj_tableViewCustomAction:(NSInteger)row section:(NSInteger)section cellData:(__kindof id)cellData;                   // cell 和 header view 的自定义响应事件
- (void)fj_tableViewDidMultiSelect:(NSInteger)row section:(NSInteger)section cellData:(__kindof FJCellDataSource*)cellData;  // cell的复选事件
- (void)fj_tableViewDidDeleteRow:(NSInteger)row section:(NSInteger)section cellData:(__kindof FJCellDataSource*)cellData;    // cell的删除事件
- (void)fj_tableViewDidInsertRow:(NSInteger)row section:(NSInteger)section cellData:(__kindof FJCellDataSource*)cellData;    // cell的插入事件

#pragma mark - ScrollView Action (代理)
- (void)fj_scrollViewDidScroll:(UIScrollView *)scrollView;                                       // 重写滚动事件（完全交付子类完成自定义的处理方式）
- (void)fj_scrollViewRefreshingHeader:(UIScrollView *)scrollView height:(CGFloat)height;         // 重写往上滚动具体距离(进入Refreshing的状态)
- (void)fj_scrollViewLoadingMore:(UIScrollView *)scrollView height:(CGFloat)height;              // 重写往下滚动具体距离（进入LoadingMore的状态）
- (void)fj_scrollView:(UIScrollView *)scrollView up:(CGFloat)height;                             // 重写往上滚动(正常范围内，两个临界值之间的非重新加载和加载更多区域)
- (void)fj_scrollView:(UIScrollView *)scrollView down:(CGFloat)height;                           // 重写往下滚动(正常范围内，两个临界值之间的非重新加载和加载更多区域)
- (void)fj_scrollViewWillBeginDragging:(UIScrollView *)scrollView;                               // 重写拖拽事件（开始拖拽）
- (void)fj_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;  // 重写拖拽事件（结束拖拽）
- (void)fj_scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;                           // 重写减速事件
- (void)fj_scrollViewDidEndDecelerating:(UIScrollView *)scrollView;                              // 重写减速事件

@end

typedef void (^CellActionBlock)(FJ_CellBlockType type, NSInteger row, NSInteger section, __kindof FJCellDataSource* cellData);
typedef void (^CellScrollBlock)(FJ_ScrollBlockType type, UIScrollView *scrollView, CGFloat height, BOOL willDecelerate);

#endif /* FJTableViewDef_h */
