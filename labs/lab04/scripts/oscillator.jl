using DifferentialEquations, Plots

# Параметры
tspan = (0.0, 35.0)
dt = 0.05
u0 = [2.0, 0.0]  # x0 = 2, y0 = 0

# ============================================================
# 1. Без затухания, без внешней силы: x'' + 5.5x = 0
# ============================================================
function oscillator1!(du, u, p, t)
    x, y = u
    du[1] = y
    du[2] = -5.5 * x
end

prob1 = ODEProblem(oscillator1!, u0, tspan)
sol1 = solve(prob1, Tsit5(), saveat=dt)

# График решения x(t)
p1 = plot(sol1, vars=1, label="x(t)", title="1. Без затухания", xlabel="t", ylabel="x", linewidth=2)

# Фазовый портрет (x, y)
p1_phase = plot(sol1, vars=(1,2), label="фазовая траектория", title="Фазовый портрет 1", xlabel="x", ylabel="y", linewidth=2)

# ============================================================
# 2. С затуханием, без внешней силы: x'' + 2x' + 20x = 0
# ============================================================
function oscillator2!(du, u, p, t)
    x, y = u
    du[1] = y
    du[2] = -20*x - 2*y
end

prob2 = ODEProblem(oscillator2!, u0, tspan)
sol2 = solve(prob2, Tsit5(), saveat=dt)

p2 = plot(sol2, vars=1, label="x(t)", title="2. С затуханием", xlabel="t", ylabel="x", linewidth=2)
p2_phase = plot(sol2, vars=(1,2), label="фазовая траектория", title="Фазовый портрет 2", xlabel="x", ylabel="y", linewidth=2)

# ============================================================
# 3. С затуханием и внешней силой: x'' + x' + 9x = 2sin(t)
# ============================================================
function oscillator3!(du, u, p, t)
    x, y = u
    du[1] = y
    du[2] = -9*x - 1*y + 2*sin(t)
end

prob3 = ODEProblem(oscillator3!, u0, tspan)
sol3 = solve(prob3, Tsit5(), saveat=dt)

p3 = plot(sol3, vars=1, label="x(t)", title="3. С внешней силой", xlabel="t", ylabel="x", linewidth=2)
p3_phase = plot(sol3, vars=(1,2), label="фазовая траектория", title="Фазовый портрет 3", xlabel="x", ylabel="y", linewidth=2)

# ============================================================
# Вывод всех графиков
# ============================================================
plot(p1, p1_phase, p2, p2_phase, p3, p3_phase, layout=(3,2), size=(1000, 1200))
savefig("oscillator_results.png")
display(plot(p1, p1_phase, p2, p2_phase, p3, p3_phase, layout=(3,2), size=(1000, 1200)))
