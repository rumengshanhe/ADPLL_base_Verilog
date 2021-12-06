# ADPLL_base_Verilog
基于Verilog的全数字锁相环

---
2021年9月23日  from my blog:lijinbo.top
---

# 概述

项目的主要目标就是用**Verilog**设计实现一款数字锁相环，基于低频率时钟源，倍频产生高频时钟，并且达到高频时钟输出相位锁定、占空比1:1的预期效果。设计全基于Verilog代码实现，第一阶段实现数字锁相环的基础架构，达到输入输出锁定的效果，第二阶段再进行倍频的实现。并结合**Modelsim**平台进行行为仿真，验证功能的正确性，观测仿真波形图。 

![](https://s2.loli.net/2021/12/06/arilVAXkFsG1gh8.png)

<!--more-->

# 层次结构

工程的结构分为顶层模块**dpll.v**和子模块**Phasecomparator**、**VariableResetRandomWalkFilter**和**Freqdivider**，分别对应PLL原理中的鉴相器**PD**、环路滤波器**LF**和受控振荡器**VCO**。系统在统一的系统时钟下同步工作，参考的架构图如下：

<div style='text-align: center;'>

![设计架构](https://s2.loli.net/2021/12/06/wpVePZIkvgc9U3x.jpg)

</div>

# 模块说明

## DPLL.v

### 模块接口

```verilog
module dpll(
    input  SignalIn;                       // 输入信号
    input  MainClock;                     // 系统时钟
    output SignalOut;                // 输出信号
    output Positive, Negative;          // 环路滤波器输出
    output Lead, Lag;               // 鉴相器输出
);
```



### 功能描述

**DPLL**模块是工程的顶层文件，负责把各个子模块组合起来，负责声明整个系统的信号接口。

## Phasecomparator.v

### 模块接口

```verilog
module phasecomparator(
    input MainClock,                  // System Clock
    input InputSignal, OutputSignal,         // 输入输出信号
    output SynchronousSignal,                 // 同步信号
    output Lead, Lag,                    // 超前、滞后脉冲
    output InputSignalEdge,  // 输入信号上升沿
    output OutputSignalEdge,      // 输出信号上升沿
    output Lock,                    // 锁定标志位
    output [7:0] PeriodCount  // 输入信号周期
);
```



### 功能描述

**Phasecomparator**为鉴相器模块，首先通过D触发器，把输入信号同步到系统的时钟域；其二，统计输入信号的周期，用于振荡信号的生成；其三，对输入信号与反馈信号进行相位比较，反馈信号超前于输入信号则置Lead为高电平，反之，反馈信号滞后则置Lag为高电平，这两个信号有效的持续周期都为一个系统时钟周期。

<div style='text-align: center;'>

![鉴相器工作示意图](https://s2.loli.net/2021/12/06/GUCWkRHwEKltxFZ.jpg)

</div>

## VariableResetRandomWalkFilter.v和RandomWalkFilter.v

### 模块接口

```verilog
module variableresetrandomwalkfilter(
   input  MainClock, Lead, Lag;  // System Clock and Phase Comparator signals
   output Positive, Negative;    // "positive shift" and "negative shift" outputs
);
```

```verilog
module randomwalkfilter(
   input  MainClock, Lead, Lag;  // System Clock and Phase Comparator signals
   output Positive, Negative;    // "positive shift" and "negative shift" outputs
);
```

### 功能描述

**VariableResetRandomWalkFilter**模块是环路滤波器模块，**RandomWalkFilter**是它的子模块，该子模块实现的是**随机徘徊序列滤波器**，前者在后者基础上增加Reset值可调的功能。随机徘徊序列滤波器的主体是一个可逆计数器。当有超前脉冲输人到UP端时,计数器上行计数,当有滞后脉冲输入到DN端时,计数器下行计数。如果超前脉冲超过滞后的数目到达计数容量N时,就在+N端输出一个提前脉冲,同时使计数器复位。反之，则在-N端输出一个推后脉冲,同时计数器复位。环路锁定前,鉴相器连续输出超前或滞后脉冲,上行计数器或下行计数器到达满状态后输出提前脉冲或推后脉冲,在这两个脉冲作用下环路逐步进入锁定状态。当环路进入锁定状态后，由噪声引起的超前或滞后脉冲是随机的，而且出现概率基本相等,不会有连续很多个超前或滞后脉冲，因而它们的差值达到计数容量N的可能性极小，这样就可以减小噪声对环路的干扰作用。

<div style='text-align: center;'>

![RandomWalkFilter滤波器的结构](https://s2.loli.net/2021/12/06/C7VKpyd3mNFPsrg.jpg)

</div>



## Freqdivider.v

### 模块接口

```verilog
module freqdivider(
	input MainClock;                  
	input Positive, Negative;    // 控制输出周期
	output FrequencyOut;               // 倍频输出
);
```

### 功能描述

主要功能是基于系统时钟进行分频。系统时钟取决于FPGA硬件型号，一般需要较高的系统时钟。基于由上述鉴相器模块计算得到的输入信号的时钟周期数，计算倍频信号的时钟周期数，产生同步振荡信号。由于存在系统延时，一开始产生的振荡信号与输入信号并不同步，由鉴相器处理使其逐渐达到同步锁定状态。

# 功能仿真

## 电路逻辑

使用Quartus完成程序设计，对应的RTL电路逻辑如下图所示。

![RTL逻辑电路图](https://s2.loli.net/2021/12/06/JWBkolRYv56Op2V.png)

## 仿真参数

系统时钟设置为50MHz，输入信号频率为500KHz，输入信号具有不确定性，即仿真中添加一个随机时延，此处设置为3287ns。

## 仿真效果

### 同步性能

波形仿真图如图3-1所示，MainClock为系统时钟，SignalIn为输入信号，SignalOut为输出信号，Lead、Lag分别为鉴相器输出的相位领先和滞后信号，Positive、Negative则对应上述两个信号经过环路滤波器后的输出。Lock是输出锁定信号，置高电平时环路锁定。由仿真波形图可以看出，锁定时间为168300ns ，减去开头加入的输入时延3287ns，实际锁定时间为165013ns，即165μs，锁定后输出与输入信号同频同相。

![环路锁定](https://s2.loli.net/2021/12/06/jmBtJRqaOgFWsSx.png)

### 倍频效果

改变顶层文件（dpll.v）里的参数（parameter）DividerMultiple的值，便可以修改锁相环输出倍频的倍数，可以实现奇倍频和偶倍频。如图所示分别为基于500KHz输入信号产生2倍频、5倍频和20倍频的效果图。。

![2倍频](https://s2.loli.net/2021/12/06/Ibzl2HNjD1W9xRQ.png)

![5倍频](https://s2.loli.net/2021/12/06/xM14OUsGlWbcQ6I.png)

![20倍频](https://s2.loli.net/2021/12/06/U5VjaZlAGEFqdS3.png)

# 总结

本设计实现了一款全数字锁相环路，能够基于低频率时钟源，倍频产生高频时钟，并且达到高频时钟输出相位锁定、占空比1:1的预期效果。通过本次设计的锁相环路，可以实现在FPGA平台上，锁定未知的较低频输入信号，产生同频同相的任意倍频（频率低于系统时钟频率）输出信号。本设计完全基于Verilog代码实现，程序简单，完全可以满足简单地实现同步倍频信号的场合要求。

 

 </br>

- end
