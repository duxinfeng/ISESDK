//
//  ViewController.m
//  ISESDKDemo
//
//  Created by Xinfeng Du on 2018/9/5.
//  Copyright © 2018年 XXB. All rights reserved.
//

#import "ViewController.h"
#import <XXBSpeechEvaluator.h>

@interface ViewController ()<XXBSpeechEvaluatorDelegate>
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scroreLabel;
@property (nonatomic, strong) XXBSpeechEvaluator *speechEvaluator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.speechEvaluator = [[XXBSpeechEvaluator alloc] initWithAppid:@"appid"];
    self.speechEvaluator.delegate = self;
    self.speechEvaluator.categoryType = XXBSpeechCategoryTypeSentence;
    self.speechEvaluator.speechText = @"I have a ruler.";
    
    self.textLabel.text = self.speechEvaluator.speechText;
}

- (IBAction)start:(id)sender {
    self.scroreLabel.text = @"";
    [self.speechEvaluator speechEvaluatorStart];
}

- (IBAction)stop:(id)sender {
    [self.speechEvaluator speechEvaluatorStop];

}
- (IBAction)parse:(id)sender {
    [self.speechEvaluator speechEvaluatorParse];

}
- (IBAction)cancel:(id)sender {
    [self.speechEvaluator speechEvaluatorCancel];

}

#pragma mark - XXBSpeechEvaluatorDelegate
- (void)speechEvaluatorVolume:(NSInteger)volume
{
    self.volumeLabel.text = [NSString stringWithFormat:@"%zd",volume];
}
- (void)speechEvaluatorResult:(CGFloat)score
{
    self.scroreLabel.text = [NSString stringWithFormat:@"%.f",score];
}

- (void)speechEvaluatorErrorDesc:(NSString *)errorDesc
{
    NSLog(@"error-->%@",errorDesc);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
