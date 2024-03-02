import sys

print("sys.argv:", sys.argv)
print("type of sys.argv:", type(sys.argv))


for i, arg in enumerate(sys.argv):
    print("sys.argv[{}]:".format(i), arg, ", type:", type(arg))

print("sys.argv[3] == sys.argv[4]:", sys.argv[3] == sys.argv[4])