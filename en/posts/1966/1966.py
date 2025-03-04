import torch
import torch.autograd as autograd 

x = torch.linspace(0, 1, 100, requires_grad=True)
y = x**3 + 2*x**2 + 3*x + 1
z = x**2 + 2*x + 3

y_autograd = autograd.grad(y, x, grad_outputs=torch.ones_like(x))
autograd.grad(z, x, grad_outputs=torch.ones_like(x))

y_autograd = autograd.grad(y, x, grad_outputs=torch.ones_like(x), create_graph=True)
y_autograd2 = autograd.grad(y_autograd, x, grad_outputs=torch.ones_like(x))

import matplotlib.pyplot as plt
y_prime = 3*x**2 + 4*x + 3
fig = plt.figure(dpi=300)
plt.plot(x.detach().numpy(), y_prime.detach().numpy(), label='y_prime', linewidth=3, c='blue')
plt.plot(x.detach().numpy(), y_autograd[0].detach().numpy(), label='y_autograd', linestyle='--', c='red', linewidth=3)
plt.xlabel('x')
plt.ylabel("y'")
plt.legend()
plt.show()

## 다변수 함수
x = torch.linspace(0, 1, 100, requires_grad=True)
y = torch.linspace(2, 1, 100, requires_grad=True)
X, Y = torch.meshgrid(x,y, indexing='xy')
X, Y = X.reshape(-1), Y.reshape(-1)

z = (X**2)*Y + 2*X*(Y**3)

z_x_auto = autograd.grad(z, X, grad_outputs=torch.ones_like(z), retain_graph=True)
z_x_auto_y1 = z_x_auto[0].reshape(100,100)[-1, :]

z_x_y1 = 2*x + 2
fig = plt.figure(dpi=300)
plt.plot(x.detach().numpy(), z_x_y1.detach().numpy(), label='z_x_y1', linewidth=3, c='blue')
plt.plot(x.detach().numpy(), z_x_auto_y1.detach().numpy(), label='z_x_auto_y1', linestyle='--', c='red', linewidth=3)
plt.xlabel('x')
plt.ylabel("z_x_y1")
plt.legend()
plt.show()

z_x = 2*X*Y + 2*(Y**3)
fig = plt.figure(dpi=300)
plt.subplot(1,3,1)
plt.imshow(z_x.reshape(100,100).detach().numpy(),
           extent=(x.min().item(), x.max().item(), y.min().item(), y.max().item()))
plt.title('z_x')
plt.xlabel('x')
plt.ylabel('y')
plt.colorbar()
plt.subplot(1,3,2)
plt.imshow(z_x_auto[0].reshape(100,100).detach().numpy(),
           extent=(x.min().item(), x.max().item(), y.min().item(), y.max().item()))
plt.title('z_x_auto')
plt.xlabel('x')
plt.ylabel('y')
plt.colorbar()
plt.subplot(1,3,3)
plt.imshow((z_x - z_x_auto[0]).reshape(100,100).detach().numpy(),
           extent=(x.min().item(), x.max().item(), y.min().item(), y.max().item()))
plt.title('z_x - z_x_auto')
plt.xlabel('x')
plt.ylabel('y')
plt.colorbar()
plt.show()

z_xy_auto = autograd.grad(z, [X, Y], grad_outputs=torch.ones_like(z), retain_graph=True)
z_xy_auto[0]
z_xy_auto[1]

fig = plt.figure(dpi=300)
plt.subplot(1,2,1)
plt.imshow(z_x_auto[0].reshape(100,100).detach().numpy(),
           extent=(x.min().item(), x.max().item(), y.min().item(), y.max().item()))
plt.title('z_x_auto')
plt.xlabel('x')
plt.ylabel('y')
plt.colorbar()
plt.subplot(1,2,2)
plt.imshow(z_xy_auto[0].reshape(100,100).detach().numpy(),
           extent=(x.min().item(), x.max().item(), y.min().item(), y.max().item()))
plt.title('z_xy_auto[0]')
plt.xlabel('x')
plt.ylabel('y')
plt.colorbar()
plt.show()