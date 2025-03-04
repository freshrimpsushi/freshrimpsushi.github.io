import torch
import torch.nn as nn
import torch.autograd as autograd

import numpy as np
import matplotlib.pyplot as plt

seednumber = 1234
torch.manual_seed(seednumber)
np.random.seed(seednumber)

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu"); print("Is cuda available?:", torch.cuda.is_available())

class MLP(nn.Module):
    def __init__(self, layers):
        super().__init__()

        self.activ = nn.Tanh()
        self.linears = nn.ModuleList([nn.Linear(layers[i], layers[i+1]) for i in range(len(layers)-1)])

        # Xavier Initialization
        for i in range(len(self.linears)):
            nn.init.xavier_normal_(self.linears[i].weight)
            nn.init.zeros_(self.linears[i].bias)
        
    def forward(self, x):
        y = x
        
        if len(self.linears) == 2:
            y = self.linears[0](y)
            y = self.activ(y)
            y = self.linears[1](y)
        else :
            for i in range(len(self.linears)-2):
                y = self.linears[i](y)
                y = self.activ(y)
            y = self.linears[-1](y)
        
        return y
    
layers = [2, 100, 100, 100, 100, 2]
network = MLP(layers).to(device)

## Data Generation
### Initial Condition
N0 = 50
x0 = 10*torch.rand(N0) - 5
t0 = torch.zeros(N0)
xt0 = torch.stack([x0, t0], dim=1).to(device)

u0 = 2*(2/(torch.exp(x0) + torch.exp(-x0))).to(device)
v0 = torch.zeros_like(u0).to(device)

def initial_loss(network, xt0, u0, v0, criterion):
    h0_pred = network(xt0)
    
    u0_pred = h0_pred[:,0]
    v0_pred = h0_pred[:,1]
    
    loss_0 = criterion(u0_pred, u0) + criterion(v0_pred, v0)

    return loss_0

### Boundary Condition
Nb = 50
tb = torch.pi*torch.rand(Nb)/2
xt_lb = torch.stack([-5*torch.ones(Nb), tb], dim=1).requires_grad_(True).to(device) # lb = lower boundary
xt_ub = torch.stack([5*torch.ones(Nb), tb], dim=1).requires_grad_(True).to(device) # ub = upper boundary

def boundary_loss(network, xt_lb, xt_ub, criterion):
    h_lb_pred = network(xt_lb)
    u_lb_pred = h_lb_pred[:,0]
    v_lb_pred = h_lb_pred[:,1]

    u_x_lb_pred = autograd.grad(u_lb_pred, xt_lb, grad_outputs=torch.ones_like(u_lb_pred), retain_graph=True, create_graph=True)[0][:,0]
    v_x_lb_pred = autograd.grad(v_lb_pred, xt_lb, grad_outputs=torch.ones_like(v_lb_pred), retain_graph=True, create_graph=True)[0][:,1]

    h_ub_pred = network(xt_ub)
    u_ub_pred = h_ub_pred[:,0]
    v_ub_pred = h_ub_pred[:,1]

    u_x_ub_pred = autograd.grad(u_ub_pred, xt_ub, grad_outputs=torch.ones_like(u_ub_pred), retain_graph=True, create_graph=True)[0][:,0]
    v_x_ub_pred = autograd.grad(v_ub_pred, xt_ub, grad_outputs=torch.ones_like(v_ub_pred), retain_graph=True, create_graph=True)[0][:,1]

    loss_b = criterion(u_lb_pred, u_ub_pred) + criterion(v_lb_pred, v_ub_pred) + criterion(u_x_lb_pred, u_x_ub_pred) + criterion(v_x_lb_pred, v_x_ub_pred)

    return loss_b

### Collocation Points
Nc = 5000
xc = 10*torch.rand(Nc) - 5
tc = torch.rand(Nc)*torch.pi/2
xtc = torch.stack([xc, tc], dim=1).requires_grad_(True).to(device)

def collocation_points_loss(network, xtc):
    # physics-information loss or equation loss
    h_c_pred = network(xtc)
    u_c_pred = h_c_pred[:,0]
    v_c_pred = h_c_pred[:,1]

    u_tx_c_pred = autograd.grad(u_c_pred, xtc, grad_outputs=torch.ones_like(u_c_pred), retain_graph=True, create_graph=True)[0]
    u_t_c_pred = u_tx_c_pred[:,1]
    u_x_c_pred = u_tx_c_pred[:,0]
    u_xx_c_pred = autograd.grad(u_x_c_pred, xtc, grad_outputs=torch.ones_like(u_x_c_pred), retain_graph=True, create_graph=True)[0][:,0]

    v_tx_c_pred = autograd.grad(v_c_pred, xtc, grad_outputs=torch.ones_like(v_c_pred), retain_graph=True, create_graph=True)[0]
    v_t_c_pred = v_tx_c_pred[:,1]
    v_x_c_pred = v_tx_c_pred[:,0]
    v_xx_c_pred = autograd.grad(v_x_c_pred, xtc, grad_outputs=torch.ones_like(v_x_c_pred), retain_graph=True, create_graph=True)[0][:,0]

    loss_c_real = v_t_c_pred - 0.5*u_xx_c_pred - (u_c_pred**2 + v_c_pred**2)*u_c_pred
    loss_c_imag = u_t_c_pred + 0.5*v_xx_c_pred + (u_c_pred**2 + v_c_pred**2)*v_c_pred

    return torch.mean(loss_c_real**2) + torch.mean(loss_c_imag**2)

## Set up the loss function and optimizer
criterion = nn.MSELoss()
optimizer = torch.optim.Adam(network.parameters(), lr=5e-4)

def train(network, xt0, u0, xt_lb, xt_ub, xtc, criterion, optimizer, epoch):
    optimizer.zero_grad()
    
    loss_0 = initial_loss(network, xt0, u0, v0, criterion)
    loss_b = collocation_points_loss(network, xtc)
    loss_c = boundary_loss(network, xt_lb, xt_ub, criterion)
    loss = loss_0 + loss_b + 10*loss_c
    loss.backward()
    optimizer.step()

    if epoch % 100 == 0:
        print(f"Epoch {epoch}, Loss 0: {loss_0.item():.6f}, Loss b: {loss_b.item():.6f}, Loss c: {loss_c.item():.8f}")

## Training
for epoch in range(49500,50_001):
    train(network, xt0, u0, xt_lb, xt_ub, xtc, criterion, optimizer, epoch)

from scipy.io import loadmat
data = loadmat("C:/Users/rydbr/Downloads/NLS.mat")
u = np.real(data['uu'])
v = np.imag(data['uu'])
h = np.sqrt(u**2 + v**2)

Nx = 256
Nt = 201
x = torch.linspace(-5, 5, Nx)
t = torch.linspace(0, torch.pi/2, Nt)
X, T = torch.meshgrid(x,t, indexing='ij')
X, T = X.reshape(-1), T.reshape(-1)
xt = torch.stack([X, T], dim=1).to(device)

h_pred = network(xt)
h_pred = torch.sqrt(h_pred[:,0]**2 + h_pred[:,1]**2).reshape(Nx,Nt).cpu().detach().numpy()

fig, axes = plt.subplots(3, 1, figsize=(8, 5), dpi=200)

# First subplot: exact solution
axes[0].imshow(h, extent=[t.min(), t.max(), x.min(), x.max()])
axes[0].set_title("Original h")
axes[0].set_xlabel("t")
axes[0].set_ylabel("x")
axes[0].set_aspect(0.05)

# Second subplot: predicted solution
axes[1].imshow(h_pred, extent=[t.min(), t.max(), x.min(), x.max()])
axes[1].set_title("Predicted h")
axes[1].set_xlabel("t")
axes[1].set_ylabel("x")
axes[1].set_aspect(0.05)

# Third subplot: absolute error
axes[2].imshow(np.abs(h-h_pred), extent=[t.min(), t.max(), x.min(), x.max()])
axes[2].set_title("Absolute Error")
axes[2].set_xlabel("t")
axes[2].set_ylabel("x")
axes[2].set_aspect(0.05)

# Display the plot
plt.tight_layout()
plt.show()