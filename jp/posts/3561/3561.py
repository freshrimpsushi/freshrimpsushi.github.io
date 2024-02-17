import argparse

parser = argparse.ArgumentParser()

parser.add_argument("-epo", "--epoch", type=int)
parser.add_argument("-s", "--seed", type=int)
parser.add_argument("-a", "--activ_fn", type=str)

args = parser.parse_args()

print(type(args))
print("args:", args)

print("epoch:", args.epoch, type(args.epoch))
print("seed:", args.seed, type(args.seed))
print("activ_fn:", args.activ_fn, type(args.activ_fn))

# parser.add_argument("--dx", type=float, nargs=3)
# parser.add_argument("--dy", type=float, nargs=2)
# args = parser.parse_args()

# print("dx:", args.dx, ", type of dx:", type(args.dx))
# print("dy:", args.dy, ", type of dy:", type(args.dy))