using PowerSystems
using TimeSeries
using Missings
using NamedTuples

DayAhead  = collect(DateTime("1/1/2024  0:00:00", "d/m/y  H:M:S"):Hour(1):DateTime("1/1/2024  23:00:00", "d/m/y  H:M:S"))
#Dispatch_11am =  collect(DateTime("1/1/2024  0:11:00", "d/m/y  H:M:S"):Minute(15):DateTime("1/1/2024  12::00", "d/m/y  H:M:S"))

FiveBus = SystemParam(5, 230, 100, length(DayAhead));

nodes5    = [Bus(1,"nodeA", "PV", 0, 1.0, @NT(min = 0.9, max=1.05), 230),
             Bus(2,"nodeB", "PQ", 0, 1.0, @NT(min = 0.9, max=1.05), 230),
             Bus(3,"nodeC", "PV", 0, 1.0, @NT(min = 0.9, max=1.05), 230),
             Bus(4,"nodeD", "PV", 0, 1.0, @NT(min = 0.9, max=1.05), 230),
             Bus(5,"nodeE", "SF", 0, 1.0, @NT(min = 0.9, max=1.05), 230),
        ];

branches5 = [Line("1", true, (nodes5[1],nodes5[2]), 0.00281, 0.0281, 0.00712, 400.0, missing),
             Line("2", true, (nodes5[1],nodes5[4]), 0.00304, 0.0304, 0.00658, Inf, missing),
             Line("3", true, (nodes5[1],nodes5[5]), 0.00064, 0.0064, 0.03126, Inf, missing),
             Line("4", true, (nodes5[2],nodes5[3]), 0.00108, 0.0108, 0.01852, Inf, missing),     
             Line("5", true, (nodes5[3],nodes5[4]), 0.00297, 0.0297, 0.00674, Inf, missing),
             Line("6", true, (nodes5[4],nodes5[5]), 0.00297, 0.0297, 0.00674, 240, missing)
];     

Net5 = Network(FiveBus, branches5, nodes5); 

solar_ts_DA = [0
               0
               0
               0
               0
               0
               0
               0
               0
               0.351105684
               0.632536266
               0.99463925
               1
               0.944237283
               0.396681234
               0.366511428
               0.155125829
               0.040872694
               0
               0
               0
               0
               0
               0]

wind_ts_DA = [0.985205412
           0.991791369
           0.997654144
           1
           0.998663733
           0.995497149
           0.992414567
           0.98252418
           0.957203427
           0.927650911
           0.907181989
           0.889095913
           0.848186718
           0.766813846
           0.654052531
           0.525336131
           0.396098004
           0.281771509
           0.197790004
           0.153241012
           0.131355854
           0.113688144
           0.099302656
           0.069569628]

generators5 = [  ThermalGen("Alta", true, nodes5[1],
                    TechGen(40, @NT(min=0, max=40), 10, @NT(min = -30, max = 30), missing, missing),
                    EconGen(40, 14.0, 0.0, 0.0, 0.0, missing)
                ), 
                ThermalGen("Park City", true, nodes5[1],
                    TechGen(170, @NT(min=0, max=170), 20, @NT(min =-127.5, max=127.5), missing, missing),
                    EconGen(170, 15.0, 0.0, 0.0, 0.0, missing)
                ), 
                ThermalGen("Solitude", true, nodes5[3],
                    TechGen(520, @NT(min=0, max=520), 100, @NT(min =-390, max=390), missing, missing),
                    EconGen(520, 30.0, 0.0, 0.0, 0.0, missing)
                ),                
                ThermalGen("Sundance", true, nodes5[4],
                    TechGen(200, @NT(min=0, max=200), 40, @NT(min =-150, max=150), missing, missing),
                    EconGen(200, 40.0, 0.0, 0.0, 0.0, missing)
                ),    
                ThermalGen("Brighton", true, nodes5[5],
                    TechGen(600, @NT(min=0, max=600), 150, @NT(min =-450, max=450), missing, missing),
                    EconGen(600, 10.0, 0.0, 0.0, 0.0, missing)
                ),
                ReFix("SolarBusC", true, nodes5[3], 
                    60.0,
                    TimeSeries.TimeArray(DayAhead,solar_ts_DA)
                ),
                ReCurtailment("WindBusA", true, nodes5[5],
                    120,
                    EconRE(22.0, missing), 
                    TimeSeries.TimeArray(DayAhead,wind_ts_DA)
                )
            ];

loadbus2_ts_DA = [ 0.792729978
              0.723201574
              0.710952098
              0.677672816
              0.668249175
              0.67166919
              0.687608809
              0.711821241
              0.756320618
              0.7984057
              0.827836527
              0.840362459
              0.84511032
              0.834592803
              0.822949221
              0.816941743
              0.824079963
              0.905735139
              0.989967048
              1
              0.991227765
              0.960842114
              0.921465115
              0.837001437 ] 

loadbus3_ts_DA = [ 0.831093782
                0.689863228
                0.666058513
                0.627033103
                0.624901388
                0.62858924
                0.650734211
                0.683424321
                0.750876413
                0.828347191
                0.884248576
                0.888523615
                0.87752169
                0.847534405
                0.8227661
                0.803809323
                0.813282799
                0.907575962
                0.98679848
                1
                0.990489904
                0.952520972
                0.906611479
                0.824307054]     

loadbus4_ts_DA = [ 0.871297342
                0.670489749
                0.642812243
                0.630092987
                0.652991383
                0.671971681
                0.716278493
                0.770885833
                0.810075243
                0.85562361
                0.892440566
                0.910660449
                0.922135467
                0.898416969
                0.879816542
                0.896390855
                0.978598576
                0.96523761
                1
                0.969626503
                0.901212601
                0.81894251
                0.771004923
                0.717847996]            

loads5_DA = [  StaticLoad("Bus2", true, nodes5[2], "P", 300, 98.61, TimeArray(DayAhead, loadbus2_ts_DA)),
            StaticLoad("Bus3", true, nodes5[3], "P", 300, 98.61, TimeArray(DayAhead, loadbus3_ts_DA)),
            StaticLoad("Bus4", true, nodes5[4], "P", 400, 131.47, TimeArray(DayAhead, loadbus4_ts_DA)),
        ]