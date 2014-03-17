//
//  ViewController.m
//  i2048
//
//  Created by xiaoyuan wang on 3/16/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "ViewController.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define NUM 4
#define GAP_LENGTH 10
#define TILE_LENGTH 50
#define DELAY_SECOND 0.1

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *board;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation ViewController
{
    int grid[8][8];
    
    BOOL hasMovedInThisSwipe;
    int fourCnt;
    int theScore;
    
    DMAdView *_dmAdView;
}

- (void)loadDuoMengAd
{
    _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJwkJYuNLAkxcjIa"
                                          placementId:@"16TLuIFaApfPwNUfzW3C70Gs" size:DOMOB_AD_SIZE_320x50];
    // 设置广告视图的位置
    _dmAdView.frame = CGRectMake(0, 0, DOMOB_AD_SIZE_320x50.width, DOMOB_AD_SIZE_320x50.height);
    
    _dmAdView.delegate = self;
    // 设置 Delegate
    _dmAdView.rootViewController = self;
    // 设置 RootViewController
    [self.view addSubview:_dmAdView];
    // 将⼲⼴广告视图添加到⽗父视图中
    [_dmAdView loadAd]; // 开始加载广告
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self loadDuoMengAd];
    [self startTheGame];
}

- (void)clearTheBoard
{
    fourCnt = 0;
    for (int i = 0; i < NUM * NUM; i++) {
        UIView *tile = [_board viewWithTag:i + 1];
        if (tile) {
            [tile removeFromSuperview];
        }
    }
    for (int i = 0; i < NUM; i++) {
        for (int j = 0; j < NUM; j++) {
            grid[i][j] = 0;
        }
    }
}

- (void)addTileAtRow:(int)row atCol:(int)col withNum:(int)num
{
    CGRect frame = CGRectMake(GAP_LENGTH * (col + 1) + col * TILE_LENGTH,GAP_LENGTH * (row + 1) + row * TILE_LENGTH, TILE_LENGTH, TILE_LENGTH);
    UILabel *tileLabel = [[UILabel alloc] initWithFrame:frame];
    
    tileLabel.text = [NSString stringWithFormat:@"%d", num];
    tileLabel.textAlignment = NSTextAlignmentCenter;
    tileLabel.textColor = UIColorFromRGB(0x766e66);
    tileLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:30];
    tileLabel.backgroundColor = [self getBackgroudForNum:num];
    tileLabel.tag = row * 4 + col + 1;
    tileLabel.adjustsFontSizeToFitWidth = YES;
    
    grid[row][col] = num;
    
    [_board addSubview:tileLabel];
    tileLabel.transform = CGAffineTransformMakeScale(0,0);
    [UIView animateWithDuration:0.2 animations:^{
        tileLabel.transform = CGAffineTransformIdentity;
    }];
}

- (void)randomPut
{
    NSMutableArray *zeroGrids = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < NUM; i++) {
        for (int j = 0; j < NUM; j++) {
            if (grid[i][j] == 0) {
                [zeroGrids addObject:@(i * NUM + j)];
            }
        }
    }

    if (zeroGrids.count <= 0) {
        NSLog(@"game over");
        return;
    }
    
    int pos = [zeroGrids[arc4random() % zeroGrids.count] intValue];
    int row = pos / NUM;
    int col = pos % NUM;
    NSLog(@"%d  %d", row, col);
    
    BOOL isFour = arc4random() % 2 == 0;
    int num = 2;
    if (isFour) {
        fourCnt++;
        if (fourCnt == 2) {
            fourCnt = 0;
            num = 4;
        }
    }
    [self addTileAtRow:row atCol:col withNum:num];
}


- (void)startTheGame
{
    theScore = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", theScore];
    
    [self clearTheBoard];
    [self randomPut];
    [self randomPut];
}

- (CGRect)makeFrameWithRow:(int)row col:(int)col
{
    return CGRectMake(GAP_LENGTH * (col + 1) + col * TILE_LENGTH,GAP_LENGTH * (row + 1) + row * TILE_LENGTH, TILE_LENGTH, TILE_LENGTH);
}

- (UIColor *)getBackgroudForNum:(int)num
{
    if (num == 2) return UIColorFromRGB(0xede4db);
    if (num == 4) return UIColorFromRGB(0xecdfc9);
    if (num == 8) return UIColorFromRGB(0xebb37f);
    if (num == 16) return UIColorFromRGB(0xa50e4e);
    if (num == 32) return UIColorFromRGB(0x750ea5);
    if (num == 64) return UIColorFromRGB(0x0e1ca5);
    if (num == 128) return UIColorFromRGB(0x0e7ca5);
    if (num == 256) return UIColorFromRGB(0x0ea578);
    if (num == 512) return UIColorFromRGB(0xa5a30e);
    if (num == 1024) return UIColorFromRGB(0xf5170c);
    if (num == 2048) return UIColorFromRGB(0xb27a18);
    if (num == 4096) return UIColorFromRGB(0xede4db);
    return [UIColor blackColor];
}

- (void)moveTileFromRow:(int)fromRow fromCol:(int)fromCol toRow:(int)toRow toCol:(int)toCol
{
    if (fromCol == toCol && fromRow == toRow) return;
    hasMovedInThisSwipe = YES;
    
    UILabel *movingTile = (UILabel *)[_board viewWithTag:fromRow * NUM + fromCol + 1];
    UILabel *toTile = (UILabel *)[_board viewWithTag:toRow * NUM + toCol + 1];
    
    
    grid[toRow][toCol] += grid[fromRow][fromCol];
    grid[fromRow][fromCol] = 0;
    movingTile.tag = toRow * NUM + toCol + 1;
    CGRect toFrame = [self makeFrameWithRow:toRow col:toCol];
    [UIView animateWithDuration:0.1 animations:^{
        movingTile.frame = toFrame;
    } completion:^(BOOL finished) {
        if (toTile) [movingTile removeFromSuperview];
        
        if (toTile) {
            toTile.text = [NSString stringWithFormat:@"%d", grid[toRow][toCol]];
            if (grid[toRow][toCol] > 8) {
                toTile.textColor = [UIColor whiteColor];
            }
            toTile.backgroundColor = [self getBackgroudForNum:grid[toRow][toCol]];
            toTile.transform = CGAffineTransformMakeScale(1.2, 1.2);
            [UIView animateWithDuration:0.2 animations:^{
                toTile.transform = CGAffineTransformIdentity;
            }];
        }
        
        if (toTile) {
            [self addScore:grid[toRow][toCol]/2];
        }
    }];
}

- (void)addScore:(int)score
{
    int finalScore = score - 1 + (int)log2(score);
    theScore += finalScore;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", theScore];
}

- (void)swipeLeftAtRow:(int)row
{
    BOOL hasMerged = NO;
    int col = -1;
    for (int j = 0; j < NUM; j++) {
        if (grid[row][j] > 0) {
            if (col != -1 && !hasMerged && col != j && grid[row][j] == grid[row][col]) {
                //merge
                hasMerged = YES;
                [self moveTileFromRow:row fromCol:j toRow:row toCol:col];
            }else {
                col++;
                [self moveTileFromRow:row fromCol:j toRow:row toCol:col];
            }
        }
    }
}

- (IBAction)swipeToLeft:(id)sender {
    hasMovedInThisSwipe = NO;
    for (int i = 0; i < NUM; i++) {
        [self swipeLeftAtRow:i];
    }
    if (hasMovedInThisSwipe) {
        [self performSelectorOnMainThread:@selector(randomPut) withObject:nil waitUntilDone:DELAY_SECOND];
    }
}

- (void)swipRightAtRow:(int)row
{
    BOOL hasMerged = NO;
    int col = NUM;
    for (int j = NUM - 1; j >= 0; j--) {
        if (grid[row][j] > 0) {
            if (col != NUM && !hasMerged && col != j && grid[row][j] == grid[row][col]) {
                //merge
                hasMerged = YES;
                [self moveTileFromRow:row fromCol:j toRow:row toCol:col];
            }else {
                col--;
                [self moveTileFromRow:row fromCol:j toRow:row toCol:col];
            }
        }
    }
}

- (IBAction)swipeToRight:(id)sender {
    hasMovedInThisSwipe = NO;
    for (int i = 0; i < NUM; i++) {
        [self swipRightAtRow:i];
    }
    if (hasMovedInThisSwipe) {
        [self performSelectorOnMainThread:@selector(randomPut) withObject:nil waitUntilDone:DELAY_SECOND];
    }
}

- (void)swipUpAtCol:(int)col
{
    BOOL hasMerged = NO;
    int row = -1;
    for (int i = 0; i < NUM; i++) {
        if (grid[i][col] > 0) {
            if (row != -1 && !hasMerged && row != i && grid[row][col] == grid[i][col]) {
                //merge
                hasMerged = YES;
                [self moveTileFromRow:i fromCol:col toRow:row toCol:col];
            }else {
                row++;
                [self moveTileFromRow:i fromCol:col toRow:row toCol:col];
            }
        }
    }
}

- (IBAction)swipeToUp:(id)sender {
    hasMovedInThisSwipe = NO;
    for (int i = 0; i < NUM; i++) {
        [self swipUpAtCol:i];
    }
    if (hasMovedInThisSwipe) {
        [self performSelectorOnMainThread:@selector(randomPut) withObject:nil waitUntilDone:DELAY_SECOND];
    }
}

- (void)swipDownAtCol:(int)col
{
    BOOL hasMerged = NO;
    int row = NUM;
    for (int i = NUM - 1; i >=0; i--) {
        if (grid[i][col] > 0) {
            if (row != NUM && !hasMerged && row != i && grid[row][col] == grid[i][col]) {
                //merge
                hasMerged = YES;
                [self moveTileFromRow:i fromCol:col toRow:row toCol:col];
            }else {
                row--;
                [self moveTileFromRow:i fromCol:col toRow:row toCol:col];
            }
        }
    }
}

- (IBAction)swipeToDown:(id)sender {
    hasMovedInThisSwipe = NO;
    for (int i = 0; i < NUM; i++) {
        [self swipDownAtCol:i];
    }
    if (hasMovedInThisSwipe) {
        [self performSelectorOnMainThread:@selector(randomPut) withObject:nil waitUntilDone:DELAY_SECOND];
    }
}

- (IBAction)pauseTheGame:(id)sender {
    NSLog(@"pause");
}


- (void)viewDidUnload {
    [super viewDidUnload];
    [_dmAdView removeFromSuperview]; // 将⼲⼴广告试图从⽗父视图中移除
}

- (void)dealloc
{
    _dmAdView.delegate = nil;
    _dmAdView.rootViewController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
