//
//  RecordListView.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/3.
//  Copyright © 2019 finger. All rights reserved.
//

#import "RecordListViewController.h"
#import "QMSegmentContainer.h"
#import "RecordListView.h"

typedef NS_ENUM(NSInteger) {
    RecordTypeNormalMode =0,
    RecordTypeTimeLimitMode,
    RecordTypeCount
}RecordType;

@interface RecordListViewController()<QMSegmentContainerDelegate>

@property (nonatomic,strong) QMSegmentContainer *segmentView;
@end

@implementation RecordListViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.segmentView];
    [self.view bringSubviewToFront:self.backButton];
}


#pragma mark - Property

- (QMSegmentContainer *)segmentView {
    if (!_segmentView) {
        _segmentView = [[QMSegmentContainer alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _segmentView.delegate = self;
        _segmentView.segmentTopBar.indicatorHeight = 0;
        _segmentView.segmentTopBar.titleNormalColor = [UIColor grayColor];
        _segmentView.segmentTopBar.titleSelectedColor = [UIColor whiteColor];
        _segmentView.segmentTopBar.bgColor = [UIColor clearColor];
        _segmentView.segmentTopBar.titleFont = font(18);
        _segmentView.segmentTopBar.titleSelectedFont = font(18);
//        _segmentView.backgroundColor = RGBAlpha(0x06, 0x70, 0xbc, 0.8);
        _segmentView.backgroundColor = [UIColor clearColor];
    }
    return _segmentView;
}

#pragma mark - SegmentContainer Delegate
- (NSInteger)numberOfItemsInTopBar:(UIView<QMSegmentTopBarProtocol> *)topBar {
    return RecordTypeCount;
}

- (NSString *)topBar:(UIView<QMSegmentTopBarProtocol> *)segmentTopBar titleForItemAtIndex:(NSInteger)index {
    if (index == RecordTypeNormalMode) {
        return @"挑战模式";
    }else{
        return @"限时模式";
    }
}

- (id)segmentContainer:(QMSegmentContainer *)segmentContainer contentForIndex:(NSInteger)index {
    RecordListView *view = [[RecordListView alloc] initWithFrame:segmentContainer.containerView.bounds];
    RecordViewModel *vm = [[RecordViewModel alloc] init];
    if (index == RecordTypeNormalMode) {
        vm.gameMode = GameModeFree;
    }else {
        vm.gameMode = GameModeTimeLimit;
    }
    vm.isLocalRecord = NO;
    view.viewModel = vm;
    return view;
}

@end
