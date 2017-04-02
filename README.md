![](./images/banner.png)

# How To Get Started

> FJTableView is a customized data-driven tableview.

## Installation with CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like FJTableView in your projects. See the [Get Started section](https://cocoapods.org/#get_started) for more details.

### Podfile

To integrate FJTableView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```shell
pod 'FJTableView', :git => 'https://github.com/jeffnjut/FJTableView.git'
```

Then, run the following command:

```shell
$ pod install
```

If any update occurs, run the following command:

```shell
$ pod update
```


### Import

Import FJTableView Header File

```objectivec
#import <FJTableView/FJTableViewHeader.h>
```

## Usage

### Fast Involve FJTableView

```objectivec
FJTableView *tableView = [FJTableView FJTableView:CGRectMake(0, 0, size.width, size.height) editStyle:0 seperatorStyle:0 bgColor:nil];
[self.view addSubview:tableView];
```

### Make Cell & DataSource
#### Cell Header
```objectivec
@interface FeedsCell : FJCell

@end

@interface FeedsCellDataSource : FJCellDataSource
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cover_url;

@end
```

#### Cell Coding
You could write UI in coding or xib, method setCellDataSource must be implemented if some cell data passed from TableView's DataSource. And If transferring event from cell to controller, you must call [fjcell_actionRespond:] to notice controller that you have tapped some button or anything.In DataSource coding, there's a key atrribute "cellHeight" which refers to the height of itself.
```objectivec
@interface FeedsCell()
@property (nonatomic, weak) IBOutlet UIImageView *iv_feeds;
@property (nonatomic, weak) IBOutlet UILabel *lb_name;

@end

@implementation FeedsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

- (void)setCellDataSource:(FJCellDataSource *)cellDataSource {
    [super setCellDataSource:cellDataSource];
    FeedsCellDataSource *ds = (FeedsCellDataSource*)cellDataSource;
    // write something rendering cell with data.
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
        self.cellHeight = 201.0;
    }
    return self;
}

@end

```
### Make Section & DataSource
If section is enabled, section header and section footer is similar with cell style, but they inherited from FJHeaderView & FJHeaderViewDataSource
```objectivec
@interface FeedsHeaderView : FJHeaderView

@end

@interface FeedsHeaderViewDataSource : FJHeaderViewDataSource

@end

```

```objectivec
@interface FeedsHeaderView()

@end


@implementation FeedsHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setHeaderDataSource:(__kindof FJHeaderViewDataSource *)headerDataSource {
    [super setHeaderDataSource:headerDataSource];
}

- (IBAction)tap:(id)sender {
    FeedsHeaderViewDataSource *ds = self.headerDataSource;
    [self.delegate fjheader_actionRespond:ds from:self];
}

@end

@implementation FeedsHeaderViewDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewHeight = 60.0;
    }
    return self;
}
```

### Start Loading Data & Rendering UI

```objectivec
// Loaded Data >>>> FeedsCellDataSource
for (NSString *data in loadedData) {
    FeedsCellDataSource *feedDataSource = [[FeedsCellDataSource alloc] init];
    feedDataSource.name = data;
    [self.tableView addDataSource:feedDataSource];
}

// When dataSource is ready, refreshing is required
[self.tableView refresh];
```

### Write A TableView With Section Header
```objectivec
// Section 1
FJMultiDataSource *multiDataSource = [[FJMultiDataSource alloc] init];
multiDataSource.cellDataSources = [[NSMutableArray<FJCellDataSource> alloc] init];

// Banner Cell
BannerCellDataSource *bannerDataSource = [[BannerCellDataSource alloc] init]; 
[multiDataSource.cellDataSources addObject:bannerDataSource];
[self.tableView addDataSource:multiDataSource];
        
// Section 2
multiDataSource = [[FJMultiDataSource alloc] init];
multiDataSource.cellDataSources = [[NSMutableArray<FJCellDataSource> alloc] init];
    
// Header
FeedsHeaderViewDataSource *headerDataSource = [[FeedsHeaderViewDataSource alloc] init];
multiDataSource.headerViewDataSource = headerDataSource;

for (NSString *data in loadedData) {
    FeedsCellDataSource *feedDataSource = [[FeedsCellDataSource alloc] init];
    feedDataSource.name = data;
    [multiDataSource.cellDataSources addObject:feedDataSource];
}
[self.tableView addDataSource:feedDataSource];

// Refresh
[self.tableView refresh];

```

### Write Block for Dealing with Action Occurs on Cell
```objectivec

__weak typeof(self) weakSelf = self;
[tableView setCellActionBlock:^(FJ_CellBlockType type, NSInteger row, NSInteger section, __kindof FJCellDataSource *cellData) {

    switch (type) {
        case FJ_CellBlockType_CellTapped:
        {
            NSLog(@"Cell Tapped");
            break;
        }

        case FJ_CellBlockType_CellCustomizedTapped:
        {
            if ([cellData isKindOfClass:[FeedsCellDataSource class]]) {
                NSLog(@"Cell Clicked");
            }else if ([cellData isKindOfClass:[FeedsHeaderViewDataSource class]]) {
                NSLog(@"Header Clicked");
            }
            break;
        }

        case FJ_CellBlockType_CellMultiSelected:
        {
            if (cellData.multiSelected) {
                NSLog(@"Multi Selected");
            } else {
                NSLog(@"Multi De-Selected");
            }
            break;
        }

        case FJ_CellBlockType_CellDeleted:
        {
            NSLog(@"Deleted");
            break;
        }

        case FJ_CellBlockType_CellDeletedWConfirm:
        {
            NSLog(@"Deleted W Confirm");

            [[weakSelf.tableView dataSource] removeDataSource:cellData];
            [weakSelf.tableView refresh];
            break;
        }

        case FJ_CellBlockType_CellInserted:
        {
            NSLog(@"Inserted");
            static int i = 1;
            FeedsCellDataSource *feedDataSource = [[FeedsCellDataSource alloc] init];
            feedDataSource.name = [NSString stringWithFormat:@"Insert(%d)", (int)i++];
            [[weakSelf.tableView dataSource] insertDataSource:feedDataSource at:cellData append:YES];
            [weakSelf.tableView refresh];
            break;
        }

        case FJ_CellBlockType_CellMoved:
        {
            NSLog(@"Moved");
            break;
        }
    }
}];

```

### Write Block for Scrolling Action
```objectivec
[self.tableView setCellScrollBlock:^(FJ_ScrollBlockType type, UIScrollView *scrollView, CGFloat height, BOOL willDecelerate) {
    NSLog(@"type = %d, height = %f", (int)type, height);
}];

```

### Write MJRefresh with FJTableView seamlessly
```objectivec
[self.tableView tableView].mj_header = MJHeader Object ...
[self.tableView tableView].mj_footer = MJFooter Object ...

```

```objectivec

```

# Contribute

Feel free to open an issue or pull request, if you need help or there is a bug.

# Contact

- Powered by [Jeff NJUT](https://github.com/jeffnjut)
- If any bug or question, please email me [Jeff NJUT](mailto://jeff_njut@163.com)

# Todo

- Documentation

# License

FJTableView is available under the MIT license. See the LICENSE file for more info.

The MIT License (MIT)

Copyright (c) 2017 Jeff

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
