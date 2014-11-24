1.matlab代码规范：每个函数或者脚本的功能说明。

2.如何一次性向代码仓库中提交所有被修改过的文件 


3.判断图像类型
imfinfo(“图像名")：
size("图像名")：二维还是三维


4.总结canny边缘检测的缺陷。然后说明为了解决这个缺陷我们采用了什么样的办法。

Todo:

1.提取sketch和image的特征：【global feature , local feature】

2.matching值的计算

3.计算HOG特征的时间过长，考虑是否对image或者sketch进行hog特诊提取的点的数量进行控制。比如只取1000个点？
image的处理是离线的，时间长短是否有关系呢？

4.提取好了hog feature,需要把它量化。量化过程中使用adaptive-weigthing的思路。

5.用于提取词典的HOG特征的量应该是多少？从哪些图像上提取？