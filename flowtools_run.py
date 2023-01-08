import flowtools
import matplotlib.pyplot as plt

gamma = 1.4

testfile = open('testfile.txt', 'r')
testfile_lines = testfile.readlines()
testfile.close()

xtab = []
p__pt_tab = []

for line in testfile_lines:
    line = line.strip()
    if line[0]!="%":
        line = line.split()
        xtab.append(float(line[0]))
        p__pt_tab.append(float(line[1]))

plt.plot(xtab, p__pt_tab, 'bo-')
plt.xlim(40, 200)
plt.show()

# out = flowtools.flowisentropic2(gamma,50.0,'sub')
# print(out)

# out2 = flowtools.flownormalshock2(gamma,2.5,'mach')
# print(out2)