using DifferentialEquations, Plots

# Параметры модели (вариант 9)
α = 0.01   # коэффициент заболеваемости
β = 0.02   # коэффициент выздоровления
N = 15500  # общая численность популяции

# Критическое значение (порог эпидемии)
I_crit = 200  # задаём самостоятельно (можно менять для анализа)

# Начальные условия
I0 = 115      # инфицированные в начале
R0 = 15       # иммунные в начале
S0 = N - I0 - R0  # восприимчивые

println("\n" * "="^60)
println("МОДЕЛЬ ЭПИДЕМИИ (SIR)")
println("="^60)
println("Параметры:")
println("α (коэффициент заболеваемости) = $α")
println("β (коэффициент выздоровления) = $β")
println("N (общая численность) = $N")
println("I* (критическое значение) = $I_crit")
println("\nНачальные условия:")
println("S(0) = $S0")
println("I(0) = $I0")
println("R(0) = $R0")
println("="^60)

# ============================================================
# СЛУЧАЙ 1: I(0) <= I* (эпидемии нет, больные изолированы)
# ============================================================
function epidemic_case1!(du, u, p, t)
    S, I, R = u
    du[1] = 0.0                # S не меняется, т.к. нет заражений
    du[2] = -β * I              # I уменьшается за счёт выздоровления
    du[3] =  β * I              # R увеличивается за счёт выздоровевших
end

tspan = (0.0, 200.0)
u0 = [S0, I0, R0]

prob1 = ODEProblem(epidemic_case1!, u0, tspan)
sol1 = solve(prob1, Tsit5(), saveat=1.0)

# ============================================================
# СЛУЧАЙ 2: I(0) > I* (эпидемия, больные заражают здоровых)
# ============================================================
function epidemic_case2!(du, u, p, t)
    S, I, R = u
    du[1] = -α * S * I         # восприимчивые заражаются
    du[2] =  α * S * I - β * I # инфицированные: новые заражения минус выздоровевшие
    du[3] =  β * I              # выздоровевшие
end

# Для случая 2 изменим начальные условия, чтобы I0 было больше I_crit
I0_case2 = 300  # задаём > I_crit, например 300
S0_case2 = N - I0_case2 - R0
u0_case2 = [S0_case2, I0_case2, R0]

prob2 = ODEProblem(epidemic_case2!, u0_case2, tspan)
sol2 = solve(prob2, Tsit5(), saveat=1.0)

# ============================================================
# Построение графиков
# ============================================================

# График для случая 1 (I(0) <= I*)
p1 = plot(sol1, label=["S(t) восприимчивые" "I(t) инфицированные" "R(t) с иммунитетом"],
          title="Случай 1: I(0) ≤ I* (эпидемии нет)",
          xlabel="Время (дни)", ylabel="Численность",
          linewidth=2, legend=:right)

# График для случая 2 (I(0) > I*)
p2 = plot(sol2, label=["S(t) восприимчивые" "I(t) инфицированные" "R(t) с иммунитетом"],
          title="Случай 2: I(0) > I* (эпидемия)",
          xlabel="Время (дни)", ylabel="Численность",
          linewidth=2, legend=:right)

# Объединяем графики
plot(p1, p2, layout=(2,1), size=(800, 1000))
savefig("epidemic_results.png")
display(plot(p1, p2, layout=(2,1), size=(800, 1000)))

println("\n✅ График сохранён в epidemic_results.png")

# ============================================================
# Анализ результатов
# ============================================================
println("\n" * "="^60)
println("АНАЛИЗ РЕЗУЛЬТАТОВ")
println("="^60)

# Случай 1
S_end1 = sol1[end][1]
I_end1 = sol1[end][2]
R_end1 = sol1[end][3]
println("\nСлучай 1 (I(0) ≤ I*):")
println("  Финальные значения:")
println("  S = $(round(S_end1, digits=1))")
println("  I = $(round(I_end1, digits=1))")
println("  R = $(round(R_end1, digits=1))")

# Случай 2
S_end2 = sol2[end][1]
I_end2 = sol2[end][2]
R_end2 = sol2[end][3]
println("\nСлучай 2 (I(0) > I*):")
println("  Финальные значения:")
println("  S = $(round(S_end2, digits=1))")
println("  I = $(round(I_end2, digits=1))")
println("  R = $(round(R_end2, digits=1))")

# Пик эпидемии для случая 2
I_max = maximum(sol2[2,:])
t_max = sol2.t[argmax(sol2[2,:])]
println("\n  Пик эпидемии:")
println("  Максимальное число инфицированных: $(round(I_max, digits=1))")
println("  Время достижения пика: $(round(t_max, digits=1)) дней")

println("\n✅ Анализ завершён")

# ============================================================
# Сохраняем результаты для отчёта
# ============================================================
using DelimitedFiles

mkpath("../report")

results = [
    "Параметр α" α
    "Параметр β" β
    "Общая численность N" N
    "Критическое значение I*" I_crit
    "Начальные S0" S0
    "Начальные I0" I0
    "Начальные R0" R0
    "Случай 1: S кон." round(S_end1, digits=1)
    "Случай 1: I кон." round(I_end1, digits=1)
    "Случай 1: R кон." round(R_end1, digits=1)
    "Случай 2: S кон." round(S_end2, digits=1)
    "Случай 2: I кон." round(I_end2, digits=1)
    "Случай 2: R кон." round(R_end2, digits=1)
    "Пик эпидемии (I_max)" round(I_max, digits=1)
    "Время пика (t_max)" round(t_max, digits=1)
]

writedlm("../report/results.csv", results, ',')

cp("epidemic_results.png", "../report/epidemic_results.png", force=true)

println("\n✅ Результаты сохранены в report/")
