import numpy as np
import matplotlib.pyplot as plt

solid = np.ones(10)
dashed = 2*solid
dashdot = 3*solid
dotted = 4*solid
none = 5*solid

plt.plot(solid, ls="-", label="-")
plt.plot(dashed, ls="--", label="--")
plt.plot(dashdot, ls="-.", label="-.")
plt.plot(dotted, linestyle=":", label=":")
plt.plot(none, ls=" ", label=" ")
plt.ylim(0,6)
plt.legend(loc = "upper right")
plt.show()

line1 = np.ones(10)
line2 = 2*np.ones(10)
line3 = 2.5 + np.sin(np.linspace(0,2*np.pi,10))
line4 = 4*np.ones(10)

plt.plot(line1, ls=(0, (10, 2)), label="(0, (10, 2))")
plt.plot(line2, ls=(10, (5, 5)), label="(10, (5, 5))")
plt.plot(line3, ls=(10, (5, 2, 1, 2)), label="(10, (5, 2, 0, 2))")
plt.plot(line4, ls=(0, (1, 3, 1, 3, 5, 3)), label="(0, (0, 3, 0, 3, 5, 3))")
plt.ylim(0,6)
plt.legend(loc = "upper right")
plt.show()