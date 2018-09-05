//
//  XXBSpeechEvaluator.m
//  XXB
//
//  Created by Xinfeng Du on 2018/9/4.
//

#import "XXBSpeechEvaluator.h"
#import "iflyMSC/iflyMSC.h"
#import "ISEResultXmlParser.h"

NSString* const XXBLanguageZHCN = @"zh_cn";
NSString* const XXBLanguageENUS = @"en_us";

NSString* const XXBCategorySentence = @"read_sentence";
NSString* const XXBCategoryWord     = @"read_word";
NSString* const XXBCategorySyllable = @"read_syllable";

@interface XXBSpeechEvaluator () <IFlySpeechEvaluatorDelegate,ISEResultXmlParserDelegate>

@property (nonatomic, strong) IFlySpeechEvaluator *iFlySpeechEvaluator;
@property (nonatomic, copy) NSString *resultText;

@end

@implementation XXBSpeechEvaluator

- (id)init
{
    self = [super init];
    if (self) {
        [self initSpeechEvaluatorSetting];
        [self initSpeechEvaluator];
        [self initSpeechEvaluatorDefaultParameter];
    }
    return self;
}

- (void)initSpeechEvaluator
{
    if (!self.iFlySpeechEvaluator) {
        self.iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
    }
    self.iFlySpeechEvaluator.delegate = self;
}

- (void)initSpeechEvaluatorSetting
{
    NSString *iflyAppid = @"appid";

    [IFlySetting setLogFile:LVL_ALL];
    [IFlySetting showLogcat:YES];
    
    //Set the local storage path of SDK
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //Configure and initialize iflytek services.(This interface must been invoked in application:didFinishLaunchingWithOptions:)
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@",iflyAppid]];
}

- (void)initSpeechEvaluatorDefaultParameter
{
    self.languageType = XXBSpeechLanguageTypeENUS;
    self.categoryType = XXBSpeechCategoryTypeWord;
    
    [self.iFlySpeechEvaluator setParameter:@"complete" forKey:[IFlySpeechConstant ISE_RESULT_LEVEL]];
    [self.iFlySpeechEvaluator setParameter:@"5000" forKey:[IFlySpeechConstant VAD_BOS]];
    [self.iFlySpeechEvaluator setParameter:@"1800" forKey:[IFlySpeechConstant VAD_EOS]];
   
    [self.iFlySpeechEvaluator setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [self.iFlySpeechEvaluator setParameter:@"utf-8" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    [self.iFlySpeechEvaluator setParameter:@"xml" forKey:[IFlySpeechConstant ISE_RESULT_TYPE]];
    [self.iFlySpeechEvaluator setParameter:@"eva.pcm" forKey:[IFlySpeechConstant ISE_AUDIO_PATH]];
    
    // [IFlySpeechConstant AUDIO_SOURCE] 默认为麦克风，设置为1 IFLY_AUDIO_SOURCE_MIC
    // [IFlySpeechConstant SPEECH_TIMEOUT] 默认值 30000
    
    if (self.languageType == XXBSpeechLanguageTypeENUS && self.categoryType == XXBSpeechCategoryTypeSyllable) {
        NSLog(@"==========================================");
        NSLog(@"设置错误");
        NSLog(@"==========================================");
    }
}


- (void)speechEvaluatorStart
{
    BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]] isEqualToString:@"utf-8"];
    NSMutableData *buffer = nil;
    if (isUTF8 && self.languageType == XXBSpeechLanguageTypeZHCN && self.speechText.length) {
        Byte bomHeader[] = { 0xEF, 0xBB, 0xBF };
        buffer = [NSMutableData dataWithBytes:bomHeader length:sizeof(bomHeader)];
        [buffer appendData:[self.speechText dataUsingEncoding:NSUTF8StringEncoding]];
    }else{
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        buffer= [NSMutableData dataWithData:[self.speechText dataUsingEncoding:encoding]];
    }
  
    BOOL ret = [self.iFlySpeechEvaluator startListening:buffer params:nil];
    if (ret) {
        
    }
}

- (void)speechEvaluatorStop
{
    [self.iFlySpeechEvaluator stopListening];
}

- (void)speechEvaluatorCancel
{
    [self.iFlySpeechEvaluator cancel];
}

- (void)speechEvaluatorParse
{
    ISEResultXmlParser *parser = [[ISEResultXmlParser alloc] init];
    parser.delegate = self;
    [parser parserXml:self.resultText];
}

- (void)destroySpeechEvaluator
{
    [self.iFlySpeechEvaluator cancel];
    self.iFlySpeechEvaluator.delegate = nil;
}

- (void)dealloc
{
    [self destroySpeechEvaluator];
}

#pragma mark - setter

- (void)setLanguageType:(XXBSpeechLanguageType)languageType
{
    _languageType = languageType;
    
    if (languageType == XXBSpeechLanguageTypeZHCN) {
        [self.iFlySpeechEvaluator setParameter:XXBLanguageENUS forKey:[IFlySpeechConstant LANGUAGE]];
    }else{
        [self.iFlySpeechEvaluator setParameter:XXBLanguageZHCN forKey:[IFlySpeechConstant LANGUAGE]];
    }
}

- (void)setCategoryType:(XXBSpeechCategoryType)categoryType
{
    if (categoryType == XXBSpeechCategoryTypeWord) {
        [self.iFlySpeechEvaluator setParameter:XXBCategoryWord forKey:[IFlySpeechConstant ISE_CATEGORY]];
    }else if (categoryType == XXBSpeechCategoryTypeSentence){
        [self.iFlySpeechEvaluator setParameter:XXBCategorySentence forKey:[IFlySpeechConstant ISE_CATEGORY]];
    }else{
        [self.iFlySpeechEvaluator setParameter:XXBCategorySyllable forKey:[IFlySpeechConstant ISE_CATEGORY]];
    }
}

#pragma mark - IFlySpeechEvaluatorDelegate

// 音量和数据回调
- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer
{
    
}

// 开始录音回调
- (void)onBeginOfSpeech
{
    
}

// 停止录音回调
- (void)onEndOfSpeech
{
    
}

// 正在取消
- (void)onCancel
{
    
}

// 评测错误回调
- (void)onCompleted:(IFlySpeechError *)errorCode
{
    if(errorCode && errorCode.errorCode!=0){
        NSString *error = [NSString stringWithFormat:@"Error：%d %@",[errorCode errorCode],[errorCode errorDesc]];
        NSLog(@"ERROR-->%@",error);
    }
}

// 评测结果回调 会多次回调此函数
- (void)onResults:(NSData *)results isLast:(BOOL)isLast
{
    self.resultText = @"";
    if (results) {
        const char *chResult=[results bytes];
        BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant RESULT_ENCODING]]isEqualToString:@"utf-8"];
        if(isUTF8){
            self.resultText = [[NSString alloc] initWithBytes:chResult length:[results length] encoding:NSUTF8StringEncoding];
        }else{
            NSLog(@"result encoding: gb2312");
            NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            self.resultText = [[NSString alloc] initWithBytes:chResult length:[results length] encoding:encoding];
        }
        
        if (isLast) {
            [self speechEvaluatorParse];
        }
        
    }else{
        // 没有说话
    }
}

#pragma mark - ISEResultXmlParserDelegate

-(void)onISEResultXmlParser:(NSXMLParser *)parser Error:(NSError*)error
{
    
}

-(void)onISEResultXmlParserResult:(ISEResult*)result
{
    
}

@end
