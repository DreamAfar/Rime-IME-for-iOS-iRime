### 注意：这是一个个人的使用的iRime仓库，主要用于记录

iRime作者的项目地址：https://github.com/jimmy54/iRime

iRime相关资源：https://github.com/jimmy54/iRime-Resource

# iRime輸入法-   基于Rime输入法框架开发的iOS端Rime输入法

基於著名的【Rime】輸入法框架，
旨在保護漢語各地方言，
音碼形碼通用輸入法平臺。

- [点击到AppStore下载](https://itunes.apple.com/cn/app/irime输入法/id1142623977?mt=8)


# iRime电脑快传内容详解

> 这是依据iRime开启时电脑快传所显示的内容进行解释。


- 添加输入方案  
  - 【常用输入方案】【】（或加 iRime作者（筋斗云，微信号：pappa8857）加入iRime输入法交流群）  
  - 【更多开源输入方案】【】  
- 学习如何DIY
  - 配置输入方案，请参阅 【Rime说明书】【】。

`附表1: （iRime 文件分布、作用及相关教程`  

| 文件&文件夹                                                  | 作用及相关教程                                               |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| :file_folder:`<词典名>.userdb`                               | <u>用户词典</u>：存储用户输入习惯。                          |
| :file_folder:`SharedSupport`                                 | <u>目录</u>：存放iRime的默认配置文件与方案文件。             |
| :file_folder:`build`                                         | <u>编译结果</u>：部署成功后，会在此处生成编译结果文件（ yaml 或 bin 格式）。输入法程序运行时读取的也是这里的文件。对于较复杂的输入方案，在手机端若无法部署，也可将 PC 端部署生成的编译结果文件拷贝到这里使用（新版 librime 生成的 bin 文件可通用）。编辑方案或主题请直接操作用户文件夹中的源文件，而非这里的编译结果。 |
| :file_folder:`theme`                                         | <u>键盘主题文件夹</u>：用于改变键盘界面。将个性化自定义的键盘主题存放于此文件夹中。 |
| :file_folder:`opencc`                                        | <u>简繁转换组件(可选)</u>：简繁转换。【原理及示例】【】      |
| :file_folder:`sync`                                          | <u>同步文件夹</u>：备份方案&词库及相关配置文件，导出的用户词典也存放在此处。详见【同步用户资料】【】。 |
| -------------------                                          | ------------------------------------------------------------ |
| :page_facing_up:`custom_phrase.txt`                          | <u>自定义短语(可选)</u>：存储少量的固定短语等数据。配置步骤：①【新建短语翻译器】【】 ②【配置翻译器】【】 ③往custom_phrase.txt添加自定义短语 （【custom_phrase样例文件】【】 *） |
| :page_facing_up:`default.yaml`                               | <u>全局设定文件</u>：Rime各个平台通用的**全局参数** (功能键定义、按键捆绑、方案列表、候选条数……)。请参考【定制指南】【】 |
| :page_facing_up:`default.custom.yaml`                        | <u>全局设定补丁文件</u>：Rime各个平台通用的**全局参数** 补丁文件。请参考【定制指南】【】 |
| :page_facing_up:`flypy_sys.txt`                              | <u>方案文件<u>小鹤音形符号、补充简码等词库                   |
| :page_facing_up:`frypy_top.txt`                              | <u>方案文件</u>：小鹤音形“置顶”用户词库。                    |
| :page_facing_up:`flypy.schema.yaml`                          | <u>方案文件</u>：小鹤音形主方案文件                          |
| :page_facing_up:`flypyplus.schema.yaml`                      | <u>方案文件</u>：小鹤音形+主方案文件                         |
| :page_facing_up:`iRime.yaml`                                 | <u>iRime配置文件</u>：iRime主配置文件。                      |
| :page_facing_up:`essay.txt`                                  | <u>八股文(可选)</u>：一份词汇表和简陋的语言模型。【八股文的详细说明】【】 |
| :page_facing_up:`installation.yaml`                          | <u>安装信息</u>：保存安装ID用以区分不同来源的备份数据，也可以在此处设定同步位置。详见【同步用户资料】【】 |
| :page_facing_up:`<方案标识>.schema.yaml`<br>:page_facing_up:`<方案标识>.custom.yaml ` | <u>输入方案定义及其补丁文件</u>：输入方案的**设定**。可参考【详解输入方案】【】 以及 【`schema.yaml`详解】【】 |
| :page_facing_up:`<词典名>.dict.yaml`<br>:page_facing_up:`<词典名>.<分词库名>.dict.yaml` | <u>输入方案词典及其分词库</u>：输入方案所使用的**词典**(包含词条、编码、构词码、权重等信息)。详见【码表与词典】【】 以及 【`dict.yaml`详解】【】 |
| :page_facing_up:`symbols.yaml`                               | <u>扩充的特殊符号</u>：提供了比`default.yaml`更为丰富的特殊符号，【symbols.yaml用法说明】【】。 |
| :page_facing_up:`user.yaml`                                  | <u>用户状态信息</u>：用来保存当前所使用的方案ID，以及各种开关的状态。 |





-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

【常用输入方案】:https://github.com/rime/plum/blob/master/README.md#packages
 
【更多开源输入方案】:https://github.com/osfans/rime-tool
 
【Rime说明书】:https://github.com/rime/home/wiki/UserGuide
 

【原理及示例】:https://github.com/rime/home/wiki/CustomizationGuide/0dd06383528e7794013815c1b12c32ec8647ef56#%E4%B8%80%E4%BE%8B%E5%AE%9A%E8%A3%BD%E7%B0%A1%E5%8C%96%E5%AD%97%E8%BC%B8%E5%87%BA
  
【同步用户资料】:https://github.com/rime/home/wiki/UserGuide#同步用戶資料
  
【配置翻译器】:https://github.com/rime/rime-luna-pinyin/blob/master/luna_pinyin.schema.yaml#L81-L87
  
【新建短语翻译器】:https://github.com/rime/rime-luna-pinyin/blob/master/luna_pinyin.schema.yaml#L49
  
【custom_phrase样例文件】:https://gist.github.com/lotem/5440677
  
【定制指南】:https://github.com/rime/home/wiki/CustomizationGuide#定製指南
  
【八股文的详细说明】:https://github.com/rime/home/wiki/RimeWithSchemata#八股文
  
【详解输入方案】:https://github.com/rime/home/wiki/RimeWithSchemata#詳解輸入方案
  
【`schema.yaml`详解】:https://github.com/LEOYoon-Tsaw/Rime_collections/blob/master/Rime_description.md#schemayaml-詳解
  
【码表与词典】:https://github.com/rime/home/wiki/RimeWithSchemata#碼表與詞典
  
【`dict.yaml`详解】:https://github.com/LEOYoon-Tsaw/Rime_collections/blob/master/Rime_description.md#dictyaml-詳解
  
【symbols.yaml用法说明】:https://github.com/rime/rime-prelude/blob/master/symbols.yaml#L4-L10
