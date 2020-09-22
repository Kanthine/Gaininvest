//
//  FeedbackProblemVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/9.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "FeedbackProblemVC.h"
#import "UserInfoHttpManager.h"
#import "UploadImageTool.h"
#import "FeedbackProblemItemView.h"

@interface FeedbackProblemVC ()

<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    __weak IBOutlet UILabel *_placeholderLable;
    __weak IBOutlet UITextView *_suggestTextView;
    __weak IBOutlet UIView *_imageContentView;
    
}

@property (nonatomic ,strong) NSMutableArray<UIImage *> *imageArray;

@end

@implementation FeedbackProblemVC

- (NSMutableArray<UIImage *> *)imageArray
{
    if (_imageArray == nil)
    {
        _imageArray = [NSMutableArray array];
    }
    
    return _imageArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self customNavBar];
    
    
    if (_suggestTextView.text.length > 0)
    {
        _placeholderLable.hidden = YES;
    }
    else
    {
        _placeholderLable.hidden = NO;
    }
    
    
    [self updateImageContentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"反馈问题";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    UIButton *rightNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightNavBarButton addTarget:self action:@selector(submitProblemItemClick) forControlEvents:UIControlEventTouchUpInside];
    rightNavBarButton.frame = CGRectMake(ScreenWidth - 40, 7, 60, 44);
    [rightNavBarButton setTitle:@"提交" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateImageContentView
{
    
    CGFloat itemWidth = (ScreenWidth - 30 - 2 * 10) / 3.0;

    [_imageContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         [obj removeFromSuperview];
     }];
    
    if (self.imageArray && self.imageArray.count)
    {
        [self.imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (idx > 2)
             {
                 * stop = YES;
             }
             
             CGRect rect = CGRectMake((itemWidth + 10) * idx, 0, itemWidth, itemWidth);
             FeedbackProblemItemView *itemView = [[FeedbackProblemItemView alloc]initWithFrame:rect Image:obj];
             itemView.deleteButton.tag = idx + 10;
             [itemView.deleteButton addTarget:self action:@selector(deleteItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
             [_imageContentView addSubview:itemView];
         }];
        
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.adjustsImageWhenDisabled = NO;
        addButton.adjustsImageWhenHighlighted = NO;
        [addButton setImage:[UIImage imageNamed:@"owner_PhotoAdd"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addImageButtonclick) forControlEvents:UIControlEventTouchUpInside];
        int row = self.imageArray.count % 3;
        if (self.imageArray.count < 3)
        {
            addButton.frame = CGRectMake((itemWidth + 10) * row, 0, itemWidth, itemWidth);

            [_imageContentView addSubview:addButton];
        }
        
    }
    else
    {
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.adjustsImageWhenDisabled = NO;
        addButton.adjustsImageWhenHighlighted = NO;
        [addButton setImage:[UIImage imageNamed:@"owner_PhotoAdd"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addImageButtonclick) forControlEvents:UIControlEventTouchUpInside];
        addButton.frame = CGRectMake(0, 0, itemWidth, itemWidth);
        [_imageContentView addSubview:addButton];
    }
        
}

- (void)deleteItemButtonClick:(UIButton *)sender
{
    NSUInteger index = sender.tag - 10;
    [self.imageArray removeObjectAtIndex:index];
    [self updateImageContentView];
}

- (void)addImageButtonclick
{
    [_suggestTextView resignFirstResponder];

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       
                                   }];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        [weakSelf presentPhotoResourceViewControllerWithIndex:0];
                                    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      [weakSelf presentPhotoResourceViewControllerWithIndex:1];
                                  }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:libraryAction];
    [actionSheet addAction:photoAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)presentPhotoResourceViewControllerWithIndex:(NSInteger)index
{
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if (index == 0)
    {
        //图库
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else
    {
        //相机
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.imageArray addObject:image];
    [self updateImageContentView];
    NSLog(@"image === %@",image);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_suggestTextView resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (_suggestTextView.text.length == 0)
    {
        _placeholderLable.hidden = NO;
    }
    else
    {
        _placeholderLable.hidden = YES;
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_suggestTextView.text.length == 0)
    {
        _placeholderLable.hidden = NO;
    }
    else
    {
        _placeholderLable.hidden = YES;
    }
}

#pragma mark - Submit Problem

- (void)submitProblemItemClick
{
    //提交问题
    [_suggestTextView resignFirstResponder];
    
    if (_suggestTextView.text.length < 1)
    {
        [ErrorTipView errorTip:@"请描述您要反馈的问题或建议" SuperView:self.view];
        return;
    }
    
    
    if (self.imageArray.count == 0)
    {
        [self submitProblemWithImageArray:nil];
        
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"上传资料...";
    [UploadImageTool upLoadImages:self.imageArray ProgressBlock:^(float progress)
     {
         NSLog(@"progress ===== %f",progress);
     } CompletionBlock:^(NSArray *urlArray, NSError *error)
     {
         [hud hideAnimated:YES];

         if (error)
         {
             [ErrorTipView errorTip:@"上传资料失败" SuperView:self.view];
         }
         else
         {
             //得到图片地址 数组
             NSLog(@"progress ===== %@",urlArray);
             [self submitProblemWithImageArray:urlArray];
         }
     }];
}


- (void)submitProblemWithImageArray:(NSArray<NSString *> *)imagePathArray
{
     __block NSString *imagePath = @"";
    if (imagePathArray && imagePathArray.count)
    {
        [imagePathArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if ([imagePath isEqualToString:@""])
            {
                imagePath = obj;
            }
            else
            {
                imagePath = [NSString stringWithFormat:@"%@,%@",imagePath,obj];
            }
        }];
    }
    
    NSLog(@"%@",imagePath);
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *dict = @{@"uid":account.internalBaseClassIdentifier,
                           @"content":_suggestTextView.text,
                           @"images":imagePath};
    
    [[[UserInfoHttpManager alloc]init] feedbackProblemWithParameterDict:dict CompletionBlock:^(NSError *error)
     {
         if (error.code == 1)
         {
             [ErrorTipView errorTip:@"感谢您的问题反馈，我们会努力改进" SuperView:self.view];
             [self performSelector:@selector(leftNavBarButtonClick) withObject:nil afterDelay:1];
         }
         else
         {
             [ErrorTipView errorTip:@"提交失败" SuperView:self.view];
         }
         
     }];

    
}

@end
