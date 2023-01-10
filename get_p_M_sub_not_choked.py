import flowtools
#import matplotlib.pyplot as plt
GAMMA=1.4

#Process Fixed Geom File
testfile = open('testfile.txt', 'r')
testfile_lines = testfile.readlines()
testfile.close()

geom1file = open('fixed_geom.txt', 'r')
geom1file_lines = geom1file.readlines()
geom1file.close()

xtab = []
p__pt_measured_tab = []

h_tab = []
Aratio_tab = []

for line in testfile_lines:
    line = line.strip()
    if line[0]!="%":
        line = line.split()
        # xtab.append(float(line[0]))
        p__pt_measured_tab.append(float(line[1]))

for line in geom1file_lines:
    line = line.strip()
    if line[0]!="%":
        line = line.split()
        xtab.append(float(line[0]))
        h_tab.append(float(line[1]))
        Aratio_tab.append(float(line[2]))
#------------------------------------------------------------------#    
#Input (Constants)
x0=44.8                 #[mm]
p_pt_x0_measured=0.83167270    #[-]

#Compute Local Mach from p_pt_x0_measured
A_x0_A_t=Aratio_tab[xtab.index(x0)]
A_x0_A_star=flowtools.flowisentropic2(GAMMA, p_pt_x0_measured, 'pres')[4]
A_t_A_star=A_x0_A_star/A_x0_A_t

#Final Values
p_pt=[]
M_local=[]

for i in range(len(xtab)):
    A_x_A_t=Aratio_tab[i]
    A_x_A_star=A_t_A_star*A_x_A_t
    
    M_local.append(flowtools.flowisentropic2(GAMMA, A_x_A_star, 'sub')[0])
    p_pt.append(flowtools.flowisentropic2(GAMMA, A_x_A_star, 'sub')[2])

#plt.plot(xtab, p_pt, 'go-')
#plt.ylim(0, 1.2)
#plt.grid()
#plt.show()
    
