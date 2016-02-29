//
//  ViewController.m
//  searchBarTest
//
//  Created by admin on 16/1/27.
//  Copyright © 2016年 CC. All rights reserved.
//
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#import "LeftViewController.h"
#import "Masonry.h"


@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic) CGFloat lastPostionY;

@property (nonatomic) BOOL isSearchBarMoving;

@property (nonatomic) CGFloat currentBarHeight;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self setStatusBar];
    
    WS(weakSelf)
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-49);
    }];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"搜索";
    [self.view addSubview:self.searchBar];
    [self.view sendSubviewToBack:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(20);
        make.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@44);
    }];
    
    self.currentBarHeight = 44;
    [self profileData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)setStatusBar {
    UIView *statusBarBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20)];
    statusBarBg.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:statusBarBg];
    
}


- (void)profileData {
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 40; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
    }
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndetifier = @" cellIndetifier";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndetifier];
        
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}




#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.searchBar.isFirstResponder) {
        [self.searchBar endEditing:YES];
    }
    
    CGFloat y = scrollView.contentOffset.y;
    
    if (y <= 0) {
        return;
    } else if ((y + MainScreenHeight - 70) >= scrollView.contentSize.height) {
        return;
    }
    
    self.currentBarHeight +=(y - self.lastPostionY);
    
    
    
    WS(weakSelf)
    
    if ((y - self.lastPostionY) > 0) {
   
        if (self.currentBarHeight >= 44) {
            self.currentBarHeight = 44;
        }
        
    } else if ((y - self.lastPostionY) < 0){
        
        if (self.currentBarHeight <= 0) {
            self.currentBarHeight = 0;
        }
        
    }
   
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64 - self.currentBarHeight);
    }];
    
    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(20 - self.currentBarHeight);
    }];
    
    self.lastPostionY = y;
    NSLog(@"%.2f",y);
    
    
}


@end
