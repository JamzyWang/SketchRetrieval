
# 整个sketch retrieval的处理流程
---

## 1.离线处理（处理image）

**（1）边缘提取**

**输入**：所有原始图像

**处理脚本**：`image_ edge_ detection.m`

**输出**：所有图像的边缘图像

备注：处理时间较长


**（2）计算图像的local feature**

**输入**：（1）处理得到的边缘图像

**处理脚本**：`image_ local_ feature_extraction.m`

**输出**：所有图像的local feature

备注：处理时间较长，相比(1)时间要短


**（3）计算图像的视觉词典visual vocabulary**

**输入**：（2）得到的local feature

**处理脚本**：`generate_local_feature_visual_word.m`

**输出**：所有图像的local feature

**备注**：visual vocabulary用于量化local feature


**（4）量化所有图像的local feature**

**输入**：（2）得到的local feature,(3)得到的visual vocabulary

**处理脚本**：`quantize_image_local_feature.m`

**输出**：所有图像经过量化后的local feature

**备注**：


**（5）计算图像的分割情况**

**输入**：（1）处理得到的边缘图像

**处理脚本**：`image_divide.m`

**输出**：每一个图像的分割情况

**备注**：
1）处理时间较快；
2）图像的分割情况可能用于匹配值计算（类似two-way-matching）



## 2.在线处理

### 2.1 处理sketch

**（1）边缘提取**

**输入**：sketch

**处理脚本**：`sketch_ processing.m`

**输出**：sketch的边缘图像

备注：


**（2）计算local feature**

**输入**：（1）处理后的边缘图像

**处理脚本**：`feature_ extraction_ local.m`

**输出**：sketch的local feature

备注：


**(3)量化sketch的local feature**

**输入**：（2）处理后的local feature，离线得到的visual vocablary

**处理脚本**：`image_divide.m`

**输出**：sketch的分割情况

备注：

****
**(4)计算sketch的分割情况**

**输入**：（1）处理后的边缘图像

**处理脚本**：`image_divide.m`

**输出**：sketch的分割情况

备注：

### 2.2 计算global feature

#### 2.2.1 根据sketch的分割情况计算global feature

**(1) 根据sketch的分割情况计算sketch的global feature**

**输入**：sketch的边缘图像，sketch的分割情况

**处理脚本**：`feature_ extraction_ global`

**输出**：sketch的global feature

备注：

**(2) 根据sketch的分割情况计算image的global feature**

**输入**：image的边缘图像，sketch的分割情况

**处理脚本**：`feature_ extraction_ global`

**输出**：image的global feature

（3）整理sketch和image的feature

对于sketch和image上的每一个兴趣点,现在已经可以得到每一个兴趣点的feature，每一个`feature = [global feature, local feature]`

#### 2.2.2 根据image的分割情况计算global feature

**(1) 根据image的分割情况计算sketch的global feature**

**输入**：sketch的边缘图像，image的分割情况

**处理脚本**：`feature_ extraction_ global`

**输出**：sketch的global feature

备注：

**(2) 根据image的分割情况计算image的global feature**

**输入**：image的边缘图像，image的分割情况

**处理脚本**：`feature_ extraction_ global`

**输出**：image的global feature

**（3）整理sketch和image的feature**

对于sketch和image上的每一个兴趣点,现在已经可以得到每一个兴趣点的feature，每一个`feature = [global feature, local feature]`

###2.3 计算匹配值


#### 2.3.1 计算sketch和所有图像的匹配值

**输入**：sketch，所有image

**处理脚本**：`query_sketch.m`

**输出**：最终的匹配值

**备注**：query_sketch.m中包含下面两部分


#### （1）计算sketch ——> image的匹配值

**输入**：sketch的feature，image的feature，sketch的分割情况

**处理脚本**：`calculate_ matching_ cost.m`

**输出**：sketch ——> image的匹配值

**备注**：


#### （2）计算image ——> sketch的匹配值

**输入**：sketch的feature，image的feature，image的分割情况

**处理脚本**：`calculate_ matching_ cost.m`

**输出**：image ——> sketch的匹配值

**备注**：