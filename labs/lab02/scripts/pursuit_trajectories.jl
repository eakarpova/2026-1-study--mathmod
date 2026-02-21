# pursuit_trajectories.jl
include("pursuit_params.jl")  # подгружаем параметры из первого файла

# Функции траектории катера
r1(θ) = x1 * exp(θ / α)           # случай 1, θ ∈ [0, φ]
r2(θ) = x2 * exp((θ + π) / α)      # случай 2, θ ∈ [-π, φ]

# Точки пересечения (θ = φ)
r_intersect1 = r1(φ)
r_intersect2 = r2(φ)

println("\nТочки пересечения (при θ = φ):")
println("Случай 1: r = $(round(r_intersect1, digits=3)) км")
println("Случай 2: r = $(round(r_intersect2, digits=3)) км")
