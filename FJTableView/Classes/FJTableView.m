//
//  FJTableView.m
//  haitao
//
//  Created by Fu Jie on 15/7/22.
//  Copyright (c) 2015年 Jeff. All rights reserved.
//

#import "FJTableView.h"
#import "FJCell.h"
#import <Masonry/Masonry.h>

#define COLOR_F3F3F9 [UIColor colorWithRed:(243.0/255.0) green:(243.0/255.0) blue:(249.0/255.0) alpha:1.0]

#define MF_TABLEVIEW_CELL_ACTION_2_P(target, action) \
if (target.delegate && [target.delegate respondsToSelector:@selector(fjcell_actionRespond:from:)]) { \
    [target.delegate fjcell_actionRespond:action from:target]; \
}

#define MF_CUSTOMIZED_VIEW_ACTION_2_P(target, action) \
if (target.delegate && [target.delegate respondsToSelector:@selector(fjheader_actionRespond:from:)]) { \
    [target.delegate fjheader_actionRespond:action from:target]; \
}

@interface FJTableView()<UITableViewDataSource,UITableViewDelegate,FJTableViewDelegate,FJCellDelegate,FJHeaderViewDelegate>

// TableView
@property (nonatomic, strong) UITableView *innerTableView;
// 数据源(设置数据源并刷新tableView)
@property (nonatomic, strong) NSMutableArray *innerDataSource;

// 滚动和点击的事件回调
@property (nonatomic, copy) CellActionBlock cellActionBlock;
@property (nonatomic, copy) CellScrollBlock cellScrollBlock;

// scrollview滚动到最上方静止状态的临界值(contentOffset)
@property (nonatomic, assign) CGFloat init_y;
// scrollview滚动到最下方静止状态的临界值(contentOffset)
@property (nonatomic, assign) CGFloat end_y;
// scrollview上次滚动的y值(contentOffset)
@property (nonatomic, assign) CGFloat last_y;

@end

@implementation FJTableView

-(void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
}

/*************************
 *      系统初始化方法     *
 *************************/
// 初始化TableView（from code）
-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.innerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height) style:UITableViewStylePlain];
        self.innerTableView.delegate=self;
        self.innerTableView.dataSource=self;
        [self addSubview:self.innerTableView];
        
        __weak typeof(self) weakSelf = self;
        [self.innerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        
        // 禁止显示滚动条
        self.innerTableView.showsVerticalScrollIndicator = NO;
        self.innerTableView.showsHorizontalScrollIndicator = NO;
        
        // 默认分割线贴边
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self.innerTableView setLayoutMargins:UIEdgeInsetsZero];
        }else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [self.innerTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        self.innerTableView.scrollsToTop = YES;
        
    }
    return self;
}


/*************************
 *        设置属性        *
 *************************/
- (void)setFj_allowEditing:(BOOL)fj_allowEditing {
    _fj_allowEditing = fj_allowEditing;
    self.innerTableView.editing = fj_allowEditing;
}


- (void)setFj_allowMoveCell:(BOOL)fj_allowMoveCell {
    _fj_allowMoveCell = fj_allowMoveCell;
    if (fj_allowMoveCell) {
        [self.innerTableView setEditing:YES animated:NO];
    }
}

- (void)setFj_editingStyle:(FJ_CellEditingStyle)fj_editingStyle {
    _fj_editingStyle = fj_editingStyle;
    switch (fj_editingStyle) {
        case FJ_CellEditingStyle_Insert:
        {
            self.innerTableView.editing = YES;
        }
            break;
        case FJ_CellEditingStyle_MultiSelection:
        {
            self.innerTableView.editing = YES;
            self.innerTableView.allowsMultipleSelectionDuringEditing = YES;
            break;
        }
        case FJ_CellEditingStyle_None:
        case FJ_CellEditingStyle_Deletion:
        default:
            break;
    }
}

- (void)setFj_cellSeperateType:(UITableViewCellSeparatorStyle)fj_cellSeperateType {
    _fj_cellSeperateType = fj_cellSeperateType;
    [_innerTableView setSeparatorStyle:fj_cellSeperateType];
}

- (void)setFj_view_bgColor:(UIColor *)fj_view_bgColor {
    _fj_view_bgColor = fj_view_bgColor;
    self.innerTableView.backgroundColor = _fj_view_bgColor;
}

// 初始化TableView（from xib）
-(id)initWithCoder:(NSCoder *)coder{
    
    if (self = [super initWithCoder:coder]) {
        
        self.innerTableView = [[UITableView alloc] initWithCoder:coder];
        self.innerTableView.delegate=self;
        self.innerTableView.dataSource=self;
        [self addSubview:self.innerTableView];
        
        // 默认分割线贴边
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self.innerTableView setLayoutMargins:UIEdgeInsetsZero];
        }else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [self.innerTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        self.innerTableView.scrollsToTop = YES;
        
    }
    return self;
}

/*************************
 *   生成 - Table/Data   *
 *************************/
// 生成FJTableView（默认）
+ (FJTableView*)defaultFJTableView {
    return [self FJTableView:CGRectZero allowMultiStyle:NO editStyle:FJ_CellEditingStyle_None seperateType:UITableViewCellSeparatorStyleNone bgColor:COLOR_F3F3F9 delegate:nil];
}

// 生成FJTableView（自定义）
+ (FJTableView*)FJTableView:(CGRect)frame allowMultiStyle:(BOOL)allowMultiStyle editStyle:(FJ_CellEditingStyle)editStyle seperateType:(UITableViewCellSeparatorStyle)seperateType bgColor:(UIColor*)bgColor delegate:(id<FJTableViewDelegate>)delegate {
    
    FJTableView *fjTableView = [[FJTableView alloc] initWithFrame:frame];
    
    // 保存和设置属性
    fjTableView.delegate = delegate;
    fjTableView.fj_allowMultiTableView = allowMultiStyle;
    fjTableView.fj_editingStyle = editStyle;
    fjTableView.fj_cellSeperateType = seperateType;
    fjTableView.fj_view_bgColor = COLOR_F3F3F9;
    if (bgColor) {
        fjTableView.fj_view_bgColor = bgColor;
    }
    
    fjTableView.innerDataSource = [[NSMutableArray alloc] init];
    
    return fjTableView;
    
}

// 获取TableView
- (UITableView *)tableView {
    return self.innerTableView;
}

// 获取数据源
- (NSMutableArray *)dataSource {
    return _innerDataSource;
}

// 设置数据源
- (void)setDataSource:(NSMutableArray *)dataSource {
    if (dataSource == nil) {
        [_innerDataSource removeAllObjects];
    }else{
        [_innerDataSource addObjectsFromArray:dataSource];
    }
    [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:YES];
}

// 添加数据
- (void)addDataSource:(id)cellDataSource {
    NSAssert(cellDataSource != nil, @"cellDataSource不能为空");
    [_innerDataSource addObject:cellDataSource];
}

// 重新刷新数据源
- (void)refresh {
    [self.innerTableView reloadData];
}


/*************************
 *  回调 - Delegate/Block *
 *************************/
// 设置Cell Action Block
- (void)setCellActionBlock:(CellActionBlock)cellActionBlock {
    _cellActionBlock = cellActionBlock;
}

// 设置Cell Scroll Block
- (void)setCellScrollBlock:(CellScrollBlock)cellScrollBlock {
    _cellScrollBlock = cellScrollBlock;
}

/***************************************
 * 代理：TableView的Delegate和DataSource *
 ***************************************/
#pragma mark - Table view delegate & data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_fj_allowMultiTableView) {
        return [_innerDataSource count];
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_fj_allowMultiTableView) {
        FJMultiDataSource *multiDataSource = [_innerDataSource objectAtIndex:section];
        return [self visibleCellsCount:multiDataSource.cellDataSources];
    }else{
        return [self visibleCellsCount:_innerDataSource];
    }
}

// 内部函数
- (NSInteger)visibleCellsCount:(NSArray*)cellDataSources {
    NSInteger cnt = 0;
    for (FJCellDataSource *cell in cellDataSources) {
        if (cell.disableVisible == NO) {
            cnt++;
        }
    }
    return cnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // BaseCellDataSource
    FJCellDataSource *cellData = [self getFJCellByIndexPath:indexPath];
    // 越界处理
    if (cellData == nil) {
        return nil;
    }
    
    // 获取Cell名
    NSString *cellClassName;
    if ([cellData isKindOfClass:[FJCellDataSource class]]) {
        cellClassName = [NSString stringWithUTF8String:object_getClassName(cellData)];
        cellClassName = [cellClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@""];
    }
    
    FJCell *cell = nil;
    if (_fj_disableCellReuse) {
        // 禁止复用Cell
        cell = [[[NSBundle mainBundle] loadNibNamed:cellClassName owner:nil options:nil] lastObject];
        
    }else{
        // 复用Cell
        cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
        if (!cell){
            // 注册Cell(第一次注册的时候)
            [tableView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forCellReuseIdentifier:cellClassName];
            cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
        }
    }
    
    /* 设置Cell的Accessory的类型
     UITableViewCellAccessoryNone
     UITableViewCellAccessoryDisclosureIndicator
     UITableViewCellAccessoryDetailDisclosureButton __TVOS_PROHIBITED
     UITableViewCellAccessoryCheckmark
     UITableViewCellAccessoryDetailButton
     cell.accessoryType = UITableViewCellAccessoryNone;
     */
    
    // Cell的代理
    cell.delegate = self;
    
    // 设置Cell是有点击效果
    if (cellData.tapEffect == FJ_CellTapEffect_None) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        /* 这种方式会导致其它UI的颜色设置全部失效 */
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = COLOR_F3F3F9;
    }
    
    // ContentView的背景色优先级高
    if (cellData.fj_cellContentView_bgColor) {
        cell.contentView.backgroundColor = cellData.fj_cellContentView_bgColor;
    }else if(cellData.fj_cell_bgColor) {
        cell.backgroundColor = cellData.fj_cell_bgColor;
    }
    
    // 传值给Cell
    [cell setCellDataSource:cellData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FJCellDataSource *fjCellData = [self getFJCellByIndexPath:indexPath];
    // 越界处理
    if (fjCellData == nil) {
        return;
    }
    
    if (fjCellData.tapEffect == FJ_CellTapEffect_None) {
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    if (_fj_editingStyle == FJ_CellEditingStyle_MultiSelection) {
        // 多重选择
        if (self.delegate && [self.delegate respondsToSelector:@selector(fj_tableViewDidMultiSelect:section:cellData:)]) {
            [self.delegate fj_tableViewDidMultiSelect:row section:section cellData:fjCellData];
        }
        _cellActionBlock == nil ? : _cellActionBlock(FJ_CellBlockType_CellChecked, row, section, fjCellData);
    }else{
        // 点击Cell
        if (self.delegate && [self.delegate respondsToSelector:@selector(fj_tableViewDidSelect:section:cellData:)]) {
            [self.delegate fj_tableViewDidSelect:row section:section cellData:fjCellData];
        }
        _cellActionBlock == nil ? : _cellActionBlock(FJ_CellBlockType_CellTapped, row, section, fjCellData);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didDeselectRowAtIndexPath");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FJCellDataSource *fjCellData = [self getFJCellByIndexPath:indexPath];
    // 越界处理
    if (fjCellData == nil) {
        return 0.0;
    }
    
    return fjCellData.cellHeight;
}

// 是否可以删除、插入和选择
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FJCellDataSource *fjCellData = [self getFJCellByIndexPath:indexPath];
    // 越界处理
    if (fjCellData == nil) {
        return NO;
    }
    return (self.fj_editingStyle != FJ_CellEditingStyle_None) || fjCellData.allowDeletion;
}


//删除风格    :UITableViewCellEditingStyleDelete （默认风格）  当tableView.editing=YES时，显示删除  /  当tableView.editing=NO时，隐藏删除，滑动出现  ||| 相应方法：commitEditingStyle
//插入风格    :UITableViewCellEditingStyleInsert  当tableView.editing=YES生效  ||| 相应方法：commitEditingStyle
//无风格      :UITableViewCellEditingStyleNone
//多组选中风格 :UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete  ||| 相应方法：didSelectRowAtIndexPath
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 判断Cell是否允许删除
    if (self.fj_allowMultiTableView) {
        
        FJMultiDataSource *fjmds = [_innerDataSource objectAtIndex:[indexPath section]];
        FJCellDataSource *fjds = [fjmds.cellDataSources objectAtIndex:[indexPath row]];
        if (fjds.allowDeletion == NO) {
            return UITableViewCellEditingStyleNone;
        }
        
    }else{
        
        FJCellDataSource *fjds = [_innerDataSource objectAtIndex:[indexPath row]];
        if (fjds.allowDeletion == NO) {
            return UITableViewCellEditingStyleNone;
        }
    }
    
    switch (_fj_editingStyle) {
        case FJ_CellEditingStyle_Deletion:
        {
            return UITableViewCellEditingStyleDelete;
        }
            
        case FJ_CellEditingStyle_Insert:
        {
            return UITableViewCellEditingStyleInsert;
        }
            
        case FJ_CellEditingStyle_MultiSelection:
        {
            return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
        }
        case FJ_CellEditingStyle_None:
        default:
        {
            return UITableViewCellEditingStyleNone;
        }
    }
    return UITableViewCellEditingStyleNone;
}

// 当TableView的Cell的编辑风格为UITableViewCellEditingStyleDelete 或 UITableViewCellEditingStyleInsert时，响应事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    FJCellDataSource *fjCellData = [self getFJCellByIndexPath:indexPath];
    // 越界处理
    if (fjCellData == nil) {
        return;
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除(讲Cell的可视禁止参数调为YES)
        if (_fj_cellDeletionPolicy == FJ_CellDeletion_Policy_Hidden) {
            // 只是标记位设置隐藏
            fjCellData.disableVisible = YES;
            // 重新加载
            [self.innerTableView reloadData];
            
        }else{
            NSInteger row = [indexPath row];
            NSInteger section = [indexPath section];
            if (!self.fj_disableDeletionBeforeConfirm) {
                // 从DataSource中删除
                BOOL deleteSection = NO;
                if (_fj_allowMultiTableView) {
                    
                    FJMultiDataSource *multiDataSource = [_innerDataSource objectAtIndex:section];
                    [multiDataSource.cellDataSources removeObjectAtIndex:row];
                    if ([multiDataSource.cellDataSources count] == 0) {
                        [_innerDataSource removeObjectAtIndex:section];
                        deleteSection = YES;
                    }
                    
                }else{
                    
                    [_innerDataSource removeObjectAtIndex:row];
                    
                }
                
                // 删除动画
                if (deleteSection) {
                    [self.innerTableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:_fj_cellAnimation];
                }else{
                    [self.innerTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:_fj_cellAnimation];
                }
            }
        }
        
        // 标记后重新加载
        // 没有动画，全部重新加载
        // [self.tableView reloadData];
        
        // 删除代理方法
        if (self.delegate && [self.delegate respondsToSelector:@selector(fj_tableViewDidSelect:section:cellData:)]) {
            [self.delegate fj_tableViewDidSelect:row section:section cellData:fjCellData];
        }
        _cellActionBlock == nil ? : _cellActionBlock(FJ_CellBlockType_CellDeleted, row, section, fjCellData);
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // 插入
        if (self.delegate && [self.delegate respondsToSelector:@selector(fj_tableViewDidInsertRow:section:cellData:)]) {
            [self.delegate fj_tableViewDidInsertRow:row section:section cellData:fjCellData];
        }
        _cellActionBlock == nil ? : _cellActionBlock(FJ_CellBlockType_CellInterted, row, section, fjCellData);
    }
}

// 返回当前Cell是否可以移动
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fj_allowMoveCell == NO) {
        return NO;
    }
    
    FJCellDataSource *fjCellData = [self getFJCellByIndexPath:indexPath];
    if (fjCellData == nil) {
        return NO;
    }
    
    return fjCellData.allowMoveCell;
}

// 执行移动操作
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    // 移动后是否交换DataSource
    // 交换DataSource的位置
    // NSLog(@"from %d to %d", (int)[fromIndexPath row], (int)[toIndexPath row]);
    // 交换CellDataSource
    if (_fj_allowMultiTableView) {
        
    }else{
        
        NSInteger fromIndex = [fromIndexPath row];
        NSInteger toIndex = [toIndexPath row];
        
        if (fromIndex == toIndex) {
            return;
        }else if(fromIndex < toIndex) {
            FJCellDataSource *tempCellDataSource = [_innerDataSource objectAtIndex:fromIndex];
            for (int i = (int)fromIndex; i < toIndex; i++) {
                _innerDataSource[i] = _innerDataSource[i+1];
            }
            _innerDataSource[toIndex] = tempCellDataSource;
        }else{
            FJCellDataSource *tempCellDataSource = [_innerDataSource objectAtIndex:fromIndex];
            for (int i = (int)fromIndex; i > toIndex; i--) {
                _innerDataSource[i] = _innerDataSource[i-1];
            }
            _innerDataSource[toIndex] = tempCellDataSource;
        }
        [self.innerTableView reloadData];
    }
}

// 处理Cell间的分割线偏移的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] < 0 || [indexPath row] >= [_innerDataSource count]) {
        return;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

// Header View
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!_fj_allowMultiTableView) {
        return nil;
    }
    FJMultiDataSource *multiDataSource = [_innerDataSource objectAtIndex:section];
    FJHeaderViewDataSource *headerData = multiDataSource.headerViewDataSource;
    NSString *viewName = nil;
    if ([headerData isKindOfClass:[FJHeaderViewDataSource class]]) {
        viewName = [NSString stringWithUTF8String:object_getClassName(headerData)];
        viewName = [viewName stringByReplacingOccurrencesOfString:@"DataSource" withString:@""];
    }
    
    FJHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewName];
    if (view == nil) {
        id nib = [UINib nibWithNibName:viewName bundle:nil];
        [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:viewName];
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewName];
        
    }
    [view setHeaderDataSource:headerData];
    view.delegate = self;
    
    return view;
}

// Header View Height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_fj_allowMultiTableView) {
        FJMultiDataSource *multiDataSource = [_innerDataSource objectAtIndex:section];
        if (multiDataSource.headerViewDataSource == nil) {
            return 0.0;
        }else{
            return [multiDataSource.headerViewDataSource viewHeight];
        }
    }
    return 0.0f;
}

// Footer View Height
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.0f;
}

/***************************
 *  代理：scrollView滚动事件 *
 ***************************/
#pragma mark - scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate == nil && _cellScrollBlock == nil) {
        return;
    }
    
    _end_y = scrollView.contentSize.height - scrollView.bounds.size.height;
    
    // NSLog(@"%f",scrollView.contentOffset.y);
    // 完全交由子类实现
    if ([self.delegate respondsToSelector:@selector(fj_scrollViewDidScroll:)]) {
        [self.delegate fj_scrollViewDidScroll:scrollView];
    }
    _cellScrollBlock == nil ? : _cellScrollBlock(FJ_ScrollBlockType_Scroll, scrollView, 0, NO);
    
    CGFloat height = 0.0;
    if (scrollView.contentOffset.y >= _init_y && scrollView.contentOffset.y < _end_y) {
        // 当大于第一个临界值，并且，小于第二个临界值
        height = scrollView.contentOffset.y - _last_y;
        if (height > 0) {
            // 往下拉
            if ([self.delegate respondsToSelector:@selector(fj_scrollView:down:)]) {
                [self.delegate fj_scrollView:scrollView down:height];
            }
            _cellScrollBlock == nil ? : _cellScrollBlock(FJ_ScrollBlockType_Scroll_Moving_Down_Height, scrollView, height, NO);
        }else if (height < 0) {
            // 往上拉
            if ([self.delegate respondsToSelector:@selector(fj_scrollView:up:)]) {
                [self.delegate fj_scrollView:scrollView up:-height];
            }
            _cellScrollBlock == nil ? : _cellScrollBlock(FJ_ScrollBlockType_Scroll_Moving_Up_Height, scrollView, height, NO);
        }
    }else if(scrollView.contentOffset.y < _init_y){
        // 当小于第一临界值（表示开始进入下拉刷新准备状态）
        height = _init_y - scrollView.contentOffset.y;
        if ([self.delegate respondsToSelector:@selector(fj_scrollViewRefreshingHeader:height:)]) {
            [self.delegate fj_scrollViewRefreshingHeader:scrollView height:height];
        }
        _cellScrollBlock == nil ? : _cellScrollBlock(FJ_ScrollBlockType_Scroll_RefreshingView_Up_Height, scrollView, height, NO);
        
    }else if (scrollView.contentOffset.y >= _end_y) {
        height = scrollView.contentOffset.y - _end_y;
        if ([self.delegate respondsToSelector:@selector(fj_scrollViewLoadingMore:height:)]) {
            [self.delegate fj_scrollViewLoadingMore:scrollView height:height];
        }
        _cellScrollBlock == nil ? : _cellScrollBlock(FJ_ScrollBlockType_Scroll_LoadingView_Down_Height, scrollView, height, NO);
    }
    
    // 最后、记录下本次的contentOffset.y
    _last_y = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(fj_scrollViewWillBeginDragging:)]) {
        [self.delegate fj_scrollViewWillBeginDragging:scrollView];
    }
    _cellScrollBlock == nil ? : _cellScrollBlock(FJ_ScrollBlockType_Scroll_Drag_Will_Begin, scrollView, 0, NO);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(fj_scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate fj_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    _cellScrollBlock == nil ? : _cellScrollBlock(FJ_ScrollBlockType_Scroll_Drag_Did_End, scrollView, 0, decelerate);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(fj_scrollViewWillBeginDecelerating:)]) {
        [self.delegate fj_scrollViewWillBeginDecelerating:scrollView];
    }
    _cellScrollBlock == nil ? : _cellScrollBlock(FJ_ScrollBlockType_Scroll_Decelerating_Will_Begin, scrollView, 0, NO);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(fj_scrollViewDidEndDecelerating:)]) {
        [self.delegate fj_scrollViewDidEndDecelerating:scrollView];
    }
    _cellScrollBlock == nil ? : _cellScrollBlock(FJ_ScrollBlockType_Scroll_Decelerating_Did_End, scrollView, 0, NO);
}

/************************************
 * 代理：Cell和HeaderView的点击事件代理 *
 ************************************/
#pragma mark - Delegate FJCell
-(void)fjcell_actionRespond:(id)cellDataSource from:(id)fjCell {
    if (fjCell == nil || cellDataSource == nil) {
        return;
    }
    
    NSIndexPath *indexPath = [self.innerTableView indexPathForCell:fjCell];
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fj_tableViewCustomAction:section:cellData:)]) {
        
        [self.delegate fj_tableViewCustomAction:row section:section cellData:cellDataSource];
    }
    _cellActionBlock == nil ? : _cellActionBlock(FJ_CellBlockType_CellCustomizedTapped, row, section, cellDataSource);
}

#pragma mark - Delegate FJHeaderView
- (void)fjheader_actionRespond:(id)viewDataSource from:(id)fjHeaderView {
    
    
    if (self.fj_allowMultiTableView == NO) {
        return;
    }
    
    if (fjHeaderView == nil || viewDataSource == nil) {
        return;
    }
    
    for (int section = 0; section < [_innerDataSource count]; section++) {
        FJMultiDataSource *fjmds = [_innerDataSource objectAtIndex:section];
        id hds = fjmds.headerViewDataSource;
        if (hds == nil) {
            continue;
        }
        if ([viewDataSource isEqual:hds]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(fj_tableViewCustomAction:section:cellData:)]) {
                [self.delegate fj_tableViewCustomAction:-1 section:section cellData:viewDataSource];
            }
            _cellActionBlock == nil ? : _cellActionBlock(FJ_CellBlockType_CellCustomizedTapped, -1, section, viewDataSource);
            break;
        }
    }
}

/*************************
 *  Operation - 伸缩、滚动 *
 *************************/
// 延伸Cell
- (void)extend:(__kindof FJCellDataSource*)cellData {
    [self.innerTableView beginUpdates];
    [cellData extend];
    if (self.fj_allowMultiTableView) {
        
        for (int i = 0; i < [_innerDataSource count]; i++) {
            FJMultiDataSource *fjMultuDataSource = [_innerDataSource objectAtIndex:i];
            for (int j = 0 ; j < [fjMultuDataSource.cellDataSources count] ; j++) {
                FJCellDataSource *data = [fjMultuDataSource.cellDataSources objectAtIndex:j];
                if ([data isEqual:cellData]) {
                    FJCell *fjCell = [self.innerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                    if ([fjCell respondsToSelector:@selector(extend)]) {
                        [fjCell extend];
                    }
                    break;
                }
            }
        }
        
    }else{
        for (int i = 0; i < [_innerDataSource count]; i++) {
            FJCellDataSource *data = [_innerDataSource objectAtIndex:i];
            if ([data isEqual:cellData]) {
                FJCell *fjCell = [self.innerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if ([fjCell respondsToSelector:@selector(extend)]) {
                    [fjCell extend];
                }
                break;
            }
        }
    }
    [self.innerTableView endUpdates];
}

// 收缩Cell
- (void)collapse:(__kindof FJCellDataSource*)cellData {
    [self.innerTableView beginUpdates];
    [cellData collapse];
    if (self.fj_allowMultiTableView) {
        
        for (int i = 0; i < [_innerDataSource count]; i++) {
            FJMultiDataSource *fjMultuDataSource = [_innerDataSource objectAtIndex:i];
            for (int j = 0 ; j < [fjMultuDataSource.cellDataSources count] ; j++) {
                FJCellDataSource *data = [fjMultuDataSource.cellDataSources objectAtIndex:j];
                if ([data isEqual:cellData]) {
                    FJCell *fjCell = [self.innerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                    if ([fjCell respondsToSelector:@selector(collapse)]) {
                        [fjCell collapse];
                    }
                    break;
                }
            }
        }
        
    }else{
        for (int i = 0; i < [_innerDataSource count]; i++) {
            FJCellDataSource *data = [_innerDataSource objectAtIndex:i];
            if ([data isEqual:cellData]) {
                FJCell *fjCell = [self.innerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if ([fjCell respondsToSelector:@selector(collapse)]) {
                    [fjCell collapse];
                }
                break;
            }
        }
    }
    [self.innerTableView endUpdates];
}

// 自动伸缩Cell
- (void)autoExtendAndCollapse:(__kindof FJCellDataSource*)cellData {
    [self.innerTableView beginUpdates];
    [cellData autoExtendAndCollapse];
    if (self.fj_allowMultiTableView) {
        
        for (int i = 0; i < [_innerDataSource count]; i++) {
            FJMultiDataSource *fjMultuDataSource = [_innerDataSource objectAtIndex:i];
            for (int j = 0 ; j < [fjMultuDataSource.cellDataSources count] ; j++) {
                FJCellDataSource *data = [fjMultuDataSource.cellDataSources objectAtIndex:j];
                if ([data isEqual:cellData]) {
                    FJCell *fjCell = [self.innerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                    if (data.extended == YES) {
                        if ([fjCell respondsToSelector:@selector(extend)]) {
                            [fjCell extend];
                        }
                    }else{
                        if ([fjCell respondsToSelector:@selector(collapse)]) {
                            [fjCell collapse];
                        }
                    }
                    break;
                }
            }
        }
        
    }else{
        for (int i = 0; i < [_innerDataSource count]; i++) {
            FJCellDataSource *data = [_innerDataSource objectAtIndex:i];
            if ([data isEqual:cellData]) {
                FJCell *fjCell = [self.innerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (data.extended == YES) {
                    if ([fjCell respondsToSelector:@selector(extend)]) {
                        [fjCell extend];
                    }
                }else{
                    if ([fjCell respondsToSelector:@selector(collapse)]) {
                        [fjCell collapse];
                    }
                }
                break;
            }
        }
    }
    [self.innerTableView endUpdates];
}

#pragma mark - 滚动
// 滚动到某个indexPath
- (void)scrollToIndexPath:(NSIndexPath*)indexPath position:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    FJCellDataSource *fjCellData = [self getFJCellByIndexPath:indexPath];
    // 越界处理
    if (fjCellData == nil) {
        return;
    }
    [self.innerTableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

// 滚动到某个FJCellDataSource
- (void)scrollToCellDataSource:(__kindof FJCellDataSource*)cellDataSource position:(UITableViewScrollPosition)position animated:(BOOL)animated {
    
    if (_fj_allowMultiTableView) {
        for (int section = 0; section < [_innerDataSource count]; section++) {
            FJMultiDataSource *multiData = [_innerDataSource objectAtIndex:section];
            for (int row = 0; row < [multiData.cellDataSources count]; row++) {
                FJCellDataSource *fjCellData = [multiData.cellDataSources objectAtIndex:row];
                if ([fjCellData isEqual:cellDataSource]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    [self.innerTableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:animated];
                    break;
                }
            }
        }
    }else{
        for (int i = 0; i < [_innerDataSource count]; i++) {
            FJCellDataSource *fjCellData = [_innerDataSource objectAtIndex:i];
            if ([fjCellData isEqual:cellDataSource]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.innerTableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:animated];
                break;
            }
        }
    }
}

// 滚动到第一个CellDataSource的类型
- (void)scrollToTheFirstCellClass:(Class)dataSourceClass position:(UITableViewScrollPosition)position animated:(BOOL)animated {
    for (int i = 0; i < [_innerDataSource count]; i++) {
        FJCellDataSource *cellDS = [_innerDataSource objectAtIndex:i];
        if ([cellDS isMemberOfClass:dataSourceClass]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.innerTableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:animated];
            break;
        }
    }
}


/******************************
 *           内部方法          *
 ******************************/
// 根据cellData获取实际对应到TableView的Row Index
- (int)getVisibleIndex:(NSArray*)cellDataSources cellData:(__kindof FJCellDataSource*)cellData{
    for (int i = 0, j = -1; i < [cellDataSources count]; i++) {
        FJCellDataSource *ds = [cellDataSources objectAtIndex:i];
        
        if (ds.disableVisible == NO) {
            j++;
        }
        
        if ([ds isEqual:cellData]) {
            return j;
        }
    }
    return NOT_FOUND_INDEX;
}

// 根据cellData的类型获取实际对应到第一个TableView的Row Index
- (int)getVisibleIndex:(NSArray*)cellDataSources cellClass:(id)cellClass{
    for (int i = 0, j = -1; i < [cellDataSources count]; i++) {
        FJCellDataSource *ds = [cellDataSources objectAtIndex:i];
        
        if (ds.disableVisible == NO) {
            j++;
        }
        
        if ([ds isMemberOfClass:cellClass]) {
            return j;
        }
    }
    return NOT_FOUND_INDEX;
}

// 根据Index获得Cell
- (id)cellForRow:(NSInteger)row section:(NSInteger)section{
    
    if (row < 0 || section < 0) {
        return nil;
    }
    
    return [self.innerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
}

// 根据DataSource获得Cell
- (id)cellForDataSource:(__kindof FJCellDataSource*)cellDataSource{
    
    if (_fj_allowMultiTableView) {
        
        for (int section = 0 ; section < [_innerDataSource count]; section++) {
            FJMultiDataSource *multiDataSource = [_innerDataSource objectAtIndex:section];
            int row = [self getVisibleIndex:multiDataSource.cellDataSources cellData:cellDataSource];
            if (row != NOT_FOUND_INDEX) {
                return [self cellForRow:row section:section];
            }
        }
        
    }else{
        
        int row = [self getVisibleIndex:_innerDataSource cellData:cellDataSource];
        if (row != NOT_FOUND_INDEX) {
            return [self cellForRow:row section:0];
        }
    }
    
    return nil;
}

// 根据DataSource的类型获得Cell （若存在多个，仅返回第一个cell）
- (id)cellForClass:(id)cellClass {
    
    if (_fj_allowMultiTableView) {
        
        for (int section = 0 ; section < [_innerDataSource count]; section++) {
            FJMultiDataSource *multiDataSource = [_innerDataSource objectAtIndex:section];
            int row = [self getVisibleIndex:multiDataSource.cellDataSources cellClass:cellClass];
            if (row != NOT_FOUND_INDEX) {
                return [self cellForRow:row section:section];
            }
        }
        
    }else{
        int row = [self getVisibleIndex:_innerDataSource cellClass:cellClass];
        if (row != NOT_FOUND_INDEX) {
            return [self cellForRow:row section:0];
        }
    }
    
    return nil;
}

// 根据DataSource的类型获得Cells
- (NSMutableArray*)cellsForClass:(id)cellClass {
    NSMutableArray *ret = nil;
    
    if (_fj_allowMultiTableView) {
        for (int section = 0 ; section < [_innerDataSource count]; section++) {
            FJMultiDataSource *multiDataSource = [_innerDataSource objectAtIndex:section];
            for (int i = 0, j = -1; i < [multiDataSource.cellDataSources count]; i++) {
                FJCellDataSource *ds = [multiDataSource.cellDataSources objectAtIndex:i];
                if (ds.disableVisible == NO) {
                    j++;
                }
                
                if ([ds isMemberOfClass:cellClass]) {
                    if (!ret) {
                        ret = [[NSMutableArray alloc] init];
                    }
                    id cell = [self cellForRow:j section:section];
                    if (cell) {
                        [ret addObject:cell];
                    }
                }
            }
        }
    }else{
        for (int i = 0, j = -1; i < [_innerDataSource count]; i++) {
            FJCellDataSource *ds = [_innerDataSource objectAtIndex:i];
            if (ds.disableVisible == NO) {
                j++;
            }
            
            if ([ds isMemberOfClass:cellClass]) {
                if (!ret) {
                    ret = [[NSMutableArray alloc] init];
                }
                id cell = [self cellForRow:j section:0];
                if (cell) {
                    [ret addObject:cell];
                }
            }
        }
    }
    return ret;
}

// 根据Index获得DataSource
- (id)dataSourceForRow:(NSInteger)row {
    return [_innerDataSource objectAtIndex:row];
}

// 根据DataSource的类型获得DataSource （若存在多个，仅返回第一个DataSource）
- (id)dataSourceForClass:(id)cellClass {
    for (int i = 0; i < [_innerDataSource count]; i++) {
        FJCellDataSource *ds = [_innerDataSource objectAtIndex:i];
        if ([ds isMemberOfClass:cellClass]) {
            return ds;
        }
    }
    return nil;
}

// 根据DataSource的类型获得DataSources
- (NSMutableArray*)dataSourcesForClass:(id)cellClass {
    NSMutableArray *ret = nil;
    for (int i = 0; i < [_innerDataSource count]; i++) {
        FJCellDataSource *ds = [_innerDataSource objectAtIndex:i];
        if ([ds isMemberOfClass:cellClass]) {
            if (!ret) {
                ret = [[NSMutableArray alloc] init];
            }
            [ret addObject:ds];
        }
    }
    return ret;
}


// 根据Index重新加载Cell
- (void)reloadCellForRow:(NSInteger)row section:(NSInteger)section{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.innerTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

// 根据DataSource重新加载Cell
- (void)reloadCellForDataSource:(__kindof FJCellDataSource*)cellDataSource {
    if (_fj_allowMultiTableView) {
        
        for (int section = 0; section < [_innerDataSource count]; section++) {
            FJMultiDataSource *multiDataSource = [_innerDataSource objectAtIndex:section];
            int row = [self getVisibleIndex:multiDataSource.cellDataSources cellData:cellDataSource];
            if (row != NOT_FOUND_INDEX) {
                [self reloadCellForRow:row section:section];
                break;
            }
        }
        
    }else{
        int row = [self getVisibleIndex:_innerDataSource cellData:cellDataSource];
        [self reloadCellForRow:row section:0];
    }
}

// 根据DataSource的类型重新加载所有的Cells
- (void)reloadCellsForClass:(id)cellClass {
    
    NSMutableArray *indexPaths = nil;
    if (_fj_allowMultiTableView) {
        for (int section = 0 ; section < [_innerDataSource count]; section++) {
            FJMultiDataSource *multiDataSource = [_innerDataSource objectAtIndex:section];
            for (int i = 0, j = -1; i < [multiDataSource.cellDataSources count]; i++) {
                FJCellDataSource *ds = [multiDataSource.cellDataSources objectAtIndex:i];
                if (ds.disableVisible == NO) {
                    j++;
                }
                
                if ([ds isMemberOfClass:cellClass]) {
                    if (!indexPaths) {
                        indexPaths = [[NSMutableArray alloc] init];
                    }
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:section];
                    [indexPaths addObject:indexPath];
                }
            }
        }
    }else{
        for (int i = 0, j = -1; i < [_innerDataSource count]; i++) {
            FJCellDataSource *ds = [_innerDataSource objectAtIndex:i];
            if (ds.disableVisible == NO) {
                j++;
            }
            
            if ([ds isMemberOfClass:cellClass]) {
                if (!indexPaths) {
                    indexPaths = [[NSMutableArray alloc] init];
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:0];
                [indexPaths addObject:indexPath];
            }
        }
    }
    [self.innerTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:_fj_cellAnimation];
}


// 检查indexPath的合法性
- (__kindof FJCellDataSource*)getFJCellByIndexPath:(NSIndexPath*)indexPath {
    
    if (_innerDataSource == nil || [_innerDataSource count] == 0) {
        return nil;
    }
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    if (_fj_allowMultiTableView) {
        
        if (section < 0 || section >= [_innerDataSource count]) {
            return nil;
        }
        
        FJMultiDataSource *multiDataSource = [_innerDataSource objectAtIndex:section];
        if (row < 0 || row >= [multiDataSource.cellDataSources count]) {
            return nil;
        }
        
        return [self getVisibleCell:multiDataSource.cellDataSources row:row];
        
    }else{
        
        if (row < 0 || row >= [_innerDataSource count]) {
            return nil;
        }
        
        return [self getVisibleCell:_innerDataSource row:row];
    }
    
    return nil;
}

// 获取第row个非disableVisible的Cell
- (__kindof FJCellDataSource*)getVisibleCell:(NSArray*)cellDataSources row:(NSInteger)row {
    for (int i = 0, j = -1; i < [cellDataSources count]; i++) {
        FJCellDataSource *fjCellData = [cellDataSources objectAtIndex:i];
        if (fjCellData.disableVisible == NO) {
            j++;
        }
        if (row == j) {
            return [cellDataSources objectAtIndex:i];
        }
    };
    return nil;
}

@end
