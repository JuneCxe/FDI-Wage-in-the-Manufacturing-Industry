## 🇨🇳 Foreign Direct Investment and Wage Dynamics in China’s Manufacturing Sector  
**Author:** Xiaen (June) Chen  
**Institution:** Beijing Foreign Studies University  
**Software:** Stata 17  

---

### 📘 Overview  
This project investigates how **foreign direct investment (FDI)** affects wage levels in China’s manufacturing sector using **provincial panel data (2010–2020)**.  
By combining econometric modeling and policy interpretation, it explores the **channels through which FDI influences labor income**, focusing on **technological spillovers** and **industrial agglomeration effects**.

---

### 🔍 Research Question  
> Does FDI promote or suppress wage growth in China’s manufacturing sector, and what mechanisms drive this relationship?

---

### 🧮 Methodology  

**Data Construction**  
- Compiled a balanced panel of 29 provinces (2010–2020) from *China Statistical Yearbook*, *China Population and Employment Yearbook*, and provincial statistics.  
- Engineered key variables:  
  - *ln_sal*: log of manufacturing average wage  
  - *ln_fdi*: log of actual utilized FDI in manufacturing  
  - *lnPGDP*, *inv*, *edu*: control variables for economic scale, domestic investment, and education  
  - *R&D*, *LQ*: mediators for technology spillover and industrial agglomeration  

**Modeling Workflow**  
1. Data cleaning & transformation  
2. Descriptive statistics & correlation analysis  
3. Fixed-effects panel regressions (Hausman-tested)  
4. Three-step mediation analysis to test indirect channels  
5. Regional heterogeneity regressions (East / Central / West / Northeast)  
6. System GMM robustness checks for dynamic effects  

All analysis was conducted in **Stata 17** using reproducible `.do` scripts.

---

### 📈 Key Findings  
- **FDI has a negative marginal effect** on manufacturing wages in China (–0.01 elasticity).  
- **Industrial agglomeration** mediates part of this negative impact, suggesting regional clustering pressures.  
- **Technological spillovers** offset the adverse wage effect by improving productivity.  
- Findings highlight the need for **industrial upgrading and targeted FDI policies** to enhance labor income outcomes.  

---

### 🧭 Policy Implications  
- Encourage technology-intensive rather than labor-intensive FDI.  
- Balance industrial clustering with regional diversification.  
- Promote R&D transfer and skills training to amplify positive spillovers.  
