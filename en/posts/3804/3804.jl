using Distributions
using Plots
using LaTeXStrings

# 1. 분포 및 기본 데이터 설정
N_dist = Normal(0, 8)
x_vals = -10π:0.1:10π
N_pdf = pdf.(N_dist, x_vals)

# 단위원 그리기용 데이터
theta = 0:0.01:2π
circle_x = cos.(theta)
circle_y = sin.(theta)

# 애니메이션에서 점이 이동할 범위
anim_x_vals = 0:0.1:10π
anim_x_vals = 0:0.5:4π

p1 = plot(x_vals, N_pdf, label=L"$f(x)$", labelfontsize=12,
              xlabel=L"$x$", color=:black, linewidth=2, 
              xlims=(-10π-1, 10π+1), ylims=(-0.01, 0.05), framestyle=:origin, showaxis=:x, grid=false,
              xticks=([-10π, -8π, -6π, -4π, -2π, 0.001, 2π, 4π, 6π, 8π, 10π], [L"$-10\pi$", L"$-8\pi$", L"$-6\pi$", L"$-4\pi$", L"$-2\pi$", L"$0$", L"$2\pi$", L"$4\pi$", L"$6\pi$", L"$8\pi$", L"$10\pi$"]),
                        )  # x축의 점이 잘 보이도록 하단을 -0.02로 설정

# 2. 애니메이션 생성
anim = @animate for curr_x in anim_x_vals
    # [위쪽 그림] 실수 선(R) 위의 정규분포
    p1 = plot(x_vals, N_pdf, label=L"$f(x)$", labelfontsize=12,
              xlabel=L"$x$", color=:black, linewidth=2, 
              xlims=(-10π-1, 10π+1), ylims=(-0.005, 0.05), framestyle=:origin, showaxis=:x, grid=false,
              xticks=([-10π, -8π, -6π, -4π, -2π, 0.001, 2π, 4π, 6π, 8π, 10π], [L"$-10\pi$", L"$-8\pi$", L"$-6\pi$", L"$-4\pi$", L"$-2\pi$", L"$0$", L"$2\pi$", L"$4\pi$", L"$6\pi$", L"$8\pi$", L"$10\pi$"]),
                        )    # x축의 점이 잘 보이도록 하단을 -0.02로 설정
    
    # ★ 수정된 부분: pdf 곡선 위가 아니라 x축(y=0) 위에 빨간 점을 찍습니다.
    scatter!(p1, [curr_x], [0.0], color=:red, label="", markersize=6)
    
    # [아래쪽 그림] 단위원과 매핑되는 위치
    p2 = plot(circle_x, circle_y,
              aspect_ratio=:equal, 
              color=:black, 
              xlims=(-1.3, 1.3), ylims=(-1.3, 1.3), showaxis=false, grid=false, label="", legend=false)
    
    # 실수 x를 단위원 위의 좌표로 매핑 (x -> x mod 2π 의 효과)
    wrap_x = cos(curr_x)
    wrap_y = sin(curr_x)
    
    # 중심에서 매핑된 점까지의 선
    plot!(p2, [0, wrap_x], [0, wrap_y], color=:gray, linestyle=:dash, label="")
    #원점에서 시작점까지 선 그리기
    plot!(p2, [0, 1], [0, 0], color=:gray, linestyle=:dash, label="")
    # 각도를 표시하는 호 그리기
    scatter!(p2, [wrap_x], [wrap_y], color=:red, label="Mapped point", markersize=6)
    arc_theta = 0:0.01:curr_x % (2π)
    now_theta = round(curr_x % (2π), digits=2)  # 현재 각도 (0에서 2π 사이)
    arc_x = 0.2*cos.(arc_theta)
    arc_y = 0.2*sin.(arc_theta)
    plot!(p2, arc_x, arc_y, color=:gray)
    annotate!(p2, 0.25, 0.3, text(L"$\theta$", :left))
    annotate!(p2, 1.3, 1.4, text(L"$x = " * string(round(curr_x, digits=2))*L"$", :left))
    annotate!(p2, 1.3, 0.8, text(L"$\theta = " * string(now_theta)*L"$", :left))
    l = @layout [p1; p2{0.3h}]
    # 3. 레이아웃 합치기
    plot(p1, p2, layout=l, size=(600, 400), dpi=300)
end
# 4. GIF 파일로 저장
gif(anim, "./content/j_/0_recent/3804_감긴분포/3804_1.webp", fps=20)