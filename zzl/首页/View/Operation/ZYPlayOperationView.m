//
//  ZYPlayOperationView.m
//  WawaSDKDemo
//
//

#import <Foundation/Foundation.h>
#import "ZYPlayOperationView.h"


static NSTimeInterval LPressTimerInteraval = 0.1f; // 秒
static NSTimeInterval RPressTimerInteraval = 0.05f; // 秒

@interface ZYPlayOperationView () {
    BOOL _operationDisable;
}

@property (nonatomic, copy) NSArray *directionArray;
@property (nonatomic, copy) NSArray *currDirs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBtn_trailing;
@property (nonatomic,strong) UIImageView *bgimgV;

@end

@implementation ZYPlayOperationView

+ (instancetype)operationView {
    ZYPlayOperationView * view = [[NSBundle mainBundle] loadNibNamed:@"ZYPlayOperationView" owner:nil options:nil].lastObject;
    [view initUI];
    [view initData];
    
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self initData];
    }
    return self;
}

- (void)initUI {
    
    if (kScreenWidth < 370) {
        for (UIButton * btn in @[self.upBtn,self.downBtn,self.leftBtn,self.rightBtn]) {
            CGRect frame = btn.frame;
            frame.origin.x -= 18;
            btn.frame = frame;
        }
        self.confirmBtn_trailing.constant = 10;
    }
    [self addSubview:self.bgimgV];
    [self.bgimgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@(0));
        make.right.equalTo(@(0));
        make.bottom.equalTo(@(0));
    }];
    [self addSubview:self.viewBtn];
    [self.viewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Px(10)));
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(Px(68)));
        make.height.equalTo(@(Py(53)));
    }];
    self.viewBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(Px(-10)));
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(Px(68)));
        make.height.equalTo(@(Py(53)));
    }];
    self.confirmBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:self.upBtn];
    [self.upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Py(-10)));
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(Px(68)));
        make.height.equalTo(@(Py(53)));
    }];
    self.upBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upBtn.mas_bottom).offset(Py(-14));
        make.right.equalTo(self.upBtn.mas_left).offset(Px(20));
        make.width.equalTo(@(Px(68)));
        make.height.equalTo(@(Py(53)));
    }];
    self.leftBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upBtn.mas_bottom).offset(Py(-14));
        make.left.equalTo(self.upBtn.mas_right).offset(Px(-20));
        make.width.equalTo(@(Px(68)));
        make.height.equalTo(@(Py(53)));
    }];
    self.rightBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:self.downBtn];
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightBtn.mas_bottom).offset(Py(-14));
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(Px(68)));
        make.height.equalTo(@(Py(53)));
    }];
    self.downBtn.adjustsImageWhenHighlighted = NO;
    
}

- (void)changeView:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(changePerspective:)]) {
        [self.delegate changePerspective:sender.selected];
    }
}

- (void)initData {
    _directionArray = @[
                        @[@(PlayDirection_Up), @(PlayDirection_Left), @(PlayDirection_Down), @(PlayDirection_Right)], // 上，左，下，右
                        @[@(PlayDirection_Right), @(PlayDirection_Up), @(PlayDirection_Left), @(PlayDirection_Down)], // 右，上，左，下
                        @[@(PlayDirection_Left), @(PlayDirection_Down), @(PlayDirection_Right), @(PlayDirection_Up)]  // 左，下，右，上
                        ];
    _currDirs = _directionArray[CameraDirection_Front];
}

#pragma mark - Public Methods
- (BOOL)operationDisable {
    return _operationDisable;
}

- (void)setOperationDisable:(BOOL)operationDisable {
    if (_operationDisable != operationDisable) {
        _operationDisable = operationDisable;
        _upBtn.enabled = !operationDisable;
        _downBtn.enabled = !operationDisable;
        _leftBtn.enabled = !operationDisable;
        _rightBtn.enabled = !operationDisable;
        _confirmBtn.enabled = !operationDisable;
    }
}

- (void)setCameraDir:(CameraDirection)cameraDir {
    if (_cameraDir != cameraDir) {
        _cameraDir = cameraDir;
        _currDirs = _directionArray[cameraDir];
    }
}

- (PlayDirection)mapRelativeDirection:(PlayDirection)btnDir {
    PlayDirection dir = [_currDirs[btnDir] integerValue];
    return dir;
}

- (IBAction)onUpButtonClicked:(UIButton *)sender {
    [self onButtonClicked:sender];
}

- (IBAction)onLeftButtonClicked:(UIButton *)sender {
    [self onButtonClicked:sender];
}

- (IBAction)onDownButtonClicked:(UIButton *)sender {
    [self onButtonClicked:sender];
}


- (IBAction)onRightButtonClicked:(UIButton *)sender {
    [self onButtonClicked:sender];
}

- (IBAction)onConfirmButtonClicked:(UIButton *)sender {
    [self onButtonClicked:sender];
}

- (void)onButtonPressed:(UIButton *)sender {
    OBShapedButton *button = (OBShapedButton *)sender;
    BOOL startLongPress = YES;
    if (button == self.upBtn) {
        NSLog(@"%s: up", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_up"] forState:UIControlStateHighlighted];
    }
    else if (button == self.downBtn) {
        NSLog(@"%s: down", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_down"] forState:UIControlStateHighlighted];
    }
    else if (button == self.leftBtn) {
        NSLog(@"%s: left", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_left"] forState:UIControlStateHighlighted];
    }
    else if (button == self.rightBtn) {
        NSLog(@"%s: right", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_right"] forState:UIControlStateHighlighted];
    }
    else if (button == self.confirmBtn) {
        NSLog(@"%s: confirm", __PRETTY_FUNCTION__);
        startLongPress = NO;
        [button setImage:[UIImage imageNamed:@"op_press_confirm"] forState:UIControlStateHighlighted];
    }
    
    [self invalidTimerByButton:button clearTimer:YES];
    // 开始长压timer
    if (startLongPress) {
        button.longPTimer = [NSTimer scheduledTimerWithTimeInterval:LPressTimerInteraval target:self selector:@selector(longPressTimeOut:) userInfo:@{@"btn":button} repeats:NO];
    }
}

- (void)onButtonClicked:(UIButton *)sender {
    NSLog(@"%s: up", __PRETTY_FUNCTION__);
    OBShapedButton *button = (OBShapedButton *)sender;
    if ([button.longPTimer isValid]) {
        // 1.清空timer
        [button.longPTimer invalidate];
        button.longPTimer = nil;
    }
    else {
        if (button != self.confirmBtn) {
            // 下抓按钮没有长压
            return;
        }
    }
    
    if (button == self.upBtn) {
//        NSLog(@"%s: up", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_up"] forState:UIControlStateFocused];
        if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
            [self.delegate onPlayDirection:[self mapRelativeDirection:PlayDirection_Up] operationType:PlayOperationType_Click];
        }
    }
    else if (button == self.downBtn) {
//        NSLog(@"%s: down", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_down"] forState:UIControlStateSelected];
        if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
            [self.delegate onPlayDirection:[self mapRelativeDirection:PlayDirection_Down] operationType:PlayOperationType_Click];
        }
    }
    else if (button == self.leftBtn) {
//        NSLog(@"%s: left", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_left"] forState:UIControlStateFocused];
        if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
            [self.delegate onPlayDirection:[self mapRelativeDirection:PlayDirection_Left] operationType:PlayOperationType_Click];
        }
    }
    else if (button == self.rightBtn) {
//        NSLog(@"%s: right", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_right"] forState:UIControlStateFocused];
        if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
            [self.delegate onPlayDirection:[self mapRelativeDirection:PlayDirection_Right] operationType:PlayOperationType_Click];
        }
    }
    else if (button == self.confirmBtn) {
        NSLog(@"%s: confirm", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_confirm"] forState:UIControlStateFocused];
        if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
            [self.delegate onPlayDirection:PlayDirection_Confirm operationType:PlayOperationType_Click];
        }
    }
}

- (void)onButtonTouchInside:(UIButton *)sender {
    [self onButtonClicked:sender];
    OBShapedButton *button = (OBShapedButton *)sender;
    BOOL sendRelease = YES;
    if (!button.longPTimer) {
        // timer 被置空，不发送release事件
        sendRelease = NO;
    }
    // 2.清空timer
    button.longPTimer = nil;
    
    PlayDirection direction = PlayDirection_None;
    if (button == self.upBtn) {
        NSLog(@"%s: up", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Up];
    }
    else if (button == self.downBtn) {
        NSLog(@"%s: down", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Down];
    }
    else if (button == self.leftBtn) {
        NSLog(@"%s: left", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Left];
    }
    else if (button == self.rightBtn) {
        NSLog(@"%s: right", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Right];
    }
    else if (button == self.confirmBtn) {
        NSLog(@"%s: confirm", __PRETTY_FUNCTION__);
        direction = PlayDirection_Confirm;
    }
    
    if (sendRelease) {
        PlayOperationType opType = PlayOperationType_Release;
        if ([button.reversePTimer isValid]) {
            // Note: 如果未超时，发送一个reverse事件
            opType = PlayOperationType_Reverse;
        }
        
        if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
            [self.delegate onPlayDirection:direction operationType:opType];
        }
    }
}

- (void)invalidTimerByButton:(OBShapedButton *)button clearTimer:(BOOL)clear{
    // 清空timer
    if (button && [button.longPTimer isValid]) {
        [button.longPTimer invalidate];
        if (clear) {
            button.longPTimer = nil;
        }
    }
}

- (void)longPressTimeOut:(NSTimer *)timer {
    NSDictionary *userInfo = [timer userInfo];
    UIButton *sender = userInfo[@"btn"];
    OBShapedButton *button = (OBShapedButton *)sender;
    
    if (button == self.upBtn) {
        NSLog(@"%s: up", __PRETTY_FUNCTION__);
    }
    else if (button == self.downBtn) {
        NSLog(@"%s: down", __PRETTY_FUNCTION__);
    }
    else if (button == self.leftBtn) {
        NSLog(@"%s: left", __PRETTY_FUNCTION__);
    }
    else if (button == self.rightBtn) {
        NSLog(@"%s: right", __PRETTY_FUNCTION__);
    }
    [self onButtonLongPressed:sender];
    
    // 开始校验reverse的timer
    [self startReverseTimerByButton:button];
}

- (void)reverseLongPressTimeOut:(NSTimer *)timer {
    NSDictionary *userInfo = [timer userInfo];
    UIButton *button = userInfo[@"btn"];
    if (button == self.upBtn) {
        NSLog(@"%s: up", __PRETTY_FUNCTION__);
    }
    else if (button == self.downBtn) {
        NSLog(@"%s: down", __PRETTY_FUNCTION__);
    }
    else if (button == self.leftBtn) {
        NSLog(@"%s: left", __PRETTY_FUNCTION__);
    }
    else if (button == self.rightBtn) {
        NSLog(@"%s: right", __PRETTY_FUNCTION__);
    }
}

- (void)startReverseTimerByButton:(OBShapedButton *)button {
    if ([button.reversePTimer isValid]) {
        [button.reversePTimer invalidate];
        button.reversePTimer = nil;
    }
    
    button.reversePTimer = [NSTimer scheduledTimerWithTimeInterval:RPressTimerInteraval target:self selector:@selector(reverseLongPressTimeOut:) userInfo:@{@"btn":button} repeats:NO];
}

- (void)onButtonLongPressed:(UIButton *)sender {
    PlayDirection direction = PlayDirection_None;
    if (sender == self.upBtn) {
        NSLog(@"%s: up", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Up];
    }
    else if (sender == self.downBtn) {
        NSLog(@"%s: down", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Down];
    }
    else if (sender == self.leftBtn) {
        NSLog(@"%s: left", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Left];
    }
    else if (sender == self.rightBtn) {
        NSLog(@"%s: right", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Right];
    }
    
    if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
        [self.delegate onPlayDirection:direction operationType:PlayOperationType_LongPress];
    }
}

#pragma mark lazyload
- (OBShapedButton *)upBtn{
    if (!_upBtn) {
        _upBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [_upBtn setImage:[UIImage imageNamed:@"game_up_normal"] forState:UIControlStateNormal];
        [_upBtn setImage:[UIImage imageNamed:@"game_up_select"] forState:UIControlStateHighlighted];
        [_upBtn addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [_upBtn addTarget:self action:@selector(onButtonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upBtn;
}
- (OBShapedButton *)downBtn{
    if (!_downBtn) {
        _downBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [_downBtn setImage:[UIImage imageNamed:@"game_down_normal"] forState:UIControlStateNormal];
        [_downBtn setImage:[UIImage imageNamed:@"game_down_select"] forState:UIControlStateHighlighted];
        [_downBtn addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [_downBtn addTarget:self action:@selector(onButtonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downBtn;
}
- (OBShapedButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:@"game_left_normal"] forState:UIControlStateNormal];
        [_leftBtn setImage:[UIImage imageNamed:@"game_left_select"] forState:UIControlStateHighlighted];
        [_leftBtn addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [_leftBtn addTarget:self action:@selector(onButtonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (OBShapedButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"game_right_normal"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"game_right_select"] forState:UIControlStateHighlighted];
        [_rightBtn addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [_rightBtn addTarget:self action:@selector(onButtonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
- (OBShapedButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setImage:[UIImage imageNamed:@"game_game_normal"] forState:UIControlStateNormal];
        [_confirmBtn setImage:[UIImage imageNamed:@"game_game_select"] forState:UIControlStateHighlighted];
        [_confirmBtn addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [_confirmBtn addTarget:self action:@selector(onButtonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _confirmBtn;
}
- (UIButton *)viewBtn{
    if (!_viewBtn) {
        _viewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_viewBtn setImage:[UIImage imageNamed:@"game_normal_view_normal"] forState:UIControlStateNormal];
        [_viewBtn setImage:[UIImage imageNamed:@"game_normal_view_select"] forState:UIControlStateHighlighted];
        [_viewBtn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewBtn;
}
- (UIImageView *)bgimgV{
    if (!_bgimgV) {
        _bgimgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_bottom_game"]];
    }
    return _bgimgV;
}

@end
