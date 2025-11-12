import excel "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\stata-fdi-制造业面板数据.xlsx", firstrow clear
gen edu=(Pop_ASNE+Pop_ASPrim*6+Pop_ASMid*9+Pop_ASHigh*12+Pop_ASHE*16)/Pop_AS
gen lnPGDP=ln(PGDP)
gen ln_sal=ln(Manu_AvgSal)
gen ln_fdi=ln(Manu_FDI)
gen LQ=(Manuwker_10k/TProv_Employ)/(Total_Manuewker/Total_Emp)
gen inv=ln(FAInv-FAFInv)
drop Pop_AS Pop_ASHE Pop_ASHigh Pop_ASMid Pop_ASNE Pop_ASPrim FAInv FAFInv ExpManu ImpManu

// 对省份分区（来源：https://www.stats.gov.cn/zt_18555/zthd/sjtjr/dejtjkfr/tjkp/202302/t20230216_1909741.htm）
gen 东部地区=0
replace 东部地区=1 if Code==110000 | Code==120000 | Code==130000 | Code==310000 | Code==320000 | Code==330000 | Code==350000 | Code==370000 | Code==440000 | Code==460000
gen 西部地区=0
replace 西部地区=1 if Code==150000 | Code==450000 | Code==500000 | Code==510000 | Code==520000 | Code==530000 | Code==610000 | Code==620000 | Code==630000 | Code==640000 | Code==650000
gen 中部地区=0
replace 中部地区=1 if Code==140000 | Code==340000 | Code==360000 | Code==410000 | Code==420000 | Code==430000
gen 东北地区=0
replace 东北地区=1 if Code==210000 | Code==230000

// 描述性统计
sum2docx ln_sal ln_fdi lnPGDP inv edu 研发强度 LQ using "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\描述性统计.docx",replace stats(N mean(%9.4f) sd min(%9.2f) median(%9.2f) max(%9.2f))  title("Table: Summary Statistics")

* 按地区分组进行描述性统计
summarize ln_sal ln_fdi lnPGDP inv edu GPatent LQ if 东部地区 == 1
summarize ln_sal ln_fdi lnPGDP inv edu GPatent LQ if 西部地区 == 1
summarize ln_sal ln_fdi lnPGDP inv edu GPatent LQ if 中部地区 == 1
summarize ln_sal ln_fdi lnPGDP inv edu GPatent LQ if 东北地区 == 1



// 相关性分析
logout,save(相关系数分析) word replace:pwcorr_a  ln_sal ln_fdi lnPGDP inv edu 研发强度 LQ, star1(.01) star5(.05) star10(.1) 

* 按地区分组进行相关性分析
pwcorr_a ln_sal ln_fdi lnPGDP inv edu 研发强度 LQ if 东部地区 == 1, star1(.01) star5(.05) star10(.1)
pwcorr_a ln_sal ln_fdi lnPGDP inv edu 研发强度 LQ if 西部地区 == 1, star1(.01) star5(.05) star10(.1)
pwcorr_a ln_sal ln_fdi lnPGDP inv edu 研发强度 LQ if 中部地区 == 1, star1(.01) star5(.05) star10(.1)
pwcorr_a ln_sal ln_fdi lnPGDP inv edu 研发强度 LQ if 东北地区 == 1, star1(.01) star5(.05) star10(.1)



// 回归分析（显著版）
xtset Code Year
xtreg ln_sal ln_fdi lnPGDP inv edu, fe
outreg2 using "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\回归结果.doc"
//分地区回归
xtreg ln_sal ln_fdi lnPGDP inv edu if 东部地区 ==1, fe
xtreg ln_sal ln_fdi lnPGDP inv edu if 西部地区 ==1, fe
xtreg ln_sal ln_fdi lnPGDP inv edu if 中部地区 ==1, fe
xtreg ln_sal ln_fdi lnPGDP inv edu if 东北地区 ==1, fe

//回归分析（显著+逐步回归版）
xtset Code Year
* 第一步：运行基线模型
xtreg ln_sal ln_fdi, fe
outreg2 using "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\回归结果.doc", replace ctitle("Baseline Model")
* 第二步：添加控制变量lnPGDP并重新运行模型
xtreg ln_sal ln_fdi lnPGDP, fe
outreg2 using "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\回归结果.doc", append ctitle("Model with lnPGDP")
* 第三步：添加控制变量inv并重新运行模型
xtreg ln_sal ln_fdi lnPGDP inv, fe
outreg2 using "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\回归结果.doc", append ctitle("Model with lnPGDP and inv")
* 第四步：添加控制变量edu并重新运行模型
xtreg ln_sal ln_fdi lnPGDP inv edu, fe
outreg2 using "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\回归结果.doc", append ctitle("Full Model with all variables")


// 技术溢出中介效应分析（显著版）
reg ln_sal ln_fdi lnPGDP inv edu
outreg2 using "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\技术溢出中介效应分析.doc", replace
reg 研发强度 ln_fdi lnPGDP inv edu
outreg2 using "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\技术溢出中介效应分析.doc", append
reg ln_sal ln_fdi 研发强度 lnPGDP inv edu
outreg2 using "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\技术溢出中介效应分析.doc", append
(1)中的ln_fdi要显著  (2)中的ln_fdi要显著  (3)中的ln_fdi和研发强度要显著，则存在中介效应

// 产业集聚中介效应分析
reg ln_sal ln_fdi lnPGDP inv edu
outreg2 using "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\产业集聚中介效应分析.doc", replace
reg LQ ln_fdi lnPGDP inv edu
outreg2 using "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\产业集聚中介效应分析.doc", append
reg ln_sal ln_fdi LQ lnPGDP inv edu
outreg2 using "C:\Users\陈夏恩\Documents\大学\论文\国商论文\新\产业集聚中介效应分析.doc", append



// 稳健性分析（系统GMM）【存在问题】
xtabond2 ln_sal L.ln_sal ln_fdi lnPGDP inv edu, iv(lnPGDP inv edu) gmm(L.ln_sal  L.(ln_fdi), lag(1 2) c) robust twostep 

xtabond2 ln_sal L.ln_sal ln_fdi lnPGDP inv edu if 东部地区 ==1, iv(lnPGDP inv edu) gmm(L.ln_sal  L.(ln_fdi), lag(1 2) c) robust twostep 
xtabond2 ln_sal L.ln_sal ln_fdi lnPGDP inv edu if 西部地区 ==1, iv(lnPGDP inv edu) gmm(L.ln_sal  L.(ln_fdi), lag(1 2) c) robust twostep 
xtabond2 ln_sal L.ln_sal ln_fdi lnPGDP inv edu if 中部地区 ==1, iv(lnPGDP inv edu) gmm(L.ln_sal  L.(ln_fdi), lag(1 2) c) robust twostep 
xtabond2 ln_sal L.ln_sal ln_fdi lnPGDP inv edu if 东北地区 ==1, iv(lnPGDP inv edu) gmm(L.ln_sal  L.(ln_fdi), lag(1 2) c) robust twostep 