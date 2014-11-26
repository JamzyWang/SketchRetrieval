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

6.git中如何丢弃本地的所有修改（不提交任何修改），直接从远程仓库中pull，覆盖本地的文件

7  find . -type f >result.ttx
   cut -c 3- result >image_id.txt

## 函数设计和参数选择



### 1. image边缘提取参数的选择
**参数**：image_ edge_ detection.m 中的 
t = 30，
sigma = 6，
lowScale = 2:3:17

---
### 2. local feature（HOG feature）中的参数选择

**脚本**：feature_ extraction_ local.m

**函数**：extractHOGFeatures中的参数设置

---

### 3. 分割函数设计，分割参数选择

**分割函数**：
divide_ function.m 中的 calculate_ condition(*image_ percent*,*cell_ percent*)

**分割参数**：image_ divide.m 中的 image_ percent 和cell_ percent

**备注**：是否考虑image和sketch选择不同的参数，因为sketch的兴趣点比较稀疏

---

