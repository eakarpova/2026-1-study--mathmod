# pursuit_plot.jl
include("pursuit_trajectories.jl")

# Случай 1
θ_range1 = range(0, φ, length=200)
r_vals1 = r1.(θ_range1)

# Случай 2
θ_range2 = range(-π, φ, length=200)
r_vals2 = r2.(θ_range2)

# Лодка
ρ_range = range(0, max(r_intersect1, r_intersect2)*1.2, length=100)
x_boat = ρ_range .* cos(φ)
y_boat = ρ_range .* sin(φ)

# Преобразование в декартовы координаты
x1_cart = r_vals1 .* cos.(θ_range1)
y1_cart = r_vals1 .* sin.(θ_range1)

x2_cart = r_vals2 .* cos.(θ_range2)
y2_cart = r_vals2 .* sin.(θ_range2)

# Точки пересечения
x_intersect1 = r_intersect1 * cos(φ)
y_intersect1 = r_intersect1 * sin(φ)

x_intersect2 = r_intersect2 * cos(φ)
y_intersect2 = r_intersect2 * sin(φ)

# График
p = plot(aspect_ratio=:equal, legend=:topright, 
         title="Задача о погоне (n=$n, k=$k км)")

plot!(p, x_boat, y_boat, label="Лодка (φ = $(round(φ*180/π))°)", 
      linewidth=2, color=:red, linestyle=:dash)

plot!(p, x1_cart, y1_cart, label="Катер (случай 1)", 
      linewidth=2, color=:blue)

plot!(p, x2_cart, y2_cart, label="Катер (случай 2)", 
      linewidth=2, color=:green)

scatter!(p, [x_intersect1], [y_intersect1], label="Пересечение 1", 
         color=:blue, markersize=6)
scatter!(p, [x_intersect2], [y_intersect2], label="Пересечение 2", 
         color=:green, markersize=6)

scatter!(p, [x1], [0], label="Старт катера 1", 
         color=:blue, markersize=4, marker=:square)
scatter!(p, [-x2], [0], label="Старт катера 2", 
         color=:green, markersize=4, marker=:square)

scatter!(p, [0], [0], label="Полюс (лодка)", 
         color=:black, markersize=5, marker=:star5)

xlabel!("x, км")
ylabel!("y, км")

display(p)
savefig(p, "pursuit_problem.png")
println("График сохранён в pursuit_problem.png")
