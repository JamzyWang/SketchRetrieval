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


