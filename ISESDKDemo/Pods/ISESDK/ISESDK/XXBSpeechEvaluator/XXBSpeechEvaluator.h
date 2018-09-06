//
//  XXBSpeechEvaluator.h
//  XXB
//
//  Created by Xinfeng Du on 2018/9/4.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XXBSpeechLanguageType)
{
    XXBSpeechLanguageTypeZHCN = 0, // 中文
    XXBSpeechLanguageTypeENUS      //英文
};

typedef NS_ENUM(NSInteger, XXBSpeechCategoryType)
{
    XXBSpeechCategoryTypeSentence, // 句子
    XXBSpeechCategoryTypeWord,     // 单词
    XXBSpeechCategoryTypeSyllable  // 单字 语言为英文时不支持
};

@protocol XXBSpeechEvaluatorDelegate <NSObject>

- (void)speechEvaluatorVolume:(NSInteger)volume;
- (void)speechEvaluatorResult:(CGFloat)score;
- (void)speechEvaluatorErrorDesc:(NSString *)errorDesc;

@end

@interface XXBSpeechEvaluator : NSObject

@property (nonatomic,   weak) id <XXBSpeechEvaluatorDelegate> delegate;
@property (nonatomic,   copy) NSString *speechText;
@property (nonatomic, assign) XXBSpeechLanguageType languageType;
@property (nonatomic, assign) XXBSpeechCategoryType categoryType;

- (id)initWithAppid:(NSString *)appid;

- (void)speechEvaluatorStart; // 开始说话
- (void)speechEvaluatorStop; // 停止说话
- (void)speechEvaluatorCancel; //取消说话
- (void)speechEvaluatorParse; //解析评测
- (void)destroySpeechEvaluator; //销毁评测实例

@end
