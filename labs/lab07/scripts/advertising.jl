using DifferentialEquations, Plots, DelimitedFiles

# Параметры модели (вариант 9)
N = 1210        # общее число потенциальных покупателей
n0 = 13         # начальное число знающих о товаре
tspan = (0.0, 30.0)  # временной интервал (30 дней)

println("\n" * "="^60)
println("МОДЕЛЬ РАСПРОСТРАНЕНИЯ РЕКЛАМЫ")
println("="^60)
println("Общая аудитория N = $N")
println("Начальное число знающих n0 = $n0")
println("="^60)

# ============================================================
# СЛУЧАЙ 1: α₁ = 0.7, α₂ = 0.00051
# ============================================================
function case1!(du, u, p, t)
    n = u[1]
    α₁ = 0.7
    α₂ = 0.00051
    du[1] = (α₁ + α₂ * n) * (N - n)
end

prob1 = ODEProblem(case1!, [n0], tspan)
sol1 = solve(prob1, Tsit5(), saveat=0.1)

# ============================================================
# СЛУЧАЙ 2: α₁ = 0.00004, α₂ = 0.75
# ============================================================
function case2!(du, u, p, t)
    n = u[1]
    α₁ = 0.00004
    α₂ = 0.75
    du[1] = (α₁ + α₂ * n) * (N - n)
end

prob2 = ODEProblem(case2!, [n0], tspan)
sol2 = solve(prob2, Tsit5(), saveat=0.1)

# ============================================================
# СЛУЧАЙ 3: α₁(t) = 0.75*sin(0.5t), α₂(t) = 0.35*cos(0.6t)
# ============================================================
function case3!(du, u, p, t)
    n = u[1]
    α₁ = 0.75 * sin(0.5 * t)
    α₂ = 0.35 * cos(0.6 * t)
    du[1] = (α₁ + α₂ * n) * (N - n)
end

prob3 = ODEProblem(case3!, [n0], tspan)
sol3 = solve(prob3, Tsit5(), saveat=0.1)

# ============================================================
# Анализ скорости распространения для случая 2
# (нахождение момента максимальной скорости)
# ============================================================
# Скорость распространения = dn/dt
function growth_rate(t)
    n = sol2(t)[1]  # значение n в момент t
    α₁ = 0.00004
    α₂ = 0.75
    return (α₁ + α₂ * n) * (N - n)
end

# Ищем максимум скорости
t_values = 0:0.1:30
rates = [growth_rate(t) for t in t_values]
max_rate, idx = findmax(rates)
t_max = t_values[idx]

println("\n" * "="^60)
println("АНАЛИЗ СКОРОСТИ РАСПРОСТРАНЕНИЯ (СЛУЧАЙ 2)")
println("="^60)
println("Максимальная скорость распространения: $(round(max_rate, digits=2)) человек/день")
println("Достигается в момент времени: t = $(round(t_max, digits=2)) дней")
println("Число знающих в этот момент: n = $(round(sol2(t_max)[1], digits=1))")
println("="^60)

# ============================================================
# Построение графиков
# ============================================================

# График для случая 1
p1 = plot(sol1, 
          title="Случай 1: α₁ = 0.7, α₂ = 0.00051",
          xlabel="Время (дни)", 
          ylabel="Число знающих n(t)",
          linewidth=2,
          legend=false)

# График для случая 2
p2 = plot(sol2,
          title="Случай 2: α₁ = 0.00004, α₂ = 0.75",
          xlabel="Время (дни)", 
          ylabel="Число знающих n(t)",
          linewidth=2,
          legend=false)

# График для случая 3
p3 = plot(sol3,
          title="Случай 3: α₁(t) = 0.75sin(0.5t), α₂(t) = 0.35cos(0.6t)",
          xlabel="Время (дни)", 
          ylabel="Число знающих n(t)",
          linewidth=2,
          legend=false)

# График скорости распространения для случая 2
p4 = plot(t_values, rates,
          title="Скорость распространения (случай 2)",
          xlabel="Время (дни)",
          ylabel="Скорость dn/dt",
          linewidth=2,
          legend=false)
scatter!([t_max], [max_rate], color=:red, markersize=8, label="Максимум")

# Объединяем графики
plot(p1, p2, p3, p4, layout=(2,2), size=(1000, 800))
savefig("advertising_results.png")
display(plot(p1, p2, p3, p4, layout=(2,2), size=(1000, 800)))

println("\n✅ График сохранён в advertising_results.png")

# ============================================================
# Сохраняем результаты для отчёта
# ============================================================
mkpath("../report")

results = [
    "Параметр N" N
    "Начальное n0" n0
    "Случай 1: n(30)" round(sol1[end][1], digits=1)
    "Случай 2: n(30)" round(sol2[end][1], digits=1)
    "Случай 3: n(30)" round(sol3[end][1], digits=1)
    "Макс. скорость (случай 2)" round(max_rate, digits=2)
    "Время макс. скорости" round(t_max, digits=2)
    "n в момент макс. скорости" round(sol2(t_max)[1], digits=1)
]

writedlm("../report/results.csv", results, ',')

cp("advertising_results.png", "../report/advertising_results.png", force=true)

println("\n✅ Результаты сохранены в report/")
