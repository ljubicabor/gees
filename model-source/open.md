# GEES Import, export, and BOP module


## Declare quantities

```matlab

!variables(:open)

    "Non-commodity imports" mm
    "Price of non-commodity imports" pmm
    "Price of non-commodity imports, FOB" fob_pmm
    "Imports for non-commodity exports" mxx
    "Imports for domestic production" my

    "Domestic content of non-commodity exports" yxx
    "Non-commodity exports" xx
    "Commodity exports" xq
    "Price of non-commodity exports" pxx

    "Net foreign fixed-income assets to GDP Ratio" nfa_to_ngdp
    "Primary income rate on net foreign fixed-income assets" rnfa
    "Checksum for net foreign fixed-income assets to GDP ratio" nfa_to_ngdp_checksum
    "Nominal exchange rate" e
    "Expectations of nominal exchange rate" exp_e
    "Nominal Exchange Rate, Y/Y" roc_e
    "BOP CA corporate equity primary income to GDP ratio" bpceq_to_ngdp
    "BOP FA corporate equity transactions to GDP ratio" bpfeq_to_ngdp
    "Price of non-commodity exports, Reference ccy" pxx_rcy
    "Value of non-commodity exports, Reference ccy" nxx_rcy
    "Net claims of financial sector on households" bh_to_ngdp
    "Non-commodity imports to GDP ratio" nmm_to_ngdp
    "Non-commodity exports to GDP ratio" nxx_to_ngdp
    "Net commodity exports to GDP ratio" netxq_to_ngdp
    "Net non-commodity exports to GDP ratio" netxx_to_ngdp

    "Country credit risk" zh
    "Autonomous component in country credit risk" zh_aut


!log-variables !all-but

    nfa_to_ngdp
    nfa_to_ngdp_checksum
    bpfeq_to_ngdp
    bpceq_to_ngdp
    bh_to_ngdp
    nmm_to_ngdp
    nxx_to_ngdp
    netxq_to_ngdp
    netxx_to_ngdp
    zh_aut


!parameters(:open :steady)

    "Import intensity of non-commodity exports !! $\gamma_\mathit{mxx}$" gamma_mxx
    "Acceleration in exportable productivity !! $\gamma_\mathit{xx}$" gamma_xx
    "Elasticity of household risk function wrt NFA !! $\theta_1$" theta_1
    "Curvature of household risk function wrt NFA !! $\theta_2$" theta_2
    "Share of local commodity production in world commodity production !! $\lambda$" lambda
    "S/S Autonomous component in country credit risk !! $\mathit{zh}^\mathrm{aut}_\ss$" ss_zh_aut


!parameters(:open :dynamic)

    "A/R Autonomous component in country credit risk !! $\rho_{\mathit{zh}}^\mathrm{aut}$" rho_zh_aut
    "Weight on model-consistent expectations in exchange rate !! $\zeta_e$" zeta_e
    "Adjustment cost parameter in stage t-3 production !! $\xi_{y3}$" xi_y3


!shocks(:open)

    "Interest parity shock" shk_e
    "Shock to country credit risk" shk_zh
    "Shock to autonoumous component in country credit risk" shk_zh_aut

```


## Define substitutions


```matlab

!substitutions

    % xq = (lambda * gg_q);
    adj_nv = (log(nv/y3)-log(nv{-1}/y3{-1})-log(&roc_nv/&roc_y3))-&rdf*(log(nv{+1}/y3{+1})-log(nv/y3)-log(&roc_nv/&roc_y3));
    adj_mm = (log(my/y3)-log(my{-1}/y3{-1}))-&rdf*(log(my{+1}/y3{+1})-log(my/y3));

```


## Define equations


```matlab

!equations(:open)


    %% -----Non-commodity imports-----

    "Distribution of non-commodity imports"
    mm = my + mxx;


    %% -----Commodity sector-----

    "Commodity endowment"
    xq = lambda * gg_q;

    "Commodity prices in local currency"
    pq = gg_pq * e;


    %% -----Non-commodity export production-----

    "Non-commodity export production function"
    xx = ar^gamma_xx * (yxx/(1-gamma_mxx))^(1-gamma_mxx) * (mxx/gamma_mxx)^gamma_mxx;

    "Demand for local content in export production"
    (1-gamma_mxx) * pxx * xx = py * yxx;

    "Demand for re-exports"
    gamma_mxx * pxx * xx = (pmm * gg_dmm) * mxx;


    %% -----Balance of payments and exchange rate-----

    "Balance of payments transactions"
    nfa_to_ngdp * ngdp - nfa_to_ngdp{-1} * ngdp{-1} = ...
        + bpfeq_to_ngdp * ngdp ...
        + (rnfa - 1) * nfa_to_ngdp{-1} * ngdp{-1} ...
        + bpceq_to_ngdp*ngdp ...
        + pxx * xx ... Non-commodity exports
        - fob_pmm * mm ... Non-commodity imports, priced FOB destination
        + netxq_to_ngdp * ngdp ... Net commodity exports
        + nfa_to_ngdp_checksum * ngdp;

    "Local interest spread"
    zh = ...
        + zh_aut ...
        + theta_1 * (1/theta_2)*[ exp(-theta_2*nfa_to_ngdp*ngdp/(pk*k)) - 1 ] ...
        + shk_zh;

    "Autonomous component in local interest spread"
    zh_aut = ...
        + rho_zh_aut * zh_aut{-1} ...
        + (1 - rho_zh_aut) * ss_zh_aut ...
        + shk_zh_aut ...
    !! zh_aut = ss_zh_aut;


    "Net balance sheet of local financial sector"
    bh_to_ngdp + dg_to_ngdp + nfa_to_ngdp = 0;


    "Nominal Exchange Rate Expectations"
    exp_e = e{+1}^zeta_e * (e*&roc_e)^(1-zeta_e);


    roc_e = e / e{-1};


    %% -----International comparison-----

    "Price of non-commodity exports in reference currency"
    pxx_rcy = pxx / e;

    "Value of non-commodity exports in reference currency"
    nxx_rcy = pxx_rcy * xx;


    %% -----Calibration ratios-----

    "Total imports to GDP ratio"
    nmm_to_ngdp = fob_pmm*mm / ngdp;
    nxx_to_ngdp = pxx*xx / ngdp;
    netxq_to_ngdp = pq*(xq - mq) / ngdp;
    netxx_to_ngdp = nxx_to_ngdp - nmm_to_ngdp;

```


## Postprocessing equations outside model 


```matlab

!postprocessor

    nmxx_to_ngdp = fob_pmm * mxx / ngdp;


!log-variables !all-but

    nmm_to_ngdp
    nxx_to_ngdp
    nmxx_to_ngdp

```

