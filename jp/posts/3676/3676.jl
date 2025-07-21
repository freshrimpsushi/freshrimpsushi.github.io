using Random
using Plots
using Distributions
using LinearAlgebra

# 2변량 가우시안 혼합 분포 정의
function mixture_density(x, mean1, cov1, mean2, cov2, weight1)
    dist1 = MvNormal(mean1, cov1)
    dist2 = MvNormal(mean2, cov2)
    return weight1 * pdf(dist1, x) + (1 - weight1) * pdf(dist2, x)
end

# 로그 밀도 함수 계산 (혼합된 2변량 가우시안 분포에 대해)
function log_density(x, mean1, cov1, mean2, cov2, weight1)
    return log(mixture_density(x, mean1, cov1, mean2, cov2, weight1))
end

# 로그 밀도 함수의 그래디언트 (스코어) 계산
function score_function(x, mean1, cov1, mean2, cov2, weight1)
    dist1 = MvNormal(mean1, cov1)
    dist2 = MvNormal(mean2, cov2)
    
    # 각 분포에 대해 로그 밀도의 기울기 (편미분)
    grad1 = inv(cov1) * (x .- mean1)
    grad2 = inv(cov2) * (x .- mean2)
    
    # 혼합 모델에 대한 기울기
    score = weight1 * grad1 + (1 - weight1) * grad2
    return score
end

# [-1, 1]^2 공간에서 임의의 점들을 샘플링
function sample_points(num_points)
    return rand(Uniform(-1, 1), num_points, 2)
end

# 파라미터 설정
mean1 = [0.0, 0.0]   # 첫 번째 가우시안 분포의 평균
cov1 = [0.5 0.0; 0.0 0.5]  # 첫 번째 가우시안 분포의 공분산 행렬
mean2 = [2.0, 2.0]   # 두 번째 가우시안 분포의 평균
cov2 = [0.5 0.0; 0.0 0.5]  # 두 번째 가우시안 분포의 공분산 행렬
weight1 = 0.6        # 혼합 가중치
num_points = 50      # 샘플링할 점의 수
num_steps = 20       # 애니메이션의 스텝 수

# 샘플링된 점들
points = sample_points(num_points)

# GIF 생성을 위한 애니메이션
anim = @animate for step in 1:num_steps
    # 혼합 가우시안 분포의 히트맵 그리기
    x_vals = LinRange(-1.5, 3.5, 300)  # x축 값
    y_vals = LinRange(-1.5, 3.5, 300)  # y축 값
    
    # 2D 그리드에 대해 밀도 계산
    z_vals = [mixture_density([x, y], mean1, cov1, mean2, cov2, weight1) for x in x_vals, y in y_vals]
    
    # heatmap을 그리기 위한 x_vals, y_vals에 대응하는 z_vals (2D 배열)
    heatmap(x_vals, y_vals, z_vals, xlabel="x", ylabel="y", title="Score Field and Point Movement", color=:blues)
    
    # 각 점에서의 스코어 계산
    scores = [score_function(p, mean1, cov1, mean2, cov2, weight1) for p in eachrow(points)]
    
    # 각 점을 스코어 방향으로 이동
    for i in 1:num_points
        points[i, :] .+= scores[i]
    end
    
    # 그래디언트 벡터 필드 그리기
    quiver_data_x = Float64[]
    quiver_data_y = Float64[]
    quiver_data_u = Float64[]
    quiver_data_v = Float64[]
    
    for (p, s) in zip(eachrow(points), scores)
        push!(quiver_data_x, p[1])
        push!(quiver_data_y, p[2])
        push!(quiver_data_u, s[1])  # 벡터의 x 방향
        push!(quiver_data_v, s[2])  # 벡터의 y 방향
    end
    
    # 그래디언트 벡터 필드 그리기
    # quiver!(quiver_data_x, quiver_data_y, quiver_data_u, quiver_data_v, scale=0.2, color=:blue, label="Score Vectors")
    
    # 점의 이동 상태 시각화
    scatter!(points[:,1], points[:,2], label="Moved Points", color=:red, markersize=3)
end

# GIF 파일로 저장
gif_filename = "score_field_movement.gif"
gif(anim, gif_filename, fps=10)  # GIF 저장
