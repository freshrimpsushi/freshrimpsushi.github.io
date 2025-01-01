import torch
import torch.nn as nn
from tqdm import tqdm

# check if cuda is available
print("Is cuda available?:", str(torch.cuda.is_available()))
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
print("Device            :", device,"\n")

class DeepONet(nn.Module):
    # Class constructor and initialization for inheritance
    def __init__(self, branch_layers, trunk_layers):
        super().__init__()

        self.activ = nn.ReLU()

        #1 brunch network
        self.branch = nn.ModuleList([nn.Linear(branch_layers[i], branch_layers[i+1]) for i in range(len(branch_layers)-1)])
        
        #2 trunk network
        self.trunk = nn.ModuleList([nn.Linear(trunk_layers[i], trunk_layers[i+1]) for i in range(len(trunk_layers)-1)])

        #3 bias
        self.b0 = torch.nn.Parameter(torch.zeros(1))

        #4 weight initialization
        for m in self.modules():
            if isinstance(m, nn.Linear): 
                nn.init.xavier_uniform_(m.weight.data)
        
    # define forward pass
    def forward(self, u, y):
        #5 branch network forward pass
        for layer in self.branch[:-1] :
            u = self.activ(layer(u))
        b_k = self.branch[-1](u)
        
        #6 trunk network forward pass
        for layer in self.trunk[:-1]:
            y = self.activ(layer(y))
        # t_k =  self.activ(self.trunk[-1](y))
        t_k =  self.trunk[-1](y)
        
        #7 inner product
        Gu = torch.sum(b_k * t_k, dim=-1) + self.b0
        
        return Gu.reshape(-1, 1)
    
import numpy as np
from scipy.integrate import odeint # solver for ODE
from torch.utils.data import TensorDataset, DataLoader

#8 fix random seed
seednumber = 1234
torch.manual_seed(seednumber)
np.random.seed(seednumber)

#9 
p = 50      # dimemsion of trunk network's output or number of basis functions
m = 100     # number of sensors

#10
s0       = 0                        # initial condition
Num_u    = 3500                     # number of samples for input functions u
Num_y    = 50                       # dimension of the variable y for output function Gu
inputs_y = np.linspace(0, 1, Num_y) # sampling points for y

#11 sampling points for u
M       = 1  # bound of domain
sensors = np.random.uniform(-M, M, m)
sensors = np.sort(sensors)

#12 set the number of Chebyshev polynomials
Num_Ti  = 15 # number of Chebyshev polynomials T_i

#13
def ds_dx(s, x, a):
    return np.polynomial.chebyshev.Chebyshev(a)(x)

#14 generate data
inputs_u = []
target_s = []

for i in range(Num_u):
    a = np.random.uniform(-M, M, Num_Ti)
    u = np.polynomial.chebyshev.Chebyshev(a)(sensors)
    s = odeint(ds_dx, s0, inputs_y, args=(a,)).reshape(Num_y)

    inputs_u.append(u)
    target_s.append(s)

#15
inputs_u = torch.as_tensor(np.array(inputs_u), dtype=torch.float32)
target_s = torch.as_tensor(np.array(target_s), dtype=torch.float32)

#16
N_train  = 3000
inputs_U = torch.kron(inputs_u[:N_train], torch.ones(len(inputs_y), 1))
inputs_Y = torch.kron(torch.ones(N_train, 1), torch.as_tensor(inputs_y, dtype=torch.float32).reshape(-1, 1))
target_S = target_s[:N_train,:].reshape(-1, 1)

valid_U = torch.kron(inputs_u[N_train:], torch.ones(len(inputs_y), 1)).to(device)
valid_Y = torch.kron(torch.ones(Num_u-N_train, 1), torch.as_tensor(inputs_y, dtype=torch.float32).reshape(-1, 1)).to(device)
valid_S = target_s[N_train:,:].reshape(-1, 1).to(device)

np.save('inputs_U.npy', inputs_U)
np.save('inputs_Y.npy', inputs_Y)
np.save('target_S.npy', target_S)
np.save('valid_U.npy', valid_U)
np.save('valid_Y.npy', valid_Y)
np.save('valid_S.npy', valid_S)

#17 data loader
batch_size    = 1000
training_data = TensorDataset(inputs_U, inputs_Y, target_S)
train_loader  = DataLoader(training_data, batch_size=batch_size, shuffle=True)

#18 set the dimensions of hidden layers for the branch and trunk networks
branch_layers = [m, 100, 100, 100, p]
trunk_layers  = [1, 100, 100, 100, p]

# define the network, loss function and optimizer
network = DeepONet(branch_layers, trunk_layers).to(device)

criterion = nn.MSELoss()
optimizer = torch.optim.Adam(network.parameters(), lr=5e-4)
Epochs = 400

def train(network, optimizer, criterion, train_loader, epoch, loss_list, error_list):
    network.train()

    for u, y, s in train_loader:
        optimizer.zero_grad()
        batch_inputs_u = u.to(device)
        batch_inputs_y = y.to(device)
        batch_target_s = s.to(device)

        prediction = network(batch_inputs_u, batch_inputs_y)

        #19 calculate loss and backpropagate
        loss = criterion(prediction, batch_target_s)
        loss.backward()
        optimizer.step()

        #20 calculate relative L2 error
        with torch.no_grad():
            error = relative_L2_error(prediction.reshape(-1,Num_y), batch_target_s.reshape(-1,Num_y))
    
    loss_list.append(loss.item())
    error_list.append(error.item())

    #21 print the loss and relative L2 error every 5 epochs
    if epoch % 5 == 0 or epoch == Epochs-1:
        tqdm.write(f'Epoch {epoch+1:4d}/{Epochs:4d}, Train Loss: {loss.item():.8f}, Train Relative L2 error: {error.item():.4f}')

        with torch.no_grad():
            network.eval()
            valid_prediction = network(valid_U.to(device), valid_Y.to(device))
            valid_loss       = criterion(valid_prediction, valid_S.to(device))
            valid_error      = relative_L2_error(valid_prediction.reshape(-1,Num_y), valid_S.reshape(-1,Num_y).to(device))
            tqdm.write(f'Epoch {epoch+1:4d}/{Epochs:4d}, Valid Loss: {valid_loss.item():.8f}, Valid Relative L2 error: {valid_error.item():.4f}\n')
        
    return

def relative_L2_error(pred, true):
    if pred.shape != true.shape:
        raise ValueError('pred and true must have the same shape')
    
    if pred.dim() == 1:
        return torch.norm(pred - true) / torch.norm(true)
    else:
        N = pred.shape[0]
        return torch.sum(torch.norm(pred-true,dim=-1)/torch.norm(true, dim=-1))/N
    
#22 check the performance of the network before training
pre_prediction = network(train_loader.dataset.tensors[0][:10000,:].to(device), train_loader.dataset.tensors[1][:10000].to(device))
pre_loss       = criterion(pre_prediction, train_loader.dataset.tensors[2][:10000,:].to(device))
pre_error      = relative_L2_error(pre_prediction, train_loader.dataset.tensors[2][:10000,:].to(device))
print(f'before_training, init. Loss: {pre_loss.item():.8f}, init. Relative L2 error: {pre_error.item():.4f}\n')

#23 train the network
loss_list  = []
error_list = []
for epoch in tqdm(range(Epochs)):
    train(network, optimizer, criterion, train_loader, epoch, loss_list, error_list)

import matplotlib.pyplot as plt

plt.plot(loss_list,  linewidth = 3, label="loss")
plt.plot(error_list, linewidth = 3, label="rel. L2 error"); plt.legend(fontsize=15)
plt.yscale('log'); plt.xlabel('Epochs', fontsize=15)
plt.title('Training loss and relative L2 error', fontsize=20)
plt.subplots_adjust(left=0.05, right=0.95, bottom=0.10, top=0.90, wspace=0.15, hspace=0.15)
plt.show()

test_y_np = np.linspace(0, 1, 200)
test_y = torch.linspace(0, 1, 200).reshape(-1,1).to(device)

a1, a2 = np.random.uniform(-M, M, Num_Ti), np.random.uniform(-M, M, Num_Ti)
u1, u2 = np.polynomial.chebyshev.Chebyshev(a1)(sensors), np.polynomial.chebyshev.Chebyshev(a2)(sensors)
s1, s2 = odeint(ds_dx, s0, inputs_y, args=(a1,)).reshape(Num_y), odeint(ds_dx, s0, inputs_y, args=(a2,)).reshape(Num_y)
u_tensor1, u_tensor2 = torch.as_tensor(np.array(u1), dtype=torch.float32).to(device), torch.as_tensor(np.array(u2), dtype=torch.float32).to(device)

plt.subplot(2,2,1)
plt.plot(sensors, u1, color='green', linewidth=5, zorder=1)
plt.scatter(sensors, u1, color='black')
plt.ylim(-5, 5)
plt.title(r'Input functions $u$', fontsize=20)

plt.subplot(2,2,2)
plt.plot(inputs_y, s1, linewidth=5, color='dodgerblue')
plt.plot(test_y_np, network(u_tensor1, test_y).detach().cpu().numpy(), linewidth=2, color='red',linestyle='--')
plt.ylim(-0.8, 0.8)
plt.title(r'Output functions $Gu$ and predictions', fontsize=20)

plt.subplot(2,2,3)
plt.plot(sensors, u2, color='green', linewidth=5, label=r'$u(x)$', zorder=1)
plt.scatter(sensors, u2, color='black', label='value on sensors', zorder=2)
plt.ylim(-5, 5)
plt.xlabel('x', fontsize=20)
plt.legend(fontsize=17, loc='lower right')

plt.subplot(2,2,4)
plt.plot(inputs_y, s2, linewidth=5, color='dodgerblue', label=r'$Gu(y)$')
plt.plot(test_y_np, network(u_tensor2, test_y).detach().cpu().numpy(), linewidth=2, color='red',linestyle='--',label='predition')
plt.ylim(-0.8, 0.8)
plt.xlabel('y', fontsize=20)
plt.legend(fontsize=17, loc='lower right')

plt.subplots_adjust(left=0.05, right=0.95, bottom=0.10, top=0.95, wspace=0.15, hspace=0.15)
plt.show()