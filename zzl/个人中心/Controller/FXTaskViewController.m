
//
//  FXTaskViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/14.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXTaskViewController.h"
#import "FXTaskCell.h"
#import "FXTaskModel.h"
#import "LSJTaskHeaderView.h"
#import "LSJTaskPopView.h"
@interface FXTaskViewController ()<UITableViewDelegate,UITableViewDataSource,LSJTaskPopViewDelegate>
{
    NSInteger taskNum;
}
@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) NSArray * cellConfigArr;
@property (nonatomic,strong) LSJTaskHeaderView *headerV;
@property (nonatomic,strong) LSJTaskPopView *popV;
@end

@implementation FXTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    taskNum = 0;
    self.title = @"每日任务";
    [self.view addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.tableHeaderView = self.headerV;
    [self loadTastListData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellConfigArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseId = @"cell";
    FXTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[FXTaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    NSInteger index;
    if (indexPath.section==1) {
        index = indexPath.row+4;
    }else{
        index = indexPath.row;
    }
    cell.model = self.cellConfigArr[indexPath.row];
    NSString *imgStr = [NSString stringWithFormat:@"task_icon_%zd",indexPath.row];
    cell.icon.image = [UIImage imageNamed:imgStr];
    cell.icon.contentMode = UIViewContentModeCenter;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return Py(10);
    }
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FXTaskModel *model = self.cellConfigArr[indexPath.row];
    if ([model.status isEqualToString:@"1"]) {
        [self loadRawAwardDataWithType:model.sign_type money:model.award_num];
    }
}

#pragma mark 获取用户任务列表
- (void)loadTastListData{
    NSString *path = @"task";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            self.cellConfigArr = [FXTaskModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            NSString *num = [dic[@"num"] stringValue];
            taskNum = [num integerValue];
            NSString *money = [dic[@"money"] stringValue];
            [self.headerV refershViewWithTaskNum:num zuanshiNum:money];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 领取任务奖励
- (void)loadRawAwardDataWithType:(NSString *)type money:(NSString *)money{
    NSString *path = @"taskClaim";
    NSDictionary *params = @{@"uid":KUID,@"type":type,@"money":money};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"领取成功" toView:self.tableView];
            
            if (taskNum == 2 || taskNum == 4 || taskNum == 6 || taskNum == 8) {
                NSString *award_num = @"0";
                if (taskNum == 2) {
                    award_num = @"200";
                }else if (taskNum == 4){
                    award_num = @"400";
                }else if (taskNum == 6){
                    award_num = @"600";
                }else if (taskNum == 8){
                    award_num = @"1000";
                }else{
                    award_num = @"0";
                }
                [self bringActionWithNum:taskNum+1 award_num:award_num];
            }
            
            NSInteger mark = [dic[@"data"][@"ward_id"] integerValue];
            switch (mark) {
                case 1:
                    [MobClick event:@"pay_one_game"];
                    break;
                case 2:
                    [MobClick event:@"task_center_shared"];
                    break;
                case 3:
                    [MobClick event:@"get_one_baby"];
                    break;
                case 4:
                    [MobClick event:@"get_three_baby"];
                    break;
                case 5:
                    [MobClick event:@"get_10baby"];
                    break;
                case 9:
                    [MobClick event:@"shared_friends_10"];
                    break;
                case 7:
                    [MobClick event:@"everyday_pay"];
                    break;
                case 8:
                    [MobClick event:@"signin_seven_days"];
                    break;
                default:
                    break;
            }
            [self loadTastListData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)bringActionWithNum:(NSInteger)num award_num:(NSString *)award_num{
    NSString *path = @"taskWindow";
    NSDictionary *params = @{@"uid":KUID,@"num":@(num),@"money":award_num};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            
            [[UIApplication sharedApplication].keyWindow addSubview:self.popV];
            [self.popV refreshViewWithNum:taskNum+1 award_num:award_num];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark LSJTaskPopViewDelegate
- (void)sureBringActionWithNum:(NSInteger)num award_num:(NSString *)award_num{
    
    [self.popV removeFromSuperview];
}

#pragma mark lazy load

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BGColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor =DYGColorFromHex(0xe6e6e6);
    }
    return _tableView;
}
-(NSArray *)cellConfigArr{
    if (!_cellConfigArr) {
        _cellConfigArr = [NSArray array];
                           
    }
    return _cellConfigArr;
}
- (LSJTaskHeaderView *)headerV{
    if (!_headerV) {
        _headerV = [[LSJTaskHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, Py(139))];
        _headerV.backgroundColor = [UIColor whiteColor];
    }
    return _headerV;
}
- (LSJTaskPopView *)popV{
    if (!_popV) {
        _popV = [[LSJTaskPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _popV.delegate = self;
    }
    return _popV;
}

@end
