import flowtools
import matplotlib.pyplot as plt

gamma = 1.4

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

p__pt_theoretical_tab = []
M_theoretical_tab = []

for i in range(len(xtab)):
    if xtab[i] < 65:
        regime = 'sub'
    else:
        regime = 'sup'
    values = flowtools.flowisentropic2(gamma, Aratio_tab[i], regime)
    p__pt_theoretical_tab.append(float(values[1]))

plt.plot(xtab, p__pt_measured_tab[:25], 'bo-', label="Measured")
plt.plot(xtab, p__pt_theoretical_tab, 'ro-', label="Theoretical")
plt.xlim(40, 200)
plt.legend()
plt.show()

# out = flowtools.flowisentropic2(gamma,50.0,'sub')
# print(out)

# out2 = flowtools.flownormalshock2(gamma,2.5,'mach')
# print(out2)