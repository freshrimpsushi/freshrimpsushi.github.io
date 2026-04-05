using Distributions
using Plots

# 1. 기본 설정 (정규분포 및 정의역)
d = Normal(0, 2.3)      # 원본 정규분포 (퍼지는 정도를 보기 좋게 1.5로 설정)
s_vals = -4π:0.05:4π    # 실수 선(R)의 전개 범위 (양옆으로 충분히 길게)

# 2. 곡률 변환 함수: 직선을 원으로 구부리는 등거리 매핑 (t는 0에서 1까지 변함)
# t=0 이면 곡률이 0인 직선, t=1 이면 반경이 1인 단위원
function bend(s, t)
    if t == 0.0
        return 1.0, s   # x=1에 접하는 직선
    else
        R = 1.5 / t     # 현재 반경
        # 회전 중심은 (1-R, 0). 길이를 보존하며 감김 (호의 길이 s = R * 각도)
        x = (1 - R) + R * cos(s * t)
        y = R * sin(s * t)
        return x, y
    end
end

# 3. 고정된 단위원 데이터 (바닥의 까만 원 참조용)
theta = 0:0.05:2π
circle_x = 1.5*cos.(theta).-.5 # 단위원 중심이 x=1에 위치하도록 이동
circle_y = 1.5*sin.(theta)
circle_z = zeros(length(theta))

# 4. '감긴 정규분포(Wrapped Normal)'의 최종 형태 계산 (사진의 빨간 굵은 선)
wrapped_z = zeros(length(theta))
for (i, th) in enumerate(theta)
    sum_pdf = 0.0
    # 주기 2π마다 겹치는 꼬리 확률들을 모두 더해줍니다.
    for k in -3:3 
        sum_pdf += pdf(d, th + 2π * k)
    end
    wrapped_z[i] = sum_pdf
end

# 5. 애니메이션 렌더링 시작
# t가 0(평면)에서 1(원통)로 서서히 변합니다.
px = Plots.px
anim = @animate for t in range(0, 1, length=80)
    p = plot(layout=(1, 3), size=(600, 200), margin=0px, dpi=300)
    cam = [(-45, 35), (0, 15), (-90, 25)] # 두 뷰의 카메라 각도
    # 3D 캔버스 초기화
    for idx in 1:3
        plot!(p[idx], camera=cam[idx], legend=false, 
                aspect_ratio=:equal,
                xlims=(-4, 4), ylims=(-4, 4), zlims=(0, 0.21),
                framestyle=:origin, showaxis=:x, ticks=nothing)
             
        # 참고용 가이드라인 그리기 (단위원 및 접선)
        plot!(p[idx], circle_x, circle_y, circle_z, color=:black, linewidth=1.5, aspect_ratio=:equal)
        plot!(p[idx], [1.0, 1.0], [-4.0, 4.0], [0.0, 0.0], color=:black, linewidth=1.5)

        # 시간에 따라 구부러지는 1차원 도메인 (바닥의 파란 선)
        X_base = [bend(s, t)[1] for s in s_vals]
        Y_base = [bend(s, t)[2] for s in s_vals]
        Z_zero = zeros(length(s_vals))
        plot!(p[idx], X_base, Y_base, Z_zero, color=:black, linewidth=2)

        # 구부러진 도메인 위로 솟은 정규분포 함수 (공중의 파란 선)
        Z_pdf = pdf.(d, s_vals)
        plot!(p[idx], X_base, Y_base, Z_pdf, color=:blue, linewidth=2.5)

        # ★ 추가: 원래의 평평한 정규분포를 회색 잔상으로 남김 (t=0 상태 고정)
        X_orig = ones(length(s_vals)) # 직선은 x=1 에 고정됨
        Y_orig = s_vals               # y축 방향으로 펼쳐짐
        Z_pdf = pdf.(d, s_vals)       # 높이
        
        # 원래 분포의 선 그리기
        plot!(p[idx], X_orig, Y_orig, Z_pdf, color=:blue, linewidth=2.5)

        # 면적을 시각적으로 보여주기 위한 세로선들 (사진의 옅은 파란색 면적 효과)
        for i in 1:12:length(s_vals)
            plot!(p[idx], [X_base[i], X_base[i]], [Y_base[i], Y_base[i]], [0, Z_pdf[i]], 
                color=:blue, alpha=0.2)
        end

        # 애니메이션이 끝나갈 때쯤 (t > 0.8) 최종 감긴 분포를 빨간색으로 서서히 나타냄
        if t > 0.7
            alpha_red = (t - 0.7) / 0.2 # 0에서 1로 페이드 인
            plot!(p[idx], circle_x, circle_y, wrapped_z, color=:red, linewidth=3.5, alpha=alpha_red)
        end
    end
end

# 6. 움짤(GIF)로 저장
gif(anim, "D:/admin/content/j_/0_recent/3805_감긴정규분포/3805_1.gif", fps=10)

# t=5
# begin
# p = plot(camera=(-40, 35), legend=false, 
#              aspect_ratio=:equal,
#              xlims=(-2.5, 2.5), ylims=(-4, 4), zlims=(0, 0.4),
#              size=(800, 600), dpi=150, framestyle=:none, ticks=nothing)
             
#     # 참고용 가이드라인 그리기 (단위원 및 접선)
#     plot!(p, circle_x, circle_y, circle_z, color=:black, linewidth=1.5)
#     plot!(p, [1.0, 1.0], [-4.0, 4.0], [0.0, 0.0], color=:black, linewidth=1.5)

#     # 시간에 따라 구부러지는 1차원 도메인 (바닥의 파란 선)
#     X_base = [bend(s, t)[1] for s in s_vals]
#     Y_base = [bend(s, t)[2] for s in s_vals]
#     Z_zero = zeros(length(s_vals))
#     plot!(p, X_base, Y_base, Z_zero, color=:blue, linewidth=2)

#     # 구부러진 도메인 위로 솟은 정규분포 함수 (공중의 파란 선)
#     Z_pdf = pdf.(d, s_vals)
#     plot!(p, X_base, Y_base, Z_pdf, color=:blue, linewidth=2.5)

#     # ★ 추가: 원래의 평평한 정규분포
#     X_orig = ones(length(s_vals)) # 직선은 x=1 에 고정됨
#     Y_orig = s_vals               # y축 방향으로 펼쳐짐
#     Z_pdf = pdf.(d, s_vals)       # 높이
    
#     # 원래 분포의 선 그리기
#     plot!(p, X_orig, Y_orig, Z_pdf, color=:blue, linewidth=2.5)

#     # 면적을 시각적으로 보여주기 위한 세로선들 (사진의 옅은 파란색 면적 효과)
#     for i in 1:12:length(s_vals)
#         plot!(p, [X_base[i], X_base[i]], [Y_base[i], Y_base[i]], [0, Z_pdf[i]], 
#               color=:blue, alpha=0.2)
#     end

#     # 애니메이션이 끝나갈 때쯤 (t > 0.8) 최종 감긴 분포를 빨간색으로 서서히 나타냄
#     if t > 0.8
#         alpha_red = (t - 0.8) / 0.2 # 0에서 1로 페이드 인
#         plot!(p, circle_x, circle_y, wrapped_z, color=:red, linewidth=3.5, alpha=alpha_red)
#     end
# end