# To Do List
---

**总结canny边缘检测的缺陷**

说明为了解决这个缺陷我们采用了什么样的办法。



**adaptive-weigthing量化**

提取好了hog feature,需要把它量化。量化过程中使用adaptive-weigthing的思路。


**提取词典的HOG特征量**

用于提取词典的HOG特征的量应该是多少？从哪些图像上提取？




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

**4.global feature的设计**

**两种思路**：

1）计算某给点相对其他点的距离，并对距离进行量化。

2）计算far点，near点。

3） far点和near点的比例，对这个比例进行量化（为什么没有严格的利用距离，为了容错，sketch和image有一定的差异，不能这么严格）——>这一步也是只针对兴趣点，不计算非兴趣点的值



## 待会做：

**计算一下相同图像（image）的结果**


**仔细检查edge feature图像和local feature 图像顺序是否对应** 


**不考虑global feature，local feature的匹配原则上应该是BOVW，应该可以正确匹配的。**


## 待写函数
### 1.兴趣点筛选函数：interest_ points_ screening

### 2.自适应量化函数：adaptive_ weighting_ quantization

### 3.匹配函数：calculate_ matching_cost