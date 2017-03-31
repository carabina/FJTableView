//
//  FJCell.h
//  haitao
//
//  Created by Fu Jie on 15/7/22.
//  Copyright (c) 2015年 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJTableViewDef.h"

@class FJCellDataSource;

@protocol FJCellDelegate<NSObject>

@optional
-(void)fjcell_actionRespond:(id)cellDataSource from:(id)fjCell;

@end

@interface FJCell : UITableViewCell
@property (nonatomic, strong) __kindof FJCellDataSource *cellDataSource;        // CellDataSource, 用于展现UI的Model
@property (nonatomic, weak)   id <FJCellDelegate> delegate;                     // FJCell的delegate

/**
 *  虚函数
 *  Extend / Collapse
 */
- (void)extend;
- (void)collapse;
/**
 *  多态，指向子类
 */
- (void)autoExtendAndCollapse;

@end



@interface FJCellDataSource : NSObject
@property (nonatomic, assign) NSInteger dataIndex;                     // 数据下标
@property (nonatomic, assign) NSInteger dataIndexAfterMove;            // 移动后的数据下标

@property (nonatomic, assign) float cellHeight;                        // cell的高度
@property (nonatomic, assign) float cellHeightOriginal;                // cell的原始高度
@property (nonatomic, assign) float cellHeightExtended;                // cell的延展高度
@property (nonatomic, assign) FJ_CellTapEffect tapEffect;              // cell是否允许点击
@property (nonatomic, assign) BOOL  disableVisible;                    // cell是否禁止显示
@property (nonatomic, assign) BOOL  allowDeletion;                     // cell是否可以删除
@property (nonatomic, assign) BOOL  allowMoveCell;                     // cell是否可以移动
// 颜色
@property (nonatomic, strong) UIColor *fj_cell_bgColor;                // Cell的背景色
@property (nonatomic, strong) UIColor *fj_cellContentView_bgColor;     // Cell的ContentView的背景色（除去左右侧的空间颜色）
// Tap颜色
@property (nonatomic, strong) UIColor *fj_tap_color_normal;            // Normal
@property (nonatomic, strong) UIColor *fj_tap_color_highlighted;       // Highlighted
// Row动画
@property (nonatomic, assign) UITableViewRowAnimation cellAnimation;   // cell删除时候的动画

// 用于用户控制展示或隐藏UI的标识
@property (nonatomic, assign) BOOL extended;

- (void)extend;
- (void)collapse;
- (void)autoExtendAndCollapse;

@end

@protocol FJCellDataSource <NSObject>

@end
