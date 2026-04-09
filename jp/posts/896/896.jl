using Plots

# 애니메이션을 저장할 이름
anim_name = "D:/admin/content/j_/ive/전자기학/자기장/0896_자기장/896.gif"

# 애니메이션 프레임 수 (총 5초 분량, 20fps 가정)
n_frames = 120

# 수직 방향 범위 (도선의 길이 방향)
y_min = -1.5
y_max = 1.5
y = range(y_min, y_max, length=400)

# 도선 양 끝의 고정된 x 위치
fixed_x1 = -1.0
fixed_x2 = 1.0

# 💡 [수정된 부분] 도선의 기본 모양 함수
# y_min과 y_max에서 정확히 0이 되고, 중간(0)에서 1이 되는 형태
function bend_shape(y)
    return cos(pi * y / (y_max - y_min))^2
end

# 애니메이션 객체 생성
anim = @animate for i in 1:n_frames
    t = i / n_frames
    
    # 변형 진폭 계산 (도선이 서로 닿기 직전까지만 휘어지도록 설정)
    d_initial = 1.0 
    amplitude_t = d_initial * sin(pi/2 * t) * 0.98 
    
    # 각 도선의 변형된 x 위치 계산
    # bend_shape가 양 끝에서 0이므로, 양 끝 x좌표는 항상 fixed_x1, fixed_x2로 고정됨
    x1 = fixed_x1 .+ amplitude_t .* bend_shape.(y)
    x2 = fixed_x2 .- amplitude_t .* bend_shape.(y)
    
    # 그래프 초기화
    plot(title="Parallel Currents (Same Direction)",
         xlabel="x (Position)", ylabel="y (Position)",
         xlims=(-2.0, 2.0), ylims=(y_min - 0.3, y_max + 0.3),
         aspect_ratio=:equal,
         legend=false, grid=true, frame=:origin)
    
    # 도선 그리기
    plot!(x1, y, color=:blue, linewidth=6)
    plot!(x2, y, color=:red, linewidth=6)
    
    # 📌 양 끝 고정점 시각화 (확실히 고정된 것을 보여주기 위한 검은 점)
    scatter!([fixed_x1, fixed_x1], [y_min, y_max], color=:black, markersize=8)
    scatter!([fixed_x2, fixed_x2], [y_min, y_max], color=:black, markersize=8)
    
    annotate!(fixed_x1 - 0.3, y_min, text("Fixed", :black, 9, :center))
    annotate!(fixed_x1 - 0.3, y_max, text("Fixed", :black, 9, :center))
    annotate!(fixed_x2 + 0.3, y_min, text("Fixed", :black, 9, :center))
    annotate!(fixed_x2 + 0.3, y_max, text("Fixed", :black, 9, :center))

    # 전류 및 힘 화살표
    force_y = 0.0
    quiver_y_positions = [-0.6, 0.0, 0.6]
    arrow_length = 0.25
    
    for ay in quiver_y_positions
        ax1 = fixed_x1 + amplitude_t * bend_shape(ay)
        ax2 = fixed_x2 - amplitude_t * bend_shape(ay)
        
        # 전류 화살표
        quiver!([ax1], [ay], quiver=([0.0], [arrow_length]), color=:cyan, linewidth=2)
        quiver!([ax2], [ay], quiver=([0.0], [arrow_length]), color=:magenta, linewidth=2)
        
        # 힘 화살표 (거리가 어느 정도 있을 때만 표시)
        current_dist = ax2 - ax1
        if current_dist > 0.15
            f_start1 = ax1 + 0.1
            f_end1 = ax2 - 0.1
            
            quiver!([f_start1], [ay], quiver=([f_end1 - f_start1], [0.0]), color=:black, linestyle=:dash, linewidth=1.5)
            quiver!([f_end1], [ay], quiver=([-(f_end1 - f_start1)], [0.0]), color=:black, linestyle=:dash, linewidth=1.5)
        end
    end
    
    # 라벨링
    annotate!(0.0, force_y + 0.15, text("Force (F)", :black, 10, :center))
    annotate!(fixed_x1, force_y - 0.15, text("I₁ ↑", :cyan, 10, :center))
    annotate!(fixed_x2, force_y - 0.15, text("I₂ ↑", :magenta, 10, :center))

    # 마지막 프레임에 충돌 이펙트 추가
    if i > (n_frames - 5)
        scatter!([0.0], [0.0], color=:yellow, marker=:star, markersize=18)
    end
end

# 애니메이션을 GIF 파일로 저장
gif(anim, anim_name, fps=20)