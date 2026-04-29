using Plots
# GR 백엔드를 사용하여 깔끔하고 빠른 벡터 그래픽 스타일 출력
using LinearAlgebra: norm # 벡터 크기 계산용
using LaTeXStrings
"""
단위 원운동의 기하학적 구조와 벡터(속도, 가속도)를 시각화하는 함수
"""
function draw_arrow!(p, start, vec, color, label)
    # vec[1]: dx, vec[2]: dy
    # quiver!는 [x], [y], quiver=([dx], [dy]) 형태를 받습니다.
    quiver!(p, [start[1]], [start[2]], quiver=([vec[1]], [vec[2]]), 
            color=color, linewidth=2.5, arrowhead=:stealth)
    
    # 라벨 위치 조정 (화살표 끝부분 근처)
    # label_pos = start .+ vec .+ (vec ./ norm(vec) .* 0.08)
    # annotate!(p, label_pos[1], label_pos[2], text(label, 13, color, :bold))
end
function plot_circular_motion_anatomy(θ_deg)
    # 1. 기본 설정 (단위 원 기준)
    r = 1.0           # 반지름
    # θ_deg = 60        # 시각화할 각도 (도단위)
    θ = deg2rad(θ_deg) # 호도법(radian)으로 변환

    # 입자의 현재 위치 (x, y)
    x_p = r * cos(θ)
    y_p = r * sin(θ)

    # 벡터 크기 스케일 (그림에서 잘 보이도록 조정)
    v_scale = 0.4 
    a_scale = 0.4

    # 물리 벡터 정의
    # 속도 벡터 v: (-sinθ, cosθ) 방향, 크기는 rω (여기선 ω=1 가정)
    v_vec = [-sin(θ), cos(θ)] .* v_scale
    # 구심 가속도 벡터 a: (-cosθ, -sinθ) 방향, 원점으로 향함
    a_vec = [-cos(θ), -sin(θ)] .* a_scale

    # 2. 캔버스 초기화
    # aspect_ratio=:equal 로 설정해야 원이 찌그러지지 않습니다.
    plt = plot(aspect_ratio=:equal, 
               xlims=(-1.7, 1.7), ylims=(-1.3, 1.3), 
               leg=false,         # 범례 끔
               grid=false,# gridalpha=0.3, gridstyle=:dash,
               ticks=false,        # 축 눈금 표시
               framestyle=:origin, # 축을 원점을 지나게 설정
               left_margin = 10Plots.mm,
               right_margin = 10Plots.mm,
               title="Circular Motion",
               titlefont=font(14, "DejaVu Sans"), dpi=300, size=(728,400)) # 한글 깨짐 방지용 폰트 설정 (필요시 수정)

    # 3. 단위 원 그리기 (회색 점선)
    t = range(0, 2π, length=100)
    plot!(plt, r .* cos.(t), r .* sin.(t), color=:black)#, style=:dash, alpha=0.5)

    # 4. 각도 θ 시각화
    # 원점에서 입자까지의 반경 선
    plot!(plt, [0, x_p], [0, y_p], color=:black, style=:dash, linewidth=1)
    
    # 각도 아크(Arc) 그리기 near origin
    arc_r = 0.25
    arc_t = range(0, θ, length=30)
    plot!(plt, arc_r .* cos.(arc_t), arc_r .* sin.(arc_t), color=:black, linewidth=1.5)
    
    # 각도 라벨 'θ' 추가
    annotate!(plt, arc_r*cos(θ/2)+0.12, arc_r*sin(θ/2)+0.03, text(L"\theta", 18, :black))

    # 5. 입자(Particle) 표시

    # 6. 화살표(Vector) 함수 정의 (quiver! 보다 직관적인 커스텀 화살표 함수)
    # Plots.jl의 quiver는 사용법이 약간 까다로워 커스텀 함수를 쓰는게 깔끔합니다.
    

    # 7. 속도 벡터 v 그리기 (파란색, 입자 위치에서 출발, 접선 방향)
    draw_arrow!(plt, [x_p, y_p], v_vec, :blue, "v")
    annotate!(plt, x_p+v_vec[1]+0.15, y_p+v_vec[2], text(L"$\mathbf{v}$", 20, :blue))

    # 8. 가속도 벡터 a 그리기 (빨간색, 입자 위치에서 출발, 원점 방향)
    draw_arrow!(plt, [x_p, y_p], a_vec, :red, "a")
    annotate!(plt, 0.8x_p, 0.5y_p, text(L"$\mathbf{a}$", 20, :red))

    scatter!(plt, [x_p], [y_p], markersize=15, color=:black, markerstrokewidth=0)
    annotate!(plt, [1.06], [-0.08], text(L"r", 20))
    # 9. 그림 완성 및 출력
    savefig("D:/admin/content/j_/0_recent/3157_원운동/3157_1.png")
end

# 함수 실행
plot_circular_motion_anatomy(30)