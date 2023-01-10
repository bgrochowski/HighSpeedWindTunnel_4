import flowtools
import matplotlib.pyplot as plt
from get_p_M_sub_not_choked import p_pt, M_local

gamma = 1.4

testfile1 = open('data_for_report/Data_Test_1AB.txt', 'r')
testfile1_lines = testfile1.readlines()
testfile1.close()

testfile2 = open('data_for_report/Data_Test_2A.txt', 'r')
testfile2_lines = testfile2.readlines()
testfile2.close()

geom1file = open('fixed_geom.txt', 'r')
geom1file_lines = geom1file.readlines()
geom1file.close()

xtab = []
p__pt_measurement1_tab = []
M_measurement1_tab = []

p__pt_measurement2_tab = []
M_measurement2_tab = []

h_tab = []
Aratio_tab = []

for line in testfile1_lines:
    line = line.strip()
    if line[0]!="%":
        line = line.split()
        # xtab.append(float(line[0]))
        p__pt_measurement1_tab.append(float(line[1]))
        M_measurement1_tab.append(flowtools.flowisentropic2(gamma, float(line[1]), 'pres')[0])

# for line in testfile1_lines:
#     line = line.strip()
#     if line[0]!="%":
#         line = line.split()
#         # xtab.append(float(line[0]))
#         p__pt_measurement1_tab.append(float(line[1]))
#         M_measurement1_tab.append(flowtools.flowisentropic2(gamma, float(line[1]), 'pres')[0])

for line in geom1file_lines:
    line = line.strip()
    if line[0]!="%":
        line = line.split()
        xtab.append(float(line[0]))
        h_tab.append(float(line[1]))
        Aratio_tab.append(float(line[2]))

p__pt_theoretical_tab = []
M_theoretical_tab = []

for i in range(len(xtab)):
    if xtab[i] < 65:
        regime = 'sub'
    else:
        regime = 'sup'
    values = flowtools.flowisentropic2(gamma, Aratio_tab[i], regime)
    M_theoretical_tab.append(float(values[0]))
    p__pt_theoretical_tab.append(float(values[2]))

plt.plot(xtab, M_measurement1_tab[:25], 'bo-', label="Measured, measurement 1AB")
plt.plot(xtab, M_theoretical_tab, 'r-', label="Theoretical measurement 1AB")
plt.plot(xtab, M_measurement2_tab, 'go-', label="Measured measurement 2A")
plt.plot(xtab, M_local, 'y-', label="Theoretical measurement 2A")
plt.xlim(40, 200)
plt.legend()
plt.show()