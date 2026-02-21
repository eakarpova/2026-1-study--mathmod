# save_results.jl
include("pursuit_params.jl")
include("pursuit_trajectories.jl")
include("pursuit_plot.jl")

# Сохраняем числа в текстовый файл
open("../report/results.inc", "w") do f
    println(f, "\\newcommand{\\xone}{", round(x1, digits=4), "}")
    println(f, "\\newcommand{\\xtwo}{", round(x2, digits=4), "}")
    println(f, "\\newcommand{\\alphaVal}{", round(α, digits=4), "}")
    println(f, "\\newcommand{\\rintersectone}{", round(r_intersect1, digits=3), "}")
    println(f, "\\newcommand{\\rintersecttwo}{", round(r_intersect2, digits=3), "}")
    println(f, "\\newcommand{\\xintone}{", round(x_intersect1, digits=3), "}")
    println(f, "\\newcommand{\\yintone}{", round(y_intersect1, digits=3), "}")
    println(f, "\\newcommand{\\xinttwo}{", round(x_intersect2, digits=3), "}")
    println(f, "\\newcommand{\\yinttwo}{", round(y_intersect2, digits=3), "}")
end

println("Результаты сохранены в report/results.inc")
