using Distributions
using Plots 

function allargmax(x)
    return findall(x.==maximum(x))
end

function ϵ_greedy(Q::Matrix{Float64}, ϵ::Float64)
    
    if rand(Uniform()) >= ϵ        # 활용: (1-ϵ)의 확률로 argmax(Q)인 액션 선택 
        a = allargmax(Q[:,1])          # Q가 제일 높은 a를 선택
        if size(a) == 1                # a가 유일하면,
            return a                       # 그대로 출력
        else                           # a가 여럿이면,
            return rand(a)                 # 무작위 선택
        end
    else                           # 탐험: ϵ의 확률로 무작위 선택
        return rand(1:size(Q)[1])
    end
end

function UCB(Q::Matrix{Float64}, c::Float64)
    a = allargmax(Q[:,1] .+ c*sqrt(log(sum(Q[:,2]) ./ Q[:,2])))

    if size(a) == 1                # a가 유일하면,
        return a                       # 그대로 출력
    else                           # a가 여럿이면,
        return rand(a)                 # 무작위 선택
    end
end

function Reward(a::Int64, q_true::Vector{Float64})    # 액션 a가 선택되면, 행동-가치함수의 참값으로 보상 결성
    return rand(Normal(q_true[a], 1))
end

function Multi_Armed_Bandit(k::Int64, N_t::Int64, Policy::Function, p::Float64, q_true::Vector{Float64}, Q₀ = 0.0::Float64)
# k=액션의 수, N_t=타입스텝, Policy=액션을 선택하는 전략, p=Policy의 parameter, q_true=액션-가치함수의 참값
    
    # Q의 초기값을 영행렬로 둠
    Q = zeros(k, 2)     # Q[:,1] = k번째 액션의 추정된 가치
                        # Q[:,2] = k번째 액션이 선택된 횟수
    Q[:,1] .= Q₀
    
    # 액션과 리워드를 기록할 벡터
    A = zeros(Int64, t)    # 각 타임 스텝에서 선택된 액션
    R = zeros(t)           # 각 타임 스텝에서 받은 리워드

    for t ∈ 1:N_t
        a = Policy(Q, p)    # Q와 ϵ을 기반으로 액션 결정
        r = Reward(a, q_true)        # a와 q_true를 기반으로 리워드 결정

        A[t] = a    # 선택된 액션 기록
        R[t] = r    # 결정된 리워드 기록

        Q[a,2] += 1                      # 액션 a가 선택된 횟수 업데이트
        Q[a,1] += (r - Q[a,1])/Q[a,2]    # 추정 가치 Q(a) 업데이트
    end

    return A, R, Q[:,2]   # 알고리즘 비교를 위해 필요한 A, R 출력
end

k = 10                   # 액션의 가짓수
t = 1000                 # 타임스텝
iter = 2000              # 각 ϵ에 대한 시뮬레이션 횟수
q_true = randn(k)        # 각 액션의 행동-가치함수 참값
opt_A = argmax(q_true)   # 최적의 액션 (optimal Action)

# ϵ = [0.0, 0.01, 0.1]
# l_ϵ = length(ϵ)

params = [0. # ϵ
          0.] # Q₀
params = reshape(params, (2,1))

# 각 ϵ에 대해서, iter만큼 시뮬레이션 했을 때             
R = zeros(t, iter, size(params)[2])              # 각 타임스텝에서 받은 평균 리워드의 계산을 위함
ratio_opt_A = zeros(t, iter, size(params)[2])    # 각 타임스텝까지 최적의 액션을 선택한 평균 비율의 계산을 위함
Q = zeros(k, iter)

for j ∈ 1:size(params)[2]
    for i ∈ 1:iter
        A_t, R_t, Q[:,i,j] = Multi_Armed_Bandit(k, t, ϵ_greedy, params[1,j], q_true, params[2,j])
        R[:, i, j] = R_t
        ratio_opt_A[:, i, j] = cumsum(A_t .== opt_A)./(1:t)
    end
end

Q

# 평균 계산
ave_R = sum(R, dims=2)./iter 
ave_ratio_opt_A = sum(ratio_opt_A, dims=2)./iter

# 시각화
label = ["Q₀=0, ϵ=0.1", "Q₀=5, ϵ=0", "Q₀=5, ϵ=0.1"]
p1 = plot(ave_R[:,:,1], label=label[1], title="Average reward at each time step")
plot!(ave_R[:,:,2], label=label[2])
plot!(ave_R[:,:,3], label=label[3])

p2 = plot(ave_ratio_opt_A[:,:,1], label=label[1], ylims=(0,1), title="Average ratio of optimal action ")
plot!(ave_ratio_opt_A[:,:,2], label=label[2])
plot!(ave_ratio_opt_A[:,:,3], label=label[3])

plot(p1, p2, size=(1200,400))

dir = @__DIR__
savefig(dir*"/result.png")